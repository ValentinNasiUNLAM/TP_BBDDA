/*
Archivos indicados en Miel.
Se requiere que importe toda la información antes mencionada a la base de datos:
• Genere los objetos necesarios (store procedures, funciones, etc.) para importar los
archivos antes mencionados. Tenga en cuenta que cada mes se recibirán archivos de
novedades con la misma estructura, pero datos nuevos para agregar a cada maestro.
• Considere este comportamiento al generar el código. Debe admitir la importación de
novedades periódicamente sin eliminar los datos ya cargados y sin generar
duplicados.
• Cada maestro debe importarse con un SP distinto. No se aceptarán scripts que
realicen tareas por fuera de un SP.
• La estructura/esquema de las tablas a generar será decisión suya. Puede que deba
realizar procesos de transformación sobre los maestros recibidos para adaptarlos a la
estructura requerida. Estas adaptaciones deberán hacerla en la DB y no en los
archivos provistos.
• Los archivos CSV/JSON no deben modificarse. En caso de que haya datos mal
cargados, incompletos, erróneos, etc., deberá contemplarlo y realizar las correcciones
en el fuente SQL. (Sería una excepción si el archivo está malformado y no es posible
interpretarlo como JSON o CSV, pero los hemos verificado cuidadosamente).
• Tener en cuenta que para la ampliación del software no existen datos; se deben
preparar los datos de prueba necesarios para cumplimentar los requisitos planteados.
• El código fuente no debe incluir referencias hardcodeadas a nombres o ubicaciones
de archivo. Esto debe permitirse ser provisto por parámetro en la invocación. En el
código de ejemplo el grupo decidirá dónde se ubicarían los archivos. Esto debe
aparecer en comentarios del módulo.
• El uso de SQL dinámico no está exigido en forma explícita… pero puede que
encuentre que es la única forma de resolver algunos puntos. No abuse del SQL
dinámico, deberá justificar su uso siempre.
• Respecto a los informes XML: no se espera que produzcan un archivo nuevo en el
filesystem, basta con que el resultado de la consulta sea XML.

Materia: Bases de datos aplicadas
Fecha de entrega: 08/07/2025
Grupo: 07
Alumnos: 
	Nasi Valentin 44851378
	Traversa Franco 44510896
	Arias Kevin 41246810
*/

USE Com2900G07;
GO

CREATE OR ALTER PROCEDURE socios.ImportarGrupoFamiliar
  @ruta_archivo NVARCHAR(500)
AS
BEGIN
  -- Configuraciones
  SET NOCOUNT ON;
  SET DATEFORMAT dmy;

  -- SGF = Socios de Grupo Familiar
  CREATE TABLE #SGFTemp(
    nro_socio VARCHAR(20),
    nro_socio_responsable VARCHAR(20),
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    dni VARCHAR(15),
    email VARCHAR(100),
    fecha_nacimiento VARCHAR(20),
    telefono_contacto VARCHAR(20),
    telefono_emergencia VARCHAR(20),
    nombre_obra_social VARCHAR(100),
    nro_socio_obra_social VARCHAR(30),
    telefono_obra_social VARCHAR(30)
  );

  DECLARE @sql NVARCHAR(MAX);

  SET @sql = '
  BULK INSERT #SGFTemp
  FROM ''' + REPLACE(@ruta_archivo, '''', '''''') + '''
  WITH (
    FIELDTERMINATOR = '','',
    ROWTERMINATOR = ''\n'',
    FIRSTROW = 2,
    CODEPAGE = ''65001'',
    TABLOCK
  );';

  EXEC sp_executesql @sql, N'@Ruta NVARCHAR(500)', @Ruta = @ruta_archivo;

  -- Insertar Prestadores de Salud
  WITH PrestadoresSinDuplicados AS (
      SELECT 
          RTRIM(LTRIM(nombre_obra_social)) AS nombre,
          RTRIM(LTRIM(telefono_obra_social)) AS telefono,
          ROW_NUMBER() OVER (
              PARTITION BY RTRIM(LTRIM(nombre_obra_social))
              ORDER BY telefono_obra_social
          ) AS rn
      FROM #SGFTemp
  )
  INSERT INTO socios.PrestadoresSalud (nombre, telefono)
  SELECT nombre, telefono
  FROM PrestadoresSinDuplicados pssd
  WHERE rn = 1
    AND NOT EXISTS (
      SELECT 1 
      FROM socios.PrestadoresSalud ps
      WHERE pssd.nombre IS NULL
    OR RTRIM(LTRIM(ps.nombre)) = pssd.nombre
  );

  -- Insertar Socios pertenecientes a Grupo Familiar
  WITH SGFSinDNIDuplicado AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY dni ORDER BY (SELECT NULL)) AS rn
    FROM #SGFTemp
    WHERE ISNUMERIC(dni) = 1 AND RTRIM(LTRIM(dni)) <> ''
    AND nombre_obra_social IS NOT NULL
  )
  INSERT INTO socios.Socios (nro_socio, dni, estado, nombre, apellido, email,
    fecha_nacimiento, telefono, telefono_emergencia, id_prestador_salud,
    nro_socio_obra_social, id_tutor)
  SELECT TRY_CAST(REPLACE(RTRIM(LTRIM(nro_socio)),'SN-','') as int) as nro_socio,
    TRY_CAST(dni AS INT) as dni,
    1 as estado,
    RTRIM(LTRIM(sgf.nombre)) as nombre,
    RTRIM(LTRIM(apellido)) as apellido,
    RTRIM(LTRIM(email)) as correo,
    TRY_CAST(fecha_nacimiento AS DATE) as fnac,
    TRY_CAST(telefono_contacto AS INT) as telc,
    TRY_CAST(sgf.telefono_emergencia AS INT) as telem,
    ps.id_prestador_salud as id_prestador,
    RTRIM(LTRIM(sgf.nro_socio_obra_social)) as nro_socio_obra_social,
    socios.BuscarSocioPorNumero(TRY_CAST(REPLACE(RTRIM(LTRIM(sgf.nro_socio_responsable)),'SN-','') AS INT)) as id_tutor
  FROM SGFSinDNIDuplicado sgf
  LEFT JOIN socios.PrestadoresSalud ps ON LTRIM(RTRIM(ps.nombre)) = LTRIM(RTRIM(sgf.nombre_obra_social))
  WHERE
    rn = 1
    AND sgf.dni IS NOT NULL
    -- AND sgf.email IS NOT NULL
    AND sgf.nro_socio IS NOT NULL
    AND socios.BuscarSocioPorNumero(TRY_CAST(REPLACE(RTRIM(LTRIM(sgf.nro_socio_responsable)),'SN-','') AS INT)) IS NOT NULL
    AND NOT EXISTS (
      SELECT 1 FROM socios.Socios s 
      WHERE s.dni = TRY_CAST(sgf.dni AS INT) 
      OR s.email = sgf.email
      OR s.nro_socio = TRY_CAST(REPLACE(RTRIM(LTRIM(sgf.nro_socio)),'SN-','') AS INT)
    );

  -- Actualizar id_grupo_familiar (hijos y responsables)
  -- Actualizamos a los hijos
  WITH DatosGrupoFamiliar AS (
    SELECT 
      TRY_CAST(REPLACE(RTRIM(LTRIM(nro_socio)),'SN-','') AS INT) AS nro_socio_hijo,
      TRY_CAST(REPLACE(RTRIM(LTRIM(nro_socio_responsable)),'SN-','') AS INT) AS nro_socio_responsable
    FROM #SGFTemp
    WHERE ISNUMERIC(dni) = 1 AND RTRIM(LTRIM(dni)) <> ''
  )
  UPDATE s_hijo
  SET id_grupo_familiar = s_resp.id_socio
  FROM DatosGrupoFamiliar gf
  INNER JOIN socios.Socios s_hijo ON s_hijo.nro_socio = gf.nro_socio_hijo
  INNER JOIN socios.Socios s_resp ON s_resp.nro_socio = gf.nro_socio_responsable;

  -- Actualizamos también al responsable
  WITH DatosGrupoFamiliar AS (
    SELECT 
      TRY_CAST(REPLACE(RTRIM(LTRIM(nro_socio)),'SN-','') AS INT) AS nro_socio_hijo,
      TRY_CAST(REPLACE(RTRIM(LTRIM(nro_socio_responsable)),'SN-','') AS INT) AS nro_socio_responsable
    FROM #SGFTemp
    WHERE ISNUMERIC(dni) = 1 AND RTRIM(LTRIM(dni)) <> ''
  )
  UPDATE s_resp
  SET id_grupo_familiar = s_resp.id_socio
  FROM DatosGrupoFamiliar gf
  INNER JOIN socios.Socios s_resp ON s_resp.nro_socio = gf.nro_socio_responsable;
END;

-- Descomentar para ejecuci�n:
--EXEC socios.ImportarGrupoFamiliar @ruta_archivo=N'C:\Users\kevin\TP_BBDDA\CSV\grupo_familiar.csv';

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

CREATE OR ALTER PROCEDURE socios.ImportarResponsables
	@ruta_archivo NVARCHAR(500)
AS
BEGIN
	-- Configuraciones
	SET NOCOUNT ON;
	SET DATEFORMAT dmy;

	CREATE TABLE #ResponsablesTemp(
		nro_socio VARCHAR(20),
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

	SET @sql= '
	BULK INSERT #ResponsablesTemp
	FROM ''' + REPLACE(@ruta_archivo,'''', '''''') + '''
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
	    FROM #ResponsablesTemp
	)
	INSERT INTO socios.PrestadoresSalud (nombre, telefono)
	SELECT nombre, telefono
	FROM PrestadoresSinDuplicados pssd
	-- Tomar solamente el primer valor (rn=1) de los dni repetidos
	WHERE rn = 1
	  AND NOT EXISTS (
	    SELECT 1 
	    FROM socios.PrestadoresSalud ps
	    WHERE RTRIM(LTRIM(ps.nombre)) = pssd.nombre
	);

	-- Insertar Responsables
	WITH ResponsablesSinDNIDuplicado AS (
		SELECT *, ROW_NUMBER() OVER (PARTITION BY dni ORDER BY (SELECT NULL)) AS rn
		FROM #ResponsablesTemp
		WHERE ISNUMERIC(dni) = 1 AND RTRIM(LTRIM(dni)) <> ''
	)
	INSERT INTO socios.Socios (nro_socio, dni, estado, nombre, apellido, email, fecha_nacimiento, telefono, telefono_emergencia, id_prestador_salud, nro_socio_obra_social)
	SELECT
		TRY_CAST(REPLACE(RTRIM(LTRIM(nro_socio)), 'SN-','') as INT) as nrosocio,
		TRY_CAST(dni AS INT) as dni,
		1 as estado,
		RTRIM(LTRIM(rt.nombre)) as nombre,
		RTRIM(LTRIM(apellido)) as apellido,
		RTRIM(LTRIM(email)) as correo,
		TRY_CAST(fecha_nacimiento AS DATE) as fnac,
		TRY_CAST(telefono_contacto AS INT) as telc,
		TRY_CAST(rt.telefono_emergencia AS INT) as telem,
		ps.id_prestador_salud as id_prestador,
		rt.nro_socio_obra_social as nro_socio_obra_social
	FROM ResponsablesSinDNIDuplicado rt
	LEFT JOIN socios.PrestadoresSalud ps
		ON LTRIM(RTRIM(ps.nombre)) = LTRIM(RTRIM(rt.nombre_obra_social))
	WHERE 
		rn = 1
		AND TRY_CAST(rt.dni AS INT) IS NOT NULL
		AND NOT EXISTS (
			SELECT 1 FROM socios.Socios s 
			WHERE s.dni = TRY_CAST(rt.dni AS INT) 
			OR s.email = rt.email
			OR s.nro_socio = TRY_CAST(REPLACE(RTRIM(LTRIM(nro_socio)), 'SN-','') as INT)
		);
END;

-- Descomentar para ejecuci�n:
--EXEC socios.ImportarResponsables @ruta_archivo=N'C:\Users\kevin\TP_BBDDA\CSV\responsables_pago.csv';

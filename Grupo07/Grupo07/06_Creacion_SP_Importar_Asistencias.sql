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

CREATE OR ALTER PROCEDURE actividades.ImportarPresentismo
	@ruta_archivo_presentismo NVARCHAR(500)
AS
BEGIN
	-- Configuraciones
	SET NOCOUNT ON;
	SET DATEFORMAT dmy;

	CREATE TABLE #PresentismoTemp(
		nro_socio VARCHAR(20),
		deporte VARCHAR(50),
		fecha_asistencia VARCHAR(10),
		asistencia VARCHAR(10),
		profesor VARCHAR(50)
	);

	DECLARE @sql NVARCHAR(MAX);

	SET @sql= '
	BULK INSERT #PresentismoTemp
	FROM ''' + REPLACE(@ruta_archivo_presentismo,'''', '''''') + '''
	WITH (
		FIELDTERMINATOR = '','',
		ROWTERMINATOR = ''\n'',
		FIRSTROW = 2,
		CODEPAGE = ''65001'',
		TABLOCK
	);';

	EXEC sp_executesql @sql, N'@Ruta NVARCHAR(500)', @Ruta = @ruta_archivo_presentismo;

	--SELECT * FROM  #PresentismoTemp
	
	INSERT INTO actividades.AsistenciasClase (id_socio, id_clase, presente, fecha, profesor)
	SELECT
		s.id_socio,
		c.id_clase,
		TRY_CAST(RTRIM(LTRIM(t.asistencia)) AS CHAR(1)) AS presente,
		TRY_CAST(RTRIM(LTRIM(t.fecha_asistencia)) AS DATETIME) AS fecha,
		RTRIM(LTRIM(t.profesor)) AS profesor
	FROM #PresentismoTemp t
	INNER JOIN socios.Socios s
	    ON s.nro_socio = TRY_CAST(REPLACE(RTRIM(LTRIM(t.nro_socio)), 'SN-', '') AS INT)
	INNER JOIN actividades.Deportes d
	    ON d.nombre = RTRIM(LTRIM(t.deporte))
	INNER JOIN actividades.Clases c
		ON c.id_deporte = d.id_deporte
	WHERE t.asistencia = 'P' OR t.asistencia = 'A' OR t.asistencia = 'J';
END;
GO
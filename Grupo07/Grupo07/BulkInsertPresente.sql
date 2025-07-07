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
		Deporte VARCHAR(50),
		Fecha_Asitencia VARCHAR(10),
		Asistencia CHAR(2),
		Profesor varchar(50)
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

	SELECT * FROM #PresentismoTemp;

	/*
	INSERT INTO actividades.AsistenciasClase (id_socio, id_clase, presente, fecha, profesor)
	SELECT
		s.id_socio,
		c.id_clase,
		TRY_CAST(RTRIM(LTRIM(t.Asistencia)) AS DATE) AS presente,
		TRY_CAST(RTRIM(LTRIM(t.Fecha_Asitencia)) AS DATE) AS fecha,
		TRY_CAST(RTRIM(LTRIM(t.Profesor)) AS DATE) AS profesor
	FROM #PresentismoTemp t
	INNER JOIN socios.Socios s
	    ON s.nro_socio = TRY_CAST(REPLACE(RTRIM(LTRIM(t.nro_socio)), 'SN-', '') AS INT)
	INNER JOIN actividades.Deportes d
	    ON d.nombre = RTRIM(LTRIM(t.Deporte))
	INNER JOIN actividades.Clases c
		ON c.id_deporte = d.id_deporte;*/
END;

-- Descomentar para ejecuci�n:
EXEC actividades.ImportarPresentismo @ruta_archivo_presentismo=N'C:\Users\kevin\TP_BBDDA\CSV\presentismo_actividades.csv';
DELETE FROM actividades.AsistenciasClase
SELECT * FROM actividades.AsistenciasClase
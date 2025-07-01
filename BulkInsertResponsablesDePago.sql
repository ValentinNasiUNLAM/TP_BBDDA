CREATE OR ALTER PROCEDURE sp_importar_responsables
	@ruta_archivo NVARCHAR(500)
AS
BEGIN

	SET NOCOUNT ON;

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

	EXEC (@sql);
	SELECT * FROM #ResponsablesTemp WHERE email LIKE '%ACCORINTI_%';

	INSERT INTO tabla.PrestadoresSalud (nombre, telefono, nro)
	SELECT RTRIM(LTRIM(nombre_obra_social)), RTRIM(LTRIM(telefono_obra_social)), RTRIM(LTRIM(nro_socio_obra_social))
	FROM #ResponsablesTemp;


	INSERT INTO tabla.Socios (nro_socio, dni, estado, nombre, apellido, email, fecha_nacimiento, telefono, telefono_emergencia, id_prestador_salud)
	SELECT
		TRY_CAST(RTRIM(LTRIM(nro_socio)) AS INT),
		TRY_CAST(dni AS INT),
		1,
		RTRIM(LTRIM(rt.nombre)),
		RTRIM(LTRIM(apellido)),
		RTRIM(LTRIM(email)),
		TRY_CAST(fecha_nacimiento AS DATE),
		TRY_CAST(telefono_contacto AS INT),
		TRY_CAST(rt.telefono_emergencia AS INT),
		ps.id_prestador_salud
	FROM #ResponsablesTemp rt
	LEFT JOIN tabla.PrestadoresSalud ps
		ON LTRIM(RTRIM(ps.nombre)) = LTRIM(RTRIM(rt.nombre_obra_social))
	WHERE NOT EXISTS (
		SELECT 1 FROM tabla.Socios s WHERE s.nro_socio = TRY_CAST(RTRIM(LTRIM(rt.nro_socio)) AS INT)
	);
END;

EXEC sp_importar_responsables @ruta_archivo=N'C:\Users\kevin\TP_BBDDA\CSV\responsables_pago.csv';

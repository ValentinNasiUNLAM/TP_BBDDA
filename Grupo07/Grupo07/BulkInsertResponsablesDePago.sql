USE Com2900G07;
GO

CREATE OR ALTER PROCEDURE spInsercion.ImportarResponsables
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
	INSERT INTO tabla.PrestadoresSalud (nombre, telefono)
	SELECT nombre, telefono
	FROM PrestadoresSinDuplicados pssd
	-- Tomar solamente el primer valor (rn=1) de los dni repetidos
	WHERE rn = 1
	  AND NOT EXISTS (
	    SELECT 1 
	    FROM tabla.PrestadoresSalud ps
	    WHERE RTRIM(LTRIM(ps.nombre)) = pssd.nombre
	);

	-- Insertar Responsables
	WITH ResponsablesSinDNIDuplicado AS (
		SELECT *, ROW_NUMBER() OVER (PARTITION BY dni ORDER BY (SELECT NULL)) AS rn
		FROM #ResponsablesTemp
		WHERE ISNUMERIC(dni) = 1 AND RTRIM(LTRIM(dni)) <> ''
	)
	INSERT INTO tabla.Socios (nro_socio, dni, estado, nombre, apellido, email, fecha_nacimiento, telefono, telefono_emergencia, id_prestador_salud, nro_socio_obra_social)
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
	LEFT JOIN tabla.PrestadoresSalud ps
		ON LTRIM(RTRIM(ps.nombre)) = LTRIM(RTRIM(rt.nombre_obra_social))
	WHERE 
		rn = 1
		AND TRY_CAST(rt.dni AS INT) IS NOT NULL
		AND NOT EXISTS (
			SELECT 1 FROM tabla.Socios s 
			WHERE s.dni = TRY_CAST(rt.dni AS INT) 
			OR s.email = rt.email
			OR s.nro_socio = rt.nro_socio
		);
END;

-- Descomentar para ejecuci�n:
-- EXEC spInsercion.ImportarResponsables @ruta_archivo=N'C:\Users\kevin\TP_BBDDA\CSV\responsables_pago.csv';


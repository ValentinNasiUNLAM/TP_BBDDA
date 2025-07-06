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

	SET @sql= '
	BULK INSERT #SGFTemp
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
	    FROM #SGFTemp
	)
	INSERT INTO socios.PrestadoresSalud (nombre, telefono)
	SELECT nombre, telefono
	FROM PrestadoresSinDuplicados pssd
	-- Tomar solamente el primer valor (rn=1) de los dni repetidos
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
		AND socios.BuscarSocioPorNumero(TRY_CAST(REPLACE(RTRIM(LTRIM(sgf.nro_socio_responsable)),'SN-','') AS INT) IS NOT NULL
		AND NOT EXISTS (
			SELECT 1 FROM socios.Socios s 
			WHERE s.dni = TRY_CAST(sgf.dni AS INT) 
			OR s.email = sgf.email
			OR s.nro_socio = TRY_CAST(REPLACE(RTRIM(LTRIM(sgf.nro_socio)),'SN-','') AS INT)
		);/*
		AND EXISTS (
			SELECT 1 FROM socios.Socios s
			WHERE s.nro_socio = TRY_CAST(REPLACE(RTRIM(LTRIM(nro_socio_responsable)),'SN-','') as int)
		);*/
/*
	-- Buscar ID de Socio tutor para actualizar campo id_tutor de Socio perteneciente a Grupo Familiar
	WITH SGFSinDNIDuplicado AS (
		SELECT *, ROW_NUMBER() OVER (PARTITION BY dni ORDER BY (SELECT NULL)) AS rn
		FROM #SGFTemp
		WHERE ISNUMERIC(dni) = 1 AND RTRIM(LTRIM(dni)) <> ''
	)
	UPDATE s_act
	SET s_act.id_tutor = s_res.id_socio
	FROM SGFSinDNIDuplicado sgf
	LEFT JOIN socios.Socios s_res
	ON TRY_CAST(REPLACE(RTRIM(LTRIM(sgf.nro_socio_responsable)),'SN-','') AS INT) = s_res.nro_socio
	INNER JOIN socios.Socios s_act
	ON s_act.nro_socio = TRY_CAST(REPLACE(RTRIM(LTRIM(sgf.nro_socio)),'SN-','') AS INT)
	WHERE s_act.nro_socio = TRY_CAST(REPLACE(RTRIM(LTRIM(sgf.nro_socio)),'SN-','') AS INT);*/
		
	/*
	LEFT JOIN socios.Socios s_responsable 
		ON s_responsable.nro_socio = TRY_CAST(REPLACE(RTRIM(LTRIM(sgf.nro_socio_responsable)),'SN-','') AS INT)*/
END;

-- Descomentar para ejecuci�n:
EXEC socios.ImportarGrupoFamiliar @ruta_archivo=N'C:\Users\kevin\TP_BBDDA\CSV\grupo_familiar.csv';

SELECT * 
FROM socios.Socios
WHERE id_tutor IS NOT NULL

CREATE UNIQUE NONCLUSTERED INDEX idx_email_unico
ON socios.Socios(email)
WHERE email IS NOT NULL;

ALTER TABLE socios.Socios
DROP CONSTRAINT UQ__Socios__AB6E6164CAFB3343;


DELETE FROM socios.Socios
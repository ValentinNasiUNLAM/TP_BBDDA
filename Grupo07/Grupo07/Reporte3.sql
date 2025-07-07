USE Com2900G07;
GO

--Agregamos los datos necesarios para poder generar y visualizar el reporte 3

-- Prestadores
EXEC socios.CrearPrestadorSalud 'OSDE R3', '011-5555-1111';

-- Socios
DECLARE @id_osde INT

SELECT @id_osde = id_prestador_salud FROM socios.PrestadoresSalud WHERE nombre = 'OSDE R3';

EXEC socios.CrearSocio 3001, 44333111, 'Juan', 'Perez', 'juan3@mail.com', '1990-05-20', 1122334455, 1133445566, 'OSDE-3123', @id_osde;
EXEC socios.CrearSocio 3002, 44333222, 'Ana', 'Gomez', 'ana3@mail.com', '1985-08-15', 1122334466, 1133445577, 'OSDE-3456', @id_osde;
EXEC socios.CrearSocio 3003, 44333333, 'Jose', 'Lopez', 'jose3@mail.com', '2011-08-15', 1122334466, 1133445577, 'OSDE-3789', @id_osde;

-- Crear Categorías
EXEC socios.CrearCategoria 'Menores R3', 0, 17, 5000;
EXEC socios.CrearCategoria 'Adultos R3', 18, 99, 10000;

-- Crear Deportes 
EXEC actividades.CrearDeporte 'Futbol R3', 5000;
EXEC actividades.CrearDeporte 'Tenis R3', 7000;

-- Cuotas
DECLARE @id_categoria INT

SELECT @id_categoria = id_categoria
FROM socios.Categorias
WHERE nombre_categoria = 'Adultos R3'
EXEC socios.CrearCuota 44333111, @id_categoria; 

SELECT @id_categoria = id_categoria
FROM socios.Categorias
WHERE nombre_categoria = 'Adultos R3'
EXEC socios.CrearCuota 44333222, @id_categoria; 

SELECT @id_categoria = id_categoria
FROM socios.Categorias
WHERE nombre_categoria = 'Menores R3'
EXEC socios.CrearCuota 44333333, @id_categoria; 

-- Asignar actividades 
DECLARE @id_deporte INT

SELECT @id_deporte = id_deporte
FROM actividades.Deportes
WHERE nombre = 'Futbol R3'
EXEC actividades.CrearActividad 44333111, @id_deporte; 

SELECT @id_deporte = id_deporte
FROM actividades.Deportes
WHERE nombre = 'Futbol R3'
EXEC actividades.CrearActividad 44333222, @id_deporte; 

SELECT @id_deporte = id_deporte
FROM actividades.Deportes
WHERE nombre = 'Tenis R3'
EXEC actividades.CrearActividad 44333333, @id_deporte; 

-- Crear clase
SELECT @id_deporte = id_deporte
FROM actividades.Deportes
WHERE nombre = 'Futbol R3'
EXEC actividades.CrearClase @id_deporte; 

SELECT @id_deporte = id_deporte
FROM actividades.Deportes
WHERE nombre = 'Tenis R3'
EXEC actividades.CrearClase @id_deporte; 

-- Asistencias
DECLARE @id_clase INT

SELECT @id_clase = c.id_clase
FROM actividades.Clases c
INNER JOIN actividades.Deportes d ON d.id_deporte = c.id_deporte
WHERE d.nombre = 'Futbol R3'
EXEC actividades.CrearAsistenciaClase 44333111, @id_clase, 'P', '2025-05-01 10:00', 'Profe 1'; 

SELECT @id_clase = c.id_clase
FROM actividades.Clases c
INNER JOIN actividades.Deportes d ON d.id_deporte = c.id_deporte
WHERE d.nombre = 'Futbol R3'
EXEC actividades.CrearAsistenciaClase 44333111, @id_clase, 'P', '2025-05-05 10:00', 'Profe 1'; 

SELECT @id_clase = c.id_clase
FROM actividades.Clases c
INNER JOIN actividades.Deportes d ON d.id_deporte = c.id_deporte
WHERE d.nombre = 'Futbol R3'
EXEC actividades.CrearAsistenciaClase 44333333, @id_clase, 'P', '2025-05-03 10:00', 'Profe 1'; 

SELECT @id_clase = c.id_clase
FROM actividades.Clases c
INNER JOIN actividades.Deportes d ON d.id_deporte = c.id_deporte
WHERE d.nombre = 'Tenis R3'
EXEC actividades.CrearAsistenciaClase 44333222, @id_clase, 'P', '2025-05-01 11:00', 'Profe 2'; 

SELECT @id_clase = c.id_clase
FROM actividades.Clases c
INNER JOIN actividades.Deportes d ON d.id_deporte = c.id_deporte
WHERE d.nombre = 'Tenis R3'
EXEC actividades.CrearAsistenciaClase 44333222, @id_clase, 'A', '2025-05-02 11:00', 'Profe 2'; 

GO

--Creamos el SP para el reporte 3

CREATE OR ALTER PROCEDURE administracion.ReporteInasistenciasPorDeporte
AS
BEGIN

	WITH Inasistencias AS (
		SELECT
			s.id_socio,
			c.nombre_categoria,
			d.nombre AS deporte,
			a.presente
		FROM actividades.AsistenciasClase a
		INNER JOIN socios.Socios s ON a.id_socio = s.id_socio
		INNER JOIN socios.Cuotas q ON q.id_socio = s.id_socio
		INNER JOIN socios.Categorias c ON c.id_categoria = q.id_categoria
		INNER JOIN actividades.Clases cl ON a.id_clase = cl.id_clase
		INNER JOIN actividades.Deportes d ON cl.id_deporte = d.id_deporte
		WHERE a.presente = 'P'
	),
	Conteo AS (
		SELECT
			nombre_categoria,
			deporte,
			COUNT(*) AS cantidad_inasistencias
		FROM Inasistencias
		GROUP BY nombre_categoria, deporte
	)
	SELECT 
		'Reporte de Inasistencias por Categoría y Deporte' AS [Nombre del Reporte],
		nombre_categoria AS [Categoría],
		deporte AS [Deporte],
		cantidad_inasistencias AS [Cantidad de Inasistencias]
	FROM Conteo
	ORDER BY cantidad_inasistencias DESC, nombre_categoria, deporte;

END
GO

EXEC administracion.ReporteInasistenciasPorDeporte
GO
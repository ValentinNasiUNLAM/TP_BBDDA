/*
Reporte 4
Reporte que contenga a los socios que no han asistido a alguna clase de la actividad que
realizan. El reporte debe contener: Nombre, Apellido, edad, categoría y la actividad

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

--Agregamos los datos necesarios para poder generar y visualizar el reporte 4

-- Prestadores
EXEC socios.CrearPrestadorSalud 'OSDE R4', '011-5555-1111';

-- Socios
DECLARE @id_osde INT

SELECT @id_osde = id_prestador_salud FROM socios.PrestadoresSalud WHERE nombre = 'OSDE R4';

EXEC socios.CrearSocio 1041, 44444111, 'Juan', 'Perez', 'juan4@mail.com', '1990-05-20', 1122334455, 1133445566, 'OSDE-4123', @id_osde;
EXEC socios.CrearSocio 1042, 44444222, 'Ana', 'Gomez', 'ana4@mail.com', '1985-08-15', 1122334466, 1133445577, 'OSDE-4456', @id_osde;
EXEC socios.CrearSocio 1043, 44444333, 'Jose', 'Lopez', 'jose4@mail.com', '2011-08-15', 1122334466, 1133445577, 'OSDE-4789', @id_osde;

-- Crear Categorías
EXEC socios.CrearCategoria 'Menores R4', 0, 17, 5000;
EXEC socios.CrearCategoria 'Adultos R4', 18, 99, 10000;

-- Crear Deportes 
EXEC actividades.CrearDeporte 'Futbol R4', 5000;
EXEC actividades.CrearDeporte 'Tenis R4', 7000;

-- Cuotas
DECLARE @id_categoria INT

SELECT @id_categoria = id_categoria
FROM socios.Categorias
WHERE nombre_categoria = 'Adultos R4'
EXEC socios.CrearCuota 44444111, @id_categoria; 

SELECT @id_categoria = id_categoria
FROM socios.Categorias
WHERE nombre_categoria = 'Adultos R4'
EXEC socios.CrearCuota 44444222, @id_categoria; 

SELECT @id_categoria = id_categoria
FROM socios.Categorias
WHERE nombre_categoria = 'Menores R4'
EXEC socios.CrearCuota 44444333, @id_categoria; 

-- Asignar actividades 
DECLARE @id_deporte INT

SELECT @id_deporte = id_deporte
FROM actividades.Deportes
WHERE nombre = 'Futbol R4'
EXEC actividades.CrearActividad 44444111, @id_deporte; 

SELECT @id_deporte = id_deporte
FROM actividades.Deportes
WHERE nombre = 'Futbol R4'
EXEC actividades.CrearActividad 44444222, @id_deporte; 

SELECT @id_deporte = id_deporte
FROM actividades.Deportes
WHERE nombre = 'Tenis R4'
EXEC actividades.CrearActividad 44444333, @id_deporte; 

-- Crear clase
SELECT @id_deporte = id_deporte
FROM actividades.Deportes
WHERE nombre = 'Futbol R4'
EXEC actividades.CrearClase @id_deporte; 

SELECT @id_deporte = id_deporte
FROM actividades.Deportes
WHERE nombre = 'Tenis R4'
EXEC actividades.CrearClase @id_deporte; 

-- Asistencias
DECLARE @id_clase INT

SELECT @id_clase = c.id_clase
FROM actividades.Clases c
INNER JOIN actividades.Deportes d ON d.id_deporte = c.id_deporte
WHERE d.nombre = 'Futbol R4'
EXEC actividades.CrearAsistenciaClase 44444111, @id_clase, 'P', '2025-05-01 10:00', 'Profe 1'; 

SELECT @id_clase = c.id_clase
FROM actividades.Clases c
INNER JOIN actividades.Deportes d ON d.id_deporte = c.id_deporte
WHERE d.nombre = 'Futbol R4'
EXEC actividades.CrearAsistenciaClase 44444111, @id_clase, 'P', '2025-05-05 10:00', 'Profe 1'; 

SELECT @id_clase = c.id_clase
FROM actividades.Clases c
INNER JOIN actividades.Deportes d ON d.id_deporte = c.id_deporte
WHERE d.nombre = 'Futbol R4'
EXEC actividades.CrearAsistenciaClase 44444333, @id_clase, 'P', '2025-05-03 10:00', 'Profe 1'; 

SELECT @id_clase = c.id_clase
FROM actividades.Clases c
INNER JOIN actividades.Deportes d ON d.id_deporte = c.id_deporte
WHERE d.nombre = 'Tenis R4'
EXEC actividades.CrearAsistenciaClase 44444222, @id_clase, 'P', '2025-05-01 11:00', 'Profe 2'; 

SELECT @id_clase = c.id_clase
FROM actividades.Clases c
INNER JOIN actividades.Deportes d ON d.id_deporte = c.id_deporte
WHERE d.nombre = 'Tenis R4'
EXEC actividades.CrearAsistenciaClase 44444222, @id_clase, 'A', '2025-05-02 11:00', 'Profe 2'; 

GO

--Creamos el SP para el reporte 4

CREATE OR ALTER PROCEDURE administracion.ReporteInasistenciasSocios
AS
BEGIN
	WITH Inasistencias AS (
		SELECT
			s.nombre,
			s.apellido,
			DATEDIFF(YEAR, s.fecha_nacimiento, GETDATE()) - 
				CASE 
					WHEN MONTH(s.fecha_nacimiento) > MONTH(GETDATE()) 
						 OR (MONTH(s.fecha_nacimiento) = MONTH(GETDATE()) AND DAY(s.fecha_nacimiento) > DAY(GETDATE()))
					THEN 1 ELSE 0 
				END AS edad,
			c.nombre_categoria,
			d.nombre AS actividad
		FROM actividades.AsistenciasClase a
		INNER JOIN socios.Socios s ON a.id_socio = s.id_socio
		INNER JOIN socios.Cuotas q ON s.id_socio = q.id_socio
		INNER JOIN socios.Categorias c ON q.id_categoria = c.id_categoria
		INNER JOIN actividades.Clases cl ON a.id_clase = cl.id_clase
		INNER JOIN actividades.Deportes d ON cl.id_deporte = d.id_deporte
		WHERE a.presente = 'P'
	)
	SELECT DISTINCT
		'Socios con inasistencias en su actividad' AS [Nombre del Reporte],
		nombre,
		apellido,
		edad,
		nombre_categoria AS [Categoría],
		actividad
	FROM Inasistencias
	ORDER BY apellido, nombre;
END
GO

EXEC administracion.ReporteInasistenciasSocios
GO
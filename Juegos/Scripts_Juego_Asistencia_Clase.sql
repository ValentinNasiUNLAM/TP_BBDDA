--ASISTENCIAS CLASES

USE Com2900G07
GO

--Agregamos un socio y clase para testear
EXEC spInsercion.CrearDeporte
    @nombre = 'Futbol_test_asistencia',
    @precio = 1000

DECLARE @id_deporte_test INT;

SELECT @id_deporte_test = id_deporte
FROM tabla.Deportes
WHERE nombre = 'Futbol_test_asistencia';

EXEC spInsercion.CrearClase
    @id_deporte = @id_deporte_test

EXEC spInsercion.CrearPrestadorSalud
    @nombre = 'Galeno_test_asistencia',
    @tipo = 1,
    @telefono = 46254016

DECLARE @id_prestador_salud_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM tabla.PrestadoresSalud
WHERE nombre = 'Galeno_test_asistencia';

EXEC spInsercion.CrearSocio
    @dni = 55666777,
    @nombre = 'Socio',
    @apellido = 'Prueba Asistencia',
    @email = 'socio_prueba_asistencia@sol.com',
    @fecha_nacimiento = '2002-11-26',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @id_prestador_salud = @id_prestador_salud_test
GO

--INSERCION

--TEST 1.1: Insercion correcta
DECLARE @id_clase_test INT
DECLARE @id_deporte_test INT;

SELECT @id_deporte_test = id_deporte
FROM tabla.Deportes
WHERE nombre = 'Futbol_test_asistencia';

SELECT @id_clase_test = id_clase
FROM tabla.Clases
WHERE id_deporte = @id_deporte_test

SELECT * FROM tabla.AsistenciasClase
EXEC spInsercion.CrearAsistenciaClase
	@dni_socio = 55666777,
	@id_clase = @id_clase_test,
	@presente = 1,
	@fecha = '2025-06-10 17:00:00'
SELECT * FROM tabla.AsistenciasClase
GO

--TEST 1.2: DNI invalido
DECLARE @id_clase_test INT
DECLARE @id_deporte_test INT;

SELECT @id_deporte_test = id_deporte
FROM tabla.Deportes
WHERE nombre = 'Futbol_test_asistencia';

SELECT @id_clase_test = id_clase
FROM tabla.Clases
WHERE id_deporte = @id_deporte_test

EXEC spInsercion.CrearAsistenciaClase
	@dni_socio = 99999999,
	@id_clase = @id_clase_test,
	@presente = 1,
	@fecha = '2025-06-10 17:00:00'
GO

--TEST 1.3: ID clase invalido
DECLARE @id_clase_test INT
DECLARE @id_deporte_test INT;

SELECT @id_deporte_test = id_deporte
FROM tabla.Deportes
WHERE nombre = 'Futbol_test_asistencia';

SELECT @id_clase_test = id_clase
FROM tabla.Clases
WHERE id_deporte = @id_deporte_test

EXEC spInsercion.CrearAsistenciaClase
	@dni_socio = 55666777,
	@id_clase = 99999,
	@presente = 1,
	@fecha = '2025-06-10 17:00:00'
GO

--TEST 1.4: Fecha invalida
DECLARE @id_clase_test INT
DECLARE @id_deporte_test INT;

SELECT @id_deporte_test = id_deporte
FROM tabla.Deportes
WHERE nombre = 'Futbol_test_asistencia';

SELECT @id_clase_test = id_clase
FROM tabla.Clases
WHERE id_deporte = @id_deporte_test

EXEC spInsercion.CrearAsistenciaClase
	@dni_socio = 55666777,
	@id_clase = @id_clase_test,
	@presente = 1,
	@fecha = '2026-06-10 17:00:00'
GO

--ACTUALIZACION

--TEST 2.1: Actualizacion correcta
DECLARE @id_clase_test INT
DECLARE @id_deporte_test INT;
DECLARE @id_asistencia_test INT

SELECT @id_deporte_test = id_deporte
FROM tabla.Deportes
WHERE nombre = 'Futbol_test_asistencia';

SELECT @id_clase_test = id_clase
FROM tabla.Clases
WHERE id_deporte = @id_deporte_test

SELECT @id_asistencia_test = id_asistencia
FROM tabla.AsistenciasClase
WHERE id_clase = @id_clase_test AND id_socio = fnBusqueda.BuscarSocio(55666777) AND CAST(fecha AS DATE) = '2025-06-10'

SELECT * FROM tabla.AsistenciasClase WHERE id_asistencia = @id_asistencia_test
EXEC spActualizacion.ActualizarAsistenciaClase
	@id_asistencia = @id_asistencia_test,
	@dni_socio = 55666777,
	@id_clase = @id_clase_test,
	@presente = 0,
	@fecha = '2025-06-10 17:00:00'
SELECT * FROM tabla.AsistenciasClase WHERE id_asistencia = @id_asistencia_test
GO

--TEST 2.2: ID asistencia invalido
DECLARE @id_clase_test INT
DECLARE @id_deporte_test INT;
DECLARE @id_asistencia_test INT

SELECT @id_deporte_test = id_deporte
FROM tabla.Deportes
WHERE nombre = 'Futbol_test_asistencia';

SELECT @id_clase_test = id_clase
FROM tabla.Clases
WHERE id_deporte = @id_deporte_test

SELECT @id_asistencia_test = id_asistencia
FROM tabla.AsistenciasClase
WHERE id_clase = @id_clase_test AND id_socio = fnBusqueda.BuscarSocio(55666777) AND CAST(fecha AS DATE) = '2025-06-10'

EXEC spActualizacion.ActualizarAsistenciaClase
	@id_asistencia = 99999,
	@dni_socio = 55666777,
	@id_clase = @id_clase_test,
	@presente = 0,
	@fecha = '2025-06-10 17:00:00'
GO

--TEST 2.3: DNI socio invalido
DECLARE @id_clase_test INT
DECLARE @id_deporte_test INT;
DECLARE @id_asistencia_test INT

SELECT @id_deporte_test = id_deporte
FROM tabla.Deportes
WHERE nombre = 'Futbol_test_asistencia';

SELECT @id_clase_test = id_clase
FROM tabla.Clases
WHERE id_deporte = @id_deporte_test

SELECT @id_asistencia_test = id_asistencia
FROM tabla.AsistenciasClase
WHERE id_clase = @id_clase_test AND id_socio = fnBusqueda.BuscarSocio(55666777) AND CAST(fecha AS DATE) = '2025-06-10'

EXEC spActualizacion.ActualizarAsistenciaClase
	@id_asistencia = @id_asistencia_test,
	@dni_socio = 99999999,
	@id_clase = @id_clase_test,
	@presente = 0,
	@fecha = '2025-06-10 17:00:00'
GO

--TEST 2.4: ID clase invalido
DECLARE @id_clase_test INT
DECLARE @id_deporte_test INT;
DECLARE @id_asistencia_test INT

SELECT @id_deporte_test = id_deporte
FROM tabla.Deportes
WHERE nombre = 'Futbol_test_asistencia';

SELECT @id_clase_test = id_clase
FROM tabla.Clases
WHERE id_deporte = @id_deporte_test

SELECT @id_asistencia_test = id_asistencia
FROM tabla.AsistenciasClase
WHERE id_clase = @id_clase_test AND id_socio = fnBusqueda.BuscarSocio(55666777) AND CAST(fecha AS DATE) = '2025-06-10'

EXEC spActualizacion.ActualizarAsistenciaClase
	@id_asistencia = @id_asistencia_test,
	@dni_socio = 55666777,
	@id_clase = 99999,
	@presente = 0,
	@fecha = '2025-06-10 17:00:00'
GO

--TEST 2.5: Fecha invalida
DECLARE @id_clase_test INT
DECLARE @id_deporte_test INT;
DECLARE @id_asistencia_test INT

SELECT @id_deporte_test = id_deporte
FROM tabla.Deportes
WHERE nombre = 'Futbol_test_asistencia';

SELECT @id_clase_test = id_clase
FROM tabla.Clases
WHERE id_deporte = @id_deporte_test

SELECT @id_asistencia_test = id_asistencia
FROM tabla.AsistenciasClase
WHERE id_clase = @id_clase_test AND id_socio = fnBusqueda.BuscarSocio(55666777) AND CAST(fecha AS DATE) = '2025-06-10'

EXEC spActualizacion.ActualizarAsistenciaClase
	@id_asistencia = @id_asistencia_test,
	@dni_socio = 55666777,
	@id_clase = @id_clase_test,
	@presente = 0,
	@fecha = '2026-06-10 17:00:00'
GO

--ELIMINACION

--TEST 3.1:Eliminacion correcta
DECLARE @id_clase_test INT
DECLARE @id_deporte_test INT;
DECLARE @id_asistencia_test INT

SELECT @id_deporte_test = id_deporte
FROM tabla.Deportes
WHERE nombre = 'Futbol_test_asistencia';

SELECT @id_clase_test = id_clase
FROM tabla.Clases
WHERE id_deporte = @id_deporte_test

SELECT @id_asistencia_test = id_asistencia
FROM tabla.AsistenciasClase
WHERE id_clase = @id_clase_test AND id_socio = fnBusqueda.BuscarSocio(55666777) AND CAST(fecha AS DATE) = '2025-06-10'

SELECT * FROM tabla.AsistenciasClase WHERE id_asistencia = @id_asistencia_test
EXEC spEliminacion.EliminarAsistenciaClase
	@id_asistencia = @id_asistencia_test
SELECT * FROM tabla.AsistenciasClase WHERE id_asistencia = @id_asistencia_test
GO

--TEST 3.2: ID asistencia invalido
EXEC spEliminacion.EliminarAsistenciaClase
	@id_asistencia = 99999
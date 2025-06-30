--Turnos

-- Se crean los TESTS para la insercion, actualizacion y eliminacion de Turnos

USE Com2900G07
GO

-- Agregar un nuevo deporte y una clase para usar de prueba
EXEC spInsercion.CrearDeporte
    @nombre = 'Futbol_test_clase_turno',
    @precio = 1000
GO

DECLARE @id_deporte_test INT;

SELECT @id_deporte_test = id_deporte
FROM tabla.Deportes
WHERE nombre = 'Futbol_test_clase_turno';

SELECT * FROM tabla.Clases
EXEC spInsercion.CrearClase
    @id_deporte = @id_deporte_test
GO

-- INSERCION

-- TEST 1.1: Crear Turno Exitoso
DECLARE @id_clase_test INT;

SELECT @id_clase_test = id_clase
FROM tabla.Clases c
INNER JOIN tabla.Deportes d ON d.id_deporte = c.id_clase
WHERE d.nombre = 'Futbol_test_clase_turno';

SELECT * FROM tabla.Turnos
EXEC spInsercion.CrearTurno
    @id_clase = @id_clase_test,
    @dia = 4,
    @hora_inicio = '10:00',
    @hora_fin = '12:00'

SELECT * FROM tabla.Turnos WHERE id_clase = @id_clase_test AND dia = 4 AND hora_inicio = '10:00' AND hora_fin = '12:00'
GO

--TEST 1.2: Crear Turno Fallido (Dia Incorrecto ya existe)
DECLARE @id_clase_test INT;

SELECT @id_clase_test = id_clase
FROM tabla.Clases c
INNER JOIN tabla.Deportes d ON d.id_deporte = c.id_clase
WHERE d.nombre = 'Futbol_test_clase_turno';

SELECT * FROM tabla.Turnos
EXEC spInsercion.CrearTurno
    @id_clase = @id_clase_test,
    @dia = 11,
    @hora_inicio = '10:00',
    @hora_fin = '12:00'
GO

--TEST 1.3: Crear Turno Fallido (Hora Inicio Incorrecta ya existe)
DECLARE @id_clase_test INT;

SELECT @id_clase_test = id_clase
FROM tabla.Clases c
INNER JOIN tabla.Deportes d ON d.id_deporte = c.id_clase
WHERE d.nombre = 'Futbol_test_clase_turno';

SELECT * FROM tabla.Turnos
EXEC spInsercion.CrearTurno
    @id_clase = @id_clase_test,
    @dia = 4,
    @hora_inicio = '18:00',
    @hora_fin = '14:00'
GO

-- ACTUALIZACION

-- TEST 2.1: Actualizar Turno Exitoso
DECLARE @id_clase_test INT;
DECLARE @id_turno_test INT;

SELECT @id_clase_test = id_clase
FROM tabla.Clases c
INNER JOIN tabla.Deportes d ON d.id_deporte = c.id_clase
WHERE d.nombre = 'Futbol_test_clase_turno';

SELECT @id_turno_test = id_turno
FROM tabla.Turnos
WHERE id_clase = @id_clase_test

SELECT * FROM tabla.Turnos WHERE id_turno = @id_turno_test
EXEC spActualizacion.ActualizarTurno
    @id_turno = @id_turno_test,
	@id_clase = @id_clase_test,
    @dia = 4,
    @hora_inicio = '12:00',
    @hora_fin = '14:00'

SELECT * FROM tabla.Turnos WHERE id_turno = @id_turno_test
GO

-- TEST 2.2: Actualizar Turno Fallido (Dia Incorrecto)
DECLARE @id_clase_test INT;
DECLARE @id_turno_test INT;

SELECT @id_clase_test = id_clase
FROM tabla.Clases c
INNER JOIN tabla.Deportes d ON d.id_deporte = c.id_clase
WHERE d.nombre = 'Futbol_test_clase_turno';

SELECT @id_turno_test = id_turno
FROM tabla.Turnos
WHERE id_clase = @id_clase_test

SELECT * FROM tabla.Turnos
EXEC spActualizacion.ActualizarTurno
    @id_turno = @id_turno_test,
	@id_clase = @id_clase_test,
    @dia = 11,
    @hora_inicio = '10:00',
    @hora_fin = '12:00'
GO

-- TEST 2.3: Actualizar Turno Fallido (Hora Inicio Incorrecta)
DECLARE @id_clase_test INT;
DECLARE @id_turno_test INT;

SELECT @id_clase_test = id_clase
FROM tabla.Clases c
INNER JOIN tabla.Deportes d ON d.id_deporte = c.id_clase
WHERE d.nombre = 'Futbol_test_clase_turno';

SELECT @id_turno_test = id_turno
FROM tabla.Turnos
WHERE id_clase = @id_clase_test

SELECT * FROM tabla.Turnos
EXEC spActualizacion.ActualizarTurno
    @id_turno = @id_turno_test,
	@id_clase = @id_clase_test,
    @dia = 4,
    @hora_inicio = '18:00',
    @hora_fin = '14:00'
GO

-- ELIMINACION

-- TEST 3.1: Eliminar Turno Exitoso
DECLARE @id_clase_test INT;
DECLARE @id_turno_test INT;

SELECT @id_clase_test = id_clase
FROM tabla.Clases c
INNER JOIN tabla.Deportes d ON d.id_deporte = c.id_clase
WHERE d.nombre = 'Futbol_test_clase_turno';

SELECT @id_turno_test = id_turno
FROM tabla.Turnos
WHERE id_clase = @id_clase_test

SELECT * FROM tabla.Turnos
EXEC spEliminacion.EliminarTurno
    @id_turno = @id_turno_test

SELECT * FROM tabla.Turnos WHERE id_turno = @id_turno_test
GO

-- TEST 3.2: Eliminar Turno Fallido (Turno No Existe)
SELECT * FROM tabla.Turnos
EXEC spEliminacion.EliminarTurno
    @id_turno = 9999999
GO


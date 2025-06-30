--Turnos

-- Se crean los TESTS para la insercion, actualizacion y eliminacion de Turnos

USE Com2900G07
GO

-- INSERCION

-- TEST 1.1: Crear Turno Exitoso
SELECT * FROM tabla.Turnos
EXEC spInsercion.CrearTurno
    @id_clase = 1,
    @dia = 4,
    @hora_inicio = '10:00',
    @hora_fin = '12:00'
GO
SELECT * FROM tabla.Turnos WHERE id_clase = 1 AND dia = 4 AND hora_inicio = '10:00' AND hora_fin = '12:00'
GO

--TEST 1.2: Crear Turno Fallido (Dia Incorrecto ya existe)
SELECT * FROM tabla.Turnos
EXEC spInsercion.CrearTurno
    @id_clase = 1,
    @dia = 11,
    @hora_inicio = '10:00',
    @hora_fin = '12:00'
GO
SELECT * FROM tabla.Turnos WHERE id_clase = 1 AND dia = 11 AND hora_inicio = '10:00' AND hora_fin = '12:00'
GO

--TEST 1.3: Crear Turno Fallido (Hora Inicio Incorrecta ya existe)
SELECT * FROM tabla.Turnos
EXEC spInsercion.CrearTurno
    @id_clase = 1,
    @dia = 4,
    @hora_inicio = '18:00',
    @hora_fin = '14:00'
GO
SELECT * FROM tabla.Turnos WHERE id_clase = 1 AND dia = 4 AND hora_inicio = '18:00' AND hora_fin = '14:00'
GO

-- ACTUALIZACION

-- TEST 2.1: Actualizar Turno Exitoso
SELECT * FROM tabla.Turnos
EXEC spActualizacion.ActualizarTurno
    @id_turno = 1,
	@id_clase = 1,
    @dia = 4,
    @hora_inicio = '10:00',
    @hora_fin = '12:00'
GO
SELECT * FROM tabla.Turnos WHERE id_turno = 1 AND dia = 4 AND hora_inicio = '10:00' AND hora_fin = '12:00'
GO

-- TEST 2.2: Actualizar Turno Fallido (Dia Incorrecto)
SELECT * FROM tabla.Turnos
EXEC spActualizacion.ActualizarTurno
    @id_turno = 1,
	@id_clase = 1,
    @dia = 11,
    @hora_inicio = '10:00',
    @hora_fin = '12:00'
GO
SELECT * FROM tabla.Turnos WHERE id_turno = 1 AND dia = 11 AND hora_inicio = '10:00' AND hora_fin = '12:00'
GO

-- TEST 2.3: Actualizar Turno Fallido (Hora Inicio Incorrecta)
SELECT * FROM tabla.Turnos
EXEC spActualizacion.ActualizarTurno
    @id_turno = 1,
	@id_clase = 1,
    @dia = 4,
    @hora_inicio = '18:00',
    @hora_fin = '14:00'
GO
SELECT * FROM tabla.Turnos WHERE id_turno = 1 AND dia = 4 AND hora_inicio = '18:00' AND hora_fin = '14:00'
GO

-- ELIMINACION

-- TEST 3.1: Eliminar Turno Exitoso
SELECT * FROM tabla.Turnos
EXEC spEliminacion.EliminarTurno
    @id_turno = 1
GO
SELECT * FROM tabla.Turnos WHERE id_turno = 1
GO

-- TEST 3.2: Eliminar Turno Fallido (Turno No Existe)
SELECT * FROM tabla.Turnos
EXEC spEliminacion.EliminarTurno
    @id_turno = 99991
GO


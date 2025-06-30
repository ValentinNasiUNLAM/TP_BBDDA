-- Actividad
-- Se crean los TESTS para la insercion, actualizacion y eliminacion de Actividad

USE Com2900G07
GO

--INSERCION

--TEST 1.1: Insercion Correcta
EXEC spInsercion.CrearActividad
    @dni = 12345678,
    @id_deporte = 1
GO
SELECT * FROM tabla.Actividades

--TEST 1.2: Error Id_socio
EXEC spInsercion.CrearActividad
    @dni = 12345678,
    @id_deporte = 1
GO
SELECT * FROM tabla.Actividades WHERE id_socio = 99999991;

--TEST 1.3: Error id_deporte
EXEC spInsercion.CrearActividad
    @dni = 12345678,
    @id_deporte = 99999991
GO
SELECT * FROM tabla.Actividades WHERE id_deporte = 99999991;

--Eliminacion
--Test 3.1: Eliminar Actividad
EXEC spEliminacion.EliminarActividad
    @dni = 12345678,
    @id_deporte = 1;
GO

--Test 3.2: Dni Incorrecto
EXEC spEliminacion.EliminarActividad
    @dni = 99999991,
    @id_deporte = 1;
GO

--Test 3.3: ID deporte Incorrecto
EXEC spEliminacion.EliminarActividad
    @dni = 12345678,
    @id_deporte = 999999;
GO

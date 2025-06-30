-- Actividad
-- Se crean los TESTS para la insercion, actualizacion y eliminacion de Actividad

USE Com2900G07
GO
DECLARE @id_socio INT;
--INSERCION
--TEST 1.1: Insercion Correcta
EXEC spInsercion.CrearActividad
    @id_socio = 1,
    @id_deporte = 1
GO
SELECT * FROM tabla.Actividades
--TEST 1.2: Error Id_socio
EXEC spInsercion.CrearActividad
    @id_socio = 99999991,
    @id_deporte = 1
GO
SELECT * FROM tabla.Actividades WHERE id_socio = 99999991;
--TEST 1.3: Error id_deporte
EXEC spInsercion.CrearActividad
    @id_socio = 1,
    @id_deporte = 99999991
GO
SELECT * FROM tabla.Actividades WHERE id_deporte = 99999991;
--Actualizacion
-- Test 2.1: Actualizacion Correcta
EXEC spActualizacion.actualizarActividad
    @dni = 23777221,
    @id_deporte = 1;
GO
SELECT @id_socio = id_socio FROM tabla.Socios WHERE dni = @dni;
SELECT * FROM tabla.Actividades WHERE id_socio = @id_socio;
--Test 2.2: Dni incorrecto
EXEC spActualizacion.actualizarActividad
    @dni = 99999991,
    @id_deporte = 1;
GO
SELECT @id_socio = id_socio FROM tabla.Socios WHERE dni = @dni;
SELECT * FROM tabla.Actividades WHERE id_socio = @id_socio;
--Test 2.3: Deporte Incorrecto
EXEC spActualizacion.actualizarActividad
    @dni = 23777221,
    @id_deporte = 999999;
GO
SELECT @id_socio = id_socio FROM tabla.Socios WHERE dni = @dni;
SELECT * FROM tabla.Actividades WHERE id_socio = @id_socio;
--Eliminacion
--Test 3.1: Eliminar Actividad
EXEC spActualizacion.eliminarActividad
    @dni = 23777221,
    @id_deporte = 1;
GO
SELECT @id_socio = id_socio FROM tabla.Socios WHERE dni = @dni;
SELECT * FROM tabla.Actividades WHERE id_socio = @id_socio;
--Test 3.2: Dni Incorrecto
EXEC spActualizacion.eliminarActividad
    @dni = 99999991,
    @id_deporte = 1;
GO
--Test 3.3: ID deporte Incorrecto
EXEC spActualizacion.eliminarActividad
    @dni = 23777221,
    @id_deporte = 999999;
GO
SELECT @id_socio = id_socio FROM tabla.Socios WHERE dni = @dni;
SELECT * FROM tabla.Actividades WHERE id_socio = @id_socio;
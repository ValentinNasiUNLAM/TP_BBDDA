-- Actividad
-- Se crean los TESTS para la insercion, actualizacion y eliminacion de Actividad

USE Com2900G07
GO

--Agregamos un socio y un deporte para testear
EXEC spInsercion.CrearPrestadorSalud
    @nombre = 'Galeno_test_actividad',
    @tipo = 1,
    @telefono = 46254016

DECLARE @id_prestador_salud_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM tabla.PrestadoresSalud
WHERE nombre = 'Galeno_test_actividad';

EXEC spInsercion.CrearSocio
    @dni = 11222444,
    @nombre = 'Test',
    @apellido = 'Actividad',
    @email = 'test_actividad@sol.com',
    @fecha_nacimiento = '2002-11-26',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @id_prestador_salud = @id_prestador_salud_test

EXEC spInsercion.CrearDeporte
    @nombre = 'Futbol_test_actividad',
    @precio = 1000
GO

--INSERCION

--TEST 1.1: Insercion Correcta
DECLARE @id_deporte_test INT

SELECT @id_deporte_test = id_deporte
FROM tabla.Deportes
WHERE nombre = 'Futbol_test_actividad'

EXEC spInsercion.CrearActividad
    @dni = 11222444,
    @id_deporte = @id_deporte_test
GO
SELECT * FROM tabla.Actividades

--TEST 1.2: Error DNI Socio
EXEC spInsercion.CrearActividad
    @dni = 99999999,
    @id_deporte = 1
GO

--TEST 1.3: Error id_deporte
EXEC spInsercion.CrearActividad
    @dni = 11222444,
    @id_deporte = 99999991
GO


--Eliminacion
--Test 3.1: Eliminar Actividad
DECLARE @id_deporte_test INT

SELECT @id_deporte_test = id_deporte
FROM tabla.Deportes
WHERE nombre = 'Futbol_test_actividad'

EXEC spEliminacion.EliminarActividad
    @dni = 11222444,
    @id_deporte = @id_deporte_test;
GO

--Test 3.2: Dni Incorrecto
EXEC spEliminacion.EliminarActividad
    @dni = 99999999,
    @id_deporte = 1;
GO

--Test 3.3: ID deporte Incorrecto
EXEC spEliminacion.EliminarActividad
    @dni = 11222444,
    @id_deporte = 999999;
GO

--Clases
-- Se crean los TESTS para la insercion, actualizacion y eliminacion de Clases
USE Com2900G07
GO

-- Agregar un nuevo deporte para usar de prueba
EXEC spInsercion.CrearDeporte
    @nombre = 'Futbol_test_clase',
    @precio = 1000
GO

--INSERCION

-- TEST 1.1: Insertar una Clase
DECLARE @id_deporte_test INT;

SELECT @id_deporte_test = id_deporte
FROM tabla.Deportes
WHERE nombre = 'Futbol_test_clase';

SELECT * FROM tabla.Clases
EXEC spInsercion.CrearClase
    @id_deporte = @id_deporte_test

SELECT * FROM tabla.Clases WHERE id_deporte = @id_deporte_test
GO

-- ELIMINACION
-- TEST 3.1: Eliminar un Deporte
DECLARE @id_deporte_test INT;

SELECT @id_deporte_test = id_deporte
FROM tabla.Deportes
WHERE nombre = 'Futbol_test_clase';

SELECT * FROM tabla.Clases
EXEC spEliminacion.EliminarClase
    @id_deporte = @id_deporte_test
SELECT * FROM tabla.Clases WHERE id_clase = 1
GO

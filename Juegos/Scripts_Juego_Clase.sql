--Clases
-- Se crean los TESTS para la insercion, actualizacion y eliminacion de Clases
USE Com2900G07
GO

--INSERCION

-- TEST 1.1: Insertar un Deporte
SELECT * FROM tabla.Clases
EXEC spInsercion.CrearClase
    @id_deporte = 1
GO
SELECT * FROM tabla.Clases WHERE id_clase = 1
GO

-- ELIMINACION
-- TEST 3.1: Eliminar un Deporte
SELECT * FROM tabla.Clases
EXEC spEliminacion.EliminarClase
    @id_clase = 1
GO
SELECT * FROM tabla.Clases WHERE id_clase = 1
GO

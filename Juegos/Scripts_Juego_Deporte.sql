--DEPORTES
--Se crean los TESTS para la insercion, actualizacion y eliminacion de datos en la tabla DEPORTES

USE Com2900G07
GO

--INSERCION

--TEST 1.1: Agregar un nuevo deporte Exitoso
SELECT * FROM tabla.Deportes;
EXEC spInsercion.CrearDeporte
    @nombre = 'Futbol',
    @precio = 1000
GO
SELECT * FROM tabla.Deportes WHERE nombre = 'Futbol';
--TEST 1.2: Error precio negativo
EXEC spInsercion.CrearDeporte
    @nombre = 'Baloncesto',
    @precio = -500
GO
SELECT * FROM tabla.Deportes WHERE nombre = 'Baloncesto';
--TEST 1.3: Nombre Vacio
EXEC spInsercion.CrearDeporte
    @nombre = '',
    @precio = 500
GO
SELECT * FROM tabla.Deportes;

--ACTUALIZACION
--TEST 2.1: Actualizar un deporte exitoso
EXEC spActualizacion.ActualizarDeporte
    @id = 1,
    @nombre = 'Futbol Profesional',
    @precio = 1200
GO
SELECT * FROM tabla.Deportes WHERE id = 1;
--TEST 2.2: Actualizar un deporte con nombre vacio
EXEC spActualizacion.ActualizarDeporte
    @id = 1,
    @nombre = '',
    @precio = 1200
GO
SELECT * FROM tabla.Deportes WHERE id = 1;
--TEST 2.3: Actualizar un deporte con precio negativo
EXEC spActualizacion.ActualizarDeporte
    @id = 1,
    @nombre = 'Futbol Profesional',
    @precio = -1000
GO
SELECT * FROM tabla.Deportes WHERE id = 1;
--ELIMINACION
--TEST 3.1: Eliminar un deporte exitoso
EXEC spEliminacion.EliminarDeporte
    @id = 1
GO
SELECT * FROM tabla.Deportes WHERE id = 1;
--TEST 3.2: Eliminar un deporte que no existe
EXEC spEliminacion.EliminarDeporte
    @id = 9999
GO
SELECT * FROM tabla.Deportes WHERE id = 9999;

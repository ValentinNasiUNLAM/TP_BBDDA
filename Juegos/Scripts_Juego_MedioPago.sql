--Medios Pago
-- Se crean los TESTS para la insercion, actualizacion y eliminacion de Medios Pago
USE Com2900G07
GO
-- Insercion
--TEST 1.1: Registro de un nuevo medio de pago
SELECT * FROM tabla.MediosPago
EXEC spInsercion.CrearMedioPago
    @Nombre = 'Tarjeta de Crédito',
    @Descripcion = 'Pago con tarjeta de crédito'
GO
SELECT * FROM tabla.MediosPago WHERE Nombre = 'Tarjeta de Crédito'
GO
--TEST 1.2: Error al insertar un medio de pago con nombre vacío
EXEC spInsercion.CrearMedioPago
    @Nombre = '',
    @Descripcion = 'Pago con tarjeta de crédito'
GO
SELECT * FROM tabla.MediosPago WHERE Nombre = 'Tarjeta de Crédito'
GO

-- Actualizacion
--TEST 2.1: Actualizar un medio de pago existente
SELECT * FROM tabla.MediosPago
EXEC spActualizacion.ActualizarMedioPago
    @id,
    @Nombre = 'Tarjeta de Débito',
    @Descripcion = 'Pago con tarjeta de débito'
GO
SELECT * FROM tabla.MediosPago WHERE id = @id
GO
--TEST 2.2: Error al actualizar un medio de pago con nombre vacío
EXEC spActualizacion.ActualizarMedioPago
    @id,
    @Nombre = '',
    @Descripcion = 'Pago con tarjeta de débito'
GO
SELECT * FROM tabla.MediosPago WHERE id = @id
GO
-- Eliminacion
--TEST 3.1: Eliminar un medio de pago existente
SELECT * FROM tabla.MediosPago
EXEC spEliminacion.EliminarMedioPago
    @id
GO
SELECT * FROM tabla.MediosPago WHERE id = @id
GO
--TEST 3.2: Error al eliminar un medio de pago inexistente
EXEC spEliminacion.EliminarMedioPago
    @id = 9999 -- Asumiendo que este ID no existe
GO
SELECT * FROM tabla.MediosPago WHERE id = 9999
GO


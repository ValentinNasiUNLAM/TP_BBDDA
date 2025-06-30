--REEMBOLSOS

USE Com2900G07
GO

--Agregamos un socio, cuenta, factura, medio de pago, pago y administrador para testear
EXEC spInsercion.CrearPrestadorSalud
    @nombre = 'Galeno_test_reembolso',
    @tipo = 1,
    @telefono = 46254016

DECLARE @id_prestador_salud_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM tabla.PrestadoresSalud
WHERE nombre = 'Galeno_test_reembolso';

EXEC spInsercion.CrearSocio
    @dni = 11444666,
    @nombre = 'Socio',
    @apellido = 'Prueba Reembolso',
    @email = 'socio_prueba_reembolso@sol.com',
    @fecha_nacimiento = '2002-11-26',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @id_prestador_salud = @id_prestador_salud_test

EXEC spInsercion.CrearFacturaARCA
    @dni = 11444666,
    @descripcion = 'Factura de prueba de reembolso',
    @total = 10000,
    @tipo = 'A',
    @primer_vencimiento = '2025-10-15',
    @segundo_vencimiento = '2025-10-30',
    @recargo = 5


EXEC spInsercion.CrearMedioPago
    @Nombre = 'Tarjeta de Crédito',
    @Descripcion = 'Pago con tarjeta de crédito'

DECLARE @numero_factura_test INT
DECLARE @id_medio_pago_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11444666) AND descripcion = 'Factura de prueba de reembolso'

SELECT @id_medio_pago_test = id_medio_pago
FROM tabla.MediosPago
WHERE nombre = 'Tarjeta de Crédito'

EXEC spInsercion.CrearPago
	@numero_factura = @numero_factura_test,
	@id_medio_pago = @id_medio_pago_test,
	@fecha = '2025-06-30 16:45:29',
	@total = 1000,
	@reembolso = 100

EXEC spInsercion.CrearCuentaSocio
	@dni = 11444666,
	@contrasena = '12345$a',
	@usuario = 'socioPruebaReembolso',
	@rol = 1,
	@saldo = 0,
	@fecha_vigencia_contrasena = '2026-06-30 23:59:59',
	@estado_cuenta = 1

EXEC spInsercion.CrearAdministrador
    @nombre = 'Prueba',
    @apellido = 'Reembolso',
    @dni = 22444666,
    @email = 'pruba_reembolso@sol.com',
    @rol = 2
GO

--INSERCION

--TEST 1.1: Insercion correcta
DECLARE @id_pago_test INT
DECLARE @numero_factura_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11444666) AND descripcion = 'Factura de prueba de reembolso'

SELECT @id_pago_test = id_pago
FROM tabla.Pagos
WHERE numero_factura = @numero_factura_test

SELECT * FROM tabla.Reembolsos
EXEC spInsercion.CrearReembolso
	@id_pago = @id_pago_test,
	@dni_socio = 11444666,
	@dni_admin = 22444666,
	@motivo = 'Porque si',
	@fecha = '2025-06-30 17:32:45',
	@monto = 150
SELECT * FROM tabla.Reembolsos
GO

--TEST 1.2: ID pago invalido
EXEC spInsercion.CrearReembolso
	@id_pago = 99999,
	@dni_socio = 11444666,
	@dni_admin = 22444666,
	@motivo = 'Porque si',
	@fecha = '2025-06-30 17:32:45',
	@monto = 150

--TEST 1.3: DNI socio incorrecto
DECLARE @id_pago_test INT
DECLARE @numero_factura_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11444666) AND descripcion = 'Factura de prueba de reembolso'

SELECT @id_pago_test = id_pago
FROM tabla.Pagos
WHERE numero_factura = @numero_factura_test

EXEC spInsercion.CrearReembolso
	@id_pago = @id_pago_test,
	@dni_socio = 9999999,
	@dni_admin = 22444666,
	@motivo = 'Porque si',
	@fecha = '2025-06-30 17:32:45',
	@monto = 150
GO

--TEST 1.4: DNI administrador incorrecto
DECLARE @id_pago_test INT
DECLARE @numero_factura_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11444666) AND descripcion = 'Factura de prueba de reembolso'

SELECT @id_pago_test = id_pago
FROM tabla.Pagos
WHERE numero_factura = @numero_factura_test

EXEC spInsercion.CrearReembolso
	@id_pago = @id_pago_test,
	@dni_socio = 11444666,
	@dni_admin = 99999999,
	@motivo = 'Porque si',
	@fecha = '2025-06-30 17:32:45',
	@monto = 150
GO

--TEST 1.5: Fecha invalida
DECLARE @id_pago_test INT
DECLARE @numero_factura_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11444666) AND descripcion = 'Factura de prueba de reembolso'

SELECT @id_pago_test = id_pago
FROM tabla.Pagos
WHERE numero_factura = @numero_factura_test

EXEC spInsercion.CrearReembolso
	@id_pago = @id_pago_test,
	@dni_socio = 11444666,
	@dni_admin = 22444666,
	@motivo = 'Porque si',
	@fecha = '2026-06-30 17:32:45',
	@monto = 150
GO

--TEST 1.6: Monto invalido
DECLARE @id_pago_test INT
DECLARE @numero_factura_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11444666) AND descripcion = 'Factura de prueba de reembolso'

SELECT @id_pago_test = id_pago
FROM tabla.Pagos
WHERE numero_factura = @numero_factura_test

EXEC spInsercion.CrearReembolso
	@id_pago = @id_pago_test,
	@dni_socio = 11444666,
	@dni_admin = 22444666,
	@motivo = 'Porque si',
	@fecha = '2025-06-30 17:32:45',
	@monto = 0
GO

--ACTUALIZACION

--TEST 2.1: Actualizacion correcta
DECLARE @id_pago_test INT
DECLARE @numero_factura_test INT
DECLARE @id_reembolso_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11444666) AND descripcion = 'Factura de prueba de reembolso'

SELECT @id_pago_test = id_pago
FROM tabla.Pagos
WHERE numero_factura = @numero_factura_test

SELECT @id_reembolso_test = id_reembolso
FROM tabla.Reembolsos
WHERE id_pago = @id_pago_test

SELECT * FROM tabla.Reembolsos
EXEC spActualizacion.ActualizarReembolso
	@id_reembolso = @id_reembolso_test,
	@id_pago = @id_pago_test,
	@dni_socio = 11444666,
	@dni_admin = 22444666,
	@motivo = 'Porque si y listo',
	@fecha = '2025-06-30 17:32:45',
	@monto = 200
SELECT * FROM tabla.Reembolsos
GO

--TEST 2.2: ID reembolso invalido
DECLARE @id_pago_test INT
DECLARE @numero_factura_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11444666) AND descripcion = 'Factura de prueba de reembolso'

SELECT @id_pago_test = id_pago
FROM tabla.Pagos
WHERE numero_factura = @numero_factura_test


EXEC spActualizacion.ActualizarReembolso
	@id_reembolso = 99999,
	@id_pago = @id_pago_test,
	@dni_socio = 11444666,
	@dni_admin = 22444666,
	@motivo = 'Porque si y listo',
	@fecha = '2025-06-30 17:32:45',
	@monto = 200
GO

--TEST 2.3: ID pago invalido
DECLARE @id_pago_test INT
DECLARE @numero_factura_test INT
DECLARE @id_reembolso_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11444666) AND descripcion = 'Factura de prueba de reembolso'

SELECT @id_pago_test = id_pago
FROM tabla.Pagos
WHERE numero_factura = @numero_factura_test

SELECT @id_reembolso_test = id_reembolso
FROM tabla.Reembolsos
WHERE id_pago = @id_pago_test

EXEC spActualizacion.ActualizarReembolso
	@id_reembolso = @id_reembolso_test,
	@id_pago = 9999,
	@dni_socio = 11444666,
	@dni_admin = 22444666,
	@motivo = 'Porque si y listo',
	@fecha = '2025-06-30 17:32:45',
	@monto = 200
GO

--TEST 2.4: DNI socio invalido
DECLARE @id_pago_test INT
DECLARE @numero_factura_test INT
DECLARE @id_reembolso_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11444666) AND descripcion = 'Factura de prueba de reembolso'

SELECT @id_pago_test = id_pago
FROM tabla.Pagos
WHERE numero_factura = @numero_factura_test

SELECT @id_reembolso_test = id_reembolso
FROM tabla.Reembolsos
WHERE id_pago = @id_pago_test

EXEC spActualizacion.ActualizarReembolso
	@id_reembolso = @id_reembolso_test,
	@id_pago = @id_pago_test,
	@dni_socio = 99999999,
	@dni_admin = 22444666,
	@motivo = 'Porque si y listo',
	@fecha = '2025-06-30 17:32:45',
	@monto = 200
GO

--TEST 2.5: DNI administrador invalido
DECLARE @id_pago_test INT
DECLARE @numero_factura_test INT
DECLARE @id_reembolso_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11444666) AND descripcion = 'Factura de prueba de reembolso'

SELECT @id_pago_test = id_pago
FROM tabla.Pagos
WHERE numero_factura = @numero_factura_test

SELECT @id_reembolso_test = id_reembolso
FROM tabla.Reembolsos
WHERE id_pago = @id_pago_test

EXEC spActualizacion.ActualizarReembolso
	@id_reembolso = @id_reembolso_test,
	@id_pago = @id_pago_test,
	@dni_socio = 11444666,
	@dni_admin = 99999999,
	@motivo = 'Porque si y listo',
	@fecha = '2025-06-30 17:32:45',
	@monto = 200
GO

--TEST 2.6: Fecha invalida
DECLARE @id_pago_test INT
DECLARE @numero_factura_test INT
DECLARE @id_reembolso_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11444666) AND descripcion = 'Factura de prueba de reembolso'

SELECT @id_pago_test = id_pago
FROM tabla.Pagos
WHERE numero_factura = @numero_factura_test

SELECT @id_reembolso_test = id_reembolso
FROM tabla.Reembolsos
WHERE id_pago = @id_pago_test

EXEC spActualizacion.ActualizarReembolso
	@id_reembolso = @id_reembolso_test,
	@id_pago = @id_pago_test,
	@dni_socio = 11444666,
	@dni_admin = 22444666,
	@motivo = 'Porque si y listo',
	@fecha = '2026-06-30 17:32:45',
	@monto = 200
GO

--TEST 2.7: Monto invalido
DECLARE @id_pago_test INT
DECLARE @numero_factura_test INT
DECLARE @id_reembolso_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11444666) AND descripcion = 'Factura de prueba de reembolso'

SELECT @id_pago_test = id_pago
FROM tabla.Pagos
WHERE numero_factura = @numero_factura_test

SELECT @id_reembolso_test = id_reembolso
FROM tabla.Reembolsos
WHERE id_pago = @id_pago_test

EXEC spActualizacion.ActualizarReembolso
	@id_reembolso = @id_reembolso_test,
	@id_pago = @id_pago_test,
	@dni_socio = 11444666,
	@dni_admin = 22444666,
	@motivo = 'Porque si y listo',
	@fecha = '2025-06-30 17:32:45',
	@monto = 0
GO

--ELIMINACION

--TEST 3.1: Eliminacion correcta
DECLARE @id_pago_test INT
DECLARE @numero_factura_test INT
DECLARE @id_reembolso_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11444666) AND descripcion = 'Factura de prueba de reembolso'

SELECT @id_pago_test = id_pago
FROM tabla.Pagos
WHERE numero_factura = @numero_factura_test

SELECT @id_reembolso_test = id_reembolso
FROM tabla.Reembolsos
WHERE id_pago = @id_pago_test

SELECT * FROM tabla.Reembolsos
EXEC spEliminacion.EliminarReembolso
	@id_reembolso = @id_reembolso_test
SELECT * FROM tabla.Reembolsos
GO

--TEST 3.2: ID reembolso invalido
EXEC spEliminacion.EliminarReembolso
	@id_reembolso = 99999
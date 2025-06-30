--PAGOS

USE Com2900G07
GO

--Agregamos un usuario, factura y medio de pago para testear
EXEC spInsercion.CrearPrestadorSalud
    @nombre = 'Galeno_test_pago',
    @tipo = 1,
    @telefono = 46254016

DECLARE @id_prestador_salud_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM tabla.PrestadoresSalud
WHERE nombre = 'Galeno_test_pago';

EXEC spInsercion.CrearSocio
    @dni = 11333555,
    @nombre = 'Socio',
    @apellido = 'Prueba Pago',
    @email = 'socio_prueba_pago@sol.com',
    @fecha_nacimiento = '2002-11-26',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @id_prestador_salud = @id_prestador_salud_test

EXEC spInsercion.CrearFacturaARCA
    @dni = 11333555,
    @descripcion = 'Factura de prueba de pago',
    @total = 10000,
    @tipo = 'A',
    @primer_vencimiento = '2025-10-15',
    @segundo_vencimiento = '2025-10-30',
    @recargo = 5


EXEC spInsercion.CrearMedioPago
    @Nombre = 'Tarjeta de Crédito',
    @Descripcion = 'Pago con tarjeta de crédito'
GO

--INSERCION

--TEST 1.1: Insercion correcta
DECLARE @numero_factura_test INT
DECLARE @id_medio_pago_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11333555) AND descripcion = 'Factura de prueba de pago'

SELECT @id_medio_pago_test = id_medio_pago
FROM tabla.MediosPago
WHERE nombre = 'Tarjeta de Crédito'

SELECT * FROM tabla.Pagos
EXEC spInsercion.CrearPago
	@numero_factura = @numero_factura_test,
	@id_medio_pago = @id_medio_pago_test,
	@fecha = '2025-06-30 16:45:29',
	@total = 1000,
	@reembolso = 100
SELECT * FROM tabla.Pagos
GO

--TEST 1.2: Factura inexistente
DECLARE @id_medio_pago_test INT

SELECT @id_medio_pago_test = id_medio_pago
FROM tabla.MediosPago
WHERE nombre = 'Tarjeta de Crédito'

EXEC spInsercion.CrearPago
	@numero_factura = 99999,
	@id_medio_pago = @id_medio_pago_test,
	@fecha = '2025-06-30 16:45:29',
	@total = 1000,
	@reembolso = 100
GO

--TEST 1.3: Medio de apgo inexistente
DECLARE @numero_factura_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11333555) AND descripcion = 'Factura de prueba de pago'

EXEC spInsercion.CrearPago
	@numero_factura = @numero_factura_test,
	@id_medio_pago = 99999,
	@fecha = '2025-06-30 16:45:29',
	@total = 1000,
	@reembolso = 100
GO

--TEST 1.4: Fecha invalida
DECLARE @numero_factura_test INT
DECLARE @id_medio_pago_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11333555) AND descripcion = 'Factura de prueba de pago'

SELECT @id_medio_pago_test = id_medio_pago
FROM tabla.MediosPago
WHERE nombre = 'Tarjeta de Crédito'

EXEC spInsercion.CrearPago
	@numero_factura = @numero_factura_test,
	@id_medio_pago = @id_medio_pago_test,
	@fecha = '2026-06-30 16:45:29',
	@total = 1000,
	@reembolso = 100
GO

--TEST 1.5: Monto invalido
DECLARE @numero_factura_test INT
DECLARE @id_medio_pago_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11333555) AND descripcion = 'Factura de prueba de pago'

SELECT @id_medio_pago_test = id_medio_pago
FROM tabla.MediosPago
WHERE nombre = 'Tarjeta de Crédito'

EXEC spInsercion.CrearPago
	@numero_factura = @numero_factura_test,
	@id_medio_pago = @id_medio_pago_test,
	@fecha = '2025-06-30 16:45:29',
	@total = 0,
	@reembolso = 0
GO

--ACTUALIZACION

--TEST 2.1: Actualizacion correcta
DECLARE @numero_factura_test INT
DECLARE @id_medio_pago_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11333555) AND descripcion = 'Factura de prueba de pago'

SELECT @id_medio_pago_test = id_medio_pago
FROM tabla.MediosPago
WHERE nombre = 'Tarjeta de Crédito'

SELECT * FROM tabla.Pagos
EXEC spActualizacion.ActualizarPago
	@numero_factura = @numero_factura_test,
	@id_medio_pago = @id_medio_pago_test,
	@fecha = '2025-06-30 16:45:29',
	@total = 1500,
	@reembolso = 150
SELECT * FROM tabla.Pagos
GO

--TEST 2.2: Factura inexistente
DECLARE @id_medio_pago_test INT

SELECT @id_medio_pago_test = id_medio_pago
FROM tabla.MediosPago
WHERE nombre = 'Tarjeta de Crédito'

EXEC spActualizacion.ActualizarPago
	@numero_factura = 99999,
	@id_medio_pago = @id_medio_pago_test,
	@fecha = '2025-06-30 16:45:29',
	@total = 1000,
	@reembolso = 100
GO

--TEST 2.3: Medio de pago inexistente
DECLARE @numero_factura_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11333555) AND descripcion = 'Factura de prueba de pago'

EXEC spActualizacion.ActualizarPago
	@numero_factura = @numero_factura_test,
	@id_medio_pago = 99999,
	@fecha = '2025-06-30 16:45:29',
	@total = 1000,
	@reembolso = 100
GO

--TEST 2.4: Fecha invalida
DECLARE @numero_factura_test INT
DECLARE @id_medio_pago_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11333555) AND descripcion = 'Factura de prueba de pago'

SELECT @id_medio_pago_test = id_medio_pago
FROM tabla.MediosPago
WHERE nombre = 'Tarjeta de Crédito'

EXEC spActualizacion.ActualizarPago
	@numero_factura = @numero_factura_test,
	@id_medio_pago = @id_medio_pago_test,
	@fecha = '2026-06-30 16:45:29',
	@total = 1000,
	@reembolso = 100
GO

--TEST 2.5: Monto invalido
DECLARE @numero_factura_test INT
DECLARE @id_medio_pago_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11333555) AND descripcion = 'Factura de prueba de pago'

SELECT @id_medio_pago_test = id_medio_pago
FROM tabla.MediosPago
WHERE nombre = 'Tarjeta de Crédito'

EXEC spActualizacion.ActualizarPago
	@numero_factura = @numero_factura_test,
	@id_medio_pago = @id_medio_pago_test,
	@fecha = '2025-06-30 16:45:29',
	@total = 0,
	@reembolso = 0
GO


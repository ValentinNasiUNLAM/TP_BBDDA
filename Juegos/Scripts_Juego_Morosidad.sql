-- Morosidades

USE Com2900G07
GO

--Agregamos una factura para testear
EXEC spInsercion.CrearPrestadorSalud
    @nombre = 'Galeno_test_morosidad',
    @tipo = 1,
    @telefono = 46254016

DECLARE @id_prestador_salud_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM tabla.PrestadoresSalud
WHERE nombre = 'Galeno_test_morosidad';

EXEC spInsercion.CrearSocio
    @dni = 33444555,
    @nombre = 'Socio',
    @apellido = 'Prueba Morosidad',
    @email = 'socio_prueba_morosidad@sol.com',
    @fecha_nacimiento = '2002-11-26',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @id_prestador_salud = @id_prestador_salud_test
GO

EXEC spInsercion.CrearFacturaARCA
    @dni = 33444555,
    @descripcion = 'Factura de prueba morosidad',
    @total = 10000,
    @tipo = 'A',
    @primer_vencimiento = '2025-05-15',
    @segundo_vencimiento = '2025-05-30',
    @recargo = 5
GO

--INSERCION

-- TEST 1.1: Creacion correcta
DECLARE @numero_factura_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(33444555) AND descripcion = 'Factura de prueba morosidad'

EXEC spInsercion.CrearMorosidad
	@numero_factura = @numero_factura_test,
	@monto_total = 1000,
	@fecha_pago = NULL
SELECT * FROM tabla.Morosidades
GO

--TEST 1.2: Factura invalida
EXEC spInsercion.CrearMorosidad
	@numero_factura = 99999,
	@monto_total = 1000,
	@fecha_pago = NULL
GO

--TEST 1.3: Morosidad sin monto
DECLARE @numero_factura_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(33444555) AND descripcion = 'Factura de prueba morosidad'

EXEC spInsercion.CrearMorosidad
	@numero_factura = @numero_factura_test,
	@monto_total = 0,
	@fecha_pago = NULL
GO

--ACTUALIZACION

--TEST 2.1: Actualizar correctamente
DECLARE @numero_factura_test INT
DECLARE @id_morosidad_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(33444555) AND descripcion = 'Factura de prueba morosidad'

SELECT @id_morosidad_test = id_morosidad
FROM tabla.Morosidades
WHERE numero_factura = @numero_factura_test

SELECT * FROM tabla.Morosidades
EXEC spActualizacion.ActualizarMorosidad
	@id_morosidad = @id_morosidad_test,
	@numero_factura = @numero_factura_test,
	@monto_total = 1000,
	@fecha_pago = '2025-06-30 15:40:13'
SELECT * FROM tabla.Morosidades
GO

--TEST 2.2: ID morosidad inexistente
DECLARE @numero_factura_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(33444555) AND descripcion = 'Factura de prueba morosidad'

EXEC spActualizacion.ActualizarMorosidad
	@id_morosidad = 99999,
	@numero_factura = @numero_factura_test,
	@monto_total = 1000,
	@fecha_pago = '2025-06-30 15:40:13'
GO

--TEST 2.3: Numero factura inexistente
DECLARE @numero_factura_test INT
DECLARE @id_morosidad_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(33444555) AND descripcion = 'Factura de prueba morosidad'

SELECT @id_morosidad_test = id_morosidad
FROM tabla.Morosidades
WHERE numero_factura = @numero_factura_test

EXEC spActualizacion.ActualizarMorosidad
	@id_morosidad = @id_morosidad_test,
	@numero_factura = 99999,
	@monto_total = 1000,
	@fecha_pago = '2025-06-30 15:40:13'
GO

--ELIMINACION

--TEST 3.1: Eliminacion correcta
DECLARE @numero_factura_test INT
DECLARE @id_morosidad_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(33444555) AND descripcion = 'Factura de prueba morosidad'

SELECT @id_morosidad_test = id_morosidad
FROM tabla.Morosidades
WHERE numero_factura = @numero_factura_test

EXEC spEliminacion.EliminarMorosidad
	@id_morosidad = @id_morosidad_test

--TEST 3.2: ID morosidad inexistente
EXEC spEliminacion.EliminarMorosidad
	@id_morosidad = 99999
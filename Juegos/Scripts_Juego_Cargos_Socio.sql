--Cargo socio

USE Com2900G07
GO

--Agregamos un socio, cuota, deporte, actividad extra y factura para testear
EXEC spInsercion.CrearPrestadorSalud
    @nombre = 'Galeno_test_cargo_socio',
    @tipo = 1,
    @telefono = 46254016

DECLARE @id_prestador_salud_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM tabla.PrestadoresSalud
WHERE nombre = 'Galeno_test_cargo_socio';

EXEC spInsercion.CrearSocio
    @dni = 11555999,
    @nombre = 'Socio',
    @apellido = 'Prueba Cargo Socio',
    @email = 'socio_prueba_cs@sol.com',
    @fecha_nacimiento = '2002-11-26',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @id_prestador_salud = @id_prestador_salud_test

EXEC spInsercion.CrearCategoria
    @nombre_categoria = 'Adulto_test',
    @edad_min = 18,
    @edad_max = 60,
    @precio_mensual = 5000

DECLARE @id_categoria_test INT

SELECT @id_categoria_test = id_categoria
FROM tabla.Categorias
WHERE nombre_categoria = 'Adulto_test'

EXEC spInsercion.CrearCuota
    @dni = 11555999,
    @id_categoria = @id_categoria_test

EXEC spInsercion.CrearDeporte
    @nombre = 'Futbol_test_cargo_socio',
    @precio = 1000

DECLARE @id_deporte_test INT

SELECT @id_deporte_test = id_deporte
FROM tabla.Deportes
WHERE nombre = 'Futbol_test_cargo_socio'

EXEC spInsercion.CrearActividad
    @dni = 11555999,
    @id_deporte = @id_deporte_test

EXEC spInsercion.CrearActividadExtra
    @dni = 11555999,
    @dni_invitado = NULL,
    @tipo_actividad = 1,
    @fecha = '2025-06-01',
    @fecha_reserva = '2025-05-20',
    @monto = 1000,
    @monto_invitado = NULL,
    @lluvia = NULL

EXEC spInsercion.CrearFacturaARCA
    @dni = 11555999,
    @descripcion = 'Factura de prueba cargo socio',
    @total = 10000,
    @tipo = 'A',
    @primer_vencimiento = '2025-10-15',
    @segundo_vencimiento = '2025-10-30',
    @recargo = 5

GO


--INSERCION

--TEST 1.1: Creacion correcta de un cargo de cuota
DECLARE @numero_factura_test INT;
DECLARE @id_cuota_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11555999) AND descripcion = 'Factura de prueba cargo socio'

SELECT @id_cuota_test = id_cuota
FROM tabla.Cuotas
WHERE id_socio = fnBusqueda.BuscarSocio(11555999)

EXEC spInsercion.CrearCargoSocio
	@numero_factura = @numero_factura_test,
	@fecha_creacion = '2025-06-30 09:05:56',
	@descripcion = 'Cargo de prueba sobre cuota',
	@monto_descuento = 100,
	@monto_total = 1000,
	@id_deporte = NULL,
	@id_actividad_extra = NULL,
	@id_cuota = @id_cuota_test
GO

--TEST 1.2: Creacion correcta de un cargo de deporte
DECLARE @numero_factura_test INT;
DECLARE @id_deporte_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11555999) AND descripcion = 'Factura de prueba cargo socio'

SELECT @id_deporte_test = d.id_deporte
FROM tabla.Deportes d
INNER JOIN tabla.Actividades a ON a.id_deporte = d.id_deporte
WHERE a.id_socio = fnBusqueda.BuscarSocio(11555999)

EXEC spInsercion.CrearCargoSocio
	@numero_factura = @numero_factura_test,
	@fecha_creacion = '2025-06-30 10:05:56',
	@descripcion = 'Cargo de prueba sobre cuota',
	@monto_descuento = 100,
	@monto_total = 1000,
	@id_deporte = @id_deporte_test,
	@id_actividad_extra = NULL,
	@id_cuota = NULL
GO

--TEST 1.3: Creacion correcta de un cargo de actividad extra
DECLARE @numero_factura_test INT;
DECLARE @id_actividad_extra_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11555999) AND descripcion = 'Factura de prueba cargo socio'

SELECT @id_actividad_extra_test = id_actividad_extra
FROM tabla.ActividadesExtra 
WHERE id_socio = fnBusqueda.BuscarSocio(11555999)

EXEC spInsercion.CrearCargoSocio
	@numero_factura = @numero_factura_test,
	@fecha_creacion = '2025-06-30 10:05:56',
	@descripcion = 'Cargo de prueba sobre cuota',
	@monto_descuento = 100,
	@monto_total = 1000,
	@id_deporte = NULL,
	@id_actividad_extra = @id_actividad_extra_test,
	@id_cuota = NULL
GO

--TEST 1.4: Factura inexistente
EXEC spInsercion.CrearCargoSocio
	@numero_factura = 99999,
	@fecha_creacion = '2025-06-30 10:05:56',
	@descripcion = 'Cargo de prueba sobre cuota',
	@monto_descuento = 100,
	@monto_total = 1000,
	@id_deporte = NULL,
	@id_actividad_extra = 1,
	@id_cuota = NULL
GO

--TEST 1.5: Fecha de creacion posterior a fecha actual
DECLARE @numero_factura_test INT;

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11555999) AND descripcion = 'Factura de prueba cargo socio'

EXEC spInsercion.CrearCargoSocio
	@numero_factura = @numero_factura_test,
	@fecha_creacion = '2026-06-30 10:05:56',
	@descripcion = 'Cargo de prueba sobre cuota',
	@monto_descuento = 100,
	@monto_total = 1000,
	@id_deporte = NULL,
	@id_actividad_extra = 1,
	@id_cuota = NULL
GO

--TEST 1.6: Cargo sin monto
DECLARE @numero_factura_test INT;

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11555999) AND descripcion = 'Factura de prueba cargo socio'

EXEC spInsercion.CrearCargoSocio
	@numero_factura = @numero_factura_test,
	@fecha_creacion = '2025-06-30 10:05:56',
	@descripcion = 'Cargo de prueba sobre cuota',
	@monto_descuento = 0,
	@monto_total = 0,
	@id_deporte = NULL,
	@id_actividad_extra = 1,
	@id_cuota = NULL
GO

--TEST 1.7: Cargo con dos actividades relacionadas
DECLARE @numero_factura_test INT;

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11555999) AND descripcion = 'Factura de prueba cargo socio'

EXEC spInsercion.CrearCargoSocio
	@numero_factura = @numero_factura_test,
	@fecha_creacion = '2025-06-30 10:05:56',
	@descripcion = 'Cargo de prueba sobre cuota',
	@monto_descuento = 0,
	@monto_total = 0,
	@id_deporte = 1,
	@id_actividad_extra = 1,
	@id_cuota = NULL
GO

--ACTUALIZACION

--TEST 2.1: Actualizacion correcta
DECLARE @numero_factura_test INT;
DECLARE @id_deporte_test INT
DECLARE @id_cargo_socio_test INT
DECLARE @id_cuota_test INT

SELECT @id_cuota_test = id_cuota
FROM tabla.Cuotas
WHERE id_socio = fnBusqueda.BuscarSocio(11555999)

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11555999) AND descripcion = 'Factura de prueba cargo socio'

SELECT @id_deporte_test = d.id_deporte
FROM tabla.Deportes d
INNER JOIN tabla.Actividades a ON a.id_deporte = d.id_deporte
WHERE a.id_socio = fnBusqueda.BuscarSocio(11555999)

SELECT @id_cargo_socio_test = id_cargo_socio
FROM tabla.CargosSocio
WHERE numero_factura = @numero_factura_test AND id_cuota = @id_cuota_test
	
SELECT * FROM tabla.CargosSocio WHERE id_cargo_socio = @id_cargo_socio_test
EXEC spActualizacion.ActualizarCargoSocio
	@id_cargo_socio = @id_cargo_socio_test,
	@numero_factura = @numero_factura_test,
	@fecha_creacion = '2025-06-30 10:05:56',
	@descripcion = 'Cargo de prueba sobre cuota',
	@monto_descuento = 100,
	@monto_total = 1000,
	@id_deporte = @id_deporte_test,
	@id_actividad_extra = NULL,
	@id_cuota = NULL
SELECT * FROM tabla.CargosSocio WHERE id_cargo_socio = @id_cargo_socio_test
GO

--ELIMINACION
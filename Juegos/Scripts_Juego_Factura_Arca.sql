--FACTURAS ARCA

USE Com2900G07
GO

--Agregamos un socio  para testear
EXEC spInsercion.CrearPrestadorSalud
    @nombre = 'Galeno_test_factura',
    @tipo = 1,
    @telefono = 46254016

DECLARE @id_prestador_salud_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM tabla.PrestadoresSalud
WHERE nombre = 'Galeno_test_factura';

EXEC spInsercion.CrearSocio
    @dni = 22333444,
    @nombre = 'Socio',
    @apellido = 'Prueba Factura',
    @email = 'socio_prueba_factura@sol.com',
    @fecha_nacimiento = '2002-11-26',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @id_prestador_salud = @id_prestador_salud_test
GO

--INSERCION

--TEST 1.1: INSERCION DE UNA FACTURA CORRECTA
EXEC spInsercion.CrearFacturaARCA
    @dni = 22333444,
    @descripcion = 'Factura de prueba',
    @total = 10000,
    @tipo = 'A',
    @primer_vencimiento = '2023-10-15',
    @segundo_vencimiento = '2023-10-30',
    @recargo = 5
GO

--TEST 1.2: INSERCION DE UNA FACTURA CON DNI NO EXISTENTE
EXEC spInsercion.CrearFacturaARCA
    @dni = 99999999,
    @descripcion = 'Factura de prueba',
    @total = 10000,
    @tipo = 'A',
    @primer_vencimiento = '2025-10-15',
    @segundo_vencimiento = '2025-10-30',
    @recargo = 5
GO

--TEST 1.3: INSERCION DE UNA FACTURA CON IMPORTE NEGATIVO
EXEC spInsercion.CrearFacturaARCA
    @dni = 22333444,
    @descripcion = 'Factura de prueba',
    @total = -10000,
    @tipo = 'A',
    @recargo = 5
GO

--TEST 1.4: INSERCION DE UNA FACTURA CON TIPO NO VÁLIDO
EXEC spInsercion.CrearFacturaARCA
    @dni = 22333444,
    @descripcion = 'Factura de prueba',
    @total = 10000,
    @tipo = 'X', -- Tipo no válido
    @recargo = 5
GO

--TEST 1.5: INSERCION DE UNA FACTURA CON RECARGO NEGATIVO
EXEC spInsercion.CrearFacturaARCA
    @dni = 22333444,
    @descripcion = 'Factura de prueba',
    @total = 10000,
    @tipo = 'A',
    @recargo = -5 -- Recargo negativo
GO
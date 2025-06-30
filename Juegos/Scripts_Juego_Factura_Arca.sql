--FACTURAS ARCA

--INSERCION
--TEST 1.1: INSERCION DE UNA FACTURA CORRECTA
EXEC spInsercion.CrearFacturaARCA
    @dni = 23777221,
    @fecha = '2023-10-01',
    @descripcion = 'Factura de prueba',
    @importe = 10000,
    @tipo = 'A',
    @primer_vencimiento = '2023-10-15',
    @segundo_vencimiento = '2023-10-30',
    @recargo = 0.05
GO

--TEST 1.2: INSERCION DE UNA FACTURA CON DNI NO EXISTENTE
EXEC spInsercion.CrearFacturaARCA
    @dni = 12345678,
    @fecha = '2023-10-01',
    @descripcion = 'Factura de prueba',
    @importe = 10000,
    @tipo = 'A',
    @primer_vencimiento = '2023-10-15',
    @segundo_vencimiento = '2023-10-30',
    @recargo = 0.05
GO

--TEST 1.3: INSERCION DE UNA FACTURA CON FECHA FUTURA
EXEC spInsercion.CrearFacturaARCA
    @dni = 23777221,
    @fecha = '2030-11-01',
    @descripcion = 'Factura de prueba',
    @importe = 10000,
    @tipo = 'A',
    @primer_vencimiento = '2023-11-15',
    @segundo_vencimiento = '2023-11-30',
    @recargo = 0.05
GO

--TEST 1.4: INSERCION DE UNA FACTURA CON IMPORTE NEGATIVO
EXEC spInsercion.CrearFacturaARCA
    @dni = 23777221,
    @fecha = '2023-10-01',
    @descripcion = 'Factura de prueba',
    @importe = -10000,
    @tipo = 'A',
    @primer_vencimiento = '2023-10-15',
    @segundo_vencimiento = '2023-10-30',
    @recargo = 0.05
GO

--TEST 1.5: INSERCION DE UNA FACTURA CON TIPO NO VÁLIDO
EXEC spInsercion.CrearFacturaARCA
    @dni = 23777221,
    @fecha = '2023-10-01',
    @descripcion = 'Factura de prueba',
    @importe = 10000,
    @tipo = 'X', -- Tipo no válido
    @primer_vencimiento = '2023-10-15',
    @segundo_vencimiento = '2023-10-30',
    @recargo = 0.05
GO

--TEST 1.6: INSERCION DE UNA FACTURA CON RECARGO NEGATIVO
EXEC spInsercion.CrearFacturaARCA
    @dni = 23777221,
    @fecha = '2023-10-01',
    @descripcion = 'Factura de prueba',
    @importe = 10000,
    @tipo = 'A',
    @primer_vencimiento = '2023-10-15',
    @segundo_vencimiento = '2023-10-30',
    @recargo = -0.05 -- Recargo negativo
GO
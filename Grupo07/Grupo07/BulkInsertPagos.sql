USE Com2900G07;
GO

-- Primero se crea para que funcione todo correctamente.
-- Medios de pago
/*INSERT INTO administracion.MediosPago (nombre, descripcion)
VALUES
('efectivo',        'Pago en recepción'),
('Débito',          'Tarjeta de débito / débito automático'),
('Crédito',         'Tarjeta de crédito 1 cuota'),
('Transferencia',   'Transferencia o depósito bancario'),
('Mercado Pago',    'QR o enlace de Mercado Pago'),
('PayPal',          'Pago en USD vía PayPal');*/

CREATE OR ALTER PROCEDURE administracion.ImportarPagos
    @ruta_archivo_pagos NVARCHAR(500) 
AS
BEGIN
    -- Configuraciones
    SET NOCOUNT ON;
    SET DATEFORMAT dmy;

    CREATE TABLE #PagosTemp (
        id_pago     VARCHAR(20),
        fecha       VARCHAR(10),
        nro_socio   VARCHAR(20),
        Valor       INT,
        mediopago   VARCHAR(50)
    );

    DECLARE @sql NVARCHAR(MAX);

    SET @sql = N'
    BULK INSERT #PagosTemp
    FROM N''' + REPLACE(@ruta_archivo_pagos,'''','''''') + N'''
    WITH (
        FIELDTERMINATOR = '','',
        ROWTERMINATOR   = ''\n'',
        FIRSTROW        = 2,
        CODEPAGE        = ''65001'',
        TABLOCK
    );';

	EXEC sp_executesql @sql, N'@Ruta NVARCHAR(500)', @Ruta = @ruta_archivo_pagos;

    -- Crear facturas
    
    WITH Cuotas AS (
        SELECT DISTINCT
               s.id_socio,
               DATEFROMPARTS(YEAR(TRY_CAST(pt.fecha AS DATE)),
                             MONTH(TRY_CAST(pt.fecha AS DATE)),1) AS fecha_mes,
               pt.Valor
        FROM #PagosTemp                pt
        JOIN socios.Socios             s
              ON s.nro_socio = TRY_CAST(REPLACE(RTRIM(LTRIM(pt.nro_socio)),'SN-','') AS INT)
    )
    INSERT INTO administracion.FacturasARCA
            (id_socio, fecha_creacion, descripcion, tipo,
             total,   primer_vencimiento, segundo_vencimiento, recargo)
    SELECT  c.id_socio,
            c.fecha_mes,
            CONCAT('Cuota Mensual ', DATENAME(MONTH,c.fecha_mes),' ',YEAR(c.fecha_mes)),
            'C',
            c.Valor,
            DATEADD(DAY,  9, c.fecha_mes),        -- 10 del mes
            DATEADD(DAY, 19, c.fecha_mes),        -- 20 del mes
            0
    FROM Cuotas c
    WHERE NOT EXISTS (
        SELECT 1
        FROM administracion.FacturasARCA fa
        WHERE fa.id_socio    = c.id_socio
          AND fa.descripcion = CONCAT('Cuota Mensual ',
                                      DATENAME(MONTH,c.fecha_mes),' ',YEAR(c.fecha_mes))
    );
    
    
    /*--- 4 · Insertar pagos y vincularlos a la factura más antigua impaga ---*/
    
    /*INSERT INTO administracion.Pagos (nro_pago, numero_factura, id_medio_pago, fecha, total)
    SELECT TRY_CAST(t.id_pago AS BIGINT) AS nro_pago,
           f.numero_factura,
           administracion.BuscarIDPago(t.mediopago) as  id_medio_pago,
           TRY_CAST(t.fecha AS DATE) AS fecha,
           t.Valor
    FROM #PagosTemp t
    INNER JOIN socios.Socios s
          ON s.nro_socio = TRY_CAST(REPLACE(RTRIM(LTRIM(t.nro_socio)),'SN-','') AS INT)
    OUTER APPLY (
        SELECT TOP 1 fa.numero_factura
        FROM  administracion.FacturasARCA fa
        WHERE  fa.id_socio = s.id_socio
        AND NOT EXISTS (
           SELECT 1 FROM administracion.Pagos pa
           WHERE pa.numero_factura = fa.numero_factura
        )
        ORDER  BY fa.fecha_creacion ASC  
    ) f
    WHERE NOT EXISTS (
        SELECT 1 FROM administracion.Pagos p
        WHERE p.nro_pago = t.id_pago
    );*/

    /*WITH PagosValidos AS (
       SELECT
        t.id_pago,
        TRY_CAST(REPLACE(RTRIM(LTRIM(t.nro_socio)), 'SN-', '') AS INT) AS nro_socio,
        t.mediopago,
        TRY_CAST(t.fecha AS DATE) AS fecha,
        t.Valor
      FROM #PagosTemp t
    ),
    FacturasSinPago AS (
      SELECT 
        f.numero_factura,
        f.id_socio
      FROM administracion.FacturasARCA f
      WHERE NOT EXISTS (
        SELECT 1 
        FROM administracion.Pagos p
        WHERE p.numero_factura = f.numero_factura
      )
    ),
    PagosConFactura AS (
      SELECT
        pv.id_pago,
        pv.nro_socio,
        fsp.numero_factura,
        pv.mediopago,
        pv.fecha,
        pv.Valor,
        ROW_NUMBER() OVER (PARTITION BY pv.nro_socio ORDER BY fa.fecha_creacion) AS rn
      FROM PagosValidos pv
      JOIN socios.Socios s ON s.nro_socio = pv.nro_socio
      JOIN FacturasSinPago fsp ON fsp.id_socio = s.id_socio
      JOIN administracion.FacturasARCA fa ON fa.numero_factura = fsp.numero_factura
    )
    INSERT INTO administracion.Pagos
      (nro_pago, numero_factura, id_medio_pago, fecha, total, reembolso)
    SELECT
      TRY_CAST(pcf.id_pago AS BIGINT),
      pcf.numero_factura,
      administracion.BuscarIDPago(pcf.mediopago),
      pcf.fecha,
      pcf.Valor,
      0
    FROM PagosConFactura pcf
    WHERE pcf.rn = 1
    AND NOT EXISTS (
      SELECT 1 FROM administracion.Pagos p WHERE p.nro_pago = pcf.id_pago
    );*/
WITH PagosValidos AS (
    SELECT
        t.id_pago,
        TRY_CAST(REPLACE(RTRIM(LTRIM(t.nro_socio)), 'SN-', '') AS INT) AS nro_socio,
        t.mediopago,
        TRY_CAST(t.fecha AS DATE) AS fecha,
        t.Valor
    FROM #PagosTemp t
    WHERE NOT EXISTS (
        SELECT 1 FROM administracion.Pagos p WHERE p.nro_pago = t.id_pago
    )
),
PagosNumerados AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY nro_socio ORDER BY fecha) AS rn
    FROM PagosValidos
),
FacturasNumeradas AS (
    SELECT
        f.numero_factura,
        s.nro_socio,
        f.fecha_creacion,
        ROW_NUMBER() OVER (PARTITION BY s.nro_socio ORDER BY f.fecha_creacion) AS rn
    FROM administracion.FacturasARCA f
    JOIN socios.Socios s ON f.id_socio = s.id_socio
    WHERE NOT EXISTS (
        SELECT 1 FROM administracion.Pagos p WHERE p.numero_factura = f.numero_factura
    )
)
INSERT INTO administracion.Pagos
    (nro_pago, numero_factura, id_medio_pago, fecha, total, reembolso)
SELECT
    TRY_CAST(p.id_pago AS BIGINT),
    f.numero_factura,
    administracion.BuscarIDPago(p.mediopago),
    p.fecha,
    p.Valor,
    0
FROM PagosNumerados p
JOIN FacturasNumeradas f
    ON p.nro_socio = f.nro_socio AND p.rn = f.rn;
    
    END;

-- Descomentar para ejecuci�n:
-- EXEC administracion.ImportarPagos @ruta_archivo_pagos=N'C:\Users\kevin\TP_BBDDA\CSV\pago_cuotas.csv'; 

-- Tabla formato pago_cuotas.csv
/*SELECT p.nro_pago as IdDePago, p.fecha as Fecha, s.nro_socio as ResponsablePago, p.total as Valor FROM administracion.Pagos p
INNER JOIN administracion.FacturasARCA f
ON p.numero_factura = f.numero_factura
LEFT JOIN socios.Socios s ON s.id_socio = f.id_socio*/
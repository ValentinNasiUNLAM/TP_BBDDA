

CREATE OR ALTER PROCEDURE administracion.ImportarPagos
    @ruta_archivo_pagos NVARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;
    SET DATEFORMAT dmy;

    CREATE TABLE #PagosTemp (
        id_pago VARCHAR(20),
        fecha DATE,
        nro_socio VARCHAR(20),
        Valor INT,
        mediopago VARCHAR(50)
    );

    DECLARE @sql NVARCHAR(MAX);

    SET @sql = '
    BULK INSERT #PagosTemp
    FROM ''' + REPLACE(@ruta_archivo_pagos, '''', '''''') + '''
    WITH (
        FIELDTERMINATOR = '','',
        ROWTERMINATOR = ''\n'',
        FIRSTROW = 2,
        CODEPAGE = ''65001'',
        TABLOCK
    );';

    EXEC sp_executesql @sql;

    INSERT INTO administracion.Pago (nro_pago, numero_factura, id_medio_pago, fecha, total, nro_pago)
    SELECT
        f.numero_factura,
        mp.id_medio_pago,
        t.fecha,
        t.Valor,
        TRY_CAST(t.id_pago AS BIGINT) AS nro_pago
    FROM #PagosTemp t
    
    INNER JOIN socios.Socios s
        ON s.nro_socio = TRY_CAST(REPLACE(RTRIM(LTRIM(t.nro_socio)), 'SN-', '') AS INT)

    OUTER APPLY (
        SELECT TOP 1 fa.numero_factura
        FROM administracion.FacturaARCA fa
        WHERE fa.id_socio = s.id_socio
        ORDER BY fa.fecha_creacion ASC
    ) f

    INNER JOIN administracion.MediosPago mp
        ON mp.nombre = RTRIM(LTRIM(t.mediopago));

    DROP TABLE #PagosTemp;
END;

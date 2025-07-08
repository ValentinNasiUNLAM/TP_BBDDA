/*
Archivos indicados en Miel.
Se requiere que importe toda la información antes mencionada a la base de datos:
• Genere los objetos necesarios (store procedures, funciones, etc.) para importar los
archivos antes mencionados. Tenga en cuenta que cada mes se recibirán archivos de
novedades con la misma estructura, pero datos nuevos para agregar a cada maestro.
• Considere este comportamiento al generar el código. Debe admitir la importación de
novedades periódicamente sin eliminar los datos ya cargados y sin generar
duplicados.
• Cada maestro debe importarse con un SP distinto. No se aceptarán scripts que
realicen tareas por fuera de un SP.
• La estructura/esquema de las tablas a generar será decisión suya. Puede que deba
realizar procesos de transformación sobre los maestros recibidos para adaptarlos a la
estructura requerida. Estas adaptaciones deberán hacerla en la DB y no en los
archivos provistos.
• Los archivos CSV/JSON no deben modificarse. En caso de que haya datos mal
cargados, incompletos, erróneos, etc., deberá contemplarlo y realizar las correcciones
en el fuente SQL. (Sería una excepción si el archivo está malformado y no es posible
interpretarlo como JSON o CSV, pero los hemos verificado cuidadosamente).
• Tener en cuenta que para la ampliación del software no existen datos; se deben
preparar los datos de prueba necesarios para cumplimentar los requisitos planteados.
• El código fuente no debe incluir referencias hardcodeadas a nombres o ubicaciones
de archivo. Esto debe permitirse ser provisto por parámetro en la invocación. En el
código de ejemplo el grupo decidirá dónde se ubicarían los archivos. Esto debe
aparecer en comentarios del módulo.
• El uso de SQL dinámico no está exigido en forma explícita… pero puede que
encuentre que es la única forma de resolver algunos puntos. No abuse del SQL
dinámico, deberá justificar su uso siempre.
• Respecto a los informes XML: no se espera que produzcan un archivo nuevo en el
filesystem, basta con que el resultado de la consulta sea XML.

Materia: Bases de datos aplicadas
Fecha de entrega: 08/07/2025
Grupo: 07
Alumnos: 
	Nasi Valentin 44851378
	Traversa Franco 44510896
	Arias Kevin 41246810
*/

USE Com2900G07;
GO

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
        valor       INT,
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
    
    WITH Cuotas AS (
        SELECT DISTINCT
               s.id_socio,
               DATEFROMPARTS(YEAR(TRY_CAST(pt.fecha AS DATE)),
                             MONTH(TRY_CAST(pt.fecha AS DATE)),1) AS fecha_mes,
               pt.valor
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
            c.valor,
            DATEADD(DAY,  9, c.fecha_mes),
            DATEADD(DAY, 19, c.fecha_mes),
            0
    FROM Cuotas c
    WHERE NOT EXISTS (
        SELECT 1
        FROM administracion.FacturasARCA fa
        WHERE fa.id_socio    = c.id_socio
          AND fa.descripcion = CONCAT('Cuota Mensual ',
                                      DATENAME(MONTH,c.fecha_mes),' ',YEAR(c.fecha_mes))
    );
    
	WITH PagosValidos AS (
		SELECT
			t.id_pago,
			TRY_CAST(REPLACE(RTRIM(LTRIM(t.nro_socio)), 'SN-', '') AS INT) AS nro_socio,
			t.mediopago,
			TRY_CAST(t.fecha AS DATE) AS fecha,
			t.valor
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
		p.valor,
		0
	FROM PagosNumerados p
	JOIN FacturasNumeradas f
		ON p.nro_socio = f.nro_socio AND p.rn = f.rn; 
END;
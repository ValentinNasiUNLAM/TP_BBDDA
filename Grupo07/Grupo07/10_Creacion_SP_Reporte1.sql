/*
Reporte 1
Reporte de los socios morosos, que hayan incumplido en más de dos oportunidades dado un
rango de fechas a ingresar. El reporte debe contener los siguientes datos:
Nombre del reporte: Morosos Recurrentes
Período: rango de fechas
Nro de socio
Nombre y apellido.
Mes incumplido
Ordenados de Mayor a menor por ranking de morosidad
El mismo debe ser desarrollado utilizando Windows Function.

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

--Agregamos los datos necesarios para poder generar y visualizar el reporte 1

-- Prestadores
EXEC socios.CrearPrestadorSalud 'OSDE R1', '011-5555-1111';

-- Socios
DECLARE @id_osde INT

SELECT @id_osde = id_prestador_salud FROM socios.PrestadoresSalud WHERE nombre = 'OSDE R1';

EXEC socios.CrearSocio 1001, 44111111, 'Juan', 'Perez', 'juan@mail.com', '1990-05-20', 1122334455, 1133445566, 'OSDE-1123', @id_osde;
EXEC socios.CrearSocio 1002, 44111222, 'Ana', 'Gomez', 'ana@mail.com', '1985-08-15', 1122334466, 1133445577, 'OSDE-1456', @id_osde;
EXEC socios.CrearSocio 1003, 44111333, 'Luis', 'Fernandez', 'luis@mail.com', '1995-02-10', 1122334477, 1133445588, 'OSDE-1789', @id_osde;

-- Facturas (enero a junio 2025)

-- Juan tiene 4 facturas morosas
EXEC administracion.CrearFacturaARCA 44111111, 'Cuota enero', 'B', 10000, '2025-01-10', '2025-01-20', 500;
EXEC administracion.CrearFacturaARCA 44111111, 'Cuota marzo', 'B', 10000, '2025-03-10', '2025-03-20', 500;
EXEC administracion.CrearFacturaARCA 44111111, 'Cuota mayo', 'B', 10000, '2025-05-10', '2025-05-20', 500;
EXEC administracion.CrearFacturaARCA 44111111, 'Cuota junio', 'B', 10000, '2025-06-10', '2025-06-20', 500;

-- Ana tiene 2 facturas morosas (no debe salir en el reporte)
EXEC administracion.CrearFacturaARCA 44111222, 'Cuota abril', 'B', 10000, '2025-04-10', '2025-04-20', 500;
EXEC administracion.CrearFacturaARCA 44111222, 'Cuota junio', 'B', 10000, '2025-06-10', '2025-06-20', 500;

-- Luis tiene 3 facturas, 2 morosas
EXEC administracion.CrearFacturaARCA 44111333, 'Cuota enero', 'B', 10000, '2025-01-10', '2025-01-20', 500;
EXEC administracion.CrearFacturaARCA 44111333, 'Cuota febrero', 'B', 10000, '2025-02-10', '2025-02-20', 500;
EXEC administracion.CrearFacturaARCA 44111333, 'Cuota marzo', 'B', 10000, '2025-03-10', '2025-03-20', 500;

-- Morosidades (fecha_pago NULL => deuda activa)
DECLARE @numero_factura INT

-- Juan
SELECT @numero_factura = numero_factura
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(44111111) AND descripcion = 'Cuota enero'
INSERT INTO administracion.Morosidades(numero_factura, monto_total, fecha_pago) VALUES (@numero_factura, 10500, NULL);

SELECT @numero_factura = numero_factura
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(44111111) AND descripcion = 'Cuota marzo'
INSERT INTO administracion.Morosidades(numero_factura, monto_total, fecha_pago) VALUES (@numero_factura, 10500, NULL);

SELECT @numero_factura = numero_factura
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(44111111) AND descripcion = 'Cuota mayo'
INSERT INTO administracion.Morosidades(numero_factura, monto_total, fecha_pago) VALUES (@numero_factura, 10500, NULL);

SELECT @numero_factura = numero_factura
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(44111111) AND descripcion = 'Cuota junio'
INSERT INTO administracion.Morosidades(numero_factura, monto_total, fecha_pago) VALUES (@numero_factura, 10500, NULL);

-- Ana
SELECT @numero_factura = numero_factura
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(44111222) AND descripcion = 'Cuota abril'
INSERT INTO administracion.Morosidades(numero_factura, monto_total, fecha_pago) VALUES (5, 10500, NULL);

SELECT @numero_factura = numero_factura
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(44111222) AND descripcion = 'Cuota junio'
INSERT INTO administracion.Morosidades(numero_factura, monto_total, fecha_pago) VALUES (6, 10500, NULL);

-- Luis
SELECT @numero_factura = numero_factura
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(44111333) AND descripcion = 'Cuota enero'
INSERT INTO administracion.Morosidades(numero_factura, monto_total, fecha_pago) VALUES (7, 10500, NULL);

SELECT @numero_factura = numero_factura
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(44111333) AND descripcion = 'Cuota febrero'
INSERT INTO administracion.Morosidades(numero_factura, monto_total, fecha_pago) VALUES (8, 10500, NULL);

SELECT @numero_factura = numero_factura
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(44111333) AND descripcion = 'Cuota marzo'
INSERT INTO administracion.Morosidades(numero_factura, monto_total, fecha_pago) VALUES (9, 10500, NULL);

GO


--Creamos el SP para el reporte 1

CREATE OR ALTER PROCEDURE administracion.ReporteMorososRecurrentes
	@desde DATE,
	@hasta DATE
AS
BEGIN

	WITH MorosidadesSinPagar AS (
    SELECT
        s.nro_socio,
        s.nombre + ' ' + s.apellido AS nombre_apellido,
        FORMAT(f.primer_vencimiento, 'yyyy-MM') AS mes_incumplido,
        f.primer_vencimiento,
        s.id_socio
    FROM administracion.Morosidades m
    INNER JOIN administracion.FacturasARCA f ON m.numero_factura = f.numero_factura
    INNER JOIN socios.Socios s ON f.id_socio = s.id_socio
    WHERE m.fecha_pago IS NULL
      AND f.primer_vencimiento BETWEEN @desde AND @hasta
	),
	ConteoMorosos AS (
		SELECT 
			id_socio,
			nro_socio,
			nombre_apellido,
			COUNT(*) AS cantidad_morosidades
		FROM MorosidadesSinPagar
		GROUP BY id_socio, nro_socio, nombre_apellido
		HAVING COUNT(*) > 2
	),
	RankingMorosos AS (
		SELECT *,
			   RANK() OVER (ORDER BY cantidad_morosidades DESC) AS ranking
		FROM ConteoMorosos
	),
	FinalReporte AS (
		SELECT
			rm.ranking,
			rm.nro_socio,
			rm.nombre_apellido,
			msp.mes_incumplido,
			rm.cantidad_morosidades
		FROM RankingMorosos rm
		INNER JOIN MorosidadesSinPagar msp ON rm.id_socio = msp.id_socio
	)

	SELECT
		'Morosos Recurrentes' AS [Nombre del Reporte],
		@desde AS [Desde],
		@hasta AS [Hasta],
		nro_socio,
		nombre_apellido AS [Nombre y Apellido],
		mes_incumplido AS [Mes Incumplido],
		cantidad_morosidades AS [Cantidad de Morosidades],
		ranking AS [Ranking de Morosidad] -- Juan Perez es el mas mooroso de todos (Ranking 1) 
	FROM FinalReporte
	ORDER BY ranking, nro_socio, mes_incumplido;
END
GO

EXEC administracion.ReporteMorososRecurrentes @desde = '2025-01-01', @hasta = '2025-07-01'
GO
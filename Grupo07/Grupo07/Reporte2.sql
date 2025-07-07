USE Com2900G07;
GO

--Agregamos los datos necesarios para poder generar y visualizar el reporte 1

-- Prestadores
EXEC socios.CrearPrestadorSalud 'OSDE R2', '011-5555-1111';

-- Socios
DECLARE @id_osde INT

SELECT @id_osde = id_prestador_salud FROM socios.PrestadoresSalud WHERE nombre = 'OSDE R1';

EXEC socios.CrearSocio 2001, 44111111, 'Juan', 'Pérez', 'juan2@mail.com', '1990-05-20', 1122334455, 1133445566, 'OSDE-123', @id_osde;
EXEC socios.CrearSocio 2002, 44222222, 'Ana', 'Gómez', 'ana2@mail.com', '1985-08-15', 1122334466, 1133445577, 'SWISS-456', @id_osde;

-- Crear deportes
EXEC actividades.CrearDeporte 'Fútbol', 5000;
EXEC actividades.CrearDeporte 'Tenis', 7000;

-- Crear facturas y cargos asociados a deportes
-- Socio Juan (1001) usa Fútbol en enero, marzo y mayo
EXEC administracion.CrearFacturaARCA 44111111, 'Futbol enero', 'B', 5000, '2025-01-05', '2025-01-10', 0;
EXEC administracion.CrearFacturaARCA 44111111, 'Futbol marzo', 'B', 5000, '2025-03-10', '2025-03-15', 0;
EXEC administracion.CrearFacturaARCA 44111111, 'Futbol mayo', 'B', 5000, '2025-05-01', '2025-05-05', 0;

-- Socio Ana (1002) usa Tenis en febrero y abril
EXEC administracion.CrearFacturaARCA 44222222, 'Tenis febrero', 'B', 7000, '2025-02-10', '2025-02-15', 0;
EXEC administracion.CrearFacturaARCA 44222222, 'Tenis abril', 'B', 7000, '2025-04-10', '2025-04-15', 0;

-- CargosSocio: asociamos facturas a deportes
DECLARE @numero_factura INT

SELECT @numero_factura = numero_factura
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(44111111) AND descripcion = 'Futbol enero'
EXEC administracion.CrearCargoSocio @numero_factura, '2025-01-05', 'Cargo fútbol enero', NULL, 5000, 1, NULL, NULL;

SELECT @numero_factura = numero_factura
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(44111111) AND descripcion = 'Futbol marzo'
EXEC administracion.CrearCargoSocio @numero_factura, '2025-03-10', 'Cargo fútbol marzo', NULL, 5000, 1, NULL, NULL;

SELECT @numero_factura = numero_factura
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(44111111) AND descripcion = 'Futbol mayo'
EXEC administracion.CrearCargoSocio @numero_factura, '2025-05-01', 'Cargo fútbol mayo', NULL, 5000, 1, NULL, NULL;

SELECT @numero_factura = numero_factura
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(44222222) AND descripcion = 'Tenis febrero'
EXEC administracion.CrearCargoSocio @numero_factura, '2025-02-10', 'Cargo tenis febrero', NULL, 7000, 2, NULL, NULL;

SELECT @numero_factura = numero_factura
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(44222222) AND descripcion = 'Tenis abril'
EXEC administracion.CrearCargoSocio @numero_factura, '2025-04-10', 'Cargo tenis abril', NULL, 7000, 2, NULL, NULL;

GO

CREATE OR ALTER PROCEDURE administracion.IngresosActividades
AS
BEGIN

	WITH IngresosMensuales AS (
    SELECT 
        cs.id_deporte,
        d.nombre AS deporte,
        SUM(cs.monto_total) AS ingreso_mensual
    FROM administracion.CargosSocio cs
    INNER JOIN actividades.Deportes d ON cs.id_deporte = d.id_deporte
    WHERE 
        YEAR(cs.fecha_creacion) = YEAR(GETDATE())
    GROUP BY cs.id_deporte, d.nombre
	),
	AcumuladoFinal AS (
		SELECT 
			deporte,
			SUM(ingreso_mensual) OVER (PARTITION BY deporte) AS ingresos_acumulados
		FROM IngresosMensuales
	)
	SELECT DISTINCT
		'Ingresos por Actividad Deportiva' AS [Nombre del Reporte],
		deporte,
		ingresos_acumulados AS [Ingresos Acumulados]
	FROM AcumuladoFinal
	ORDER BY ingresos_acumulados DESC;

END
GO

EXEC administracion.IngresosActividades
GO
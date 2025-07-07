USE Com2900G07;
GO

--Agregamos los datos necesarios para poder generar y visualizar el reporte 2

-- Prestadores
EXEC socios.CrearPrestadorSalud 'OSDE R2', '011-5555-1111';

-- Socios
DECLARE @id_osde INT

SELECT @id_osde = id_prestador_salud FROM socios.PrestadoresSalud WHERE nombre = 'OSDE R2';

EXEC socios.CrearSocio 2001, 44222111, 'Juan', 'Perez', 'juan2@mail.com', '1990-05-20', 1122334455, 1133445566, 'OSDE-2123', @id_osde;
EXEC socios.CrearSocio 2002, 44222222, 'Ana', 'Gomez', 'ana2@mail.com', '1985-08-15', 1122334466, 1133445577, 'OSDE-2456', @id_osde;

-- Crear deportes
EXEC actividades.CrearDeporte 'Futbol R2', 5000;
EXEC actividades.CrearDeporte 'Tenis R2', 7000;

-- Crear facturas y cargos asociados a deportes
-- Socio Juan (1001) usa Fútbol en enero, marzo y mayo
EXEC administracion.CrearFacturaARCA 44222111, 'Futbol enero', 'B', 5000, '2025-01-05', '2025-01-10', 0;
EXEC administracion.CrearFacturaARCA 44222111, 'Futbol marzo', 'B', 5000, '2025-03-10', '2025-03-15', 0;
EXEC administracion.CrearFacturaARCA 44222111, 'Futbol mayo', 'B', 5000, '2025-05-01', '2025-05-05', 0;

-- Socio Ana (1002) usa Tenis en febrero y abril
EXEC administracion.CrearFacturaARCA 44222222, 'Tenis febrero', 'B', 7000, '2025-02-10', '2025-02-15', 0;
EXEC administracion.CrearFacturaARCA 44222222, 'Tenis abril', 'B', 7000, '2025-04-10', '2025-04-15', 0;

-- CargosSocio: asociamos facturas a deportes
DECLARE @numero_factura INT
DECLARE @id_deporte INT

SELECT @numero_factura = numero_factura
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(44222111) AND descripcion = 'Futbol enero'
SELECT @id_deporte = id_deporte
FROM actividades.Deportes
WHERE nombre = 'Futbol R2'
EXEC administracion.CrearCargoSocio @numero_factura, '2025-01-05', 'Cargo fútbol enero', NULL, 5000, @id_deporte, NULL, NULL;

SELECT @numero_factura = numero_factura
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(44222111) AND descripcion = 'Futbol marzo'
SELECT @id_deporte = id_deporte
FROM actividades.Deportes
WHERE nombre = 'Futbol R2'
EXEC administracion.CrearCargoSocio @numero_factura, '2025-03-10', 'Cargo fútbol marzo', NULL, 5000, @id_deporte, NULL, NULL;

SELECT @numero_factura = numero_factura
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(44222111) AND descripcion = 'Futbol mayo'
SELECT @id_deporte = id_deporte
FROM actividades.Deportes
WHERE nombre = 'Futbol R2'
EXEC administracion.CrearCargoSocio @numero_factura, '2025-05-01', 'Cargo fútbol mayo', NULL, 5000, @id_deporte, NULL, NULL;

SELECT @numero_factura = numero_factura
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(44222222) AND descripcion = 'Tenis febrero'
SELECT @id_deporte = id_deporte
FROM actividades.Deportes
WHERE nombre = 'Tenis R2'
EXEC administracion.CrearCargoSocio @numero_factura, '2025-02-10', 'Cargo tenis febrero', NULL, 7000, @id_deporte, NULL, NULL;

SELECT @numero_factura = numero_factura
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(44222222) AND descripcion = 'Tenis abril'
SELECT @id_deporte = id_deporte
FROM actividades.Deportes
WHERE nombre = 'Tenis R2'
EXEC administracion.CrearCargoSocio @numero_factura, '2025-04-10', 'Cargo tenis abril', NULL, 7000, @id_deporte, NULL, NULL;

GO

--Creamos el SP para el reporte 2

CREATE OR ALTER PROCEDURE administracion.ReporteIngresosActividades
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

EXEC administracion.ReporteIngresosActividades
GO
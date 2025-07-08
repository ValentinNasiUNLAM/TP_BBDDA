USE Com2900G07
GO

EXEC actividades.CrearDeporte @nombre = 'Futsal', @precio = 25000;
EXEC actividades.CrearDeporte @nombre = 'Voley', @precio = 30000;
EXEC actividades.CrearDeporte @nombre = 'Taekwondo', @precio = 25000;
EXEC actividades.CrearDeporte @nombre = 'Baile artistico', @precio = 30000;
EXEC actividades.CrearDeporte @nombre = 'Natacion', @precio = 45000;
EXEC actividades.CrearDeporte @nombre = 'Ajedrez', @precio = 2000;

EXEC socios.CrearCategoria @nombre_categoria = 'Mayor', @edad_min = 18, @edad_max = 99, @precio_mensual = 25000;
EXEC socios.CrearCategoria @nombre_categoria = 'Cadete', @edad_min = 13, @edad_max = 17, @precio_mensual = 25000;
EXEC socios.CrearCategoria @nombre_categoria = 'Menor', @edad_min = 1, @edad_max = 12, @precio_mensual = 25000;
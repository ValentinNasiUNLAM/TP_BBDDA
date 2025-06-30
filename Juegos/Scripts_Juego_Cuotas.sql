--Cuotas
--Se crean los TESTS para la insercion, actualizacion y eliminacion de Cuotas

USE Com2900G07
GO

--Agregamos un socio y una categoria para testear
EXEC spInsercion.CrearPrestadorSalud
    @nombre = 'Galeno_test_cuota',
    @tipo = 1,
    @telefono = 46254016

DECLARE @id_prestador_salud_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM tabla.PrestadoresSalud
WHERE nombre = 'Galeno_test_cuota';

EXEC spInsercion.CrearSocio
    @dni = 11222333,
    @nombre = 'Test',
    @apellido = 'Cuota',
    @email = 'test_couta@sol.com',
    @fecha_nacimiento = '2002-11-26',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @id_prestador_salud = @id_prestador_salud_test

EXEC spInsercion.CrearCategoria
    @nombre_categoria = 'Juvenil_test',
    @edad_min = 12,
    @edad_max = 17,
    @precio_mensual = 5000
GO

--INSERCION

--TEST 1.1: Insercion Correcta
DECLARE @id_categoria_test INT

SELECT @id_categoria_test = id_categoria
FROM tabla.Categorias
WHERE nombre_categoria = 'Juvenil_test'

EXEC spInsercion.CrearCuota
    @dni = 11222333,
    @id_categoria = @id_categoria_test

SELECT * FROM tabla.Cuotas;
GO

--TEST 1.2: Dni Incorrecto
EXEC spInsercion.CrearCuota
    @dni = 99999999,
    @id_categoria = 1
GO

--TEST 1.3: Categoria Incorrecta
EXEC spInsercion.CrearCuota
    @dni = 11222333,
    @id_categoria = 999999
GO

--ACTUALIZACION

--TEST 2.1: Actualizacion Correcta
EXEC spInsercion.CrearCategoria
    @nombre_categoria = 'Juvenil_test2',
    @edad_min = 12,
    @edad_max = 17,
    @precio_mensual = 5000
GO

DECLARE @id_categoria_test INT

SELECT @id_categoria_test = id_categoria
FROM tabla.Categorias
WHERE nombre_categoria = 'Juvenil_test2'

EXEC spActualizacion.ActualizarCuota
    @dni = 11222333,
    @id_categoria = @id_categoria_test
GO
SELECT * FROM tabla.Cuotas;

--TEST 2.2: Error DNI
EXEC spActualizacion.ActualizarCuota
    @dni = 99999999,
    @id_categoria = 1
GO

--TEST 2.3: Error Categoria
EXEC spActualizacion.ActualizarCuota
    @dni = 11222333,
    @id_categoria = 99991
GO


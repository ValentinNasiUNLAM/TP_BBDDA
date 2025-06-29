--CATEGORIAS
--INSERCION
-- Se crean los TESTS para la insercion, actualizacion y eliminacion de categorias

USE TP_BBDDA
GO

--TEST 1: Resultado esperado, Juvenil, 12, 17, 5000
EXEC spInsercion.CrearCategoria -- ok
    @nombre_categoria = 'Juvenil',
    @edad_min = 12,
    @edad_max = 17,
    @precio_mensual = 5000
GO

SELECT * FROM tabla.Categorias WHERE nombre_categoria = 'Juvenil'
GO

--TEST 2: Edad Minima Invalida 
EXEC spInsercion.CrearCategoria --ok
    @nombre_categoria = 'Error_Edad',
    @edad_min = 20,
    @edad_max = 17,
    @precio_mensual = 5000
GO
SELECT * FROM tabla.Categorias WHERE nombre_categoria = 'Error_Edad'
GO

--TEST 3: Precio Invalido

EXEC spInsercion.CrearCategoria 
    @nombre_categoria = 'Error_Precio', --ok
    @edad_min = 12,
    @edad_max = 17,
    @precio_mensual = -1000
GO

SELECT * FROM tabla.Categorias WHERE nombre_categoria = 'Error_Precio'
GO

--TEST 4: Nombre Categoria Vacio

EXEC spInsercion.CrearCategoria --ok
    @nombre_categoria = '',
    @edad_min = 12,
    @edad_max = 17,
    @precio_mensual = -1000
GO

SELECT * FROM tabla.Categorias WHERE nombre_categoria = ''
GO

--ACTUALIZACION

--TEST 1: Resultado esperado Juvenil, 10, 18, 2000 - Actualizacion de precio mensual
EXEC spActualizacion.actualizarCategoria --ok
    @id_categoria = 1,
    @nombre_categoria = 'Juvenil',
    @edad_min = 12,
    @edad_max = 18,
    @precio_mensual = 2000
GO

SELECT * FROM tabla.Categorias WHERE id_categoria = 1
GO

--TEST 2: Error Actualizar Edad -- Se verifica que en la Edad Minima no hubo modificaciones 
EXEC spActualizacion.actualizarCategoria --ok
    @id_categoria = 1,
    @nombre_categoria = 'Juvenil',
    @edad_min = 20,
    @edad_max = 18,
    @precio_mensual = 2000
GO

SELECT * FROM tabla.Categorias WHERE id_categoria = 1
GO

--TEST 3: ERROR PRECIO MENSUAL INVALIDO -- Se verifica que en el Precio Mensual no hubo modificaciones
EXEC spActualizacion.actualizarCategoria -- ok
    @id_categoria = 1,
    @nombre_categoria = 'Juvenil',
    @edad_min = 12,
    @edad_max = 18,
    @precio_mensual = -3000
GO

SELECT * FROM tabla.Categorias WHERE id_categoria = @id_categoria
GO

--TEST 4: ERROR NOMBRE CATEGORIA VACIO -- Se verifica que nombre de la categoria no tuvo modificaciones
EXEC spActualizacion.actualizarCategoria
    @id_categoria = 1,
    @nombre_categoria = '',
    @edad_min = 12,
    @edad_max = 18,
    @precio_mensual = 2000
GO
SELECT * FROM tabla.Categorias WHERE id_categoria = @id_categoria
GO

--TEST 5: NO EXISTE ID CATEGORIA
EXEC spActualizacion.actualizarCategoria --ok
    @id_categoria = 99991;
    @nombre_categoria = 'Juvenil',
    @edad_min = 12,
    @edad_max = 18,
    @precio_mensual = 2000
GO


--ELIMINACION

--TEST 1: ELIMINACION EXITOSA
EXEC spEliminacion.eliminarCategoria --ok
    @id_categoria = 1
GO
SELECT * FROM tabla.Categorias WHERE id_categoria = @id_categoria

--TEST 2: ID CATEGORIA NO ENCONTRADO 
EXEC spEliminacion.eliminarCategoria --ok
    @id_categoria = 99991
GO


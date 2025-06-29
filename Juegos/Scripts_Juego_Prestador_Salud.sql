--Prestadores Salud

-- Se crean los TESTS para la insercion, actualizacion y eliminacion de Prestadores Salud

USE Com2900G07
GO

--INSERCION

--TEST 1.1: Resultado esperado, ID, 1, Galeno, 46254016
SELECT * FROM tabla.PrestadoresSalud
EXEC spInsercion.CrearPrestadorSalud
    @nombre = 'Galeno',
    @tipo = 1,
    @telefono = 46254016
GO
SELECT * FROM tabla.PrestadoresSalud WHERE nombre = 'Galeno'
GO

-- TEST 1.2: Error nombre vacio
SELECT * FROM tabla.PrestadoresSalud
EXEC spInsercion.CrearPrestadorSalud
    @nombre = '',
    @tipo = 1,
    @telefono = 46254016
GO
SELECT * FROM tabla.PrestadoresSalud WHERE nombre = ''
GO

--TEST 1.3: Error tipo (valido entre 1 y 3)
SELECT * FROM tabla.PrestadoresSalud
EXEC spInsercion.CrearPrestadorSalud
    @nombre = 'Galeno_Error_Tipo',
    @tipo = 4,
    @telefono = 46254016
GO
SELECT * FROM tabla.PrestadoresSalud WHERE nombre = 'Galeno_Error_Tipo'
GO

--ACTUALIZACION

--TEST 2.1: Resultado esperado ID, 2, IOMA, 1199998888
SELECT * FROM tabla.PrestadoresSalud
EXEC spActualizacion.actualizarPrestadorSalud
    @id_prestador_salud = 1,
    @nombre = 'IOMA',
    @tipo = 2,
    @telefono = 1199998888
GO
SELECT * FROM tabla.PrestadoresSalud WHERE id_prestador_salud = 1
GO

--TEST 2.2: Error nombre vacio
SELECT * FROM tabla.PrestadoresSalud
EXEC spActualizacion.actualizarPrestadorSalud
    @id_prestador_salud = 1,
    @nombre = '',
    @tipo = 2,
    @telefono = 1199998888
GO
SELECT * FROM tabla.PrestadoresSalud WHERE id_prestador_salud = 1
GO

--TEST 2.3: Error tipo:
SELECT * FROM tabla.PrestadoresSalud
EXEC spActualizacion.actualizarPrestadorSalud
    @id_prestador_salud = 1,
    @nombre = 'IOMA',
    @tipo = 5,
    @telefono = 1199998888
GO
SELECT * FROM tabla.PrestadoresSalud WHERE id_prestador_salud = 1
GO

--TEST 2.4: Error no existe ID
SELECT * FROM tabla.PrestadoresSalud
EXEC spActualizacion.actualizarPrestadorSalud
    @id_prestador_salud = 99991,
    @nombre = 'IOMA',
    @tipo = 5,
    @telefono = 1199998888
GO

--ELIMINACION

--TEST 3.1: Eliminacion Exitosa
SELECT * FROM tabla.PrestadoresSalud
EXEC spEliminacion.eliminarPrestadorSalud
    @id_prestador_salud = 1
GO
SELECT * FROM tabla.PrestadoresSalud WHERE id_prestador_salud = 1
GO

--TEST 3.2: No existe ID
SELECT * FROM tabla.PrestadoresSalud
EXEC spEliminacion.eliminarPrestadorSalud
    @id_prestador_salud = 99991
GO

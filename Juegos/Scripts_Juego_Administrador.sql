--Administradores
-- Se crean los TESTS para la insercion, actualizacion y eliminacion de Administradores
USE TP_BBDDA
GO
--INSERCION
--TEST 1.1: Resultado esperado: ID, nombre, apellido, dni, email, 1, 1
SELECT * FROM tabla.Administradores
EXEC spInsercion.CrearAdministrador
    @nombre = 'Homero',
    @apellido = 'Simpson',
    @dni = 44555666,
    @email = 'hsimpson@sol.com'
    @rol = 2
GO
SELECT * FROM tabla.Administradores WHERE dni = 44555666
GO
--TEST 1.2: Error nombre y apellido vacio
SELECT * FROM tabla.Administradores
EXEC spInsercion.CrearAdministrador
    @nombre = '',
    @apellido = '',
    @dni = 44555666,
    @email = 'hsimpson@sol.com'
    @rol = 2
GO
SELECT * FROM tabla.Administradores WHERE dni = 44555666
GO
--TEST 1.3: Error email
SELECT * FROM tabla.Administradores
EXEC spInsercion.CrearAdministrador
    @nombre = 'Homero',
    @apellido = 'Simpson',
    @dni = 44555666,
    @email = 'hsimpsonsol.com'
    @rol = 2
GO
SELECT * FROM tabla.Administradores WHERE dni = 44555666
GO
--TEST 1.4: DNI invalido
SELECT * FROM tabla.Administradores
EXEC spInsercion.CrearAdministrador
    @nombre = 'Homero',
    @apellido = 'Simpson',
    @dni = 99999999,
    @email = 'hsimpson@sol.com'
    @rol = 2
GO
SELECT * FROM tabla.Administradores WHERE dni = 99999999
GO


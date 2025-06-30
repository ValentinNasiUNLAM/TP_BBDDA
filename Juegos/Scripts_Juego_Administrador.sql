--Administradores

-- Se crean los TESTS para la insercion, actualizacion y eliminacion de Administradores

USE Com2900G07
GO

--INSERCION

--TEST 1.1: Resultado esperado: ID, nombre, apellido, dni, email, 1, 1
SELECT * FROM tabla.Administradores
EXEC spInsercion.CrearAdministrador
    @nombre = 'Homero',
    @apellido = 'Simpson',
    @dni = 44555666,
    @email = 'hsimpson@sol.com',
    @rol = 2
GO
SELECT * FROM tabla.Administradores WHERE dni = 44555666
GO

--TEST 1.2: Error nombre y apellido vacio
SELECT * FROM tabla.Administradores
EXEC spInsercion.CrearAdministrador
    @nombre = '',
    @apellido = '',
    @dni = 44555667,
    @email = 'hsimpson2@sol.com',
    @rol = 2
GO
SELECT * FROM tabla.Administradores WHERE dni = 44555667
GO

--TEST 1.3: Error email
SELECT * FROM tabla.Administradores
EXEC spInsercion.CrearAdministrador
    @nombre = 'Homero',
    @apellido = 'Simpson',
    @dni = 44555666,
    @email = 'hsimpsonsol.com',
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
    @email = 'hsimpson2@sol.com',
    @rol = 2
GO
SELECT * FROM tabla.Administradores WHERE dni = 99999999
GO

--TEST 1.5: DNI duplicado
SELECT * FROM tabla.Administradores
EXEC spInsercion.CrearAdministrador
    @nombre = 'Homero',
    @apellido = 'Flanders',
    @dni = 44555666,
    @email = 'hsimpson2@sol.com',
    @rol = 2
GO
SELECT * FROM tabla.Administradores WHERE dni = 44555666
GO

--ACTUALIZACION

--TEST 2.1: Actualizacion de Homero Simpson a Homero Flanders
SELECT * FROM tabla.Administradores WHERE dni = 44555666
EXEC spActualizacion.ActualizarAdministrador
    @dni = 44555666,
    @email = 'hflanders@sol.com',
    @rol = 2
GO
SELECT * FROM tabla.Administradores WHERE dni = 44555666
GO

--TEST 2.2: Activar Socio
SELECT * FROM tabla.Administradores WHERE dni = 44555666
EXEC spActualizacion.ActualizarAdministrador
    @dni = 44555666,
	@email = 'hsimpson@sol.com',
	@rol = 2,
    @estado = 1
GO
SELECT * FROM tabla.Administradores WHERE dni = 44555666
GO

--ELIMINACION

--TEST 3.1: Desactivar Administrador
SELECT * FROM tabla.Administradores WHERE dni = 44555666
EXEC spEliminacion.EliminarAdministrador
    @dni = 44555666
GO
SELECT * FROM tabla.Administradores WHERE dni = 44555666
GO

--TEST 3.2: ERROR DNI INVALIDO
SELECT * FROM tabla.Administradores
EXEC spEliminacion.EliminarAdministrador
    @dni = 99999999
GO
SELECT * FROM tabla.Administradores WHERE dni = 44555666
GO


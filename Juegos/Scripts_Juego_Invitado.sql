-- Invitados

-- Se crean los TESTS para la insercion, actualizacion y eliminacion de Invitados

USE Com2900G07
GO

--INSERCION

--TEST 1.1: Insercion correcta
SELECT * FROM tabla.Invitados
EXEC spInsercion.CrearInvitado
    @dni = 12345678,
	@nombre = 'Homero',
	@apellido = 'Simpson'
GO
SELECT * FROM tabla.Invitados WHERE dni = 12345678
GO

--TEST 1.2: DNI invalido
SELECT * FROM tabla.Invitados
EXEC spInsercion.CrearInvitado
    @dni = 123456789,
	@nombre = 'Homero',
	@apellido = 'Simpson'
GO
SELECT * FROM tabla.Invitados WHERE dni = 123456789
GO

--TEST 1.3: DNI duplicado
SELECT * FROM tabla.Invitados
EXEC spInsercion.CrearInvitado
    @dni = 12345678,
	@nombre = 'Homero',
	@apellido = 'Simpson'
GO
SELECT * FROM tabla.Invitados WHERE dni = 12345678
GO

--TEST 1.4: Nombre vacio
SELECT * FROM tabla.Invitados
EXEC spInsercion.CrearInvitado
    @dni = 11222333,
	@nombre = '',
	@apellido = 'Simpson'
GO
SELECT * FROM tabla.Invitados WHERE dni = 12345678
GO

--TEST 1.5: Apellido vacio
SELECT * FROM tabla.Invitados
EXEC spInsercion.CrearInvitado
    @dni = 11222333,
	@nombre = 'Homero',
	@apellido = ''
GO
SELECT * FROM tabla.Invitados WHERE dni = 12345678
GO

--ACTUALIZACION

--TEST 2.1: Actualizacion correcta
SELECT * FROM tabla.Invitados
EXEC spActualizacion.actualizarInvitado
    @dni = 12345678,
	@nombre = 'Pepe',
	@apellido = 'Azul'
GO
SELECT * FROM tabla.Invitados WHERE dni = 12345678
GO

--TEST 2.2: Activar invitado
SELECT * FROM tabla.Invitados
EXEC spActualizacion.actualizarInvitado
    @dni = 12345678,
	@nombre = 'Pepe',
	@apellido = 'Azul',
	@estado = 1
GO
SELECT * FROM tabla.Invitados WHERE dni = 12345678
GO

--ELIMINACION

--TEST 3.1: Eliminacion correcta
SELECT * FROM tabla.Invitados
EXEC spEliminacion.eliminarInvitado
    @dni = 12345678
GO
SELECT * FROM tabla.Invitados WHERE dni = 12345678
GO

--TEST 3.2: DNI inexistente
SELECT * FROM tabla.Invitados
EXEC spEliminacion.eliminarInvitado
    @dni = 87654321
GO
SELECT * FROM tabla.Invitados WHERE dni = 87654321
GO

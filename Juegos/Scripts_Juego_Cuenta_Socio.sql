--Cuenta socio

USE Com2900G07
GO

--Agregamos un socio para testear
EXEC spInsercion.CrearPrestadorSalud
    @nombre = 'Galeno_test_cuenta_cosio',
    @tipo = 1,
    @telefono = 46254016

DECLARE @id_prestador_salud_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM tabla.PrestadoresSalud
WHERE nombre = 'Galeno_test_cuenta_cosio';

EXEC spInsercion.CrearSocio
    @dni = 11777888,
    @nombre = 'Socio',
    @apellido = 'Prueba Cuenta Socio',
    @email = 'socio_prueba_cuenta@sol.com',
    @fecha_nacimiento = '2002-11-26',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @id_prestador_salud = @id_prestador_salud_test

--INSERCION

--TEST 1.1: Insercion correcta
SELECT * FROM tabla.CuentasSocios 
EXEC spInsercion.CrearCuentaSocio
	@dni = 11777888,
	@contrasena = '12345$a',
	@usuario = 'socioPruebaCuenta',
	@rol = 1,
	@saldo = 0,
	@fecha_vigencia_contrasena = '2026-06-30 23:59:59',
	@estado_cuenta = 1
SELECT * FROM tabla.CuentasSocios
GO

--TEST 1.2: DNI incorrecto
EXEC spInsercion.CrearCuentaSocio
	@dni = 99999999,
	@contrasena = '12345$a',
	@usuario = 'socioPruebaCuenta',
	@rol = 1,
	@saldo = 0,
	@fecha_vigencia_contrasena = '2026-06-30 23:59:59',
	@estado_cuenta = 1

--TEST 1.3: Contraseña vacia
EXEC spInsercion.CrearCuentaSocio
	@dni = 11777888,
	@contrasena = '',
	@usuario = 'socioPruebaCuenta',
	@rol = 1,
	@saldo = 0,
	@fecha_vigencia_contrasena = '2026-06-30 23:59:59',
	@estado_cuenta = 1
GO

--TEST 1.4: Usuario vacia
EXEC spInsercion.CrearCuentaSocio
	@dni = 11777888,
	@contrasena = '12345$a',
	@usuario = '',
	@rol = 1,
	@saldo = 0,
	@fecha_vigencia_contrasena = '2026-06-30 23:59:59',
	@estado_cuenta = 1
GO

--TEST 1.5: Rol invalido
EXEC spInsercion.CrearCuentaSocio
	@dni = 11777888,
	@contrasena = '12345$a',
	@usuario = 'socioPruebaCuenta',
	@rol = 8,
	@saldo = 0,
	@fecha_vigencia_contrasena = '2026-06-30 23:59:59',
	@estado_cuenta = 1
GO

--TEST 1.6: Fecha vigencia de contraseña invalida
EXEC spInsercion.CrearCuentaSocio
	@dni = 11777888,
	@contrasena = '12345$a',
	@usuario = 'socioPruebaCuenta',
	@rol = 1,
	@saldo = 0,
	@fecha_vigencia_contrasena = '2024-06-30 23:59:59',
	@estado_cuenta = 1
GO

--ACTUALIZACION

--TEST 2.1: Actualizacion correcta
SELECT * FROM tabla.CuentasSocios
EXEC spActualizacion.ActualizarCuentaSocio
	@dni = 11777888,
	@contrasena = '12345$a',
	@usuario = 'socioPruebaCuenta123',
	@rol = 2,
	@saldo = 0,
	@fecha_vigencia_contrasena = '2026-06-30 23:59:59',
	@estado_cuenta = 1
SELECT * FROM tabla.CuentasSocios
GO

--TEST 2.2: DNI incorrecto
EXEC spActualizacion.ActualizarCuentaSocio
	@dni = 99999999,
	@contrasena = '12345$a',
	@usuario = 'socioPruebaCuenta123',
	@rol = 2,
	@saldo = 0,
	@fecha_vigencia_contrasena = '2026-06-30 23:59:59',
	@estado_cuenta = 1
GO

--TEST 2.3: Contraseña vacia
EXEC spActualizacion.ActualizarCuentaSocio
	@dni = 11777888,
	@contrasena = '',
	@usuario = 'socioPruebaCuenta123',
	@rol = 2,
	@saldo = 0,
	@fecha_vigencia_contrasena = '2026-06-30 23:59:59',
	@estado_cuenta = 1
GO

--TEST 2.4: Usuario vacio
EXEC spActualizacion.ActualizarCuentaSocio
	@dni = 11777888,
	@contrasena = '12345$a',
	@usuario = '',
	@rol = 2,
	@saldo = 0,
	@fecha_vigencia_contrasena = '2026-06-30 23:59:59',
	@estado_cuenta = 1
GO

--TEST 2.5: Rol invalido
EXEC spActualizacion.ActualizarCuentaSocio
	@dni = 11777888,
	@contrasena = '12345$a',
	@usuario = 'socioPruebaCuenta123',
	@rol = 8,
	@saldo = 0,
	@fecha_vigencia_contrasena = '2026-06-30 23:59:59',
	@estado_cuenta = 1
GO

--TEST 2.6: Fecha de vigencia de contraseña invalida
EXEC spActualizacion.ActualizarCuentaSocio
	@dni = 11777888,
	@contrasena = '12345$a',
	@usuario = 'socioPruebaCuenta123',
	@rol = 2,
	@saldo = 0,
	@fecha_vigencia_contrasena = '2024-06-30 23:59:59',
	@estado_cuenta = 1
GO

--ELIMINACION

--TEST 3.1: Eliminacion correcta
SELECT * FROM tabla.CuentasSocios
EXEC spEliminacion.EliminarCuentaSocio
	@dni = 11777888
SELECT * FROM tabla.CuentasSocios
GO

--TEST 3.2: DNI invalido
EXEC spEliminacion.EliminarCuentaSocio
	@dni = 9999999
GO
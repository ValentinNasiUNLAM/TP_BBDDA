--SOCIOS
-- Se crean los TESTS para la insercion, actualizacion y eliminacion de SOCIOS

USE Com2900G07
GO

--INSERCION

--TEST 1.1: Insercion correcta
SELECT TOP 1 * FROM tabla.Socios -------------ESTE ES PARA TENER EN LOS PROXIMOS TESTS
EXEC spInsercion.CrearSocio
    @dni = 23777221,
    @nombre = 'Bart',
    @apellido = 'Simpson_Prueba',
    @email = 'BSimpson@sol.com',
    @fecha_nacimiento = '26-11-2002',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @id_prestador_salud = 2,
    @id_tutor = 1,
    @id_grupo_familiar = 100
GO
SELECT * FROM tabla.Socios WHERE dni = 23777221;

SELECT TOP 1 * FROM tabla.Socios
EXEC spInsercion.CrearSocio
    @dni = 23777222,
    @nombre = 'Bart',
    @apellido = 'Simpson',
    @email = 'BSimpson@sol.com',
    @fecha_nacimiento = '26-11-2002',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @id_prestador_salud = 2,
    @id_tutor = 1,
    @id_grupo_familiar = 100
GO
SELECT * FROM tabla.Socios WHERE dni = 23777222;


--TEST 1.2: Error Incorrecta DNI Incorrecto
SELECT TOP 1 * FROM tabla.Socios
EXEC spInsercion.CrearSocio
    @dni = 99999999,
    @nombre = 'Bart',
    @apellido = 'Simpson',
    @email = 'BSimpson@sol.com',
    @fecha_nacimiento = '26-11-2002',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @id_prestador_salud = 2,
    @id_tutor = 1,
    @id_grupo_familiar = 100
GO
SELECT * FROM tabla.Socios WHERE dni = 99999999;
--TEST 1.3: Error nombre y/o apellido vacios
SELECT TOP 1 * FROM tabla.Socios
EXEC spInsercion.CrearSocio
    @dni = 23777223,
    @nombre = '',
    @apellido = '',
    @email = 'BSimpson@sol.com',
    @fecha_nacimiento = '26-11-2002',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @id_prestador_salud = 2,
    @id_tutor = 1,
    @id_grupo_familiar = 100
GO
SELECT * FROM tabla.Socios WHERE dni = 23777223;
--TEST 1.4: Error email
SELECT TOP 1 * FROM tabla.Socios
EXEC spInsercion.CrearSocio
    @dni = 23777224,
    @nombre = 'Bart',
    @apellido = 'Simpson',
    @email = 'BSimpsonsol.com',
    @fecha_nacimiento = '26-11-2002',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @id_prestador_salud = 2,
    @id_tutor = 1,
    @id_grupo_familiar = 100
GO
SELECT * FROM tabla.Socios WHERE dni = 23777224;

--TEST 1.5: Error Fecha Nacimiento
SELECT TOP 1 * FROM tabla.Socios
EXEC spInsercion.CrearSocio
    @dni = 23777225,
    @nombre = 'Bart',
    @apellido = 'Simpson',
    @email = 'BSimpson@sol.com',
    @fecha_nacimiento = DATEADD(DAY, 1, CAST(GETDATE() AS DATE)),
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @id_prestador_salud = 2,
    @id_tutor = 1,
    @id_grupo_familiar = 100
GO
SELECT * FROM tabla.Socios WHERE dni = 23777225;

--TEST 1.6: Error Tutor Socio
SELECT TOP 1 * FROM tabla.Socios
EXEC spInsercion.CrearSocio
    @dni = 23777226,
    @nombre = 'Bart',
    @apellido = 'Simpson',
    @email = 'BSimpson@sol.com',
    @fecha_nacimiento = '26-11-2002',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @id_prestador_salud = 2,
    @id_tutor = 999991,
    @id_grupo_familiar = 100
GO
SELECT * FROM tabla.Socios WHERE dni = 23777226;

--TEST 1.7:Error Grupo Familiar
SELECT TOP 1 * FROM tabla.Socios
EXEC spInsercion.CrearSocio
    @dni = 23777227,
    @nombre = 'Bart',
    @apellido = 'Simpson',
    @email = 'BSimpson@sol.com',
    @fecha_nacimiento = '26-11-2002',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @id_prestador_salud = 2,
    @id_tutor = 1,
    @id_grupo_familiar = 999991
GO
SELECT * FROM tabla.Socios WHERE dni = 23777227;

--ACTUALIZACION

--TEST 2.1: Actualizacion Correcta
EXEC spActualizacion.actualizarSocio
    @dni = 23777222,
    @email = 'BartSimpson@sol.com',
    @telefono = 12345678,
    @telefono_emergencia = 11112222,
    @estado = 1,
    @id_prestador_salud = 2
GO
SELECT * FROM tabla.Socios WHERE dni = 23777222;

--TEST 2.2: Error DNI
EXEC spActualizacion.actualizarSocio
    @dni = 99999991,
    @email = 'BartSimpson@sol.com',
    @telefono = 12345678,
    @telefono_emergencia = 11112222,
    @estado = 1,
    @id_prestador_salud = 2
GO
SELECT * FROM tabla.Socios WHERE dni = 99999991;

--TEST 2.3: Error Mail
EXEC spActualizacion.actualizarSocio
    @dni = 23777222,
    @email = 'BartSimpsonsol.com',
    @telefono = 12345678,
    @telefono_emergencia = 11112222,
    @estado = 1,
    @id_prestador_salud = 2
GO
SELECT * FROM tabla.Socios WHERE dni = 23777222;

--ELIMINACION

--TEST 3.1:  Eliminacion Correcta
EXEC spEliminacion.eliminarSocio
    @dni = 23777222
GO
SELECT * FROM tabla.Socios WHERE dni = 23777222;

--TEST 3.2: DNI Incorrecto
EXEC spEliminacion.eliminarSocio
    @dni = 99999991
GO
SELECT * FROM tabla.Socios WHERE dni = 99999991;

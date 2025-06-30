--SOCIOS
-- Se crean los TESTS para la insercion, actualizacion y eliminacion de SOCIOS

USE Com2900G07
GO

--Agregamos un prestador de salud y un socio tutor para testear
EXEC spInsercion.CrearPrestadorSalud
    @nombre = 'Galeno_test_socio',
    @tipo = 1,
    @telefono = 46254016

DECLARE @id_prestador_salud_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM tabla.PrestadoresSalud
WHERE nombre = 'Galeno_test_socio';

EXEC spInsercion.CrearSocio
    @dni = 12345678,
    @nombre = 'Tutor',
    @apellido = 'Prueba',
    @email = 'tutor_prueba@sol.com',
    @fecha_nacimiento = '2002-11-26',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @id_prestador_salud = @id_prestador_salud_test
GO
--INSERCION

--TEST 1.1: Insercion correcta
DECLARE @id_prestador_salud_test INT;
DECLARE @id_tutor_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM tabla.PrestadoresSalud
WHERE nombre = 'Galeno_test_socio';

SELECT @id_tutor_test = id_socio
FROM tabla.Socios
WHERE dni = 12345678

EXEC spInsercion.CrearSocio
    @dni = 23777221,
    @nombre = 'Bart',
    @apellido = 'Simpson_Prueba',
    @email = 'BSimpson1@sol.com',
    @fecha_nacimiento = '2002-11-26',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @id_prestador_salud = @id_prestador_salud_test,
    @id_tutor = @id_tutor_test,
    @id_grupo_familiar = @id_tutor_test
SELECT * FROM tabla.Socios WHERE dni = 23777221;

-------------ESTE ES PARA TENER EN LOS PROXIMOS TESTS
EXEC spInsercion.CrearSocio
    @dni = 23777222,
    @nombre = 'Bart',
    @apellido = 'Simpson',
    @email = 'BSimpson@sol.com',
    @fecha_nacimiento = '2002-11-26',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @id_prestador_salud = @id_prestador_salud_test,
    @id_tutor = @id_tutor_test,
    @id_grupo_familiar = @id_tutor_test
SELECT * FROM tabla.Socios WHERE dni = 23777222;
GO

--TEST 1.2: Error Incorrecta DNI Incorrecto
DECLARE @id_prestador_salud_test INT;
DECLARE @id_tutor_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM tabla.PrestadoresSalud
WHERE nombre = 'Galeno_test_socio';

SELECT @id_tutor_test = id_socio
FROM tabla.Socios
WHERE dni = 12345678

EXEC spInsercion.CrearSocio
    @dni = 99999999,
    @nombre = 'Bart',
    @apellido = 'Simpson',
    @email = 'BSimpson2@sol.com',
    @fecha_nacimiento = '2002-11-26',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @id_prestador_salud = @id_prestador_salud_test,
    @id_tutor = @id_tutor_test,
    @id_grupo_familiar = @id_tutor_test
GO

--TEST 1.3: Error nombre y/o apellido vacios
DECLARE @id_prestador_salud_test INT;
DECLARE @id_tutor_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM tabla.PrestadoresSalud
WHERE nombre = 'Galeno_test_socio';

SELECT @id_tutor_test = id_socio
FROM tabla.Socios
WHERE dni = 12345678

EXEC spInsercion.CrearSocio
    @dni = 23777223,
    @nombre = '',
    @apellido = '',
    @email = 'BSimpson2@sol.com',
    @fecha_nacimiento = '2002-11-26',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @id_prestador_salud = @id_prestador_salud_test,
    @id_tutor = @id_tutor_test,
    @id_grupo_familiar = @id_tutor_test
GO

--TEST 1.4: Error email
DECLARE @id_prestador_salud_test INT;
DECLARE @id_tutor_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM tabla.PrestadoresSalud
WHERE nombre = 'Galeno_test_socio';

SELECT @id_tutor_test = id_socio
FROM tabla.Socios
WHERE dni = 12345678

EXEC spInsercion.CrearSocio
    @dni = 23777224,
    @nombre = 'Bart',
    @apellido = 'Simpson',
    @email = 'BSimpsonsol.com',
    @fecha_nacimiento = '2002-11-26',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @id_prestador_salud = @id_prestador_salud_test,
    @id_tutor = @id_tutor_test,
    @id_grupo_familiar = @id_tutor_test
GO

--TEST 1.5: Error Fecha Nacimiento
DECLARE @id_prestador_salud_test INT;
DECLARE @id_tutor_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM tabla.PrestadoresSalud
WHERE nombre = 'Galeno_test_socio';

SELECT @id_tutor_test = id_socio
FROM tabla.Socios
WHERE dni = 12345678

EXEC spInsercion.CrearSocio
    @dni = 23777225,
    @nombre = 'Bart',
    @apellido = 'Simpson',
    @email = 'BSimpson2@sol.com',
    @fecha_nacimiento = '2100-11-26',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @id_prestador_salud = @id_prestador_salud_test,
    @id_tutor = @id_tutor_test,
    @id_grupo_familiar = @id_tutor_test
GO

--TEST 1.6: Error Tutor Socio
DECLARE @id_prestador_salud_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM tabla.PrestadoresSalud
WHERE nombre = 'Galeno_test_socio';

EXEC spInsercion.CrearSocio
    @dni = 23777226,
    @nombre = 'Bart',
    @apellido = 'Simpson',
    @email = 'BSimpson2@sol.com',
    @fecha_nacimiento = '2002-11-26',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @id_prestador_salud = @id_prestador_salud_test,
    @id_tutor = 999991,
    @id_grupo_familiar = 999991
GO

--TEST 1.7:Error Grupo Familiar
DECLARE @id_prestador_salud_test INT;
DECLARE @id_tutor_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM tabla.PrestadoresSalud
WHERE nombre = 'Galeno_test_socio';

SELECT @id_tutor_test = id_socio
FROM tabla.Socios
WHERE dni = 12345678

EXEC spInsercion.CrearSocio
    @dni = 23777227,
    @nombre = 'Bart',
    @apellido = 'Simpson',
    @email = 'BSimpson2@sol.com',
    @fecha_nacimiento = '2002-11-26',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @id_prestador_salud = @id_prestador_salud_test,
    @id_tutor = @id_tutor_test,
    @id_grupo_familiar = 999991
GO

--ACTUALIZACION

--TEST 2.1: Actualizacion Correcta
DECLARE @id_prestador_salud_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM tabla.PrestadoresSalud
WHERE nombre = 'Galeno_test_socio';

EXEC spActualizacion.ActualizarSocio
    @dni = 23777221,
    @email = 'BartSimpson@sol.com',
    @telefono = 12345678,
    @telefono_emergencia = 11112222,
    @estado = 1,
    @id_prestador_salud = @id_prestador_salud_test
GO
SELECT * FROM tabla.Socios WHERE dni = 23777221;

--TEST 2.2: Error DNI
EXEC spActualizacion.ActualizarSocio
    @dni = 99999999,
    @email = 'BartSimpson@sol.com',
    @telefono = 12345678,
    @telefono_emergencia = 11112222,
    @estado = 1,
    @id_prestador_salud = 2
GO

--TEST 2.3: Error Mail
EXEC spActualizacion.ActualizarSocio
    @dni = 23777221,
    @email = 'BartSimpsonsol.com',
    @telefono = 12345678,
    @telefono_emergencia = 11112222,
    @estado = 1,
    @id_prestador_salud = 2
GO

--TEST 2.4: Actualizar tutor
EXEC spActualizacion.ActualizarSocioTutor
	@dni_tutor = 12345678,
	@dni_menor = 23777221

--TEST 2.4: Actualizar grupo familiar
EXEC spActualizacion.ActualizarSocioGrupoFamiliar
	@dni = 23777221,
	@dni_responsable_grupo_familiar = 12345678

--ELIMINACION

--TEST 3.1:  Desactivacion Correcta
EXEC spEliminacion.EliminarSocio
    @dni = 23777221
GO
SELECT * FROM tabla.Socios WHERE dni = 23777221;

--TEST 3.2: DNI Incorrecto
EXEC spEliminacion.EliminarSocio
    @dni = 99999991
GO
SELECT * FROM tabla.Socios WHERE dni = 99999991;

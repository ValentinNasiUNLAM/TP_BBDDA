/*
Luego de decidirse por un motor de base de datos relacional, lleg� el momento de generar la
base de datos. En esta oportunidad utilizar�n SQL Server.
Deber� instalar el DMBS y documentar el proceso. No incluya capturas de pantalla. Detalle
las configuraciones aplicadas (ubicaci�n de archivos, memoria asignada, seguridad, puertos,
etc.) en un documento como el que le entregar�a al DBA.
Cree la base de datos, entidades y relaciones. Incluya restricciones y claves. Deber� entregar
un archivo .sql con el script completo de creaci�n (debe funcionar si se lo ejecuta �tal cual� es
entregado en una sola ejecuci�n). Incluya comentarios para indicar qu� hace cada m�dulo
de c�digo.
Genere store procedures para manejar la inserci�n, modificado, borrado (si corresponde,
tambi�n debe decidir si determinadas entidades solo admitir�n borrado l�gico) de cada tabla.
Los nombres de los store procedures NO deben comenzar con �SP�.
Algunas operaciones implicar�n store procedures que involucran varias tablas, uso de
transacciones, etc. Puede que incluso realicen ciertas operaciones mediante varios SPs.
Aseg�rense de que los comentarios que acompa�en al c�digo lo expliquen.
Genere esquemas para organizar de forma l�gica los componentes del sistema y aplique esto
en la creaci�n de objetos. NO use el esquema �dbo�.
Todos los SP creados deben estar acompa�ados de juegos de prueba. Se espera que
realicen validaciones b�sicas en los SP (p/e cantidad mayor a cero, CUIT v�lido, etc.) y que
en los juegos de prueba demuestren la correcta aplicaci�n de las validaciones.
Las pruebas deben realizarse en un script separado, donde con comentarios se indique en
cada caso el resultado esperado
El archivo .sql con el script debe incluir comentarios donde consten este enunciado, la fecha
de entrega, n�mero de grupo, nombre de la materia, nombres y DNI de los alumnos.
Entregar todo en un zip (observar las pautas para nomenclatura antes expuestas) mediante
la secci�n de pr�cticas de MIEL. Solo uno de los miembros del grupo debe hacer la entrega.

Materia: Bases de datos aplicadas
Fecha de entrega: 03/06/2025
Grupo: 07
Alumnos: 
	Nasi Valentin 44851378
	Traversa Franco 44510896
	Arias Kevin 41246810
*/


--CATEGORIAS

-- Se crean los TESTS para la insercion, actualizacion y eliminacion de categorias


USE Com2900G07
GO

--INSERCION

--TEST 1.1: Resultado esperado, Juvenil, 12, 17, 5000
EXEC spInsercion.CrearCategoria
    @nombre_categoria = 'Juvenil',
    @edad_min = 12,
    @edad_max = 17,
    @precio_mensual = 5000
GO
SELECT * FROM tabla.Categorias WHERE nombre_categoria = 'Juvenil'
GO

--TEST 1.2: Edad Minima Invalida 
EXEC spInsercion.CrearCategoria
    @nombre_categoria = 'Error_Edad',
    @edad_min = 20,
    @edad_max = 17,
    @precio_mensual = 5000
GO
SELECT * FROM tabla.Categorias WHERE nombre_categoria = 'Error_Edad'
GO

--TEST 1.3: Precio Invalido
EXEC spInsercion.CrearCategoria 
    @nombre_categoria = 'Error_Precio', 
    @edad_min = 12,
    @edad_max = 17,
    @precio_mensual = -1000
GO
SELECT * FROM tabla.Categorias WHERE nombre_categoria = 'Error_Precio'
GO

--TEST 1.4: Nombre Categoria Vacio
EXEC spInsercion.CrearCategoria
    @nombre_categoria = '',
    @edad_min = 12,
    @edad_max = 17,
    @precio_mensual = -1000
GO
SELECT * FROM tabla.Categorias WHERE nombre_categoria = ''
GO

--ACTUALIZACION

--TEST 2.1: Resultado esperado Juvenil, 10, 18, 2000 - Actualizacion de precio mensual
EXEC spActualizacion.ActualizarCategoria
    @id_categoria = 1,
    @nombre_categoria = 'Juvenil',
    @edad_min = 10,
    @edad_max = 18,
    @precio_mensual = 2000
GO
SELECT * FROM tabla.Categorias WHERE id_categoria = 1
GO

--TEST 2.2: Error Actualizar Edad 
EXEC spActualizacion.ActualizarCategoria 
    @id_categoria = 1,
    @nombre_categoria = 'Juvenil',
    @edad_min = 20,
    @edad_max = 18,
    @precio_mensual = 2000
GO
SELECT * FROM tabla.Categorias WHERE id_categoria = 1
GO

--TEST 2.3: ERROR PRECIO MENSUAL INVALIDO 
EXEC spActualizacion.ActualizarCategoria
    @id_categoria = 1,
    @nombre_categoria = 'Juvenil',
    @edad_min = 12,
    @edad_max = 18,
    @precio_mensual = -3000
GO
SELECT * FROM tabla.Categorias WHERE id_categoria = 1
GO

--TEST 2.4: ERROR NOMBRE CATEGORIA VACIO 
EXEC spActualizacion.ActualizarCategoria
    @id_categoria = 1,
    @nombre_categoria = '',
    @edad_min = 12,
    @edad_max = 18,
    @precio_mensual = 2000
GO
SELECT * FROM tabla.Categorias WHERE id_categoria = 1
GO

--TEST 2.5: NO EXISTE ID CATEGORIA
EXEC spActualizacion.ActualizarCategoria
    @id_categoria = 99991,
    @nombre_categoria = 'Juvenil',
    @edad_min = 12,
    @edad_max = 18,
    @precio_mensual = 2000
GO


--ELIMINACION

--TEST 3.1: ELIMINACION EXITOSA
EXEC spEliminacion.EliminarCategoria --ok
    @id_categoria = 1
GO
SELECT * FROM tabla.Categorias WHERE id_categoria = 1

--TEST 3.2: ID CATEGORIA NO ENCONTRADO 
EXEC spEliminacion.EliminarCategoria --ok
    @id_categoria = 99991
GO

--Prestadores Salud

-- Se crean los TESTS para la insercion, actualizacion y eliminacion de Prestadores Salud

USE Com2900G07
GO

--INSERCION

--TEST 1.1: Resultado esperado, ID, 1, Galeno, 46254016
SELECT * FROM tabla.PrestadoresSalud
EXEC spInsercion.CrearPrestadorSalud
    @nombre = 'Galeno',
    @telefono = '46254016',
    @nro = 'TEST_1.1'
GO
SELECT * FROM tabla.PrestadoresSalud WHERE nombre = 'Galeno'
GO

-- TEST 1.2: Error nombre vacio
SELECT * FROM tabla.PrestadoresSalud
EXEC spInsercion.CrearPrestadorSalud
    @nombre = '',
    @telefono = '46254016',
    @nro = 'TEST_123'
GO


--TEST 1.3: Error nro vacio 
SELECT * FROM tabla.PrestadoresSalud
EXEC spInsercion.CrearPrestadorSalud
    @nombre = 'Galeno_Error_NRO_VACIO',
    @telefono = '46254016',
    @nro = ''
GO

--ACTUALIZACION

--TEST 2.1: Resultado esperado ID, 2, IOMA, 1199998888
SELECT * FROM tabla.PrestadoresSalud
EXEC spActualizacion.ActualizarPrestadorSalud
    @id_prestador_salud = 1,
    @nombre = 'IOMA',
    @telefono = '46254016',
    @nro = 'TEST_2.1'
GO
SELECT * FROM tabla.PrestadoresSalud WHERE id_prestador_salud = 1
GO

--TEST 2.2: Error nombre vacio
SELECT * FROM tabla.PrestadoresSalud
EXEC spActualizacion.ActualizarPrestadorSalud
    @id_prestador_salud = 1,
    @nombre = '',
    @telefono = '46254016',
    @nro = 'TEST_2.1'
GO

--TEST 2.3: Error nro vacio:
SELECT * FROM tabla.PrestadoresSalud
EXEC spActualizacion.ActualizarPrestadorSalud
    @id_prestador_salud = 1,
    @nombre = 'IOMA',
    @telefono = '46254016',
    @nro = '.'
GO

--TEST 2.4: Error no existe ID
SELECT * FROM tabla.PrestadoresSalud
EXEC spActualizacion.ActualizarPrestadorSalud
    @id_prestador_salud = 99991,
    @nombre = 'IOMA',
    @tipo = 5,
    @telefono = 1199998888
GO

--ELIMINACION

--TEST 3.1: Eliminacion Exitosa
SELECT * FROM tabla.PrestadoresSalud
EXEC spEliminacion.EliminarPrestadorSalud
    @id_prestador_salud = 1
GO
SELECT * FROM tabla.PrestadoresSalud WHERE id_prestador_salud = 1
GO

--TEST 3.2: No existe ID
SELECT * FROM tabla.PrestadoresSalud
EXEC spEliminacion.EliminarPrestadorSalud
    @id_prestador_salud = 99991
GO


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

--TEST 2.2: Activar Administrador
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

--Medios Pago

-- Se crean los TESTS para la insercion, actualizacion y eliminacion de Medios Pago

USE Com2900G07
GO

-- Insercion

--TEST 1.1: Registro de un nuevo medio de pago
SELECT * FROM tabla.MediosPago
EXEC spInsercion.CrearMedioPago
    @Nombre = 'Tarjeta de Cr�dito',
    @Descripcion = 'Pago con tarjeta de cr�dito'
GO
SELECT * FROM tabla.MediosPago WHERE Nombre = 'Tarjeta de Cr�dito'
GO

--TEST 1.2: Error al insertar un medio de pago con nombre vac�o
EXEC spInsercion.CrearMedioPago
    @Nombre = '',
    @Descripcion = 'Pago con tarjeta de cr�dito'
GO
SELECT * FROM tabla.MediosPago WHERE Nombre = 'Tarjeta de Cr�dito'
GO

-- Actualizacion

--TEST 2.1: Actualizar un medio de pago existente
SELECT * FROM tabla.MediosPago
EXEC spActualizacion.ActualizarMedioPago
    @id_medio_pago = 9898989,
    @Nombre = 'Tarjeta de D�bito',
    @Descripcion = 'Pago con tarjeta de d�bito'
GO
SELECT * FROM tabla.MediosPago WHERE id_medio_pago = 9898989
GO

--TEST 2.2: Error al Actualizar un medio de pago con nombre vac�o
EXEC spActualizacion.ActualizarMedioPago
    @id_medio_pago = 1,
    @Nombre = '',
    @Descripcion = 'Pago con tarjeta de d�bito'
GO
SELECT * FROM tabla.MediosPago WHERE id_medio_pago = 1
GO

-- Eliminacion

--TEST 3.1: Eliminar un medio de pago existente
SELECT * FROM tabla.MediosPago
EXEC spEliminacion.EliminarMedioPago
    @id_medio_pago = 1
GO
SELECT * FROM tabla.MediosPago WHERE id_medio_pago = 1
GO

--TEST 3.2: Error al Eliminar un medio de pago inexistente
EXEC spEliminacion.EliminarMedioPago
    @id_medio_pago = 9999 -- Asumiendo que este ID no existe
GO
SELECT * FROM tabla.MediosPago WHERE id_medio_pago = 9999
GO

--Deportes
--Se crean los TESTS para la insercion, actualizacion y eliminacion de datos en la tabla DEPORTES

USE Com2900G07
GO

--INSERCION

--TEST 1.1: Agregar un nuevo deporte Exitoso
SELECT * FROM tabla.Deportes;
EXEC spInsercion.CrearDeporte
    @nombre = 'Futbol',
    @precio = 1000
GO
SELECT * FROM tabla.Deportes WHERE nombre = 'Futbol';

--TEST 1.2: Error precio negativo
EXEC spInsercion.CrearDeporte
    @nombre = 'Baloncesto',
    @precio = -500
GO
SELECT * FROM tabla.Deportes WHERE nombre = 'Baloncesto';

--TEST 1.3: Nombre Vacio
EXEC spInsercion.CrearDeporte
    @nombre = '',
    @precio = 500
GO
SELECT * FROM tabla.Deportes;

--ACTUALIZACION

--TEST 2.1: Actualizar un deporte exitoso
EXEC spActualizacion.ActualizarDeporte
    @id_deporte = 1,
    @nombre = 'Futbol Profesional',
    @precio = 1200
GO
SELECT * FROM tabla.Deportes WHERE id_deporte = 1;

--TEST 2.2: Actualizar un deporte con nombre vacio
EXEC spActualizacion.ActualizarDeporte
    @id_deporte = 1,
    @nombre = '',
    @precio = 1200
GO
SELECT * FROM tabla.Deportes WHERE id_deporte = 1;

--TEST 2.3: Actualizar un deporte con precio negativo
EXEC spActualizacion.ActualizarDeporte
    @id_deporte = 1,
    @nombre = 'Futbol Profesional',
    @precio = -1000
GO
SELECT * FROM tabla.Deportes WHERE id_deporte = 1;

--ELIMINACION

--TEST 3.1: Eliminar un deporte exitoso
EXEC spEliminacion.EliminarDeporte
    @id_deporte = 1
GO
SELECT * FROM tabla.Deportes WHERE id_deporte = 1;

--TEST 3.2: Deporte inexistente
EXEC spEliminacion.EliminarDeporte
    @id_deporte = 9999
GO
SELECT * FROM tabla.Deportes WHERE id_deporte = 9999;

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
EXEC spActualizacion.ActualizarInvitado
    @dni = 12345678,
	@nombre = 'Pepe',
	@apellido = 'Azul'
GO
SELECT * FROM tabla.Invitados WHERE dni = 12345678
GO

--TEST 2.2: Activar invitado
SELECT * FROM tabla.Invitados
EXEC spActualizacion.ActualizarInvitado
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
EXEC spEliminacion.EliminarInvitado
    @dni = 12345678
GO
SELECT * FROM tabla.Invitados WHERE dni = 12345678
GO

--TEST 3.2: DNI inexistente
SELECT * FROM tabla.Invitados
EXEC spEliminacion.EliminarInvitado
    @dni = 87654321
GO
SELECT * FROM tabla.Invitados WHERE dni = 87654321
GO


--Clases
-- Se crean los TESTS para la insercion, actualizacion y eliminacion de Clases
USE Com2900G07
GO

-- Agregar un nuevo deporte para usar de prueba
EXEC spInsercion.CrearDeporte
    @nombre = 'Futbol_test_clase',
    @precio = 1000
GO

--INSERCION

-- TEST 1.1: Insertar una Clase
DECLARE @id_deporte_test INT;

SELECT @id_deporte_test = id_deporte
FROM tabla.Deportes
WHERE nombre = 'Futbol_test_clase';

SELECT * FROM tabla.Clases
EXEC spInsercion.CrearClase
    @id_deporte = @id_deporte_test

SELECT * FROM tabla.Clases WHERE id_deporte = @id_deporte_test
GO

-- ELIMINACION
-- TEST 3.1: Eliminar un Deporte
DECLARE @id_deporte_test INT;

SELECT @id_deporte_test = id_deporte
FROM tabla.Deportes
WHERE nombre = 'Futbol_test_clase';

SELECT * FROM tabla.Clases
EXEC spEliminacion.EliminarClase
    @id_deporte = @id_deporte_test
SELECT * FROM tabla.Clases WHERE id_clase = 1
GO


--Turnos

-- Se crean los TESTS para la insercion, actualizacion y eliminacion de Turnos

USE Com2900G07
GO

-- Agregar un nuevo deporte y una clase para usar de prueba
EXEC spInsercion.CrearDeporte
    @nombre = 'Futbol_test_clase_turno',
    @precio = 1000
GO

DECLARE @id_deporte_test INT;

SELECT @id_deporte_test = id_deporte
FROM tabla.Deportes
WHERE nombre = 'Futbol_test_clase_turno';

SELECT * FROM tabla.Clases
EXEC spInsercion.CrearClase
    @id_deporte = @id_deporte_test
GO

-- INSERCION

-- TEST 1.1: Crear Turno Exitoso
DECLARE @id_clase_test INT;

SELECT @id_clase_test = id_clase
FROM tabla.Clases c
INNER JOIN tabla.Deportes d ON d.id_deporte = c.id_clase
WHERE d.nombre = 'Futbol_test_clase_turno';

SELECT * FROM tabla.Turnos
EXEC spInsercion.CrearTurno
    @id_clase = @id_clase_test,
    @dia = 4,
    @hora_inicio = '10:00',
    @hora_fin = '12:00'

SELECT * FROM tabla.Turnos WHERE id_clase = @id_clase_test AND dia = 4 AND hora_inicio = '10:00' AND hora_fin = '12:00'
GO

--TEST 1.2: Crear Turno Fallido (Dia Incorrecto ya existe)
DECLARE @id_clase_test INT;

SELECT @id_clase_test = id_clase
FROM tabla.Clases c
INNER JOIN tabla.Deportes d ON d.id_deporte = c.id_clase
WHERE d.nombre = 'Futbol_test_clase_turno';

SELECT * FROM tabla.Turnos
EXEC spInsercion.CrearTurno
    @id_clase = @id_clase_test,
    @dia = 11,
    @hora_inicio = '10:00',
    @hora_fin = '12:00'
GO

--TEST 1.3: Crear Turno Fallido (Hora Inicio Incorrecta ya existe)
DECLARE @id_clase_test INT;

SELECT @id_clase_test = id_clase
FROM tabla.Clases c
INNER JOIN tabla.Deportes d ON d.id_deporte = c.id_clase
WHERE d.nombre = 'Futbol_test_clase_turno';

SELECT * FROM tabla.Turnos
EXEC spInsercion.CrearTurno
    @id_clase = @id_clase_test,
    @dia = 4,
    @hora_inicio = '18:00',
    @hora_fin = '14:00'
GO

-- ACTUALIZACION

-- TEST 2.1: Actualizar Turno Exitoso
DECLARE @id_clase_test INT;
DECLARE @id_turno_test INT;

SELECT @id_clase_test = id_clase
FROM tabla.Clases c
INNER JOIN tabla.Deportes d ON d.id_deporte = c.id_clase
WHERE d.nombre = 'Futbol_test_clase_turno';

SELECT @id_turno_test = id_turno
FROM tabla.Turnos
WHERE id_clase = @id_clase_test

SELECT * FROM tabla.Turnos WHERE id_turno = @id_turno_test
EXEC spActualizacion.ActualizarTurno
    @id_turno = @id_turno_test,
	@id_clase = @id_clase_test,
    @dia = 4,
    @hora_inicio = '12:00',
    @hora_fin = '14:00'

SELECT * FROM tabla.Turnos WHERE id_turno = @id_turno_test
GO

-- TEST 2.2: Actualizar Turno Fallido (Dia Incorrecto)
DECLARE @id_clase_test INT;
DECLARE @id_turno_test INT;

SELECT @id_clase_test = id_clase
FROM tabla.Clases c
INNER JOIN tabla.Deportes d ON d.id_deporte = c.id_clase
WHERE d.nombre = 'Futbol_test_clase_turno';

SELECT @id_turno_test = id_turno
FROM tabla.Turnos
WHERE id_clase = @id_clase_test

SELECT * FROM tabla.Turnos
EXEC spActualizacion.ActualizarTurno
    @id_turno = @id_turno_test,
	@id_clase = @id_clase_test,
    @dia = 11,
    @hora_inicio = '10:00',
    @hora_fin = '12:00'
GO

-- TEST 2.3: Actualizar Turno Fallido (Hora Inicio Incorrecta)
DECLARE @id_clase_test INT;
DECLARE @id_turno_test INT;

SELECT @id_clase_test = id_clase
FROM tabla.Clases c
INNER JOIN tabla.Deportes d ON d.id_deporte = c.id_clase
WHERE d.nombre = 'Futbol_test_clase_turno';

SELECT @id_turno_test = id_turno
FROM tabla.Turnos
WHERE id_clase = @id_clase_test

SELECT * FROM tabla.Turnos
EXEC spActualizacion.ActualizarTurno
    @id_turno = @id_turno_test,
	@id_clase = @id_clase_test,
    @dia = 4,
    @hora_inicio = '18:00',
    @hora_fin = '14:00'
GO

-- ELIMINACION

-- TEST 3.1: Eliminar Turno Exitoso
DECLARE @id_clase_test INT;
DECLARE @id_turno_test INT;

SELECT @id_clase_test = id_clase
FROM tabla.Clases c
INNER JOIN tabla.Deportes d ON d.id_deporte = c.id_clase
WHERE d.nombre = 'Futbol_test_clase_turno';

SELECT @id_turno_test = id_turno
FROM tabla.Turnos
WHERE id_clase = @id_clase_test

SELECT * FROM tabla.Turnos
EXEC spEliminacion.EliminarTurno
    @id_turno = @id_turno_test

SELECT * FROM tabla.Turnos WHERE id_turno = @id_turno_test
GO

-- TEST 3.2: Eliminar Turno Fallido (Turno No Existe)
SELECT * FROM tabla.Turnos
EXEC spEliminacion.EliminarTurno
    @id_turno = 9999999
GO


-- Socios
-- Se crean los TESTS para la insercion, actualizacion y eliminacion de SOCIOS

USE Com2900G07
GO

--Agregamos un prestador de salud y un socio tutor para testear
EXEC spInsercion.CrearPrestadorSalud
    @nombre = 'Galeno_test_socio',
    @telefono = '46254016',
    @nro = 'TEST_1234'

DECLARE @id_prestador_salud_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM tabla.PrestadoresSalud
WHERE nombre = 'Galeno_test_socio';

EXEC spInsercion.CrearSocio
    @dni = 12345678,
    @nro_socio = 9987,
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
    @nro_socio = 9986,
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
    @nro_socio = 9985,
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
    @nro_socio = 9984,
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
    @nro_socio = 9984,
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
    @nro_socio = 9983,
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
    @nro_socio = 9982,
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
    @nro_socio = 9981,
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
    @nro_socio = 9980,
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
    @nro_socio = 9981,
    @email = 'BartSimpson@sol.com',
    @telefono = 12345678,
    @telefono_emergencia = 11112222,
    @estado = 1,
    @id_prestador_salud = 2
GO

--TEST 2.3: Error Mail
EXEC spActualizacion.ActualizarSocio
    @dni = 23777221,
    @nro_socio = 9981,
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


--Cuotas
--Se crean los TESTS para la insercion, actualizacion y eliminacion de Cuotas

USE Com2900G07
GO

--Agregamos un socio y una categoria para testear
EXEC spInsercion.CrearPrestadorSalud
    @nombre = 'Galeno_test_cuota',
    @telefono = '46254016',
    @nro = 'TEST_1234'

DECLARE @id_prestador_salud_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM tabla.PrestadoresSalud
WHERE nombre = 'Galeno_test_cuota';

EXEC spInsercion.CrearSocio
    @dni = 11222333,
    @nro_socio = 9979,
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


-- Actividades
-- Se crean los TESTS para la insercion, actualizacion y eliminacion de Actividad

USE Com2900G07
GO

--Agregamos un socio y un deporte para testear
EXEC spInsercion.CrearPrestadorSalud
    @nombre = 'Galeno_test_actividad',
    @telefono = '46254016',
    @nro = 'TEST_1234'

DECLARE @id_prestador_salud_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM tabla.PrestadoresSalud
WHERE nombre = 'Galeno_test_actividad';

EXEC spInsercion.CrearSocio
    @dni = 11222444,
    @nro_socio = 9978,
    @nombre = 'Test',
    @apellido = 'Actividad',
    @email = 'test_actividad@sol.com',
    @fecha_nacimiento = '2002-11-26',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @id_prestador_salud = @id_prestador_salud_test

EXEC spInsercion.CrearDeporte
    @nombre = 'Futbol_test_actividad',
    @precio = 1000
GO

--INSERCION

--TEST 1.1: Insercion Correcta
DECLARE @id_deporte_test INT

SELECT @id_deporte_test = id_deporte
FROM tabla.Deportes
WHERE nombre = 'Futbol_test_actividad'

EXEC spInsercion.CrearActividad
    @dni = 11222444,
    @id_deporte = @id_deporte_test
GO
SELECT * FROM tabla.Actividades

--TEST 1.2: Error DNI Socio
EXEC spInsercion.CrearActividad
    @dni = 99999999,
    @id_deporte = 1
GO

--TEST 1.3: Error id_deporte
EXEC spInsercion.CrearActividad
    @dni = 11222444,
    @id_deporte = 99999991
GO


--Eliminacion
--Test 3.1: Eliminar Actividad
DECLARE @id_deporte_test INT

SELECT @id_deporte_test = id_deporte
FROM tabla.Deportes
WHERE nombre = 'Futbol_test_actividad'

EXEC spEliminacion.EliminarActividad
    @dni = 11222444,
    @id_deporte = @id_deporte_test;
GO

--Test 3.2: Dni Incorrecto
EXEC spEliminacion.EliminarActividad
    @dni = 99999999,
    @id_deporte = 1;
GO

--Test 3.3: ID deporte Incorrecto
EXEC spEliminacion.EliminarActividad
    @dni = 11222444,
    @id_deporte = 999999;
GO

--Actividades extra
--Se crean los TESTS para la insercion, actualizacion y eliminacion de ACTIVIDADES EXTRA

USE Com2900G07
GO

--Agregamos un socio y un invitado para testear
EXEC spInsercion.CrearPrestadorSalud
    @nombre = 'Galeno_test_act_extra',
    @telefono = '46254016',
    @nro = 'TEST_1234'

DECLARE @id_prestador_salud_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM tabla.PrestadoresSalud
WHERE nombre = 'Galeno_test_act_extra';

EXEC spInsercion.CrearSocio
    @dni = 44555666,
    @nro_socio = 9977,
    @nombre = 'Socio',
    @apellido = 'Prueba Act Extra',
    @email = 'socio_prueba_ae@sol.com',
    @fecha_nacimiento = '2002-11-26',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @id_prestador_salud = @id_prestador_salud_test

EXEC spInsercion.CrearInvitado
    @dni = 11123123,
	@nombre = 'Invitado',
	@apellido = 'Test Act Extra'
GO

--INSERCION

--TEST 1.1: INSERCCION CORRECTA
EXEC spInsercion.CrearActividadExtra
    @dni = 44555666,
    @dni_invitado = 11123123,
    @tipo_actividad = 1,
    @fecha = '2025-06-01',
    @fecha_reserva = '2025-05-20',
    @monto = 1000,
    @monto_invitado = 500,
    @lluvia = 0
GO

--TEST 1.2: INSERCCION CON DNI INVITADO NO EXISTENTE
EXEC spInsercion.CrearActividadExtra
    @dni = 44555666,
    @dni_invitado = 99999999, -- DNI no existente
    @tipo_actividad = 1,
    @fecha = '2025-06-01',
    @fecha_reserva = '2025-05-20',
    @monto = 1000,
    @monto_invitado = 500,
    @lluvia = 0
GO

--TEST 1.3: INSERCCION CON TIPO DE ACTIVIDAD NO EXISTENTE
EXEC spInsercion.CrearActividadExtra
    @dni = 44555666,
    @dni_invitado = 11123123,
    @tipo_actividad = 10, -- Tipo de actividad no existente
    @fecha = '2025-06-01',
    @fecha_reserva = '2025-05-20',
    @monto = 1000,
    @monto_invitado = 500,
    @lluvia = 0
GO

--TEST 1.4: INSERCCION CON FECHA RESERVA POSTERIOR A LA FECHA DE ACTIVIDAD
EXEC spInsercion.CrearActividadExtra
    @dni = 44555666,
    @dni_invitado = 11123123,
    @tipo_actividad = 1,
    @fecha = '2025-06-01',
    @fecha_reserva = '2025-06-20', -- Fecha de reserva anterior a la fecha de actividad
    @monto = 1000,
    @monto_invitado = 500,
    @lluvia = 0
GO

--TEST 1.5: INSERCCION CON MONTO NEGATIVO
EXEC spInsercion.CrearActividadExtra
    @dni = 44555666,
    @dni_invitado = 11123123,
    @tipo_actividad = 1,
    @fecha = '2025-06-01',
    @fecha_reserva = '2025-05-20',
    @monto = -1000, -- Monto negativo
    @monto_invitado = 500,
    @lluvia = 0
GO


--ACTUALIZACION

--TEST 2.1: ACTUALIZACION CORRECTA
EXEC spActualizacion.ActualizarActividadExtra
    @id_actividad_extra = 1, -- ID de la actividad a actualizar
    @dni_socio = 44555666,
    @dni_invitado = NULL, -- Saco al invitado
    @tipo_actividad = 1,
    @fecha = '2025-06-01',
    @fecha_reserva = '2025-05-30',
    @monto = 1200, -- Nuevo monto
    @monto_invitado = NULL, -- Nuevo monto invitado
    @lluvia = 0
GO

--TEST 2.2: ACTUALIZACION CON ID DE ACTIVIDAD NO EXISTENTE
EXEC spActualizacion.ActualizarActividadExtra
    @id_actividad_extra = 999, -- ID de actividad no existente
    @dni_socio = 44555666,
    @dni_invitado = 11123123,
    @tipo_actividad = 1,
    @fecha = '2025-06-01',
    @fecha_reserva = '2025-05-20',
    @monto = 1200,
    @monto_invitado = 600,
    @lluvia = 0
GO

--TEST 2.3: ACTUALIZACION CON DNI INVITADO NO EXISTENTE
EXEC spActualizacion.ActualizarActividadExtra
    @id_actividad_extra = 1,
    @dni_socio = 44555666,
    @dni_invitado = 99999999, -- DNI no existente
    @tipo_actividad = 1,
    @fecha = '2025-06-01',
    @fecha_reserva = '2025-05-20',
    @monto = 1200,
    @monto_invitado = 600,
    @lluvia = 0
GO

--TEST 2.4: ACTUALIZACION CON TIPO DE ACTIVIDAD NO EXISTENTE
EXEC spActualizacion.ActualizarActividadExtra
    @id_actividad_extra = 1,
    @dni_socio = 44555666,
    @dni_invitado = 11123123,
    @tipo_actividad = 9, -- Tipo de actividad no existente
    @fecha = '2025-06-01',
    @fecha_reserva = '2025-05-20',
    @monto = 1200,
    @monto_invitado = 600,
    @lluvia = 0
GO

--TEST 2.5: ACTUALIZACION CON FECHA RESERVA ANTERIOR A LA FECHA DE ACTIVIDAD
EXEC spActualizacion.ActualizarActividadExtra
    @id_actividad_extra = 1,
    @dni_socio = 44555666,
    @dni_invitado = 11123123,
    @tipo_actividad = 1,
    @fecha = '2025-06-01',
    @fecha_reserva = '2025-06-20', -- Fecha de reserva anterior a la fecha de actividad
    @monto = 1200,
    @monto_invitado = 600,
    @lluvia = 0
GO

--TEST 2.6: ACTUALIZACION CON MONTO NEGATIVO
EXEC spActualizacion.ActualizarActividadExtra
    @id_actividad_extra = 1,
    @dni_socio = 44555666,
    @dni_invitado = 11123123,
    @tipo_actividad = 1,
    @fecha = '2025-06-01',
    @fecha_reserva = '2025-05-20',
    @monto = -1200, -- Monto negativo
    @monto_invitado = 600,
    @lluvia = 0
GO

--Facturas ARCA

USE Com2900G07
GO

--Agregamos un socio  para testear
EXEC spInsercion.CrearPrestadorSalud
    @nombre = 'Galeno_test_factura',
    @telefono = '46254016',
    @nro = 'TEST_1234'

DECLARE @id_prestador_salud_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM tabla.PrestadoresSalud
WHERE nombre = 'Galeno_test_factura';

EXEC spInsercion.CrearSocio
    @dni = 22333444,
    @nro_socio = 9976,
    @nombre = 'Socio',
    @apellido = 'Prueba Factura',
    @email = 'socio_prueba_factura@sol.com',
    @fecha_nacimiento = '2002-11-26',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @id_prestador_salud = @id_prestador_salud_test
GO

--INSERCION

--TEST 1.1: INSERCION DE UNA FACTURA CORRECTA
EXEC spInsercion.CrearFacturaARCA
    @dni = 22333444,
    @descripcion = 'Factura de prueba',
    @total = 10000,
    @tipo = 'A',
    @primer_vencimiento = '2025-10-15',
    @segundo_vencimiento = '2025-10-30',
    @recargo = 5
GO

--TEST 1.2: INSERCION DE UNA FACTURA CON DNI NO EXISTENTE
EXEC spInsercion.CrearFacturaARCA
    @dni = 99999999,
    @descripcion = 'Factura de prueba',
    @total = 10000,
    @tipo = 'A',
    @primer_vencimiento = '2025-10-15',
    @segundo_vencimiento = '2025-10-30',
    @recargo = 5
GO

--TEST 1.3: INSERCION DE UNA FACTURA CON IMPORTE NEGATIVO
EXEC spInsercion.CrearFacturaARCA
    @dni = 22333444,
    @descripcion = 'Factura de prueba',
    @total = -10000,
    @tipo = 'A',
	@primer_vencimiento = '2025-10-15',
    @segundo_vencimiento = '2025-10-30',
    @recargo = 5
GO

--TEST 1.4: INSERCION DE UNA FACTURA CON TIPO NO V�LIDO
EXEC spInsercion.CrearFacturaARCA
    @dni = 22333444,
    @descripcion = 'Factura de prueba',
    @total = 10000,
    @tipo = 'X', -- Tipo no v�lido
	@primer_vencimiento = '2025-10-15',
    @segundo_vencimiento = '2025-10-30',
    @recargo = 5
GO

--TEST 1.5: INSERCION DE UNA FACTURA CON RECARGO NEGATIVO
EXEC spInsercion.CrearFacturaARCA
    @dni = 22333444,
    @descripcion = 'Factura de prueba',
    @total = 10000,
	@primer_vencimiento = '2025-10-15',
    @segundo_vencimiento = '2025-10-30',
    @tipo = 'A',
    @recargo = -5 -- Recargo negativo
GO

--Cargos socio

USE Com2900G07
GO

--Agregamos un socio, cuota, deporte, actividad extra y factura para testear
EXEC spInsercion.CrearPrestadorSalud
    @nombre = 'Galeno_test_cargo_socio',
    @telefono = '46254016',
    @nro = 'TEST_1234'

DECLARE @id_prestador_salud_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM tabla.PrestadoresSalud
WHERE nombre = 'Galeno_test_cargo_socio';

EXEC spInsercion.CrearSocio
    @dni = 11555999,
    @nro_socio = 9975,
    @nombre = 'Socio',
    @apellido = 'Prueba Cargo Socio',
    @email = 'socio_prueba_cs@sol.com',
    @fecha_nacimiento = '2002-11-26',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @id_prestador_salud = @id_prestador_salud_test

EXEC spInsercion.CrearCategoria
    @nombre_categoria = 'Adulto_test',
    @edad_min = 18,
    @edad_max = 60,
    @precio_mensual = 5000

DECLARE @id_categoria_test INT

SELECT @id_categoria_test = id_categoria
FROM tabla.Categorias
WHERE nombre_categoria = 'Adulto_test'

EXEC spInsercion.CrearCuota
    @dni = 11555999,
    @id_categoria = @id_categoria_test

EXEC spInsercion.CrearDeporte
    @nombre = 'Futbol_test_cargo_socio',
    @precio = 1000

DECLARE @id_deporte_test INT

SELECT @id_deporte_test = id_deporte
FROM tabla.Deportes
WHERE nombre = 'Futbol_test_cargo_socio'

EXEC spInsercion.CrearActividad
    @dni = 11555999,
    @id_deporte = @id_deporte_test

EXEC spInsercion.CrearActividadExtra
    @dni = 11555999,
    @dni_invitado = NULL,
    @tipo_actividad = 1,
    @fecha = '2025-06-01',
    @fecha_reserva = '2025-05-20',
    @monto = 1000,
    @monto_invitado = NULL,
    @lluvia = NULL

EXEC spInsercion.CrearFacturaARCA
    @dni = 11555999,
    @descripcion = 'Factura de prueba cargo socio',
    @total = 10000,
    @tipo = 'A',
    @primer_vencimiento = '2025-10-15',
    @segundo_vencimiento = '2025-10-30',
    @recargo = 5

GO


--INSERCION

--TEST 1.1: Creacion correcta de un cargo de cuota
DECLARE @numero_factura_test INT;
DECLARE @id_cuota_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11555999) AND descripcion = 'Factura de prueba cargo socio'

SELECT @id_cuota_test = id_cuota
FROM tabla.Cuotas
WHERE id_socio = fnBusqueda.BuscarSocio(11555999)

EXEC spInsercion.CrearCargoSocio
	@numero_factura = @numero_factura_test,
	@fecha_creacion = '2025-06-30 09:05:56',
	@descripcion = 'Cargo de prueba sobre cuota',
	@monto_descuento = 100,
	@monto_total = 1000,
	@id_deporte = NULL,
	@id_actividad_extra = NULL,
	@id_cuota = @id_cuota_test
GO

--TEST 1.2: Creacion correcta de un cargo de deporte
DECLARE @numero_factura_test INT;
DECLARE @id_deporte_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11555999) AND descripcion = 'Factura de prueba cargo socio'

SELECT @id_deporte_test = d.id_deporte
FROM tabla.Deportes d
INNER JOIN tabla.Actividades a ON a.id_deporte = d.id_deporte
WHERE a.id_socio = fnBusqueda.BuscarSocio(11555999)

EXEC spInsercion.CrearCargoSocio
	@numero_factura = @numero_factura_test,
	@fecha_creacion = '2025-06-30 10:05:56',
	@descripcion = 'Cargo de prueba sobre cuota',
	@monto_descuento = 100,
	@monto_total = 1000,
	@id_deporte = @id_deporte_test,
	@id_actividad_extra = NULL,
	@id_cuota = NULL
GO

--TEST 1.3: Creacion correcta de un cargo de actividad extra
DECLARE @numero_factura_test INT;
DECLARE @id_actividad_extra_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11555999) AND descripcion = 'Factura de prueba cargo socio'

SELECT @id_actividad_extra_test = id_actividad_extra
FROM tabla.ActividadesExtra 
WHERE id_socio = fnBusqueda.BuscarSocio(11555999)

EXEC spInsercion.CrearCargoSocio
	@numero_factura = @numero_factura_test,
	@fecha_creacion = '2025-06-30 10:05:56',
	@descripcion = 'Cargo de prueba sobre cuota',
	@monto_descuento = 100,
	@monto_total = 1000,
	@id_deporte = NULL,
	@id_actividad_extra = @id_actividad_extra_test,
	@id_cuota = NULL
GO

--TEST 1.4: Factura inexistente
EXEC spInsercion.CrearCargoSocio
	@numero_factura = 99999,
	@fecha_creacion = '2025-06-30 10:05:56',
	@descripcion = 'Cargo de prueba sobre cuota',
	@monto_descuento = 100,
	@monto_total = 1000,
	@id_deporte = NULL,
	@id_actividad_extra = 1,
	@id_cuota = NULL
GO

--TEST 1.5: Fecha de creacion posterior a fecha actual
DECLARE @numero_factura_test INT;

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11555999) AND descripcion = 'Factura de prueba cargo socio'

EXEC spInsercion.CrearCargoSocio
	@numero_factura = @numero_factura_test,
	@fecha_creacion = '2026-06-30 10:05:56',
	@descripcion = 'Cargo de prueba sobre cuota',
	@monto_descuento = 100,
	@monto_total = 1000,
	@id_deporte = NULL,
	@id_actividad_extra = 1,
	@id_cuota = NULL
GO

--TEST 1.6: Cargo sin monto
DECLARE @numero_factura_test INT;

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11555999) AND descripcion = 'Factura de prueba cargo socio'

EXEC spInsercion.CrearCargoSocio
	@numero_factura = @numero_factura_test,
	@fecha_creacion = '2025-06-30 10:05:56',
	@descripcion = 'Cargo de prueba sobre cuota',
	@monto_descuento = 0,
	@monto_total = 0,
	@id_deporte = NULL,
	@id_actividad_extra = 1,
	@id_cuota = NULL
GO

--TEST 1.7: Cargo con dos actividades relacionadas
DECLARE @numero_factura_test INT;

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11555999) AND descripcion = 'Factura de prueba cargo socio'

EXEC spInsercion.CrearCargoSocio
	@numero_factura = @numero_factura_test,
	@fecha_creacion = '2025-06-30 10:05:56',
	@descripcion = 'Cargo de prueba sobre cuota',
	@monto_descuento = 0,
	@monto_total = 0,
	@id_deporte = 1,
	@id_actividad_extra = 1,
	@id_cuota = NULL
GO

--ACTUALIZACION

--TEST 2.1: Actualizacion correcta
DECLARE @numero_factura_test INT;
DECLARE @id_deporte_test INT
DECLARE @id_cargo_socio_test INT
DECLARE @id_cuota_test INT

SELECT @id_cuota_test = id_cuota
FROM tabla.Cuotas
WHERE id_socio = fnBusqueda.BuscarSocio(11555999)

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11555999) AND descripcion = 'Factura de prueba cargo socio'

SELECT @id_deporte_test = d.id_deporte
FROM tabla.Deportes d
INNER JOIN tabla.Actividades a ON a.id_deporte = d.id_deporte
WHERE a.id_socio = fnBusqueda.BuscarSocio(11555999)

SELECT @id_cargo_socio_test = id_cargo_socio
FROM tabla.CargosSocio
WHERE numero_factura = @numero_factura_test AND id_cuota = @id_cuota_test
	
SELECT * FROM tabla.CargosSocio WHERE id_cargo_socio = @id_cargo_socio_test
EXEC spActualizacion.ActualizarCargoSocio
	@id_cargo_socio = @id_cargo_socio_test,
	@numero_factura = @numero_factura_test,
	@fecha_creacion = '2025-06-30 10:05:56',
	@descripcion = 'Cargo de prueba sobre cuota',
	@monto_descuento = 100,
	@monto_total = 1000,
	@id_deporte = @id_deporte_test,
	@id_actividad_extra = NULL,
	@id_cuota = NULL
SELECT * FROM tabla.CargosSocio WHERE id_cargo_socio = @id_cargo_socio_test
GO

-- Morosidades

USE Com2900G07
GO

--Agregamos una factura para testear
EXEC spInsercion.CrearPrestadorSalud
    @nombre = 'Galeno_test_morosidad',
    @telefono = '46254016',
    @nro = 'TEST_1234'

DECLARE @id_prestador_salud_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM tabla.PrestadoresSalud
WHERE nombre = 'Galeno_test_morosidad';

EXEC spInsercion.CrearSocio
    @dni = 33444555,
    @nro_socio = 9974,
    @nombre = 'Socio',
    @apellido = 'Prueba Morosidad',
    @email = 'socio_prueba_morosidad@sol.com',
    @fecha_nacimiento = '2002-11-26',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @id_prestador_salud = @id_prestador_salud_test
GO

EXEC spInsercion.CrearFacturaARCA
    @dni = 33444555,
    @descripcion = 'Factura de prueba morosidad',
    @total = 10000,
    @tipo = 'A',
    @primer_vencimiento = '2025-05-15',
    @segundo_vencimiento = '2025-05-30',
    @recargo = 5
GO

--INSERCION

-- TEST 1.1: Creacion correcta
DECLARE @numero_factura_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(33444555) AND descripcion = 'Factura de prueba morosidad'

EXEC spInsercion.CrearMorosidad
	@numero_factura = @numero_factura_test,
	@monto_total = 1000,
	@fecha_pago = NULL
SELECT * FROM tabla.Morosidades
GO

--TEST 1.2: Factura invalida
EXEC spInsercion.CrearMorosidad
	@numero_factura = 99999,
	@monto_total = 1000,
	@fecha_pago = NULL
GO

--TEST 1.3: Morosidad sin monto
DECLARE @numero_factura_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(33444555) AND descripcion = 'Factura de prueba morosidad'

EXEC spInsercion.CrearMorosidad
	@numero_factura = @numero_factura_test,
	@monto_total = 0,
	@fecha_pago = NULL
GO

--ACTUALIZACION

--TEST 2.1: Actualizar correctamente
DECLARE @numero_factura_test INT
DECLARE @id_morosidad_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(33444555) AND descripcion = 'Factura de prueba morosidad'

SELECT @id_morosidad_test = id_morosidad
FROM tabla.Morosidades
WHERE numero_factura = @numero_factura_test

SELECT * FROM tabla.Morosidades
EXEC spActualizacion.ActualizarMorosidad
	@id_morosidad = @id_morosidad_test,
	@numero_factura = @numero_factura_test,
	@monto_total = 1000,
	@fecha_pago = '2025-06-30 15:40:13'
SELECT * FROM tabla.Morosidades
GO

--TEST 2.2: ID morosidad inexistente
DECLARE @numero_factura_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(33444555) AND descripcion = 'Factura de prueba morosidad'

EXEC spActualizacion.ActualizarMorosidad
	@id_morosidad = 99999,
	@numero_factura = @numero_factura_test,
	@monto_total = 1000,
	@fecha_pago = '2025-06-30 15:40:13'
GO

--TEST 2.3: Numero factura inexistente
DECLARE @numero_factura_test INT
DECLARE @id_morosidad_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(33444555) AND descripcion = 'Factura de prueba morosidad'

SELECT @id_morosidad_test = id_morosidad
FROM tabla.Morosidades
WHERE numero_factura = @numero_factura_test

EXEC spActualizacion.ActualizarMorosidad
	@id_morosidad = @id_morosidad_test,
	@numero_factura = 99999,
	@monto_total = 1000,
	@fecha_pago = '2025-06-30 15:40:13'
GO

--ELIMINACION

--TEST 3.1: Eliminacion correcta
DECLARE @numero_factura_test INT
DECLARE @id_morosidad_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(33444555) AND descripcion = 'Factura de prueba morosidad'

SELECT @id_morosidad_test = id_morosidad
FROM tabla.Morosidades
WHERE numero_factura = @numero_factura_test

EXEC spEliminacion.EliminarMorosidad
	@id_morosidad = @id_morosidad_test

--TEST 3.2: ID morosidad inexistente
EXEC spEliminacion.EliminarMorosidad
	@id_morosidad = 99999


--Cuentas socio

USE Com2900G07
GO

--Agregamos un socio para testear
EXEC spInsercion.CrearPrestadorSalud
    @nombre = 'Galeno_test_cuenta_cosio',
    @telefono = '46254016',
    @nro = 'TEST_1234'

DECLARE @id_prestador_salud_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM tabla.PrestadoresSalud
WHERE nombre = 'Galeno_test_cuenta_cosio';

EXEC spInsercion.CrearSocio
    @dni = 11777888,
    @nro_socio = 9973,
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

--TEST 1.3: Contrase�a vacia
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

--TEST 1.6: Fecha vigencia de contrase�a invalida
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

--TEST 2.3: Contrase�a vacia
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

--TEST 2.6: Fecha de vigencia de contrase�a invalida
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

--Pagos

USE Com2900G07
GO

--Agregamos un usuario, factura y medio de pago para testear
EXEC spInsercion.CrearPrestadorSalud
    @nombre = 'Galeno_test_pago',
    @telefono = '46254016',
    @nro = 'TEST_1234'

DECLARE @id_prestador_salud_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM tabla.PrestadoresSalud
WHERE nombre = 'Galeno_test_pago';

EXEC spInsercion.CrearSocio
    @dni = 11333555,
    @nro_socio = 9972,
    @nombre = 'Socio',
    @apellido = 'Prueba Pago',
    @email = 'socio_prueba_pago@sol.com',
    @fecha_nacimiento = '2002-11-26',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @id_prestador_salud = @id_prestador_salud_test

EXEC spInsercion.CrearFacturaARCA
    @dni = 11333555,
    @descripcion = 'Factura de prueba de pago',
    @total = 10000,
    @tipo = 'A',
    @primer_vencimiento = '2025-10-15',
    @segundo_vencimiento = '2025-10-30',
    @recargo = 5


EXEC spInsercion.CrearMedioPago
    @Nombre = 'Tarjeta de Cr�dito',
    @Descripcion = 'Pago con tarjeta de cr�dito'
GO

--INSERCION

--TEST 1.1: Insercion correcta
DECLARE @numero_factura_test INT
DECLARE @id_medio_pago_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11333555) AND descripcion = 'Factura de prueba de pago'

SELECT @id_medio_pago_test = id_medio_pago
FROM tabla.MediosPago
WHERE nombre = 'Tarjeta de Cr�dito'

SELECT * FROM tabla.Pagos
EXEC spInsercion.CrearPago
	@numero_factura = @numero_factura_test,
	@id_medio_pago = @id_medio_pago_test,
	@fecha = '2025-06-30 16:45:29',
	@total = 1000,
	@reembolso = 100
SELECT * FROM tabla.Pagos
GO

--TEST 1.2: Factura inexistente
DECLARE @id_medio_pago_test INT

SELECT @id_medio_pago_test = id_medio_pago
FROM tabla.MediosPago
WHERE nombre = 'Tarjeta de Cr�dito'

EXEC spInsercion.CrearPago
	@numero_factura = 99999,
	@id_medio_pago = @id_medio_pago_test,
	@fecha = '2025-06-30 16:45:29',
	@total = 1000,
	@reembolso = 100
GO

--TEST 1.3: Medio de apgo inexistente
DECLARE @numero_factura_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11333555) AND descripcion = 'Factura de prueba de pago'

EXEC spInsercion.CrearPago
	@numero_factura = @numero_factura_test,
	@id_medio_pago = 99999,
	@fecha = '2025-06-30 16:45:29',
	@total = 1000,
	@reembolso = 100
GO

--TEST 1.4: Fecha invalida
DECLARE @numero_factura_test INT
DECLARE @id_medio_pago_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11333555) AND descripcion = 'Factura de prueba de pago'

SELECT @id_medio_pago_test = id_medio_pago
FROM tabla.MediosPago
WHERE nombre = 'Tarjeta de Cr�dito'

EXEC spInsercion.CrearPago
	@numero_factura = @numero_factura_test,
	@id_medio_pago = @id_medio_pago_test,
	@fecha = '2026-06-30 16:45:29',
	@total = 1000,
	@reembolso = 100
GO

--TEST 1.5: Monto invalido
DECLARE @numero_factura_test INT
DECLARE @id_medio_pago_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11333555) AND descripcion = 'Factura de prueba de pago'

SELECT @id_medio_pago_test = id_medio_pago
FROM tabla.MediosPago
WHERE nombre = 'Tarjeta de Cr�dito'

EXEC spInsercion.CrearPago
	@numero_factura = @numero_factura_test,
	@id_medio_pago = @id_medio_pago_test,
	@fecha = '2025-06-30 16:45:29',
	@total = 0,
	@reembolso = 0
GO

--ACTUALIZACION

--TEST 2.1: Actualizacion correcta
DECLARE @numero_factura_test INT
DECLARE @id_medio_pago_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11333555) AND descripcion = 'Factura de prueba de pago'

SELECT @id_medio_pago_test = id_medio_pago
FROM tabla.MediosPago
WHERE nombre = 'Tarjeta de Cr�dito'

SELECT * FROM tabla.Pagos
EXEC spActualizacion.ActualizarPago
	@numero_factura = @numero_factura_test,
	@id_medio_pago = @id_medio_pago_test,
	@fecha = '2025-06-30 16:45:29',
	@total = 1500,
	@reembolso = 150
SELECT * FROM tabla.Pagos
GO

--TEST 2.2: Factura inexistente
DECLARE @id_medio_pago_test INT

SELECT @id_medio_pago_test = id_medio_pago
FROM tabla.MediosPago
WHERE nombre = 'Tarjeta de Cr�dito'

EXEC spActualizacion.ActualizarPago
	@numero_factura = 99999,
	@id_medio_pago = @id_medio_pago_test,
	@fecha = '2025-06-30 16:45:29',
	@total = 1000,
	@reembolso = 100
GO

--TEST 2.3: Medio de pago inexistente
DECLARE @numero_factura_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11333555) AND descripcion = 'Factura de prueba de pago'

EXEC spActualizacion.ActualizarPago
	@numero_factura = @numero_factura_test,
	@id_medio_pago = 99999,
	@fecha = '2025-06-30 16:45:29',
	@total = 1000,
	@reembolso = 100
GO

--TEST 2.4: Fecha invalida
DECLARE @numero_factura_test INT
DECLARE @id_medio_pago_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11333555) AND descripcion = 'Factura de prueba de pago'

SELECT @id_medio_pago_test = id_medio_pago
FROM tabla.MediosPago
WHERE nombre = 'Tarjeta de Cr�dito'

EXEC spActualizacion.ActualizarPago
	@numero_factura = @numero_factura_test,
	@id_medio_pago = @id_medio_pago_test,
	@fecha = '2026-06-30 16:45:29',
	@total = 1000,
	@reembolso = 100
GO

--TEST 2.5: Monto invalido
DECLARE @numero_factura_test INT
DECLARE @id_medio_pago_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11333555) AND descripcion = 'Factura de prueba de pago'

SELECT @id_medio_pago_test = id_medio_pago
FROM tabla.MediosPago
WHERE nombre = 'Tarjeta de Cr�dito'

EXEC spActualizacion.ActualizarPago
	@numero_factura = @numero_factura_test,
	@id_medio_pago = @id_medio_pago_test,
	@fecha = '2025-06-30 16:45:29',
	@total = 0,
	@reembolso = 0
GO


--Reembolsos

USE Com2900G07
GO

--Agregamos un socio, cuenta, factura, medio de pago, pago y administrador para testear
EXEC spInsercion.CrearPrestadorSalud
    @nombre = 'Galeno_test_reembolso',
    @telefono = '46254016',
    @nro = 'TEST_1234'

DECLARE @id_prestador_salud_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM tabla.PrestadoresSalud
WHERE nombre = 'Galeno_test_reembolso';

EXEC spInsercion.CrearSocio
    @dni = 11444666,
    @nro_socio = 9971,
    @nombre = 'Socio',
    @apellido = 'Prueba Reembolso',
    @email = 'socio_prueba_reembolso@sol.com',
    @fecha_nacimiento = '2002-11-26',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @id_prestador_salud = @id_prestador_salud_test

EXEC spInsercion.CrearFacturaARCA
    @dni = 11444666,
    @descripcion = 'Factura de prueba de reembolso',
    @total = 10000,
    @tipo = 'A',
    @primer_vencimiento = '2025-10-15',
    @segundo_vencimiento = '2025-10-30',
    @recargo = 5


EXEC spInsercion.CrearMedioPago
    @Nombre = 'Tarjeta de Cr�dito',
    @Descripcion = 'Pago con tarjeta de cr�dito'

DECLARE @numero_factura_test INT
DECLARE @id_medio_pago_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11444666) AND descripcion = 'Factura de prueba de reembolso'

SELECT @id_medio_pago_test = id_medio_pago
FROM tabla.MediosPago
WHERE nombre = 'Tarjeta de Cr�dito'

EXEC spInsercion.CrearPago
	@numero_factura = @numero_factura_test,
	@id_medio_pago = @id_medio_pago_test,
	@fecha = '2025-06-30 16:45:29',
	@total = 1000,
	@reembolso = 100

EXEC spInsercion.CrearCuentaSocio
	@dni = 11444666,
	@contrasena = '12345$a',
	@usuario = 'socioPruebaReembolso',
	@rol = 1,
	@saldo = 0,
	@fecha_vigencia_contrasena = '2026-06-30 23:59:59',
	@estado_cuenta = 1

EXEC spInsercion.CrearAdministrador
    @nombre = 'Prueba',
    @apellido = 'Reembolso',
    @dni = 22444666,
    @email = 'pruba_reembolso@sol.com',
    @rol = 2
GO

--INSERCION

--TEST 1.1: Insercion correcta
DECLARE @id_pago_test INT
DECLARE @numero_factura_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11444666) AND descripcion = 'Factura de prueba de reembolso'

SELECT @id_pago_test = id_pago
FROM tabla.Pagos
WHERE numero_factura = @numero_factura_test

SELECT * FROM tabla.Reembolsos
EXEC spInsercion.CrearReembolso
	@id_pago = @id_pago_test,
	@dni_socio = 11444666,
	@dni_admin = 22444666,
	@motivo = 'Porque si',
	@fecha = '2025-06-30 17:32:45',
	@monto = 150
SELECT * FROM tabla.Reembolsos
GO

--TEST 1.2: ID pago invalido
EXEC spInsercion.CrearReembolso
	@id_pago = 99999,
	@dni_socio = 11444666,
	@dni_admin = 22444666,
	@motivo = 'Porque si',
	@fecha = '2025-06-30 17:32:45',
	@monto = 150

--TEST 1.3: DNI socio incorrecto
DECLARE @id_pago_test INT
DECLARE @numero_factura_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11444666) AND descripcion = 'Factura de prueba de reembolso'

SELECT @id_pago_test = id_pago
FROM tabla.Pagos
WHERE numero_factura = @numero_factura_test

EXEC spInsercion.CrearReembolso
	@id_pago = @id_pago_test,
	@dni_socio = 9999999,
	@dni_admin = 22444666,
	@motivo = 'Porque si',
	@fecha = '2025-06-30 17:32:45',
	@monto = 150
GO

--TEST 1.4: DNI administrador incorrecto
DECLARE @id_pago_test INT
DECLARE @numero_factura_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11444666) AND descripcion = 'Factura de prueba de reembolso'

SELECT @id_pago_test = id_pago
FROM tabla.Pagos
WHERE numero_factura = @numero_factura_test

EXEC spInsercion.CrearReembolso
	@id_pago = @id_pago_test,
	@dni_socio = 11444666,
	@dni_admin = 99999999,
	@motivo = 'Porque si',
	@fecha = '2025-06-30 17:32:45',
	@monto = 150
GO

--TEST 1.5: Fecha invalida
DECLARE @id_pago_test INT
DECLARE @numero_factura_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11444666) AND descripcion = 'Factura de prueba de reembolso'

SELECT @id_pago_test = id_pago
FROM tabla.Pagos
WHERE numero_factura = @numero_factura_test

EXEC spInsercion.CrearReembolso
	@id_pago = @id_pago_test,
	@dni_socio = 11444666,
	@dni_admin = 22444666,
	@motivo = 'Porque si',
	@fecha = '2026-06-30 17:32:45',
	@monto = 150
GO

--TEST 1.6: Monto invalido
DECLARE @id_pago_test INT
DECLARE @numero_factura_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11444666) AND descripcion = 'Factura de prueba de reembolso'

SELECT @id_pago_test = id_pago
FROM tabla.Pagos
WHERE numero_factura = @numero_factura_test

EXEC spInsercion.CrearReembolso
	@id_pago = @id_pago_test,
	@dni_socio = 11444666,
	@dni_admin = 22444666,
	@motivo = 'Porque si',
	@fecha = '2025-06-30 17:32:45',
	@monto = 0
GO

--ACTUALIZACION

--TEST 2.1: Actualizacion correcta
DECLARE @id_pago_test INT
DECLARE @numero_factura_test INT
DECLARE @id_reembolso_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11444666) AND descripcion = 'Factura de prueba de reembolso'

SELECT @id_pago_test = id_pago
FROM tabla.Pagos
WHERE numero_factura = @numero_factura_test

SELECT @id_reembolso_test = id_reembolso
FROM tabla.Reembolsos
WHERE id_pago = @id_pago_test

SELECT * FROM tabla.Reembolsos
EXEC spActualizacion.ActualizarReembolso
	@id_reembolso = @id_reembolso_test,
	@id_pago = @id_pago_test,
	@dni_socio = 11444666,
	@dni_admin = 22444666,
	@motivo = 'Porque si y listo',
	@fecha = '2025-06-30 17:32:45',
	@monto = 200
SELECT * FROM tabla.Reembolsos
GO

--TEST 2.2: ID reembolso invalido
DECLARE @id_pago_test INT
DECLARE @numero_factura_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11444666) AND descripcion = 'Factura de prueba de reembolso'

SELECT @id_pago_test = id_pago
FROM tabla.Pagos
WHERE numero_factura = @numero_factura_test


EXEC spActualizacion.ActualizarReembolso
	@id_reembolso = 99999,
	@id_pago = @id_pago_test,
	@dni_socio = 11444666,
	@dni_admin = 22444666,
	@motivo = 'Porque si y listo',
	@fecha = '2025-06-30 17:32:45',
	@monto = 200
GO

--TEST 2.3: ID pago invalido
DECLARE @id_pago_test INT
DECLARE @numero_factura_test INT
DECLARE @id_reembolso_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11444666) AND descripcion = 'Factura de prueba de reembolso'

SELECT @id_pago_test = id_pago
FROM tabla.Pagos
WHERE numero_factura = @numero_factura_test

SELECT @id_reembolso_test = id_reembolso
FROM tabla.Reembolsos
WHERE id_pago = @id_pago_test

EXEC spActualizacion.ActualizarReembolso
	@id_reembolso = @id_reembolso_test,
	@id_pago = 9999,
	@dni_socio = 11444666,
	@dni_admin = 22444666,
	@motivo = 'Porque si y listo',
	@fecha = '2025-06-30 17:32:45',
	@monto = 200
GO

--TEST 2.4: DNI socio invalido
DECLARE @id_pago_test INT
DECLARE @numero_factura_test INT
DECLARE @id_reembolso_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11444666) AND descripcion = 'Factura de prueba de reembolso'

SELECT @id_pago_test = id_pago
FROM tabla.Pagos
WHERE numero_factura = @numero_factura_test

SELECT @id_reembolso_test = id_reembolso
FROM tabla.Reembolsos
WHERE id_pago = @id_pago_test

EXEC spActualizacion.ActualizarReembolso
	@id_reembolso = @id_reembolso_test,
	@id_pago = @id_pago_test,
	@dni_socio = 99999999,
	@dni_admin = 22444666,
	@motivo = 'Porque si y listo',
	@fecha = '2025-06-30 17:32:45',
	@monto = 200
GO

--TEST 2.5: DNI administrador invalido
DECLARE @id_pago_test INT
DECLARE @numero_factura_test INT
DECLARE @id_reembolso_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11444666) AND descripcion = 'Factura de prueba de reembolso'

SELECT @id_pago_test = id_pago
FROM tabla.Pagos
WHERE numero_factura = @numero_factura_test

SELECT @id_reembolso_test = id_reembolso
FROM tabla.Reembolsos
WHERE id_pago = @id_pago_test

EXEC spActualizacion.ActualizarReembolso
	@id_reembolso = @id_reembolso_test,
	@id_pago = @id_pago_test,
	@dni_socio = 11444666,
	@dni_admin = 99999999,
	@motivo = 'Porque si y listo',
	@fecha = '2025-06-30 17:32:45',
	@monto = 200
GO

--TEST 2.6: Fecha invalida
DECLARE @id_pago_test INT
DECLARE @numero_factura_test INT
DECLARE @id_reembolso_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11444666) AND descripcion = 'Factura de prueba de reembolso'

SELECT @id_pago_test = id_pago
FROM tabla.Pagos
WHERE numero_factura = @numero_factura_test

SELECT @id_reembolso_test = id_reembolso
FROM tabla.Reembolsos
WHERE id_pago = @id_pago_test

EXEC spActualizacion.ActualizarReembolso
	@id_reembolso = @id_reembolso_test,
	@id_pago = @id_pago_test,
	@dni_socio = 11444666,
	@dni_admin = 22444666,
	@motivo = 'Porque si y listo',
	@fecha = '2026-06-30 17:32:45',
	@monto = 200
GO

--TEST 2.7: Monto invalido
DECLARE @id_pago_test INT
DECLARE @numero_factura_test INT
DECLARE @id_reembolso_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11444666) AND descripcion = 'Factura de prueba de reembolso'

SELECT @id_pago_test = id_pago
FROM tabla.Pagos
WHERE numero_factura = @numero_factura_test

SELECT @id_reembolso_test = id_reembolso
FROM tabla.Reembolsos
WHERE id_pago = @id_pago_test

EXEC spActualizacion.ActualizarReembolso
	@id_reembolso = @id_reembolso_test,
	@id_pago = @id_pago_test,
	@dni_socio = 11444666,
	@dni_admin = 22444666,
	@motivo = 'Porque si y listo',
	@fecha = '2025-06-30 17:32:45',
	@monto = 0
GO

--ELIMINACION

--TEST 3.1: Eliminacion correcta
DECLARE @id_pago_test INT
DECLARE @numero_factura_test INT
DECLARE @id_reembolso_test INT

SELECT @numero_factura_test = numero_factura
FROM tabla.FacturasARCA
WHERE id_socio = fnBusqueda.BuscarSocio(11444666) AND descripcion = 'Factura de prueba de reembolso'

SELECT @id_pago_test = id_pago
FROM tabla.Pagos
WHERE numero_factura = @numero_factura_test

SELECT @id_reembolso_test = id_reembolso
FROM tabla.Reembolsos
WHERE id_pago = @id_pago_test

SELECT * FROM tabla.Reembolsos
EXEC spEliminacion.EliminarReembolso
	@id_reembolso = @id_reembolso_test
SELECT * FROM tabla.Reembolsos
GO

--TEST 3.2: ID reembolso invalido
EXEC spEliminacion.EliminarReembolso
	@id_reembolso = 99999


--Asistencias clases

USE Com2900G07
GO

--Agregamos un socio y clase para testear
EXEC spInsercion.CrearDeporte
    @nombre = 'Futbol_test_asistencia',
    @precio = 1000

DECLARE @id_deporte_test INT;

SELECT @id_deporte_test = id_deporte
FROM tabla.Deportes
WHERE nombre = 'Futbol_test_asistencia';

EXEC spInsercion.CrearClase
    @id_deporte = @id_deporte_test

EXEC spInsercion.CrearPrestadorSalud
    @nombre = 'Galeno_test_asistencia',
    @telefono = '46254016',
    @nro = 'TEST_1234'

DECLARE @id_prestador_salud_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM tabla.PrestadoresSalud
WHERE nombre = 'Galeno_test_asistencia';

EXEC spInsercion.CrearSocio
    @dni = 55666777,
    @nro_socio = 9970,
    @nombre = 'Socio',
    @apellido = 'Prueba Asistencia',
    @email = 'socio_prueba_asistencia@sol.com',
    @fecha_nacimiento = '2002-11-26',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @id_prestador_salud = @id_prestador_salud_test
GO

--INSERCION

--TEST 1.1: Insercion correcta
DECLARE @id_clase_test INT
DECLARE @id_deporte_test INT;

SELECT @id_deporte_test = id_deporte
FROM tabla.Deportes
WHERE nombre = 'Futbol_test_asistencia';

SELECT @id_clase_test = id_clase
FROM tabla.Clases
WHERE id_deporte = @id_deporte_test

SELECT * FROM tabla.AsistenciasClase
EXEC spInsercion.CrearAsistenciaClase
	@dni_socio = 55666777,
	@id_clase = @id_clase_test,
	@presente = 1,
	@fecha = '2025-06-10 17:00:00'
SELECT * FROM tabla.AsistenciasClase
GO

--TEST 1.2: DNI invalido
DECLARE @id_clase_test INT
DECLARE @id_deporte_test INT;

SELECT @id_deporte_test = id_deporte
FROM tabla.Deportes
WHERE nombre = 'Futbol_test_asistencia';

SELECT @id_clase_test = id_clase
FROM tabla.Clases
WHERE id_deporte = @id_deporte_test

EXEC spInsercion.CrearAsistenciaClase
	@dni_socio = 99999999,
	@id_clase = @id_clase_test,
	@presente = 1,
	@fecha = '2025-06-10 17:00:00'
GO

--TEST 1.3: ID clase invalido
DECLARE @id_clase_test INT
DECLARE @id_deporte_test INT;

SELECT @id_deporte_test = id_deporte
FROM tabla.Deportes
WHERE nombre = 'Futbol_test_asistencia';

SELECT @id_clase_test = id_clase
FROM tabla.Clases
WHERE id_deporte = @id_deporte_test

EXEC spInsercion.CrearAsistenciaClase
	@dni_socio = 55666777,
	@id_clase = 99999,
	@presente = 1,
	@fecha = '2025-06-10 17:00:00'
GO

--TEST 1.4: Fecha invalida
DECLARE @id_clase_test INT
DECLARE @id_deporte_test INT;

SELECT @id_deporte_test = id_deporte
FROM tabla.Deportes
WHERE nombre = 'Futbol_test_asistencia';

SELECT @id_clase_test = id_clase
FROM tabla.Clases
WHERE id_deporte = @id_deporte_test

EXEC spInsercion.CrearAsistenciaClase
	@dni_socio = 55666777,
	@id_clase = @id_clase_test,
	@presente = 1,
	@fecha = '2026-06-10 17:00:00'
GO

--ACTUALIZACION

--TEST 2.1: Actualizacion correcta
DECLARE @id_clase_test INT
DECLARE @id_deporte_test INT;
DECLARE @id_asistencia_test INT

SELECT @id_deporte_test = id_deporte
FROM tabla.Deportes
WHERE nombre = 'Futbol_test_asistencia';

SELECT @id_clase_test = id_clase
FROM tabla.Clases
WHERE id_deporte = @id_deporte_test

SELECT @id_asistencia_test = id_asistencia
FROM tabla.AsistenciasClase
WHERE id_clase = @id_clase_test AND id_socio = fnBusqueda.BuscarSocio(55666777) AND CAST(fecha AS DATE) = '2025-06-10'

SELECT * FROM tabla.AsistenciasClase WHERE id_asistencia = @id_asistencia_test
EXEC spActualizacion.ActualizarAsistenciaClase
	@id_asistencia = @id_asistencia_test,
	@dni_socio = 55666777,
	@id_clase = @id_clase_test,
	@presente = 0,
	@fecha = '2025-06-10 17:00:00'
SELECT * FROM tabla.AsistenciasClase WHERE id_asistencia = @id_asistencia_test
GO

--TEST 2.2: ID asistencia invalido
DECLARE @id_clase_test INT
DECLARE @id_deporte_test INT;
DECLARE @id_asistencia_test INT

SELECT @id_deporte_test = id_deporte
FROM tabla.Deportes
WHERE nombre = 'Futbol_test_asistencia';

SELECT @id_clase_test = id_clase
FROM tabla.Clases
WHERE id_deporte = @id_deporte_test

SELECT @id_asistencia_test = id_asistencia
FROM tabla.AsistenciasClase
WHERE id_clase = @id_clase_test AND id_socio = fnBusqueda.BuscarSocio(55666777) AND CAST(fecha AS DATE) = '2025-06-10'

EXEC spActualizacion.ActualizarAsistenciaClase
	@id_asistencia = 99999,
	@dni_socio = 55666777,
	@id_clase = @id_clase_test,
	@presente = 0,
	@fecha = '2025-06-10 17:00:00'
GO

--TEST 2.3: DNI socio invalido
DECLARE @id_clase_test INT
DECLARE @id_deporte_test INT;
DECLARE @id_asistencia_test INT

SELECT @id_deporte_test = id_deporte
FROM tabla.Deportes
WHERE nombre = 'Futbol_test_asistencia';

SELECT @id_clase_test = id_clase
FROM tabla.Clases
WHERE id_deporte = @id_deporte_test

SELECT @id_asistencia_test = id_asistencia
FROM tabla.AsistenciasClase
WHERE id_clase = @id_clase_test AND id_socio = fnBusqueda.BuscarSocio(55666777) AND CAST(fecha AS DATE) = '2025-06-10'

EXEC spActualizacion.ActualizarAsistenciaClase
	@id_asistencia = @id_asistencia_test,
	@dni_socio = 99999999,
	@id_clase = @id_clase_test,
	@presente = 0,
	@fecha = '2025-06-10 17:00:00'
GO

--TEST 2.4: ID clase invalido
DECLARE @id_clase_test INT
DECLARE @id_deporte_test INT;
DECLARE @id_asistencia_test INT

SELECT @id_deporte_test = id_deporte
FROM tabla.Deportes
WHERE nombre = 'Futbol_test_asistencia';

SELECT @id_clase_test = id_clase
FROM tabla.Clases
WHERE id_deporte = @id_deporte_test

SELECT @id_asistencia_test = id_asistencia
FROM tabla.AsistenciasClase
WHERE id_clase = @id_clase_test AND id_socio = fnBusqueda.BuscarSocio(55666777) AND CAST(fecha AS DATE) = '2025-06-10'

EXEC spActualizacion.ActualizarAsistenciaClase
	@id_asistencia = @id_asistencia_test,
	@dni_socio = 55666777,
	@id_clase = 99999,
	@presente = 0,
	@fecha = '2025-06-10 17:00:00'
GO

--TEST 2.5: Fecha invalida
DECLARE @id_clase_test INT
DECLARE @id_deporte_test INT;
DECLARE @id_asistencia_test INT

SELECT @id_deporte_test = id_deporte
FROM tabla.Deportes
WHERE nombre = 'Futbol_test_asistencia';

SELECT @id_clase_test = id_clase
FROM tabla.Clases
WHERE id_deporte = @id_deporte_test

SELECT @id_asistencia_test = id_asistencia
FROM tabla.AsistenciasClase
WHERE id_clase = @id_clase_test AND id_socio = fnBusqueda.BuscarSocio(55666777) AND CAST(fecha AS DATE) = '2025-06-10'

EXEC spActualizacion.ActualizarAsistenciaClase
	@id_asistencia = @id_asistencia_test,
	@dni_socio = 55666777,
	@id_clase = @id_clase_test,
	@presente = 0,
	@fecha = '2026-06-10 17:00:00'
GO

--ELIMINACION

--TEST 3.1:Eliminacion correcta
DECLARE @id_clase_test INT
DECLARE @id_deporte_test INT;
DECLARE @id_asistencia_test INT

SELECT @id_deporte_test = id_deporte
FROM tabla.Deportes
WHERE nombre = 'Futbol_test_asistencia';

SELECT @id_clase_test = id_clase
FROM tabla.Clases
WHERE id_deporte = @id_deporte_test

SELECT @id_asistencia_test = id_asistencia
FROM tabla.AsistenciasClase
WHERE id_clase = @id_clase_test AND id_socio = fnBusqueda.BuscarSocio(55666777) AND CAST(fecha AS DATE) = '2025-06-10'

SELECT * FROM tabla.AsistenciasClase WHERE id_asistencia = @id_asistencia_test
EXEC spEliminacion.EliminarAsistenciaClase
	@id_asistencia = @id_asistencia_test
SELECT * FROM tabla.AsistenciasClase WHERE id_asistencia = @id_asistencia_test
GO

--TEST 3.2: ID asistencia invalido
EXEC spEliminacion.EliminarAsistenciaClase
	@id_asistencia = 99999
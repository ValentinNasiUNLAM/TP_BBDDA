/*
Luego de decidirse por un motor de base de datos relacional, llegó el momento de generar la
base de datos. En esta oportunidad utilizarán SQL Server.
Deberá instalar el DMBS y documentar el proceso. No incluya capturas de pantalla. Detalle
las configuraciones aplicadas (ubicación de archivos, memoria asignada, seguridad, puertos,
etc.) en un documento como el que le entregaría al DBA.
Cree la base de datos, entidades y relaciones. Incluya restricciones y claves. Deberá entregar
un archivo .sql con el script completo de creación (debe funcionar si se lo ejecuta “tal cual” es
entregado en una sola ejecución). Incluya comentarios para indicar qué hace cada módulo
de código.
Genere store procedures para manejar la inserción, modificado, borrado (si corresponde,
también debe decidir si determinadas entidades solo admitirán borrado lógico) de cada tabla.
Los nombres de los store procedures NO deben comenzar con “SP”.
Algunas operaciones implicarán store procedures que involucran varias tablas, uso de
transacciones, etc. Puede que incluso realicen ciertas operaciones mediante varios SPs.
Asegúrense de que los comentarios que acompañen al código lo expliquen.
Genere esquemas para organizar de forma lógica los componentes del sistema y aplique esto
en la creación de objetos. NO use el esquema “dbo”.
Todos los SP creados deben estar acompañados de juegos de prueba. Se espera que
realicen validaciones básicas en los SP (p/e cantidad mayor a cero, CUIT válido, etc.) y que
en los juegos de prueba demuestren la correcta aplicación de las validaciones.
Las pruebas deben realizarse en un script separado, donde con comentarios se indique en
cada caso el resultado esperado
El archivo .sql con el script debe incluir comentarios donde consten este enunciado, la fecha
de entrega, número de grupo, nombre de la materia, nombres y DNI de los alumnos.
Entregar todo en un zip (observar las pautas para nomenclatura antes expuestas) mediante
la sección de prácticas de MIEL. Solo uno de los miembros del grupo debe hacer la entrega.

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
EXEC socios.CrearCategoria
    @nombre_categoria = 'Juvenil',
    @edad_min = 12,
    @edad_max = 17,
    @precio_mensual = 5000
GO
SELECT * FROM socios.Categorias WHERE nombre_categoria = 'Juvenil'
GO

--TEST 1.2: Edad Minima Invalida 
EXEC socios.CrearCategoria
    @nombre_categoria = 'Error_Edad',
    @edad_min = 20,
    @edad_max = 17,
    @precio_mensual = 5000
GO


--TEST 1.3: Precio Invalido
EXEC socios.CrearCategoria 
    @nombre_categoria = 'Error_Precio', 
    @edad_min = 12,
    @edad_max = 17,
    @precio_mensual = -1000
GO

--TEST 1.4: Nombre Categoria Vacio
EXEC socios.CrearCategoria
    @nombre_categoria = '',
    @edad_min = 12,
    @edad_max = 17,
    @precio_mensual = -1000
GO

--ACTUALIZACION

--TEST 2.1: Resultado esperado Juvenil, 10, 18, 2000 - Actualizacion de precio mensual
EXEC socios.ActualizarCategoria
    @id_categoria = 1,
    @nombre_categoria = 'Juvenil',
    @edad_min = 10,
    @edad_max = 18,
    @precio_mensual = 2000
GO
SELECT * FROM socios.Categorias WHERE id_categoria = 1
GO

--TEST 2.2: Error Actualizar Edad 
EXEC socios.ActualizarCategoria 
    @id_categoria = 1,
    @nombre_categoria = 'Juvenil',
    @edad_min = 20,
    @edad_max = 18,
    @precio_mensual = 2000
GO

--TEST 2.3: ERROR PRECIO MENSUAL INVALIDO 
EXEC socios.ActualizarCategoria
    @id_categoria = 1,
    @nombre_categoria = 'Juvenil',
    @edad_min = 12,
    @edad_max = 18,
    @precio_mensual = -3000
GO

--TEST 2.4: ERROR NOMBRE CATEGORIA VACIO 
EXEC socios.ActualizarCategoria
    @id_categoria = 1,
    @nombre_categoria = '',
    @edad_min = 12,
    @edad_max = 18,
    @precio_mensual = 2000
GO

--TEST 2.5: NO EXISTE ID CATEGORIA
EXEC socios.ActualizarCategoria
    @id_categoria = 99991,
    @nombre_categoria = 'Juvenil',
    @edad_min = 12,
    @edad_max = 18,
    @precio_mensual = 2000
GO

--ELIMINACION

--TEST 3.1: ELIMINACION EXITOSA
EXEC socios.EliminarCategoria
    @id_categoria = 1
GO
SELECT * FROM socios.Categorias WHERE id_categoria = 1

--TEST 3.2: ID CATEGORIA NO ENCONTRADO 
EXEC socios.EliminarCategoria 
    @id_categoria = 99991
GO

--Prestadores Salud

-- Se crean los TESTS para la insercion, actualizacion y eliminacion de Prestadores Salud

USE Com2900G07
GO

--INSERCION

--TEST 1.1: Resultado esperado, ID, 1, Galeno, 46254016
SELECT * FROM socios.PrestadoresSalud
EXEC socios.CrearPrestadorSalud
    @nombre = 'Galeno',
    @telefono = '46254016'
GO
SELECT * FROM socios.PrestadoresSalud WHERE nombre = 'Galeno'
GO

-- TEST 1.2: Error nombre vacio
EXEC socios.CrearPrestadorSalud
    @nombre = '',
    @telefono = '46254016'
GO

--ACTUALIZACION

--TEST 2.1: Resultado esperado ID, 2, IOMA, 1199998888
SELECT * FROM socios.PrestadoresSalud
EXEC socios.ActualizarPrestadorSalud
    @id_prestador_salud = 1,
    @nombre = 'IOMA',
    @telefono = '46254016'
GO
SELECT * FROM socios.PrestadoresSalud WHERE id_prestador_salud = 1
GO

--TEST 2.2: Error nombre vacio
EXEC socios.ActualizarPrestadorSalud
    @id_prestador_salud = 1,
    @nombre = '',
    @telefono = '46254016'
GO

--ELIMINACION

--TEST 3.1: Eliminacion Exitosa
SELECT * FROM socios.PrestadoresSalud WHERE id_prestador_salud = 1
EXEC socios.EliminarPrestadorSalud
    @id_prestador_salud = 1
GO
SELECT * FROM socios.PrestadoresSalud WHERE id_prestador_salud = 1
GO

--TEST 3.2: No existe ID
SELECT * FROM socios.PrestadoresSalud
EXEC socios.EliminarPrestadorSalud
    @id_prestador_salud = 99991
GO

--Administradores

-- Se crean los TESTS para la insercion, actualizacion y eliminacion de Administradores

USE Com2900G07
GO

--INSERCION

--TEST 1.1: Resultado esperado: ID, nombre, apellido, dni, email, 1, 1
SELECT * FROM administracion.Administradores
EXEC administracion.CrearAdministrador
    @nombre = 'Homero',
    @apellido = 'Simpson',
    @dni = 44555666,
    @email = 'hsimpson@sol.com',
    @rol = 2
GO
SELECT * FROM administracion.Administradores WHERE dni = 44555666
GO

--TEST 1.2: Error nombre y apellido vacio
EXEC administracion.CrearAdministrador
    @nombre = '',
    @apellido = '',
    @dni = 44555667,
    @email = 'hsimpson2@sol.com',
    @rol = 2
GO

--TEST 1.3: Error email
EXEC administracion.CrearAdministrador
    @nombre = 'Homero',
    @apellido = 'Simpson',
    @dni = 44555666,
    @email = 'hsimpsonsol.com',
    @rol = 2
GO

--TEST 1.4: DNI invalido
EXEC administracion.CrearAdministrador
    @nombre = 'Homero',
    @apellido = 'Simpson',
    @dni = 99999999,
    @email = 'hsimpson2@sol.com',
    @rol = 2
GO

--TEST 1.5: DNI duplicado
EXEC administracion.CrearAdministrador
    @nombre = 'Homero',
    @apellido = 'Flanders',
    @dni = 44555666,
    @email = 'hsimpson2@sol.com',
    @rol = 2
GO

--ACTUALIZACION

--TEST 2.1: Actualizacion de Homero Simpson a Homero Flanders
SELECT * FROM administracion.Administradores WHERE dni = 44555666
EXEC administracion.ActualizarAdministrador
    @dni = 44555666,
	@nombre = 'Homero',
	@apellido = 'Flanders',
    @email = 'hflanders@sol.com',
    @rol = 2
GO
SELECT * FROM administracion.Administradores WHERE dni = 44555666
GO

--TEST 2.2: Activar Administrador
SELECT * FROM administracion.Administradores WHERE dni = 44555666
EXEC administracion.ActualizarAdministrador
    @dni = 44555666,
	@nombre = 'Homero',
	@apellido = 'Flanders',
	@email = 'hsimpson@sol.com',
	@rol = 2,
    @estado = 1
GO
SELECT * FROM administracion.Administradores WHERE dni = 44555666
GO

--ELIMINACION

--TEST 3.1: Desactivar Administrador
SELECT * FROM administracion.Administradores WHERE dni = 44555666
EXEC administracion.EliminarAdministrador
    @dni = 44555666
GO
SELECT * FROM administracion.Administradores WHERE dni = 44555666
GO

--TEST 3.2: ERROR DNI INVALIDO
EXEC administracion.EliminarAdministrador
    @dni = 99999999
GO

--Medios Pago

-- Se crean los TESTS para la insercion, actualizacion y eliminacion de Medios Pago

USE Com2900G07
GO

-- Insercion

--TEST 1.1: Registro de un nuevo medio de pago
SELECT * FROM administracion.MediosPago
EXEC administracion.CrearMedioPago
    @Nombre = 'Tarjeta de Crédito',
    @Descripcion = 'Pago con tarjeta de crédito'
GO
SELECT * FROM administracion.MediosPago WHERE Nombre = 'Tarjeta de Crédito'
GO

--TEST 1.2: Error al insertar un medio de pago con nombre vacío
EXEC administracion.CrearMedioPago
    @Nombre = '',
    @Descripcion = 'Pago con tarjeta de crédito'
GO

-- Actualizacion

--TEST 2.1: Actualizar un medio de pago existente
SELECT * FROM administracion.MediosPago
EXEC administracion.ActualizarMedioPago
    @id_medio_pago = 1,
    @Nombre = 'Tarjeta de Débito',
    @Descripcion = 'Pago con tarjeta de débito'
GO
SELECT * FROM administracion.MediosPago WHERE id_medio_pago = 1
GO

--TEST 2.2: Error al Actualizar un medio de pago con nombre vacío
EXEC administracion.ActualizarMedioPago
    @id_medio_pago = 1,
    @Nombre = '',
    @Descripcion = 'Pago con tarjeta de débito'
GO

-- Eliminacion

--TEST 3.1: Eliminar un medio de pago existente
SELECT * FROM administracion.MediosPago
EXEC administracion.EliminarMedioPago
    @id_medio_pago = 1
GO
SELECT * FROM administracion.MediosPago WHERE id_medio_pago = 1
GO

--TEST 3.2: Error al Eliminar un medio de pago inexistente
EXEC administracion.EliminarMedioPago
    @id_medio_pago = 9999 -- Asumiendo que este ID no existe
GO

--Deportes

--Se crean los TESTS para la insercion, actualizacion y eliminacion de datos en la tabla DEPORTES

USE Com2900G07
GO

--INSERCION

--TEST 1.1: Agregar un nuevo deporte Exitoso
SELECT * FROM actividades.Deportes;
EXEC actividades.CrearDeporte
    @nombre = 'Futbol',
    @precio = 1000
GO
SELECT * FROM actividades.Deportes WHERE nombre = 'Futbol';

--TEST 1.2: Error precio negativo
EXEC actividades.CrearDeporte
    @nombre = 'Baloncesto',
    @precio = -500
GO

--TEST 1.3: Nombre Vacio
EXEC actividades.CrearDeporte
    @nombre = '',
    @precio = 500
GO

--ACTUALIZACION

--TEST 2.1: Actualizar un deporte exitoso
EXEC actividades.ActualizarDeporte
    @id_deporte = 1,
    @nombre = 'Futbol Profesional',
    @precio = 1200
GO
SELECT * FROM actividades.Deportes WHERE id_deporte = 1;

--TEST 2.2: Actualizar un deporte con nombre vacio
EXEC actividades.ActualizarDeporte
    @id_deporte = 1,
    @nombre = '',
    @precio = 1200
GO

--TEST 2.3: Actualizar un deporte con precio negativo
EXEC actividades.ActualizarDeporte
    @id_deporte = 1,
    @nombre = 'Futbol Profesional',
    @precio = -1000
GO

--ELIMINACION

--TEST 3.1: Eliminar un deporte exitoso
EXEC actividades.EliminarDeporte
    @id_deporte = 1
GO
SELECT * FROM actividades.Deportes WHERE id_deporte = 1;

--TEST 3.2: Deporte inexistente
EXEC actividades.EliminarDeporte
    @id_deporte = 9999
GO

-- Invitados

-- Se crean los TESTS para la insercion, actualizacion y eliminacion de Invitados

USE Com2900G07
GO

--INSERCION

--TEST 1.1: Insercion correcta
SELECT * FROM socios.Invitados
EXEC socios.CrearInvitado
    @dni = 12345678,
	@nombre = 'Homero',
	@apellido = 'Simpson'
GO
SELECT * FROM socios.Invitados WHERE dni = 12345678
GO

--TEST 1.2: DNI invalido
EXEC socios.CrearInvitado
    @dni = 123456789,
	@nombre = 'Homero',
	@apellido = 'Simpson'
GO

--TEST 1.3: DNI duplicado
EXEC socios.CrearInvitado
    @dni = 12345678,
	@nombre = 'Homero',
	@apellido = 'Simpson'
GO

--TEST 1.4: Nombre vacio
EXEC socios.CrearInvitado
    @dni = 11222333,
	@nombre = '',
	@apellido = 'Simpson'
GO

--TEST 1.5: Apellido vacio
EXEC socios.CrearInvitado
    @dni = 11222333,
	@nombre = 'Homero',
	@apellido = ''
GO

--ACTUALIZACION

--TEST 2.1: Actualizacion correcta
SELECT * FROM socios.Invitados
EXEC socios.ActualizarInvitado
    @dni = 12345678,
	@nombre = 'Pepe',
	@apellido = 'Azul'
GO
SELECT * FROM socios.Invitados WHERE dni = 12345678
GO

--TEST 2.2: Activar invitado
SELECT * FROM socios.Invitados
EXEC socios.ActualizarInvitado
    @dni = 12345678,
	@nombre = 'Pepe',
	@apellido = 'Azul',
	@estado = 1
GO

--ELIMINACION

--TEST 3.1: Eliminacion correcta
SELECT * FROM socios.Invitados
EXEC socios.EliminarInvitado
    @dni = 12345678
GO
SELECT * FROM socios.Invitados WHERE dni = 12345678
GO

--TEST 3.2: DNI inexistente
EXEC socios.EliminarInvitado
    @dni = 87654321
GO


--Clases
-- Se crean los TESTS para la insercion, actualizacion y eliminacion de Clases
USE Com2900G07
GO

-- Agregar un nuevo deporte para usar de prueba
EXEC actividades.CrearDeporte
    @nombre = 'Futbol_test_clase',
    @precio = 1000
GO

--INSERCION

-- TEST 1.1: Insertar una Clase
DECLARE @id_deporte_test INT;

SELECT @id_deporte_test = id_deporte
FROM actividades.Deportes
WHERE nombre = 'Futbol_test_clase';

SELECT * FROM actividades.Clases
EXEC actividades.CrearClase
    @id_deporte = @id_deporte_test

SELECT * FROM actividades.Clases WHERE id_deporte = @id_deporte_test
GO

-- ELIMINACION

-- TEST 3.1: Eliminar una Clase
DECLARE @id_deporte_test INT;

SELECT @id_deporte_test = id_deporte
FROM actividades.Deportes
WHERE nombre = 'Futbol_test_clase';

SELECT * FROM actividades.Clases
EXEC actividades.EliminarClase
    @id_deporte = @id_deporte_test
SELECT * FROM actividades.Clases WHERE id_clase = 1
GO


--Turnos

-- Se crean los TESTS para la insercion, actualizacion y eliminacion de Turnos

USE Com2900G07
GO

-- Agregar un nuevo deporte y una clase para usar de prueba
EXEC actividades.CrearDeporte
    @nombre = 'Futbol_test_clase_turno',
    @precio = 1000
GO

DECLARE @id_deporte_test INT;

SELECT @id_deporte_test = id_deporte
FROM actividades.Deportes
WHERE nombre = 'Futbol_test_clase_turno';

EXEC actividades.CrearClase
    @id_deporte = @id_deporte_test
GO

-- INSERCION

-- TEST 1.1: Crear Turno Exitoso
DECLARE @id_clase_test INT;

SELECT @id_clase_test = id_clase
FROM actividades.Clases c
INNER JOIN actividades.Deportes d ON d.id_deporte = c.id_deporte
WHERE d.nombre = 'Futbol_test_clase_turno';

SELECT * FROM actividades.Turnos
EXEC actividades.CrearTurno
    @id_clase = @id_clase_test,
    @dia = 4,
    @hora_inicio = '10:00',
    @hora_fin = '12:00'

SELECT * FROM actividades.Turnos WHERE id_clase = @id_clase_test AND dia = 4 AND hora_inicio = '10:00' AND hora_fin = '12:00'
GO

--TEST 1.2: Crear Turno Fallido (Dia Incorrecto ya existe)
DECLARE @id_clase_test INT;

SELECT @id_clase_test = id_clase
FROM actividades.Clases c
INNER JOIN actividades.Deportes d ON d.id_deporte = c.id_clase
WHERE d.nombre = 'Futbol_test_clase_turno';

SELECT * FROM actividades.Turnos
EXEC actividades.CrearTurno
    @id_clase = @id_clase_test,
    @dia = 11,
    @hora_inicio = '10:00',
    @hora_fin = '12:00'
GO

--TEST 1.3: Crear Turno Fallido (Hora Inicio Incorrecta)
DECLARE @id_clase_test INT;

SELECT @id_clase_test = id_clase
FROM actividades.Clases c
INNER JOIN actividades.Deportes d ON d.id_deporte = c.id_clase
WHERE d.nombre = 'Futbol_test_clase_turno';

SELECT * FROM actividades.Turnos
EXEC actividades.CrearTurno
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
FROM actividades.Clases c
INNER JOIN actividades.Deportes d ON d.id_deporte = c.id_deporte
WHERE d.nombre = 'Futbol_test_clase_turno';

SELECT @id_turno_test = id_turno
FROM actividades.Turnos
WHERE id_clase = @id_clase_test

SELECT * FROM actividades.Turnos WHERE id_turno = @id_turno_test
EXEC actividades.ActualizarTurno
    @id_turno = @id_turno_test,
	@id_clase = @id_clase_test,
    @dia = 4,
    @hora_inicio = '12:00',
    @hora_fin = '14:00'

SELECT * FROM actividades.Turnos WHERE id_turno = @id_turno_test
GO

-- TEST 2.2: Actualizar Turno Fallido (Dia Incorrecto)
DECLARE @id_clase_test INT;
DECLARE @id_turno_test INT;

SELECT @id_clase_test = id_clase
FROM actividades.Clases c
INNER JOIN actividades.Deportes d ON d.id_deporte = c.id_deporte
WHERE d.nombre = 'Futbol_test_clase_turno';

SELECT @id_turno_test = id_turno
FROM actividades.Turnos
WHERE id_clase = @id_clase_test

SELECT * FROM actividades.Turnos
EXEC actividades.ActualizarTurno
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
FROM actividades.Clases c
INNER JOIN actividades.Deportes d ON d.id_deporte = c.id_deporte
WHERE d.nombre = 'Futbol_test_clase_turno';

SELECT @id_turno_test = id_turno
FROM actividades.Turnos
WHERE id_clase = @id_clase_test

SELECT * FROM actividades.Turnos
EXEC actividades.ActualizarTurno
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
FROM actividades.Clases c
INNER JOIN actividades.Deportes d ON d.id_deporte = c.id_deporte
WHERE d.nombre = 'Futbol_test_clase_turno';

SELECT @id_turno_test = id_turno
FROM actividades.Turnos
WHERE id_clase = @id_clase_test

SELECT * FROM actividades.Turnos
EXEC actividades.EliminarTurno
    @id_turno = @id_turno_test

SELECT * FROM actividades.Turnos WHERE id_turno = @id_turno_test
GO

-- TEST 3.2: Eliminar Turno Fallido (Turno No Existe)
EXEC actividades.EliminarTurno
    @id_turno = 9999999
GO

-- Socios

-- Se crean los TESTS para la insercion, actualizacion y eliminacion de SOCIOS

USE Com2900G07
GO

--Agregamos un prestador de salud y un socio tutor para testear
EXEC socios.CrearPrestadorSalud
    @nombre = 'Galeno_test_socio',
    @telefono = '46254016'

DECLARE @id_prestador_salud_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM socios.PrestadoresSalud
WHERE nombre = 'Galeno_test_socio';

EXEC socios.CrearSocio
	@nro_socio = 0001,
    @dni = 12345678,
    @nombre = 'Tutor',
    @apellido = 'Prueba',
    @email = 'tutor_prueba@sol.com',
    @fecha_nacimiento = '2002-11-26',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @nro_socio_obra_social = '9987',
    @id_prestador_salud = @id_prestador_salud_test
GO
--INSERCION

--TEST 1.1: Insercion correcta
DECLARE @id_prestador_salud_test INT;
DECLARE @id_tutor_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM socios.PrestadoresSalud
WHERE nombre = 'Galeno_test_socio';

SELECT @id_tutor_test = id_socio
FROM socios.Socios
WHERE dni = 12345678

EXEC socios.CrearSocio
	@nro_socio = 0002,
    @dni = 23777221,
    @nombre = 'Bart',
    @apellido = 'Simpson_Prueba',
    @email = 'BSimpson1@sol.com',
    @fecha_nacimiento = '2002-11-26',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @nro_socio_obra_social = '9986',
    @id_prestador_salud = @id_prestador_salud_test,
    @id_tutor = @id_tutor_test,
    @id_grupo_familiar = @id_tutor_test
SELECT * FROM socios.Socios WHERE dni = 23777221;

-------------ESTE ES PARA TENER EN LOS PROXIMOS TESTS
EXEC socios.CrearSocio
	@nro_socio = 0003,
    @dni = 23777222,
    @nombre = 'Bart',
    @apellido = 'Simpson',
    @email = 'BSimpson@sol.com',
    @fecha_nacimiento = '2002-11-26',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @nro_socio_obra_social = '9985',
    @id_prestador_salud = @id_prestador_salud_test,
    @id_tutor = @id_tutor_test,
    @id_grupo_familiar = @id_tutor_test
SELECT * FROM socios.Socios WHERE dni = 23777222;
GO

--TEST 1.2: Error Incorrecta DNI Incorrecto
DECLARE @id_prestador_salud_test INT;
DECLARE @id_tutor_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM socios.PrestadoresSalud
WHERE nombre = 'Galeno_test_socio';

SELECT @id_tutor_test = id_socio
FROM socios.Socios
WHERE dni = 12345678

EXEC socios.CrearSocio
	@nro_socio = 0004,
    @dni = 99999999,
    @nombre = 'Bart',
    @apellido = 'Simpson',
    @email = 'BSimpson2@sol.com',
    @fecha_nacimiento = '2002-11-26',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @nro_socio_obra_social = '9984',
    @id_prestador_salud = @id_prestador_salud_test,
    @id_tutor = @id_tutor_test,
    @id_grupo_familiar = @id_tutor_test
SELECT * FROM socios.Socios
GO

--TEST 1.3: Error nombre y/o apellido vacios
DECLARE @id_prestador_salud_test INT;
DECLARE @id_tutor_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM socios.PrestadoresSalud
WHERE nombre = 'Galeno_test_socio';

SELECT @id_tutor_test = id_socio
FROM socios.Socios
WHERE dni = 12345678

EXEC socios.CrearSocio
	@nro_socio = 0005,
    @dni = 23777223,
    @nombre = '',
    @apellido = '',
    @email = 'BSimpson2@sol.com',
    @fecha_nacimiento = '2002-11-26',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @nro_socio_obra_social = '9984',
    @id_prestador_salud = @id_prestador_salud_test,
    @id_tutor = @id_tutor_test,
    @id_grupo_familiar = @id_tutor_test
GO

--TEST 1.4: Error email
DECLARE @id_prestador_salud_test INT;
DECLARE @id_tutor_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM socios.PrestadoresSalud
WHERE nombre = 'Galeno_test_socio';

SELECT @id_tutor_test = id_socio
FROM socios.Socios
WHERE dni = 12345678

EXEC socios.CrearSocio
	@nro_socio = 0006,
    @dni = 23777224,
    @nombre = 'Bart',
    @apellido = 'Simpson',
    @email = 'BSimpsonsol.com',
    @fecha_nacimiento = '2002-11-26',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @nro_socio_obra_social = '9983',
    @id_prestador_salud = @id_prestador_salud_test,
    @id_tutor = @id_tutor_test,
    @id_grupo_familiar = @id_tutor_test
GO

--TEST 1.5: Error Fecha Nacimiento
DECLARE @id_prestador_salud_test INT;
DECLARE @id_tutor_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM socios.PrestadoresSalud
WHERE nombre = 'Galeno_test_socio';

SELECT @id_tutor_test = id_socio
FROM socios.Socios
WHERE dni = 12345678

EXEC socios.CrearSocio
	@nro_socio = 0007,
    @dni = 23777225,
    @nombre = 'Bart',
    @apellido = 'Simpson',
    @email = 'BSimpson2@sol.com',
    @fecha_nacimiento = '2100-11-26',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @nro_socio_obra_social = '9982',
    @id_prestador_salud = @id_prestador_salud_test,
    @id_tutor = @id_tutor_test,
    @id_grupo_familiar = @id_tutor_test
GO

--TEST 1.6: Error Tutor Socio
DECLARE @id_prestador_salud_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM socios.PrestadoresSalud
WHERE nombre = 'Galeno_test_socio';

EXEC socios.CrearSocio
	@nro_socio = 0008,
    @dni = 23777226,
    @nombre = 'Bart',
    @apellido = 'Simpson',
    @email = 'BSimpson2@sol.com',
    @fecha_nacimiento = '2002-11-26',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @nro_socio_obra_social = '9981',
    @id_prestador_salud = @id_prestador_salud_test,
    @id_tutor = 999991,
    @id_grupo_familiar = 999991
GO

--TEST 1.7:Error Grupo Familiar
DECLARE @id_prestador_salud_test INT;
DECLARE @id_tutor_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM socios.PrestadoresSalud
WHERE nombre = 'Galeno_test_socio';

SELECT @id_tutor_test = id_socio
FROM socios.Socios
WHERE dni = 12345678

EXEC socios.CrearSocio
	@nro_socio = 0009,
    @dni = 23777227,
    @nombre = 'Bart',
    @apellido = 'Simpson',
    @email = 'BSimpson2@sol.com',
    @fecha_nacimiento = '2002-11-26',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @nro_socio_obra_social = '9980',
    @id_prestador_salud = @id_prestador_salud_test,
    @id_tutor = @id_tutor_test,
    @id_grupo_familiar = 999991
GO

--ACTUALIZACION

--TEST 2.1: Actualizacion Correcta
DECLARE @id_prestador_salud_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM socios.PrestadoresSalud
WHERE nombre = 'Galeno_test_socio';

EXEC socios.ActualizarSocio
    @dni = 23777221,
	@nro_socio = 00010,
    @email = 'BartSimpson@sol.com',
    @telefono = 12345678,
    @telefono_emergencia = 11112222,
    @estado = 1,
	@nro_socio_obra_social = '9981',
    @id_prestador_salud = @id_prestador_salud_test
GO
SELECT * FROM socios.Socios WHERE dni = 23777221;

--TEST 2.2: Error DNI
EXEC socios.ActualizarSocio
    @dni = 99999999,
	@nro_socio = 00011,
    @email = 'BartSimpson@sol.com',
    @telefono = 12345678,
    @telefono_emergencia = 11112222,
    @estado = 1,
    @nro_socio_obra_social = '9981',
    @id_prestador_salud = 2
GO

--TEST 2.3: Error Mail
EXEC socios.ActualizarSocio
    @dni = 23777221,
	@nro_socio = 0012,
    @email = 'BartSimpsonsol.com',
    @telefono = 12345678,
    @telefono_emergencia = 11112222,
    @estado = 1,
	@nro_socio_obra_social = '9981',
    @id_prestador_salud = 2
GO

--TEST 2.4: Actualizar tutor
EXEC socios.ActualizarSocioTutor
	@dni_tutor = 12345678,
	@dni_menor = 23777221

--TEST 2.4: Actualizar grupo familiar
EXEC socios.ActualizarSocioGrupoFamiliar
	@dni = 23777221,
	@dni_responsable_grupo_familiar = 12345678

--ELIMINACION

--TEST 3.1:  Desactivacion Correcta
EXEC socios.EliminarSocio
    @dni = 23777221
GO
SELECT * FROM socios.Socios WHERE dni = 23777221;

--TEST 3.2: DNI Incorrecto
EXEC socios.EliminarSocio
    @dni = 99999991
GO
SELECT * FROM socios.Socios WHERE dni = 99999991;


--Cuotas
--Se crean los TESTS para la insercion, actualizacion y eliminacion de Cuotas

USE Com2900G07
GO

--Agregamos un socio y una categoria para testear
EXEC socios.CrearPrestadorSalud
    @nombre = 'Galeno_test_cuota',
    @telefono = '46254016'

DECLARE @id_prestador_salud_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM socios.PrestadoresSalud
WHERE nombre = 'Galeno_test_cuota';

EXEC socios.CrearSocio
	@nro_socio = 0013,
    @dni = 11222333,
    @nombre = 'Test',
    @apellido = 'Cuota',
    @email = 'test_couta@sol.com',
    @fecha_nacimiento = '2002-11-26',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @nro_socio_obra_social = '9979',
    @id_prestador_salud = @id_prestador_salud_test

EXEC socios.CrearCategoria
    @nombre_categoria = 'Juvenil_test',
    @edad_min = 12,
    @edad_max = 17,
    @precio_mensual = 5000
GO

--INSERCION

--TEST 1.1: Insercion Correcta
DECLARE @id_categoria_test INT

SELECT @id_categoria_test = id_categoria
FROM socios.Categorias
WHERE nombre_categoria = 'Juvenil_test'

EXEC socios.CrearCuota
    @dni = 11222333,
    @id_categoria = @id_categoria_test

SELECT * FROM socios.Cuotas;
GO

--TEST 1.2: Dni Incorrecto
EXEC socios.CrearCuota
    @dni = 99999999,
    @id_categoria = 1
GO

--TEST 1.3: Categoria Incorrecta
EXEC socios.CrearCuota
    @dni = 11222333,
    @id_categoria = 999999
GO

--ACTUALIZACION

--TEST 2.1: Actualizacion Correcta
EXEC socios.CrearCategoria
    @nombre_categoria = 'Juvenil_test2',
    @edad_min = 12,
    @edad_max = 17,
    @precio_mensual = 5000
GO

DECLARE @id_categoria_test INT

SELECT @id_categoria_test = id_categoria
FROM socios.Categorias
WHERE nombre_categoria = 'Juvenil_test2'

EXEC socios.ActualizarCuota
    @dni = 11222333,
    @id_categoria = @id_categoria_test
GO
SELECT * FROM socios.Cuotas;

--TEST 2.2: Error DNI
EXEC socios.ActualizarCuota
    @dni = 99999999,
    @id_categoria = 1
GO

--TEST 2.3: Error Categoria
EXEC socios.ActualizarCuota
    @dni = 11222333,
    @id_categoria = 99991
GO


-- Actividades
-- Se crean los TESTS para la insercion, actualizacion y eliminacion de Actividad

USE Com2900G07
GO

--Agregamos un socio y un deporte para testear
EXEC socios.CrearPrestadorSalud
    @nombre = 'Galeno_test_actividad',
    @telefono = '46254016'

DECLARE @id_prestador_salud_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM socios.PrestadoresSalud
WHERE nombre = 'Galeno_test_actividad';

EXEC socios.CrearSocio
	@nro_socio = 0014,
    @dni = 11222444,
    @nombre = 'Test',
    @apellido = 'Actividad',
    @email = 'test_actividad@sol.com',
    @fecha_nacimiento = '2002-11-26',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @nro_socio_obra_social = '9978',
    @id_prestador_salud = @id_prestador_salud_test

EXEC actividades.CrearDeporte
    @nombre = 'Futbol_test_actividad',
    @precio = 1000
GO

--INSERCION

--TEST 1.1: Insercion Correcta
DECLARE @id_deporte_test INT

SELECT @id_deporte_test = id_deporte
FROM actividades.Deportes
WHERE nombre = 'Futbol_test_actividad'

EXEC actividades.CrearActividad
    @dni = 11222444,
    @id_deporte = @id_deporte_test
GO
SELECT * FROM actividades.Actividades

--TEST 1.2: Error DNI Socio
EXEC actividades.CrearActividad
    @dni = 99999999,
    @id_deporte = 1
GO

--TEST 1.3: Error id_deporte
EXEC actividades.CrearActividad
    @dni = 11222444,
    @id_deporte = 99999991
GO


--Eliminacion
--Test 3.1: Eliminar Actividad
DECLARE @id_deporte_test INT

SELECT @id_deporte_test = id_deporte
FROM actividades.Deportes
WHERE nombre = 'Futbol_test_actividad'

EXEC actividades.EliminarActividad
    @dni = 11222444,
    @id_deporte = @id_deporte_test;
GO

--Test 3.2: Dni Incorrecto
EXEC actividades.EliminarActividad
    @dni = 99999999,
    @id_deporte = 1;
GO

--Test 3.3: ID deporte Incorrecto
EXEC actividades.EliminarActividad
    @dni = 11222444,
    @id_deporte = 999999;
GO

--Actividades extra
--Se crean los TESTS para la insercion, actualizacion y eliminacion de ACTIVIDADES EXTRA

USE Com2900G07
GO

--Agregamos un socio y un invitado para testear
EXEC socios.CrearPrestadorSalud
    @nombre = 'Galeno_test_act_extra',
    @telefono = '46254016'

DECLARE @id_prestador_salud_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM socios.PrestadoresSalud
WHERE nombre = 'Galeno_test_act_extra';

EXEC socios.CrearSocio
	@nro_socio = 0015,
    @dni = 44555666,
    @nombre = 'Socio',
    @apellido = 'Prueba Act Extra',
    @email = 'socio_prueba_ae@sol.com',
    @fecha_nacimiento = '2002-11-26',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @nro_socio_obra_social = '9977',
    @id_prestador_salud = @id_prestador_salud_test

EXEC socios.CrearInvitado
    @dni = 11123123,
	@nombre = 'Invitado',
	@apellido = 'Test Act Extra'
GO

--INSERCION

--TEST 1.1: INSERCCION CORRECTA
EXEC actividades.CrearActividadExtra
    @dni = 44555666,
    @dni_invitado = 11123123,
    @tipo_actividad = 1,
    @fecha = '2025-06-01',
    @fecha_reserva = '2025-05-20',
    @monto = 1000,
    @monto_invitado = 500,
    @lluvia = 0
SELECT * FROM actividades.ActividadesExtra
GO

--TEST 1.2: INSERCCION CON DNI INVITADO NO EXISTENTE
EXEC actividades.CrearActividadExtra
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
EXEC actividades.CrearActividadExtra
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
EXEC actividades.CrearActividadExtra
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
EXEC actividades.CrearActividadExtra
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
EXEC actividades.ActualizarActividadExtra
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
EXEC actividades.ActualizarActividadExtra
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
EXEC actividades.ActualizarActividadExtra
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
EXEC actividades.ActualizarActividadExtra
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
EXEC actividades.ActualizarActividadExtra
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
EXEC actividades.ActualizarActividadExtra
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
EXEC socios.CrearPrestadorSalud
    @nombre = 'Galeno_test_factura',
    @telefono = '46254016'

DECLARE @id_prestador_salud_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM socios.PrestadoresSalud
WHERE nombre = 'Galeno_test_factura';

EXEC socios.CrearSocio
	@nro_socio = 0016,
    @dni = 22333444,
    @nombre = 'Socio',
    @apellido = 'Prueba Factura',
    @email = 'socio_prueba_factura@sol.com',
    @fecha_nacimiento = '2002-11-26',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @nro_socio_obra_social = '9976',
    @id_prestador_salud = @id_prestador_salud_test
GO

--INSERCION

--TEST 1.1: INSERCION DE UNA FACTURA CORRECTA
EXEC administracion.CrearFacturaARCA
    @dni = 22333444,
    @descripcion = 'Factura de prueba',
    @total = 10000,
    @tipo = 'A',
    @primer_vencimiento = '2025-10-15',
    @segundo_vencimiento = '2025-10-30',
    @recargo = 5
SELECT * FROM administracion.FacturasARCA
GO

--TEST 1.2: INSERCION DE UNA FACTURA CON DNI NO EXISTENTE
EXEC administracion.CrearFacturaARCA
    @dni = 99999999,
    @descripcion = 'Factura de prueba',
    @total = 10000,
    @tipo = 'A',
    @primer_vencimiento = '2025-10-15',
    @segundo_vencimiento = '2025-10-30',
    @recargo = 5
GO

--TEST 1.3: INSERCION DE UNA FACTURA CON IMPORTE NEGATIVO
EXEC administracion.CrearFacturaARCA
    @dni = 22333444,
    @descripcion = 'Factura de prueba',
    @total = -10000,
    @tipo = 'A',
	@primer_vencimiento = '2025-10-15',
    @segundo_vencimiento = '2025-10-30',
    @recargo = 5
GO

--TEST 1.4: INSERCION DE UNA FACTURA CON TIPO NO VÁLIDO
EXEC administracion.CrearFacturaARCA
    @dni = 22333444,
    @descripcion = 'Factura de prueba',
    @total = 10000,
    @tipo = 'X', -- Tipo no válido
	@primer_vencimiento = '2025-10-15',
    @segundo_vencimiento = '2025-10-30',
    @recargo = 5
GO

--TEST 1.5: INSERCION DE UNA FACTURA CON RECARGO NEGATIVO
EXEC administracion.CrearFacturaARCA
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
EXEC socios.CrearPrestadorSalud
    @nombre = 'Galeno_test_cargo_socio',
    @telefono = '46254016'

DECLARE @id_prestador_salud_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM socios.PrestadoresSalud
WHERE nombre = 'Galeno_test_cargo_socio';

EXEC socios.CrearSocio
	@nro_socio = 0017,
    @dni = 11555999,
    @nombre = 'Socio',
    @apellido = 'Prueba Cargo Socio',
    @email = 'socio_prueba_cs@sol.com',
    @fecha_nacimiento = '2002-11-26',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @nro_socio_obra_social = '9975',
    @id_prestador_salud = @id_prestador_salud_test

EXEC socios.CrearCategoria
    @nombre_categoria = 'Adulto_test',
    @edad_min = 18,
    @edad_max = 60,
    @precio_mensual = 5000

DECLARE @id_categoria_test INT

SELECT @id_categoria_test = id_categoria
FROM socios.Categorias
WHERE nombre_categoria = 'Adulto_test'

EXEC socios.CrearCuota
    @dni = 11555999,
    @id_categoria = @id_categoria_test

EXEC actividades.CrearDeporte
    @nombre = 'Futbol_test_cargo_socio',
    @precio = 1000

DECLARE @id_deporte_test INT

SELECT @id_deporte_test = id_deporte
FROM actividades.Deportes
WHERE nombre = 'Futbol_test_cargo_socio'

EXEC actividades.CrearActividad
    @dni = 11555999,
    @id_deporte = @id_deporte_test

EXEC actividades.CrearActividadExtra
    @dni = 11555999,
    @dni_invitado = NULL,
    @tipo_actividad = 1,
    @fecha = '2025-06-01',
    @fecha_reserva = '2025-05-20',
    @monto = 1000,
    @monto_invitado = NULL,
    @lluvia = NULL

EXEC administracion.CrearFacturaARCA
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
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(11555999) AND descripcion = 'Factura de prueba cargo socio'

SELECT @id_cuota_test = id_cuota
FROM socios.Cuotas
WHERE id_socio = socios.BuscarSocio(11555999)

EXEC administracion.CrearCargoSocio
	@numero_factura = @numero_factura_test,
	@fecha_creacion = '2025-06-30 09:05:56',
	@descripcion = 'Cargo de prueba sobre cuota',
	@monto_descuento = 100,
	@monto_total = 1000,
	@id_deporte = NULL,
	@id_actividad_extra = NULL,
	@id_cuota = @id_cuota_test
SELECT * FROM administracion.CargosSocio
GO

--TEST 1.2: Creacion correcta de un cargo de deporte
DECLARE @numero_factura_test INT;
DECLARE @id_deporte_test INT

SELECT @numero_factura_test = numero_factura
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(11555999) AND descripcion = 'Factura de prueba cargo socio'

SELECT @id_deporte_test = d.id_deporte
FROM actividades.Deportes d
INNER JOIN actividades.Actividades a ON a.id_deporte = d.id_deporte
WHERE a.id_socio = socios.BuscarSocio(11555999)

EXEC administracion.CrearCargoSocio
	@numero_factura = @numero_factura_test,
	@fecha_creacion = '2025-06-30 10:05:56',
	@descripcion = 'Cargo de prueba sobre cuota',
	@monto_descuento = 100,
	@monto_total = 1000,
	@id_deporte = @id_deporte_test,
	@id_actividad_extra = NULL,
	@id_cuota = NULL
SELECT * FROM administracion.CargosSocio
GO

--TEST 1.3: Creacion correcta de un cargo de actividad extra
DECLARE @numero_factura_test INT;
DECLARE @id_actividad_extra_test INT

SELECT @numero_factura_test = numero_factura
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(11555999) AND descripcion = 'Factura de prueba cargo socio'

SELECT @id_actividad_extra_test = id_actividad_extra
FROM actividades.ActividadesExtra 
WHERE id_socio = socios.BuscarSocio(11555999)

EXEC administracion.CrearCargoSocio
	@numero_factura = @numero_factura_test,
	@fecha_creacion = '2025-06-30 10:05:56',
	@descripcion = 'Cargo de prueba sobre cuota',
	@monto_descuento = 100,
	@monto_total = 1000,
	@id_deporte = NULL,
	@id_actividad_extra = @id_actividad_extra_test,
	@id_cuota = NULL
SELECT * FROM administracion.CargosSocio
GO

--TEST 1.4: Factura inexistente
EXEC administracion.CrearCargoSocio
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
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(11555999) AND descripcion = 'Factura de prueba cargo socio'

EXEC administracion.CrearCargoSocio
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
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(11555999) AND descripcion = 'Factura de prueba cargo socio'

EXEC administracion.CrearCargoSocio
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
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(11555999) AND descripcion = 'Factura de prueba cargo socio'

EXEC administracion.CrearCargoSocio
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
FROM socios.Cuotas
WHERE id_socio = socios.BuscarSocio(11555999)

SELECT @numero_factura_test = numero_factura
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(11555999) AND descripcion = 'Factura de prueba cargo socio'

SELECT @id_deporte_test = d.id_deporte
FROM actividades.Deportes d
INNER JOIN actividades.Actividades a ON a.id_deporte = d.id_deporte
WHERE a.id_socio = socios.BuscarSocio(11555999)

SELECT @id_cargo_socio_test = id_cargo_socio
FROM administracion.CargosSocio
WHERE numero_factura = @numero_factura_test AND id_cuota = @id_cuota_test
	
SELECT * FROM administracion.CargosSocio WHERE id_cargo_socio = @id_cargo_socio_test
EXEC administracion.ActualizarCargoSocio
	@id_cargo_socio = @id_cargo_socio_test,
	@numero_factura = @numero_factura_test,
	@fecha_creacion = '2025-06-30 10:05:56',
	@descripcion = 'Cargo de prueba sobre cuota',
	@monto_descuento = 100,
	@monto_total = 1000,
	@id_deporte = @id_deporte_test,
	@id_actividad_extra = NULL,
	@id_cuota = NULL
SELECT * FROM administracion.CargosSocio WHERE id_cargo_socio = @id_cargo_socio_test
GO

-- Morosidades

USE Com2900G07
GO

--Agregamos una factura para testear
EXEC socios.CrearPrestadorSalud
    @nombre = 'Galeno_test_morosidad',
    @telefono = '46254016'

DECLARE @id_prestador_salud_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM socios.PrestadoresSalud
WHERE nombre = 'Galeno_test_morosidad';

EXEC socios.CrearSocio
	@nro_socio = 0018,
    @dni = 33444555,
    @nombre = 'Socio',
    @apellido = 'Prueba Morosidad',
    @email = 'socio_prueba_morosidad@sol.com',
    @fecha_nacimiento = '2002-11-26',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @nro_socio_obra_social = '9974',
    @id_prestador_salud = @id_prestador_salud_test
GO

EXEC administracion.CrearFacturaARCA
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
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(33444555) AND descripcion = 'Factura de prueba morosidad'

EXEC administracion.CrearMorosidad
	@numero_factura = @numero_factura_test,
	@monto_total = 1000,
	@fecha_pago = NULL
SELECT * FROM administracion.Morosidades
GO

--TEST 1.2: Factura invalida
EXEC administracion.CrearMorosidad
	@numero_factura = 99999,
	@monto_total = 1000,
	@fecha_pago = NULL
GO

--TEST 1.3: Morosidad sin monto
DECLARE @numero_factura_test INT

SELECT @numero_factura_test = numero_factura
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(33444555) AND descripcion = 'Factura de prueba morosidad'

EXEC administracion.CrearMorosidad
	@numero_factura = @numero_factura_test,
	@monto_total = 0,
	@fecha_pago = NULL
GO

--ACTUALIZACION

--TEST 2.1: Actualizar correctamente
DECLARE @numero_factura_test INT
DECLARE @id_morosidad_test INT

SELECT @numero_factura_test = numero_factura
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(33444555) AND descripcion = 'Factura de prueba morosidad'

SELECT @id_morosidad_test = id_morosidad
FROM administracion.Morosidades
WHERE numero_factura = @numero_factura_test

SELECT * FROM administracion.Morosidades
EXEC administracion.ActualizarMorosidad
	@id_morosidad = @id_morosidad_test,
	@numero_factura = @numero_factura_test,
	@monto_total = 1000,
	@fecha_pago = '2025-06-30 15:40:13'
SELECT * FROM administracion.Morosidades
GO

--TEST 2.2: ID morosidad inexistente
DECLARE @numero_factura_test INT

SELECT @numero_factura_test = numero_factura
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(33444555) AND descripcion = 'Factura de prueba morosidad'

EXEC administracion.ActualizarMorosidad
	@id_morosidad = 99999,
	@numero_factura = @numero_factura_test,
	@monto_total = 1000,
	@fecha_pago = '2025-06-30 15:40:13'
GO

--TEST 2.3: Numero factura inexistente
DECLARE @numero_factura_test INT
DECLARE @id_morosidad_test INT

SELECT @numero_factura_test = numero_factura
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(33444555) AND descripcion = 'Factura de prueba morosidad'

SELECT @id_morosidad_test = id_morosidad
FROM administracion.Morosidades
WHERE numero_factura = @numero_factura_test

EXEC administracion.ActualizarMorosidad
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
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(33444555) AND descripcion = 'Factura de prueba morosidad'

SELECT @id_morosidad_test = id_morosidad
FROM administracion.Morosidades
WHERE numero_factura = @numero_factura_test

EXEC administracion.EliminarMorosidad
	@id_morosidad = @id_morosidad_test

SELECT * FROM administracion.Morosidades
GO

--TEST 3.2: ID morosidad inexistente
EXEC administracion.EliminarMorosidad
	@id_morosidad = 99999


--Cuentas socio

USE Com2900G07
GO

--Agregamos un socio para testear
EXEC socios.CrearPrestadorSalud
    @nombre = 'Galeno_test_cuenta_cosio',
    @telefono = '46254016'

DECLARE @id_prestador_salud_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM socios.PrestadoresSalud
WHERE nombre = 'Galeno_test_cuenta_cosio';

EXEC socios.CrearSocio
	@nro_socio = 0019,
    @dni = 11777888,
    @nombre = 'Socio',
    @apellido = 'Prueba Cuenta Socio',
    @email = 'socio_prueba_cuenta@sol.com',
    @fecha_nacimiento = '2002-11-26',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @nro_socio_obra_social = '9973',
    @id_prestador_salud = @id_prestador_salud_test

--INSERCION

--TEST 1.1: Insercion correcta
SELECT * FROM socios.CuentasSocios 
EXEC socios.CrearCuentaSocio
	@dni = 11777888,
	@contrasena = '12345$a',
	@usuario = 'socioPruebaCuenta',
	@rol = 1,
	@saldo = 0,
	@fecha_vigencia_contrasena = '2026-06-30 23:59:59',
	@estado_cuenta = 1
SELECT * FROM socios.CuentasSocios
GO

--TEST 1.2: DNI incorrecto
EXEC socios.CrearCuentaSocio
	@dni = 99999999,
	@contrasena = '12345$a',
	@usuario = 'socioPruebaCuenta',
	@rol = 1,
	@saldo = 0,
	@fecha_vigencia_contrasena = '2026-06-30 23:59:59',
	@estado_cuenta = 1

--TEST 1.3: Contraseña vacia
EXEC socios.CrearCuentaSocio
	@dni = 11777888,
	@contrasena = '',
	@usuario = 'socioPruebaCuenta',
	@rol = 1,
	@saldo = 0,
	@fecha_vigencia_contrasena = '2026-06-30 23:59:59',
	@estado_cuenta = 1
GO

--TEST 1.4: Usuario vacia
EXEC socios.CrearCuentaSocio
	@dni = 11777888,
	@contrasena = '12345$a',
	@usuario = '',
	@rol = 1,
	@saldo = 0,
	@fecha_vigencia_contrasena = '2026-06-30 23:59:59',
	@estado_cuenta = 1
GO

--TEST 1.5: Rol invalido
EXEC socios.CrearCuentaSocio
	@dni = 11777888,
	@contrasena = '12345$a',
	@usuario = 'socioPruebaCuenta',
	@rol = 8,
	@saldo = 0,
	@fecha_vigencia_contrasena = '2026-06-30 23:59:59',
	@estado_cuenta = 1
GO

--TEST 1.6: Fecha vigencia de contraseña invalida
EXEC socios.CrearCuentaSocio
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
SELECT * FROM socios.CuentasSocios
EXEC socios.ActualizarCuentaSocio
	@dni = 11777888,
	@contrasena = '12345$a',
	@usuario = 'socioPruebaCuenta123',
	@rol = 2,
	@saldo = 0,
	@fecha_vigencia_contrasena = '2026-06-30 23:59:59',
	@estado_cuenta = 1
SELECT * FROM socios.CuentasSocios
GO

--TEST 2.2: DNI incorrecto
EXEC socios.ActualizarCuentaSocio
	@dni = 99999999,
	@contrasena = '12345$a',
	@usuario = 'socioPruebaCuenta123',
	@rol = 2,
	@saldo = 0,
	@fecha_vigencia_contrasena = '2026-06-30 23:59:59',
	@estado_cuenta = 1
GO

--TEST 2.3: Contraseña vacia
EXEC socios.ActualizarCuentaSocio
	@dni = 11777888,
	@contrasena = '',
	@usuario = 'socioPruebaCuenta123',
	@rol = 2,
	@saldo = 0,
	@fecha_vigencia_contrasena = '2026-06-30 23:59:59',
	@estado_cuenta = 1
GO

--TEST 2.4: Usuario vacio
EXEC socios.ActualizarCuentaSocio
	@dni = 11777888,
	@contrasena = '12345$a',
	@usuario = '',
	@rol = 2,
	@saldo = 0,
	@fecha_vigencia_contrasena = '2026-06-30 23:59:59',
	@estado_cuenta = 1
GO

--TEST 2.5: Rol invalido
EXEC socios.ActualizarCuentaSocio
	@dni = 11777888,
	@contrasena = '12345$a',
	@usuario = 'socioPruebaCuenta123',
	@rol = 8,
	@saldo = 0,
	@fecha_vigencia_contrasena = '2026-06-30 23:59:59',
	@estado_cuenta = 1
GO

--TEST 2.6: Fecha de vigencia de contraseña invalida
EXEC socios.ActualizarCuentaSocio
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
SELECT * FROM socios.CuentasSocios
EXEC socios.EliminarCuentaSocio
	@dni = 11777888
SELECT * FROM socios.CuentasSocios
GO

--TEST 3.2: DNI invalido
EXEC socios.EliminarCuentaSocio
	@dni = 9999999
GO

--Pagos

USE Com2900G07
GO

--Agregamos un usuario, factura y medio de pago para testear
EXEC socios.CrearPrestadorSalud
    @nombre = 'Galeno_test_pago',
    @telefono = '46254016'

DECLARE @id_prestador_salud_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM socios.PrestadoresSalud
WHERE nombre = 'Galeno_test_pago';

EXEC socios.CrearSocio
	@nro_socio = 0020,
    @dni = 11333555,
    @nombre = 'Socio',
    @apellido = 'Prueba Pago',
    @email = 'socio_prueba_pago@sol.com',
    @fecha_nacimiento = '2002-11-26',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @nro_socio_obra_social = '9972',
    @id_prestador_salud = @id_prestador_salud_test

EXEC administracion.CrearFacturaARCA
    @dni = 11333555,
    @descripcion = 'Factura de prueba de pago',
    @total = 10000,
    @tipo = 'A',
    @primer_vencimiento = '2025-10-15',
    @segundo_vencimiento = '2025-10-30',
    @recargo = 5


EXEC administracion.CrearMedioPago
    @Nombre = 'Tarjeta de Crédito',
    @Descripcion = 'Pago con tarjeta de crédito'
GO

--INSERCION

--TEST 1.1: Insercion correcta
DECLARE @numero_factura_test INT
DECLARE @id_medio_pago_test INT

SELECT @numero_factura_test = numero_factura
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(11333555) AND descripcion = 'Factura de prueba de pago'

SELECT @id_medio_pago_test = id_medio_pago
FROM administracion.MediosPago
WHERE nombre = 'Tarjeta de Crédito'

SELECT * FROM administracion.Pagos
EXEC administracion.CrearPago
	@numero_factura = @numero_factura_test,
	@id_medio_pago = @id_medio_pago_test,
	@fecha = '2025-06-30 16:45:29',
	@total = 1000,
	@reembolso = 100
SELECT * FROM administracion.Pagos
GO

--TEST 1.2: Factura inexistente
DECLARE @id_medio_pago_test INT

SELECT @id_medio_pago_test = id_medio_pago
FROM administracion.MediosPago
WHERE nombre = 'Tarjeta de Crédito'

EXEC administracion.CrearPago
	@numero_factura = 99999,
	@id_medio_pago = @id_medio_pago_test,
	@fecha = '2025-06-30 16:45:29',
	@total = 1000,
	@reembolso = 100
GO

--TEST 1.3: Medio de apgo inexistente
DECLARE @numero_factura_test INT

SELECT @numero_factura_test = numero_factura
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(11333555) AND descripcion = 'Factura de prueba de pago'

EXEC administracion.CrearPago
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
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(11333555) AND descripcion = 'Factura de prueba de pago'

SELECT @id_medio_pago_test = id_medio_pago
FROM administracion.MediosPago
WHERE nombre = 'Tarjeta de Crédito'

EXEC administracion.CrearPago
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
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(11333555) AND descripcion = 'Factura de prueba de pago'

SELECT @id_medio_pago_test = id_medio_pago
FROM administracion.MediosPago
WHERE nombre = 'Tarjeta de Crédito'

EXEC administracion.CrearPago
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
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(11333555) AND descripcion = 'Factura de prueba de pago'

SELECT @id_medio_pago_test = id_medio_pago
FROM administracion.MediosPago
WHERE nombre = 'Tarjeta de Crédito'

SELECT * FROM administracion.Pagos
EXEC administracion.ActualizarPago
	@numero_factura = @numero_factura_test,
	@id_medio_pago = @id_medio_pago_test,
	@fecha = '2025-06-30 16:45:29',
	@total = 1500,
	@reembolso = 150
SELECT * FROM administracion.Pagos
GO

--TEST 2.2: Factura inexistente
DECLARE @id_medio_pago_test INT

SELECT @id_medio_pago_test = id_medio_pago
FROM administracion.MediosPago
WHERE nombre = 'Tarjeta de Crédito'

EXEC administracion.ActualizarPago
	@numero_factura = 99999,
	@id_medio_pago = @id_medio_pago_test,
	@fecha = '2025-06-30 16:45:29',
	@total = 1000,
	@reembolso = 100
GO

--TEST 2.3: Medio de pago inexistente
DECLARE @numero_factura_test INT

SELECT @numero_factura_test = numero_factura
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(11333555) AND descripcion = 'Factura de prueba de pago'

EXEC administracion.ActualizarPago
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
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(11333555) AND descripcion = 'Factura de prueba de pago'

SELECT @id_medio_pago_test = id_medio_pago
FROM administracion.MediosPago
WHERE nombre = 'Tarjeta de Crédito'

EXEC administracion.ActualizarPago
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
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(11333555) AND descripcion = 'Factura de prueba de pago'

SELECT @id_medio_pago_test = id_medio_pago
FROM administracion.MediosPago
WHERE nombre = 'Tarjeta de Crédito'

EXEC administracion.ActualizarPago
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
EXEC socios.CrearPrestadorSalud
    @nombre = 'Galeno_test_reembolso',
    @telefono = '46254016'

DECLARE @id_prestador_salud_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM socios.PrestadoresSalud
WHERE nombre = 'Galeno_test_reembolso';

EXEC socios.CrearSocio
	@nro_socio = 0021,
    @dni = 11444666,
    @nombre = 'Socio',
    @apellido = 'Prueba Reembolso',
    @email = 'socio_prueba_reembolso@sol.com',
    @fecha_nacimiento = '2002-11-26',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @nro_socio_obra_social = '9971',
    @id_prestador_salud = @id_prestador_salud_test

EXEC administracion.CrearFacturaARCA
    @dni = 11444666,
    @descripcion = 'Factura de prueba de reembolso',
    @total = 10000,
    @tipo = 'A',
    @primer_vencimiento = '2025-10-15',
    @segundo_vencimiento = '2025-10-30',
    @recargo = 5


EXEC administracion.CrearMedioPago
    @Nombre = 'Tarjeta de Crédito',
    @Descripcion = 'Pago con tarjeta de crédito'

DECLARE @numero_factura_test INT
DECLARE @id_medio_pago_test INT

SELECT @numero_factura_test = numero_factura
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(11444666) AND descripcion = 'Factura de prueba de reembolso'

SELECT @id_medio_pago_test = id_medio_pago
FROM administracion.MediosPago
WHERE nombre = 'Tarjeta de Crédito'

EXEC administracion.CrearPago
	@numero_factura = @numero_factura_test,
	@id_medio_pago = @id_medio_pago_test,
	@fecha = '2025-06-30 16:45:29',
	@total = 1000,
	@reembolso = 100

EXEC socios.CrearCuentaSocio
	@dni = 11444666,
	@contrasena = '12345$a',
	@usuario = 'socioPruebaReembolso',
	@rol = 1,
	@saldo = 0,
	@fecha_vigencia_contrasena = '2026-06-30 23:59:59',
	@estado_cuenta = 1

EXEC administracion.CrearAdministrador
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
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(11444666) AND descripcion = 'Factura de prueba de reembolso'

SELECT @id_pago_test = id_pago
FROM administracion.Pagos
WHERE numero_factura = @numero_factura_test

SELECT * FROM administracion.Reembolsos
EXEC administracion.CrearReembolso
	@id_pago = @id_pago_test,
	@dni_socio = 11444666,
	@dni_admin = 22444666,
	@motivo = 'Porque si',
	@fecha = '2025-06-30 17:32:45',
	@monto = 150
SELECT * FROM administracion.Reembolsos
GO

--TEST 1.2: ID pago invalido
EXEC administracion.CrearReembolso
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
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(11444666) AND descripcion = 'Factura de prueba de reembolso'

SELECT @id_pago_test = id_pago
FROM administracion.Pagos
WHERE numero_factura = @numero_factura_test

EXEC administracion.CrearReembolso
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
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(11444666) AND descripcion = 'Factura de prueba de reembolso'

SELECT @id_pago_test = id_pago
FROM administracion.Pagos
WHERE numero_factura = @numero_factura_test

EXEC administracion.CrearReembolso
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
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(11444666) AND descripcion = 'Factura de prueba de reembolso'

SELECT @id_pago_test = id_pago
FROM administracion.Pagos
WHERE numero_factura = @numero_factura_test

EXEC administracion.CrearReembolso
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
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(11444666) AND descripcion = 'Factura de prueba de reembolso'

SELECT @id_pago_test = id_pago
FROM administracion.Pagos
WHERE numero_factura = @numero_factura_test

EXEC administracion.CrearReembolso
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
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(11444666) AND descripcion = 'Factura de prueba de reembolso'

SELECT @id_pago_test = id_pago
FROM administracion.Pagos
WHERE numero_factura = @numero_factura_test

SELECT @id_reembolso_test = id_reembolso
FROM administracion.Reembolsos
WHERE id_pago = @id_pago_test

SELECT * FROM administracion.Reembolsos
EXEC administracion.ActualizarReembolso
	@id_reembolso = @id_reembolso_test,
	@id_pago = @id_pago_test,
	@dni_socio = 11444666,
	@dni_admin = 22444666,
	@motivo = 'Porque si y listo',
	@fecha = '2025-06-30 17:32:45',
	@monto = 200
SELECT * FROM administracion.Reembolsos
GO

--TEST 2.2: ID reembolso invalido
DECLARE @id_pago_test INT
DECLARE @numero_factura_test INT

SELECT @numero_factura_test = numero_factura
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(11444666) AND descripcion = 'Factura de prueba de reembolso'

SELECT @id_pago_test = id_pago
FROM administracion.Pagos
WHERE numero_factura = @numero_factura_test


EXEC administracion.ActualizarReembolso
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
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(11444666) AND descripcion = 'Factura de prueba de reembolso'

SELECT @id_pago_test = id_pago
FROM administracion.Pagos
WHERE numero_factura = @numero_factura_test

SELECT @id_reembolso_test = id_reembolso
FROM administracion.Reembolsos
WHERE id_pago = @id_pago_test

EXEC administracion.ActualizarReembolso
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
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(11444666) AND descripcion = 'Factura de prueba de reembolso'

SELECT @id_pago_test = id_pago
FROM administracion.Pagos
WHERE numero_factura = @numero_factura_test

SELECT @id_reembolso_test = id_reembolso
FROM administracion.Reembolsos
WHERE id_pago = @id_pago_test

EXEC administracion.ActualizarReembolso
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
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(11444666) AND descripcion = 'Factura de prueba de reembolso'

SELECT @id_pago_test = id_pago
FROM administracion.Pagos
WHERE numero_factura = @numero_factura_test

SELECT @id_reembolso_test = id_reembolso
FROM administracion.Reembolsos
WHERE id_pago = @id_pago_test

EXEC administracion.ActualizarReembolso
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
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(11444666) AND descripcion = 'Factura de prueba de reembolso'

SELECT @id_pago_test = id_pago
FROM administracion.Pagos
WHERE numero_factura = @numero_factura_test

SELECT @id_reembolso_test = id_reembolso
FROM administracion.Reembolsos
WHERE id_pago = @id_pago_test

EXEC administracion.ActualizarReembolso
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
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(11444666) AND descripcion = 'Factura de prueba de reembolso'

SELECT @id_pago_test = id_pago
FROM administracion.Pagos
WHERE numero_factura = @numero_factura_test

SELECT @id_reembolso_test = id_reembolso
FROM administracion.Reembolsos
WHERE id_pago = @id_pago_test

EXEC administracion.ActualizarReembolso
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
FROM administracion.FacturasARCA
WHERE id_socio = socios.BuscarSocio(11444666) AND descripcion = 'Factura de prueba de reembolso'

SELECT @id_pago_test = id_pago
FROM administracion.Pagos
WHERE numero_factura = @numero_factura_test

SELECT @id_reembolso_test = id_reembolso
FROM administracion.Reembolsos
WHERE id_pago = @id_pago_test

SELECT * FROM administracion.Reembolsos
EXEC administracion.EliminarReembolso
	@id_reembolso = @id_reembolso_test
SELECT * FROM administracion.Reembolsos
GO

--TEST 3.2: ID reembolso invalido
EXEC administracion.EliminarReembolso
	@id_reembolso = 99999


--Asistencias clases

USE Com2900G07
GO

--Agregamos un socio y clase para testear
EXEC actividades.CrearDeporte
    @nombre = 'Futbol_test_asistencia',
    @precio = 1000

DECLARE @id_deporte_test INT;

SELECT @id_deporte_test = id_deporte
FROM actividades.Deportes
WHERE nombre = 'Futbol_test_asistencia';

EXEC actividades.CrearClase
    @id_deporte = @id_deporte_test

EXEC socios.CrearPrestadorSalud
    @nombre = 'Galeno_test_asistencia',
    @telefono = '46254016'

DECLARE @id_prestador_salud_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM socios.PrestadoresSalud
WHERE nombre = 'Galeno_test_asistencia';

EXEC socios.CrearSocio
	@nro_socio = 0022,
    @dni = 55666777,
    @nombre = 'Socio',
    @apellido = 'Prueba Asistencia',
    @email = 'socio_prueba_asistencia@sol.com',
    @fecha_nacimiento = '2002-11-26',
    @telefono = 1566667777,
    @telefono_emergencia = 48881122,
    @nro_socio_obra_social = '9970',
    @id_prestador_salud = @id_prestador_salud_test
GO

--INSERCION

--TEST 1.1: Insercion correcta
DECLARE @id_clase_test INT
DECLARE @id_deporte_test INT;

SELECT @id_deporte_test = id_deporte
FROM actividades.Deportes
WHERE nombre = 'Futbol_test_asistencia';

SELECT @id_clase_test = id_clase
FROM actividades.Clases
WHERE id_deporte = @id_deporte_test

SELECT * FROM actividades.AsistenciasClase
EXEC actividades.CrearAsistenciaClase
	@dni_socio = 55666777,
	@id_clase = @id_clase_test,
	@presente = 1,
	@fecha = '2025-06-10 17:00:00'
SELECT * FROM actividades.AsistenciasClase
GO

--TEST 1.2: DNI invalido
DECLARE @id_clase_test INT
DECLARE @id_deporte_test INT;

SELECT @id_deporte_test = id_deporte
FROM actividades.Deportes
WHERE nombre = 'Futbol_test_asistencia';

SELECT @id_clase_test = id_clase
FROM actividades.Clases
WHERE id_deporte = @id_deporte_test

EXEC actividades.CrearAsistenciaClase
	@dni_socio = 99999999,
	@id_clase = @id_clase_test,
	@presente = 1,
	@fecha = '2025-06-10 17:00:00'
GO

--TEST 1.3: ID clase invalido
DECLARE @id_clase_test INT
DECLARE @id_deporte_test INT;

SELECT @id_deporte_test = id_deporte
FROM actividades.Deportes
WHERE nombre = 'Futbol_test_asistencia';

SELECT @id_clase_test = id_clase
FROM actividades.Clases
WHERE id_deporte = @id_deporte_test

EXEC actividades.CrearAsistenciaClase
	@dni_socio = 55666777,
	@id_clase = 99999,
	@presente = 1,
	@fecha = '2025-06-10 17:00:00'
GO

--TEST 1.4: Fecha invalida
DECLARE @id_clase_test INT
DECLARE @id_deporte_test INT;

SELECT @id_deporte_test = id_deporte
FROM actividades.Deportes
WHERE nombre = 'Futbol_test_asistencia';

SELECT @id_clase_test = id_clase
FROM actividades.Clases
WHERE id_deporte = @id_deporte_test

EXEC actividades.CrearAsistenciaClase
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
FROM actividades.Deportes
WHERE nombre = 'Futbol_test_asistencia';

SELECT @id_clase_test = id_clase
FROM actividades.Clases
WHERE id_deporte = @id_deporte_test

SELECT @id_asistencia_test = id_asistencia
FROM actividades.AsistenciasClase
WHERE id_clase = @id_clase_test AND id_socio = socios.BuscarSocio(55666777) AND CAST(fecha AS DATE) = '2025-06-10'

SELECT * FROM actividades.AsistenciasClase WHERE id_asistencia = @id_asistencia_test
EXEC actividades.ActualizarAsistenciaClase
	@id_asistencia = @id_asistencia_test,
	@dni_socio = 55666777,
	@id_clase = @id_clase_test,
	@presente = 0,
	@fecha = '2025-06-10 17:00:00'
SELECT * FROM actividades.AsistenciasClase WHERE id_asistencia = @id_asistencia_test
GO

--TEST 2.2: ID asistencia invalido
DECLARE @id_clase_test INT
DECLARE @id_deporte_test INT;
DECLARE @id_asistencia_test INT

SELECT @id_deporte_test = id_deporte
FROM actividades.Deportes
WHERE nombre = 'Futbol_test_asistencia';

SELECT @id_clase_test = id_clase
FROM actividades.Clases
WHERE id_deporte = @id_deporte_test

SELECT @id_asistencia_test = id_asistencia
FROM actividades.AsistenciasClase
WHERE id_clase = @id_clase_test AND id_socio = socios.BuscarSocio(55666777) AND CAST(fecha AS DATE) = '2025-06-10'

EXEC actividades.ActualizarAsistenciaClase
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
FROM actividades.Deportes
WHERE nombre = 'Futbol_test_asistencia';

SELECT @id_clase_test = id_clase
FROM actividades.Clases
WHERE id_deporte = @id_deporte_test

SELECT @id_asistencia_test = id_asistencia
FROM actividades.AsistenciasClase
WHERE id_clase = @id_clase_test AND id_socio = socios.BuscarSocio(55666777) AND CAST(fecha AS DATE) = '2025-06-10'

EXEC actividades.ActualizarAsistenciaClase
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
FROM actividades.Deportes
WHERE nombre = 'Futbol_test_asistencia';

SELECT @id_clase_test = id_clase
FROM actividades.Clases
WHERE id_deporte = @id_deporte_test

SELECT @id_asistencia_test = id_asistencia
FROM actividades.AsistenciasClase
WHERE id_clase = @id_clase_test AND id_socio = socios.BuscarSocio(55666777) AND CAST(fecha AS DATE) = '2025-06-10'

EXEC actividades.ActualizarAsistenciaClase
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
FROM actividades.Deportes
WHERE nombre = 'Futbol_test_asistencia';

SELECT @id_clase_test = id_clase
FROM actividades.Clases
WHERE id_deporte = @id_deporte_test

SELECT @id_asistencia_test = id_asistencia
FROM actividades.AsistenciasClase
WHERE id_clase = @id_clase_test AND id_socio = socios.BuscarSocio(55666777) AND CAST(fecha AS DATE) = '2025-06-10'

EXEC actividades.ActualizarAsistenciaClase
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
FROM actividades.Deportes
WHERE nombre = 'Futbol_test_asistencia';

SELECT @id_clase_test = id_clase
FROM actividades.Clases
WHERE id_deporte = @id_deporte_test

SELECT @id_asistencia_test = id_asistencia
FROM actividades.AsistenciasClase
WHERE id_clase = @id_clase_test AND id_socio = socios.BuscarSocio(55666777) AND CAST(fecha AS DATE) = '2025-06-10'

SELECT * FROM actividades.AsistenciasClase WHERE id_asistencia = @id_asistencia_test
EXEC actividades.EliminarAsistenciaClase
	@id_asistencia = @id_asistencia_test
SELECT * FROM actividades.AsistenciasClase WHERE id_asistencia = @id_asistencia_test
GO

--TEST 3.2: ID asistencia invalido
EXEC actividades.EliminarAsistenciaClase
	@id_asistencia = 99999
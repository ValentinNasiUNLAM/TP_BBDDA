--ACTIVIDADES EXTRA
--Se crean los TESTS para la insercion, actualizacion y eliminacion de ACTIVIDADES EXTRA

USE Com2900G07
GO

--Agregamos un socio y un invitado para testear
EXEC spInsercion.CrearPrestadorSalud
    @nombre = 'Galeno_test_act_extra',
    @tipo = 1,
    @telefono = 46254016

DECLARE @id_prestador_salud_test INT;

SELECT @id_prestador_salud_test = id_prestador_salud
FROM tabla.PrestadoresSalud
WHERE nombre = 'Galeno_test_act_extra';

EXEC spInsercion.CrearSocio
    @dni = 44555666,
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


--ELIMINACION
--ACTIVIDADES EXTRA
--Se crean los TESTS para la insercion, actualizacion y eliminacion de ACTIVIDADES EXTRA

USE Com2900G07
GO

--INSERCION
--TEST 1.1: INSERCCION CORRECTA
EXEC spInsercion.CrearActividadExtra
    @dni = 23777221,
    @dni_invitado = 23777220,
    @tipo_actividad = 1,
    @fecha = '2023-10-01',
    @fecha_reserva = '2023-09-30',
    @monto = 1000,
    @monto_invitado = 500,
    @lluvia = 0
GO
--TEST 1.2: INSERCCION CON DNI INVITADO NO EXISTENTE
EXEC spInsercion.CrearActividadExtra
    @dni = 23777221,
    @dni_invitado = 99999999, -- DNI no existente
    @tipo_actividad = 1,
    @fecha = '2023-10-01',
    @fecha_reserva = '2023-09-30',
    @monto = 1000,
    @monto_invitado = 500,
    @lluvia = 0
GO
--TEST 1.3: INSERCCION CON TIPO DE ACTIVIDAD NO EXISTENTE
EXEC spInsercion.CrearActividadExtra
    @dni = 23777221,
    @dni_invitado = 23777220,
    @tipo_actividad = 999, -- Tipo de actividad no existente
    @fecha = '2023-10-01',
    @fecha_reserva = '32023-09-0',
    @monto = 1000,
    @monto_invitado = 500,
    @lluvia = 0
GO
--TEST 1.4: INSERCCION CON FECHA RESERVA ANTERIOR A LA FECHA DE ACTIVIDAD
EXEC spInsercion.CrearActividadExtra
    @dni = 23777221,
    @dni_invitado = 23777220,
    @tipo_actividad = 1,
    @fecha = '2023-10-01',
    @fecha_reserva = '2023-10-29', -- Fecha de reserva anterior a la fecha de actividad
    @monto = 1000,
    @monto_invitado = 500,
    @lluvia = 0
GO
--TEST 1.5: INSERCCION CON MONTO NEGATIVO
EXEC spInsercion.CrearActividadExtra
    @dni = 23777221,
    @dni_invitado = 23777220,
    @tipo_actividad = 1,
    @fecha = '2023-10-01',
    @fecha_reserva = '2023-09-30',
    @monto = -1000, -- Monto negativo
    @monto_invitado = 500,
    @lluvia = 0
GO
--TEST 1.6: INSERCCION CON MONTO INVITADO NEGATIVO
EXEC spInsercion.CrearActividadExtra
    @dni = 23777221,
    @dni_invitado = 23777220,
    @tipo_actividad = 1,
    @fecha = '2023-10-01',
    @fecha_reserva = '2023-09-30',
    @monto = 1000,
    @monto_invitado = -500, -- Monto invitado negativo
    @lluvia = 0
GO
--TEST 1.7: INSERCCION CON LLUVIA NO VÁLIDA
EXEC spInsercion.CrearActividadExtra
    @dni = 23777221,
    @dni_invitado = 23777220,
    @tipo_actividad = 1,
    @fecha = '2023-10-01',
    @fecha_reserva = '2023-09-30',
    @monto = 1000,
    @monto_invitado = 500,
    @lluvia = 2 -- Valor de lluvia no válido
GO
--ACTUALIZACION
--TEST 2.1: ACTUALIZACION CORRECTA
EXEC spActualizacion.ActualizarActividadExtra
    @id_actividad = 1, -- ID de la actividad a actualizar
    @dni = 23777221,
    @dni_invitado = 23777220,
    @tipo_actividad = 1,
    @fecha = '2023-10-01',
    @fecha_reserva = '2023-09-30',
    @monto = 1200, -- Nuevo monto
    @monto_invitado = 600, -- Nuevo monto invitado
    @lluvia = 0
GO
--TEST 2.2: ACTUALIZACION CON ID DE ACTIVIDAD NO EXISTENTE
EXEC spActualizacion.ActualizarActividadExtra
    @id_actividad = 999, -- ID de actividad no existente
    @dni = 23777221,
    @dni_invitado = 23777220,
    @tipo_actividad = 1,
    @fecha = '2023-10-01',
    @fecha_reserva = '2023-09-30',
    @monto = 1200,
    @monto_invitado = 600,
    @lluvia = 0
GO
--TEST 2.3: ACTUALIZACION CON DNI INVITADO NO EXISTENTE
EXEC spActualizacion.ActualizarActividadExtra
    @id_actividad = 1,
    @dni = 23777221,
    @dni_invitado = 99999999, -- DNI no existente
    @tipo_actividad = 1,
    @fecha = '2023-10-01',
    @fecha_reserva = '2023-09-30',
    @monto = 1200,
    @monto_invitado = 600,
    @lluvia = 0
GO
--TEST 2.4: ACTUALIZACION CON TIPO DE ACTIVIDAD NO EXISTENTE
EXEC spActualizacion.ActualizarActividadExtra
    @id_actividad = 1,
    @dni = 23777221,
    @dni_invitado = 23777220,
    @tipo_actividad = 999, -- Tipo de actividad no existente
    @fecha = '2023-10-01',
    @fecha_reserva = '2023-09-30',
    @monto = 1200,
    @monto_invitado = 600,
    @lluvia = 0
GO
--TEST 2.5: ACTUALIZACION CON FECHA RESERVA ANTERIOR A LA FECHA DE ACTIVIDAD
EXEC spActualizacion.ActualizarActividadExtra
    @id_actividad = 1,
    @dni = 23777221,
    @dni_invitado = 23777220,
    @tipo_actividad = 1,
    @fecha = '2023-10-01',
    @fecha_reserva = '2023-10-29', -- Fecha de reserva anterior a la fecha de actividad
    @monto = 1200,
    @monto_invitado = 600,
    @lluvia = 0
GO
--TEST 2.6: ACTUALIZACION CON MONTO NEGATIVO
EXEC spActualizacion.ActualizarActividadExtra
    @id_actividad = 1,
    @dni = 23777221,
    @dni_invitado = 23777220,
    @tipo_actividad = 1,
    @fecha = '2023-10-01',
    @fecha_reserva = '2023-09-30',
    @monto = -1200, -- Monto negativo
    @monto_invitado = 600,
    @lluvia = 0
GO
--TEST 2.7: ACTUALIZACION CON MONTO INVITADO NEGATIVO
EXEC spActualizacion.ActualizarActividadExtra
    @id_actividad = 1,
    @dni = 23777221,
    @dni_invitado = 23777220,
    @tipo_actividad = 1,
    @fecha = '2023-10-01',
    @fecha_reserva = '2023-09-30',
    @monto = 1200,
    @monto_invitado = -600, -- Monto invitado negativo
    @lluvia = 0
GO
--TEST 2.8: ACTUALIZACION CON LLUVIA NO VÁLIDA
EXEC spActualizacion.ActualizarActividadExtra
    @id_actividad = 1,
    @dni = 23777221,
    @dni_invitado = 23777220,
    @tipo_actividad = 1,
    @fecha = '2023-10-01',
    @fecha_reserva = '2023-09-30',
    @monto = 1200,
    @monto_invitado = 600,
    @lluvia = 2 -- Valor de lluvia no válido
GO
--ELIMINACION
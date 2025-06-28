
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'Com2900G07')
BEGIN
    CREATE DATABASE Com2900G07;
END;
GO
USE Com2900G07
GO
--DROP DATABASE Com2900G07

--ESQUEMAS

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'tabla')
BEGIN
    EXEC('CREATE SCHEMA tabla')
END

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'spInsercion')
BEGIN
    EXEC('CREATE SCHEMA spInsercion')
END

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'spActualizacion')
BEGIN
    EXEC('CREATE SCHEMA spActualizacion')
END

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'spEliminacion')
BEGIN
    EXEC('CREATE SCHEMA spEliminacion')
END

--TABLAS

IF NOT EXISTS (
    SELECT * FROM sys.tables 
    WHERE name = 'Categorias' 
    AND schema_id = SCHEMA_ID('tabla')
)
BEGIN
	CREATE TABLE tabla.Categorias(
		id_categoria INT PRIMARY KEY IDENTITY(1,1),
		nombre_categoria VARCHAR(15),
		edad_min TINYINT,
		edad_max TINYINT,
		precio_mensual INT,
		--CONSTRAINTS
		CONSTRAINT chk_rango_edades_categoria CHECK (edad_min <= edad_max),
		CONSTRAINT chk_precio_mensual_categoria CHECK (precio_mensual >= 0)
	)
END
GO

IF NOT EXISTS (
    SELECT * FROM sys.tables 
    WHERE name = 'PrestadoresSalud' 
    AND schema_id = SCHEMA_ID('tabla')
)
BEGIN
	CREATE TABLE tabla.PrestadoresSalud(
		id_socio_prestador_salud INT PRIMARY KEY IDENTITY(1,1),
		tipo TINYINT,
		nombre VARCHAR(50),
		telefono INT,
	)
END
GO

IF NOT EXISTS (
    SELECT * FROM sys.tables 
    WHERE name = 'Administradores' 
    AND schema_id = SCHEMA_ID('tabla')
)
BEGIN
	CREATE TABLE tabla.Administradores(
		id_admin INT PRIMARY KEY IDENTITY(1,1),
		nombre VARCHAR(30),
		apellido VARCHAR(30),
		dni INT UNIQUE,
		email VARCHAR(30) UNIQUE,
		rol TINYINT,
		estado BIT DEFAULT(1),
		--CONSTRAINTS
		CONSTRAINT chk_dni_admin CHECK (dni > 3000000 AND dni < 99999999),
		CONSTRAINT chk_email_admin CHECK (
			CHARINDEX('@', email) > 1 AND 
			CHARINDEX('.', email, CHARINDEX('@', email)) > CHARINDEX('@', email) + 1
		),
	)
END
GO

IF NOT EXISTS (
    SELECT * FROM sys.tables 
    WHERE name = 'MediosPago' 
    AND schema_id = SCHEMA_ID('tabla')
)
BEGIN
	CREATE TABLE tabla.MediosPago(
		id_medio_pago INT PRIMARY KEY IDENTITY(1,1),
		nombre VARCHAR(50),
		descripcion VARCHAR(50),
		habilitado BIT DEFAULT(1),
	)
END
GO

IF NOT EXISTS (
    SELECT * FROM sys.tables 
    WHERE name = 'Deportes' 
    AND schema_id = SCHEMA_ID('tabla')
)
BEGIN
	CREATE TABLE tabla.Deportes(
		id_deporte INT PRIMARY KEY IDENTITY(1,1),
		nombre VARCHAR(50),
		precio INT,
		estado BIT DEFAULT(1),
		--CONSTRAINTS
		CONSTRAINT chk_precio_deporte CHECK (precio > 0)
	)
END
GO

IF NOT EXISTS (
    SELECT * FROM sys.tables 
    WHERE name = 'Invitados' 
    AND schema_id = SCHEMA_ID('tabla')
)
BEGIN
	CREATE TABLE tabla.Invitados(
		id_invitado INT PRIMARY KEY IDENTITY(1,1),
		dni INT UNIQUE,
		nombre VARCHAR(30),
		apellido VARCHAR(30),
		--CONSTRAINTS
		CONSTRAINT chk_dni_invitado CHECK (dni > 3000000 AND dni < 99999999)
	)
END
GO

IF NOT EXISTS (
    SELECT * FROM sys.tables 
    WHERE name = 'Clases' 
    AND schema_id = SCHEMA_ID('tabla')
)
BEGIN
	CREATE TABLE tabla.Clases(
		id_clase INT PRIMARY KEY IDENTITY(1,1),
		id_deporte INT NOT NULL,
		--CONSTRAINTS
		CONSTRAINT fk_id_deporte_clase FOREIGN KEY (id_deporte) REFERENCES tabla.Deportes(id_deporte)
	)
END
GO

IF NOT EXISTS (
    SELECT * FROM sys.tables 
    WHERE name = 'Turnos' 
    AND schema_id = SCHEMA_ID('tabla')
)
BEGIN
	CREATE TABLE tabla.Turnos(
		id_turno INT PRIMARY KEY IDENTITY(1,1),
		id_clase INT NOT NULL,
		dia TINYINT,
		hora_inicio TIME,
		hora_fin TIME,
		--CONSTRAINTS
		CONSTRAINT fk_id_clase_turno FOREIGN KEY (id_clase) REFERENCES tabla.Clases(id_clase),
		CONSTRAINT chk_dia_turno CHECK (dia >= 1 AND dia <=7),
		CONSTRAINT chk_rango_horas_turno CHECK (hora_fin > hora_inicio)
	)
END
GO

IF NOT EXISTS (
    SELECT * FROM sys.tables 
    WHERE name = 'Socios' 
    AND schema_id = SCHEMA_ID('tabla')
)
BEGIN
	CREATE TABLE tabla.Socios(
		id_socio INT PRIMARY KEY IDENTITY(1,1),
		dni INT UNIQUE,
		nombre VARCHAR(30),
		apellido VARCHAR(30),
		email VARCHAR(50) UNIQUE,
		fecha_nacimiento DATE,
		telefono INT,
		telefono_emergencia INT,
		estado BIT DEFAULT(1),
		id_socio_prestador_salud INT NOT NULL,
		id_tutor INT NULL,
		id_grupo_familiar INT NULL,
		--CONSTRAINTS
		CONSTRAINT chk_dni_socio CHECK (dni > 3000000 AND dni < 99999999),
		CONSTRAINT chk_email_socio CHECK (
			CHARINDEX('@', email) > 1 AND 
			CHARINDEX('.', email, CHARINDEX('@', email)) > CHARINDEX('@', email) + 1),
		CONSTRAINT chk_fecha_nacimiento_no_futuro_socio CHECK (fecha_nacimiento <= CAST(GETDATE() AS DATE)),
		CONSTRAINT fk_prestador_socio FOREIGN KEY (id_socio_prestador_salud) REFERENCES tabla.PrestadoresSalud(id_socio_prestador_salud),
		CONSTRAINT fk_tutor_socio FOREIGN KEY (id_tutor) REFERENCES tabla.Socios(id_socio),
		CONSTRAINT fk_grupo_familiar_socio FOREIGN KEY (id_grupo_familiar) REFERENCES tabla.Socios(id_socio)
	)
END
GO

IF NOT EXISTS (
    SELECT * FROM sys.tables 
    WHERE name = 'Cuotas' 
    AND schema_id = SCHEMA_ID('tabla')
)
BEGIN
	CREATE TABLE tabla.Cuotas(
		id_cuota INT PRIMARY KEY IDENTITY(1,1),
		id_categoria INT NOT NULL,
		id_socio INT NOT NULL,
		--CONSTRAINTS
		CONSTRAINT fk_id_categoria_cuota FOREIGN KEY (id_categoria) REFERENCES tabla.Categorias(id_categoria),
		CONSTRAINT fk_id_socio_cuota FOREIGN KEY (id_socio) REFERENCES tabla.Socios(id_socio)
	)
END
GO

IF NOT EXISTS (
    SELECT * FROM sys.tables 
    WHERE name = 'Actividades' 
    AND schema_id = SCHEMA_ID('tabla')
)
BEGIN
	CREATE TABLE tabla.Actividades(
		id_actividad INT PRIMARY KEY IDENTITY(1,1),
		id_socio INT NOT NULL,
		id_deporte INT NOT NULL,
		 --CONSTRAINT
		CONSTRAINT fk_id_socio_actividad FOREIGN KEY (id_socio) REFERENCES tabla.Socios(id_socio),
		CONSTRAINT fk_id_deporte_actividad FOREIGN KEY (id_deporte) REFERENCES tabla.Deportes(id_deporte)
	)
END
GO

IF NOT EXISTS (
    SELECT * FROM sys.tables 
    WHERE name = 'ActividadesExtra' 
    AND schema_id = SCHEMA_ID('tabla')
)
BEGIN
	CREATE TABLE tabla.ActividadesExtra(
		id_actividad_extra INT PRIMARY KEY IDENTITY(1,1),
		id_socio INT NOT NULL,
		id_invitado INT NOT NULL,
		tipo_actividad TINYINT,
		fecha DATE,
		fecha_reserva DATETIME NULL,
		monto INT,
		monto_invitado INT NULL,
		lluvia BIT NULL,
		 --CONSTRAINTS
		CONSTRAINT fk_id_socio_actividadextra FOREIGN KEY (id_socio) REFERENCES tabla.Socios(id_socio),
		CONSTRAINT fk_id_invitado_actividadextra FOREIGN KEY (id_invitado) REFERENCES tabla.Invitados(id_invitado),
		CONSTRAINT chk_tipo_activado_actividadextra CHECK ( tipo_actividad >= 1 AND tipo_actividad <=5),
		CONSTRAINT chk_monto_actividadextra CHECK (monto > 0),
		CONSTRAINT chk_fecha_reserva CHECK (fecha_reserva < CAST(GETDATE() AS DATETIME))
	)
END
GO

IF NOT EXISTS (
    SELECT * FROM sys.tables 
    WHERE name = 'FacturasARCA' 
    AND schema_id = SCHEMA_ID('tabla')
)
BEGIN
	CREATE TABLE tabla.FacturasARCA(
		numero_factura INT PRIMARY KEY IDENTITY (1,1),
		id_socio INT NOT NULL,
		fecha_creacion DATETIME,
		descripcion VARCHAR(200),
		tipo CHAR(1),
		total INT,
		primer_vencimiento DATE,
		segundo_vencimiento DATE,
		recargo INT,
		--CONSTRAINTS
		CONSTRAINT fk_id_socio_facturaarca FOREIGN KEY (id_socio) REFERENCES tabla.Socios(id_socio),
		CONSTRAINT chk_tipo_facturaarca CHECK ( tipo = 'A' OR tipo = 'B' OR tipo = 'C' ),
		CONSTRAINT chk_monto_facturaarca CHECK (total > 0),
		CONSTRAINT chk_segundo_vencimiento_facturaarca CHECK ( segundo_vencimiento > primer_vencimiento),
		CONSTRAINT chk_recargo_facturaarca CHECK (recargo >= 0),
		CONSTRAINT chk_fecha_creacion CHECK (fecha_creacion < CAST(GETDATE() AS DATETIME))
	)
END
GO

IF NOT EXISTS (
    SELECT * FROM sys.tables 
    WHERE name = 'CargosSocio' 
    AND schema_id = SCHEMA_ID('tabla')
)
BEGIN
	CREATE TABLE tabla.CargosSocio(
		id_cargo_socio INT PRIMARY KEY IDENTITY (1,1),
		numero_factura INT NOT NULL,
		fecha_creacion DATETIME,
		descripcion VARCHAR(200),
		monto_descuento INT NULL,
		monto_total INT,
		id_actividad INT NULL,
		id_actividad_extra INT NULL,
		id_cuota INT NULL,
		--CONSTRAINTS
		CONSTRAINT chk_fecha_creacion_cargosocio CHECK (fecha_creacion <= CAST(GETDATE() AS DATETIME)),
		CONSTRAINT chk_descuento_cargosocio CHECK (monto_descuento >= 0),
		CONSTRAINT chk_monto_cargosocio CHECK (monto_total >= 0),
		CONSTRAINT chk_al_menos_un_item_cargosocio CHECK (
			id_actividad IS NOT NULL OR
			id_actividad_extra IS NOT NULL OR
			id_cuota IS NOT NULL
		),
		CONSTRAINT fk_id_actividad_cargosocio FOREIGN KEY (id_actividad) REFERENCES tabla.Actividades(id_actividad),
		CONSTRAINT fk_id_actividadesextra_cargosocio FOREIGN KEY (id_actividad_extra) REFERENCES tabla.ActividadesExtra(id_actividad_extra),
		CONSTRAINT fk_id_cuota_cargosocio FOREIGN KEY (id_cuota) REFERENCES tabla.Cuotas(id_cuota),
		CONSTRAINT fk_numero_factura_cargosocio FOREIGN KEY (numero_factura) REFERENCES tabla.FacturasARCA(numero_factura)
	)
END
GO

IF NOT EXISTS (
    SELECT * FROM sys.tables 
    WHERE name = 'Morosidades' 
    AND schema_id = SCHEMA_ID('tabla')
)
BEGIN
	CREATE TABLE tabla.Morosidades(
		id_morosidad INT PRIMARY KEY IDENTITY(1,1),
		numero_factura INT NOT NULL,
		monto_total INT,
		fecha_pago DATETIME,
		--CONSTRAINTS
		CONSTRAINT fk_numero_factura_morosidad FOREIGN KEY (numero_factura) REFERENCES tabla.FacturasARCA(numero_factura),
		CONSTRAINT chk_monto_total_morosidad CHECK (monto_total > 0)
	)
END
GO

IF NOT EXISTS (
    SELECT * FROM sys.tables 
    WHERE name = 'CuentasSocios' 
    AND schema_id = SCHEMA_ID('tabla')
)
BEGIN
	CREATE TABLE tabla.CuentasSocios(
		id_cuenta INT PRIMARY KEY IDENTITY(1,1),
		id_socio INT NOT NULL UNIQUE,
		contrasena VARCHAR(30),
		usuario VARCHAR(30),
		rol TINYINT,
		saldo INT,
		fecha_vigencia_contrasena DATETIME,
		estado_cuenta BIT,
		--CONSTRAINTS
		CONSTRAINT fk_id_socio_cuenta_socio FOREIGN KEY (id_socio) REFERENCES tabla.Socios(id_socio),
		CONSTRAINT chk_rol_cuenta_socio CHECK (rol >=0 AND rol <=5),
		CONSTRAINT chk_contrasena_no_vacia_cuenta_socio CHECK (LEN(contrasena) > 0),
		CONSTRAINT chk_fecha_vigencia_contrasena_cuenta_socio CHECK (fecha_vigencia_contrasena > CAST(GETDATE() AS DATETIME))
	)
END
GO

IF NOT EXISTS (
    SELECT * FROM sys.tables 
    WHERE name = 'Pagos' 
    AND schema_id = SCHEMA_ID('tabla')
)
BEGIN
	CREATE TABLE tabla.Pagos(
		id_pago INT PRIMARY KEY IDENTITY(1,1),
		numero_factura INT NOT NULL,
		id_medio_pago INT NOT NULL,
		fecha DATETIME,
		total INT,
		reembolso INT,
		tipo_movimiento TINYINT,
		--CONSTRAINTS
		CONSTRAINT fk_id_medio_pago_pago FOREIGN KEY (id_medio_pago) REFERENCES tabla.MediosPago(id_medio_pago),
		CONSTRAINT fk_numero_factura_pago FOREIGN KEY (numero_factura) REFERENCES tabla.FacturasARCA(numero_factura),
		CONSTRAINT chk_fecha_pago CHECK (fecha <= CAST(GETDATE() AS DATETIME))
	)
END
GO

IF NOT EXISTS (
    SELECT * FROM sys.tables 
    WHERE name = 'Reembolsos' 
    AND schema_id = SCHEMA_ID('tabla')
)
BEGIN
	CREATE TABLE tabla.Reembolsos(
		id_reembolso INT PRIMARY KEY IDENTITY(1,1),
		id_pago INT NOT NULL,
		id_cuenta INT NOT NULL,
		id_admin INT NOT NULL,
		motivo VARCHAR(200),
		fecha DATETIME,
		monto INT,
		--CONSTRAINTS
		CONSTRAINT fk_id_pago_reembolso FOREIGN KEY (id_pago) REFERENCES tabla.Pagos(id_pago),
		CONSTRAINT fk_id_cuenta_socio_reembolso FOREIGN KEY (id_cuenta) REFERENCES tabla.CuentasSocios(id_cuenta),
		CONSTRAINT fk_id_admin_reembolso FOREIGN KEY (id_admin) REFERENCES tabla.Administradores(id_admin),
		CONSTRAINT chk_fecha_reembolso CHECK (fecha <= CAST(GETDATE() AS DATETIME)),
		CONSTRAINT chk_monto_reembolso CHECK (monto > 0)
	)
END
GO

IF NOT EXISTS (
    SELECT * FROM sys.tables 
    WHERE name = 'AsistenciasClase' 
    AND schema_id = SCHEMA_ID('tabla')
)
BEGIN
	CREATE TABLE tabla.AsistenciasClase(
		id_asistencia INT PRIMARY KEY IDENTITY(1,1),
		id_socio INT NOT NULL,
		id_clase INT NOT NULL,
		presente BIT,
		fecha DATETIME,
		--CONSTRAINTS
		CONSTRAINT fk_id_socio_asistencia_clase FOREIGN KEY (id_socio) REFERENCES tabla.Socios(id_socio),
		CONSTRAINT fk_id_clase_asistencia_clase FOREIGN KEY (id_clase) REFERENCES tabla.Clases(id_clase),
		CONSTRAINT chk_fecha_asistencia_clase CHECK (fecha <= CAST(GETDATE() AS DATETIME))
	)
END
GO



--STORED PROCEDURES INSERCION 

CREATE PROCEDURE spInsercion.CrearCategoria 
	@nombre_categoria VARCHAR(15),
	@edad_min TINYINT,
	@edad_max TINYINT,
	@precio_mensual INT
AS
BEGIN
	INSERT INTO tabla.Categorias(nombre_categoria, edad_min, edad_max, precio_mensual)
	VALUES(@nombre_categoria, @edad_min, @edad_max, @precio_mensual)
END;
GO

CREATE PROCEDURE spInsercion.CrearPrestadorSalud
	@tipo TINYINT,
	@nombre VARCHAR(50),
	@telefono INT
AS 
BEGIN
	INSERT INTO tabla.PrestadoresSalud(tipo, nombre, telefono)
	VALUES(@tipo, @nombre, @telefono)
END;
GO

CREATE PROCEDURE spInsercion.CrearAdministrador
	@nombre VARCHAR(30),
	@apellido VARCHAR(30),
	@dni INT,
	@email VARCHAR(30),
	@rol TINYINT
AS 
BEGIN
	INSERT INTO tabla.Administradores(nombre, apellido, dni, email, rol)
	VALUES(@nombre, @apellido, @dni, @email, @rol)
END;
GO

CREATE PROCEDURE spInsercion.CrearMedioPago
	@nombre VARCHAR(50),
	@descripcion VARCHAR(50)
AS 
BEGIN
	INSERT INTO tabla.MediosPago(nombre, descripcion)
	VALUES(@nombre, @descripcion)
END;
GO

CREATE PROCEDURE spInsercion.CrearDeporte
	@nombre VARCHAR(50),
	@precio INT
AS 
BEGIN
	INSERT INTO tabla.Deportes(nombre, precio)
	VALUES(@nombre, @precio)
END;
GO

CREATE PROCEDURE spInsercion.CrearInvitado
	@dni INT ,
	@nombre VARCHAR(30),
	@apellido VARCHAR(30)
AS 
BEGIN
	INSERT INTO tabla.Invitados(dni, nombre, apellido)
	VALUES(@dni, @nombre, @apellido)
END;
GO

CREATE PROCEDURE spInsercion.CrearClase
	@id_clase INT,
	@id_deporte INT
AS 
BEGIN
	INSERT INTO tabla.Clases(id_clase, id_deporte)
	VALUES(@id_clase, @id_deporte)
END;
GO

CREATE PROCEDURE spInsercion.CrearTurno
	@id_clase INT,
	@dia TINYINT,
	@hora_inicio TIME,
	@hora_fin TIME
AS 
BEGIN
	INSERT INTO tabla.Turnos(id_clase, dia, hora_inicio, hora_fin)
	VALUES(@id_clase, @dia, @hora_inicio, @hora_fin)
END;
GO

CREATE PROCEDURE spInsercion.CrearSocio
    @dni INT,
    @nombre VARCHAR(30),
    @apellido VARCHAR(30),
    @email VARCHAR(50),
    @fecha_nacimiento DATE,
    @telefono INT,
    @telefono_emergencia INT,
    @id_socio_prestador_salud INT,
    @id_tutor INT = NULL,
    @id_grupo_familiar INT = NULL
AS
BEGIN
    INSERT INTO tabla.Socios(dni, nombre, apellido, email, fecha_nacimiento, telefono, 
		telefono_emergencia, id_socio_prestador_salud, id_tutor,
		id_grupo_familiar)
    VALUES(@dni, @nombre, @apellido, @email, @fecha_nacimiento, @telefono,
        @telefono_emergencia, @id_socio_prestador_salud, @id_tutor,
        @id_grupo_familiar);
        END;
GO

CREATE PROCEDURE spInsercion.CrearCuota
	@id_socio INT,
	@id_categoria INT
AS
BEGIN
    INSERT INTO tabla.Cuotas(id_socio, id_categoria)
    VALUES(@id_socio, @id_categoria);
END;
GO

CREATE PROCEDURE spInsercion.CrearActividad
	@id_socio INT,
	@id_deporte INT
AS
BEGIN
    INSERT INTO tabla.Actividades(id_socio, id_deporte)
    VALUES(@id_socio, @id_deporte);
END;
GO

CREATE PROCEDURE spInsercion.CrearActividadExtra
	@id_socio INT,
	@id_invitado INT,
	@tipo_actividad TINYINT,
	@fecha DATE,
	@fecha_reserva DATETIME = NULL,
	@monto INT,
	@monto_invitado INT = NULL,
	@lluvia BIT = NULL
AS
BEGIN
    INSERT INTO tabla.ActividadesExtra(id_socio, id_invitado, tipo_actividad, fecha,
		fecha_reserva, monto, monto_invitado, lluvia)
    VALUES(@id_socio, @id_invitado, @tipo_actividad, @fecha, @fecha_reserva, 
		@monto, @monto_invitado, @lluvia);
END;
GO

CREATE PROCEDURE spInsercion.CrearFacturaARCA
	@id_socio INT,
	@fecha_creacion DATETIME,
	@descripcion VARCHAR(200),
	@tipo CHAR(1),
	@total INT,
	@primer_vencimiento DATE,
	@segundo_vencimiento DATE,
	@recargo INT
AS
BEGIN
    INSERT INTO tabla.FacturasARCA(id_socio, fecha_creacion, descripcion, tipo, total, 
		primer_vencimiento, segundo_vencimiento, recargo)
    VALUES(@id_socio, @fecha_creacion, @descripcion, @tipo, @total, 
		@primer_vencimiento, @segundo_vencimiento, @recargo);
END;
GO

CREATE PROCEDURE spInsercion.CrearCargoSocio
	@numero_factura INT,
	@fecha_creacion DATETIME,
	@descripcion VARCHAR(200),
	@monto_descuento INT = NULL,
	@monto_total INT,
	@id_actividad INT = NULL,
	@id_actividad_extra INT = NULL,
	@id_cuota INT = NULL
AS
BEGIN
    INSERT INTO tabla.CargosSocio(numero_factura, fecha_creacion, descripcion, monto_descuento,
		monto_total, id_actividad, id_actividad_extra, id_cuota)
    VALUES(@numero_factura, @fecha_creacion, @descripcion, @monto_descuento,
		@monto_total, @id_actividad, @id_actividad_extra, @id_cuota);
END;
GO

CREATE PROCEDURE spInsercion.CrearMorosidad
	@numero_factura INT,
	@monto_total INT,
	@fecha_pago DATETIME
AS
BEGIN
    INSERT INTO tabla.Morosidades(numero_factura, monto_total, fecha_pago)
    VALUES(@numero_factura, @monto_total, @fecha_pago);
END;
GO

CREATE PROCEDURE spInsercion.CrearCuentaSocio
	@id_socio INT,
	@contrasena VARCHAR(30),
	@usuario VARCHAR(30),
	@rol TINYINT,
	@saldo INT,
	@fecha_vigencia_contrasena DATETIME,
	@estado_cuenta BIT
AS
BEGIN
    INSERT INTO tabla.CuentasSocios(id_socio, contrasena, usuario, rol, saldo, 
		fecha_vigencia_contrasena, estado_cuenta)
    VALUES(@id_socio, @contrasena, @usuario, @rol, @saldo, 
		@fecha_vigencia_contrasena, @estado_cuenta);
END;
GO

CREATE PROCEDURE spInsercion.CrearPago
	@numero_factura INT,
	@id_medio_pago INT,
	@fecha DATETIME,
	@total INT,
	@reembolso INT,
	@tipo_movimiento TINYINT
AS
BEGIN
    INSERT INTO tabla.Pagos(numero_factura, id_medio_pago, fecha, total, reembolso, tipo_movimiento)
    VALUES(@numero_factura, @id_medio_pago, @fecha, @total, @reembolso, @tipo_movimiento);
END;
GO

CREATE PROCEDURE spInsercion.CrearReembolso
	@id_pago INT,
	@id_cuenta INT,
	@id_admin INT,
	@motivo VARCHAR(200),
	@fecha DATETIME,
	@monto INT
AS
BEGIN
    INSERT INTO tabla.Reembolsos(id_pago, id_cuenta, id_admin, motivo, fecha, monto)
    VALUES(@id_pago, @id_cuenta, @id_admin, @motivo, @fecha, @monto);
END;
GO

CREATE PROCEDURE spInsercion.CrearAsistenciaClase
	@id_socio INT,
	@id_clase INT,
	@presente BIT,
	@fecha DATETIME
AS
BEGIN
    INSERT INTO tabla.AsistenciasClase(id_socio, id_clase, presente, fecha)
    VALUES(@id_socio, @id_clase, @presente, @fecha);
END;
GO




--STORED PROCEDURES ACTUALIZACION


--STORES PROCEDURES ELIMINACION

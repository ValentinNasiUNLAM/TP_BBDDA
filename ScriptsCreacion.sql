
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

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'fnBusqueda')
BEGIN
    EXEC('CREATE SCHEMA fnBusqueda')
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
		estado BIT DEFAULT(1),
		--CONSTRAINTS
		CONSTRAINT chk_nombre_categoria CHECK (LEN(LTRIM(RTRIM(nombre_categoria))) > 0),
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
		id_prestador_salud INT PRIMARY KEY IDENTITY(1,1),
		tipo TINYINT,
		nombre VARCHAR(50),
		telefono INT,
		estado BIT DEFAULT(1),
		--CONSTRAINT
		CONSTRAINT chk_nombre_prestador CHECK (LEN(LTRIM(RTRIM(nombre))) > 0),
		CONSTRAINT chk_tipo_prestador_salud CHECK (tipo BETWEEN 1 AND 3)
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
		dni INT NOT NULL UNIQUE,
		email VARCHAR(30) UNIQUE,
		rol TINYINT,
		estado BIT DEFAULT(1),
		--CONSTRAINTS
		CONSTRAINT chk_dni_admin CHECK (dni > 3000000 AND dni < 99999999),
		CONSTRAINT chk_email_admin CHECK (
			CHARINDEX('@', email) > 1 AND 
			CHARINDEX('.', email, CHARINDEX('@', email)) > CHARINDEX('@', email) + 1
		),
		CONSTRAINT chk_nombre_admin CHECK (LEN(LTRIM(RTRIM(nombre))) > 0),
		CONSTRAINT chk_apellido_admin CHECK (LEN(LTRIM(RTRIM(apellido))) > 0)
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
		--CONSTRAINT
		CONSTRAINT chk_nombre_mediopago CHECK (LEN(LTRIM(RTRIM(nombre))) > 0)
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
		CONSTRAINT chk_nombre_deporte CHECK (LEN(LTRIM(RTRIM(nombre))) > 0),
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
		estado BIT DEFAULT(1),
		--CONSTRAINTS
		CONSTRAINT chk_dni_invitado CHECK (dni > 3000000 AND dni < 99999999),
		CONSTRAINT chk_nombre_invitado CHECK (LEN(LTRIM(RTRIM(nombre))) > 0),
		CONSTRAINT chk_apellido_invitado CHECK (LEN(LTRIM(RTRIM(apellido))) > 0)
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
		id_prestador_salud INT NOT NULL,
		id_tutor INT NULL,
		id_grupo_familiar INT NULL,
		--CONSTRAINTS
		CONSTRAINT chk_dni_socio CHECK (dni > 3000000 AND dni < 99999999),
		CONSTRAINT chk_email_socio CHECK (
			CHARINDEX('@', email) > 1 AND 
			CHARINDEX('.', email, CHARINDEX('@', email)) > CHARINDEX('@', email) + 1),
		CONSTRAINT chk_fecha_nacimiento_no_futuro_socio CHECK (fecha_nacimiento <= CAST(GETDATE() AS DATE)),
		CONSTRAINT fk_prestador_socio FOREIGN KEY (id_prestador_salud) REFERENCES tabla.PrestadoresSalud(id_prestador_salud),
		CONSTRAINT fk_tutor_socio FOREIGN KEY (id_tutor) REFERENCES tabla.Socios(id_socio),
		CONSTRAINT fk_grupo_familiar_socio FOREIGN KEY (id_grupo_familiar) REFERENCES tabla.Socios(id_socio),
		CONSTRAINT chk_nombre_socio CHECK (LEN(LTRIM(RTRIM(nombre))) > 0),
		CONSTRAINT chk_apellido_socio CHECK (LEN(LTRIM(RTRIM(apellido))) > 0)
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
		fecha_creacion DATETIME DEFAULT(GETDATE()),
		descripcion VARCHAR(200),
		monto_descuento INT NULL,
		monto_total INT,
		id_deporte INT NULL,
		id_actividad_extra INT NULL,
		id_cuota INT NULL,
		--CONSTRAINTS
		CONSTRAINT chk_fecha_creacion_cargosocio CHECK (fecha_creacion <= CAST(GETDATE() AS DATETIME)),
		CONSTRAINT chk_descuento_cargosocio CHECK (monto_descuento >= 0),
		CONSTRAINT chk_monto_cargosocio CHECK (monto_total >= 0),
		CONSTRAINT chk_al_menos_un_item_cargosocio CHECK (
			id_deporte IS NOT NULL OR
			id_actividad_extra IS NOT NULL OR
			id_cuota IS NOT NULL
		),
		CONSTRAINT fk_id_deporte_cargosocio FOREIGN KEY (id_deporte) REFERENCES tabla.Deportes(id_deporte),
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

CREATE or ALTER PROCEDURE spInsercion.CrearCategoria 
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

CREATE  or ALTER PROCEDURE spInsercion.CrearPrestadorSalud
	@tipo TINYINT,
	@nombre VARCHAR(50),
	@telefono INT
AS 
BEGIN
	INSERT INTO tabla.PrestadoresSalud(tipo, nombre, telefono)
	VALUES(@tipo, @nombre, @telefono)
END;
GO

CREATE  or ALTER PROCEDURE spInsercion.CrearAdministrador
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

CREATE  or ALTER PROCEDURE spInsercion.CrearMedioPago
	@nombre VARCHAR(50),
	@descripcion VARCHAR(50)
AS 
BEGIN
	INSERT INTO tabla.MediosPago(nombre, descripcion)
	VALUES(@nombre, @descripcion)
END;
GO

CREATE  or ALTER PROCEDURE spInsercion.CrearDeporte
	@nombre VARCHAR(50),
	@precio INT
AS 
BEGIN
	INSERT INTO tabla.Deportes(nombre, precio)
	VALUES(@nombre, @precio)
END;
GO

CREATE  or ALTER PROCEDURE spInsercion.CrearInvitado
	@dni INT ,
	@nombre VARCHAR(30),
	@apellido VARCHAR(30)
AS 
BEGIN
	INSERT INTO tabla.Invitados(dni, nombre, apellido)
	VALUES(@dni, @nombre, @apellido)
END;
GO

CREATE  or ALTER PROCEDURE spInsercion.CrearClase
	@id_deporte INT
AS 
BEGIN
	INSERT INTO tabla.Clases(id_deporte)
	VALUES(@id_deporte)
END;
GO

CREATE  or ALTER PROCEDURE spInsercion.CrearTurno
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

CREATE  or ALTER PROCEDURE spInsercion.CrearSocio
    @dni INT,
    @nombre VARCHAR(30),
    @apellido VARCHAR(30),
    @email VARCHAR(50),
    @fecha_nacimiento DATE,
    @telefono INT,
    @telefono_emergencia INT,
    @id_prestador_salud INT,
    @id_tutor INT = NULL,
    @id_grupo_familiar INT = NULL
AS
BEGIN
    INSERT INTO tabla.Socios(dni, nombre, apellido, email, fecha_nacimiento, telefono, 
		telefono_emergencia, id_prestador_salud, id_tutor,
		id_grupo_familiar)
    VALUES(@dni, @nombre, @apellido, @email, @fecha_nacimiento, @telefono,
        @telefono_emergencia, @id_prestador_salud, @id_tutor,
        @id_grupo_familiar);
        END;
GO

CREATE  or ALTER PROCEDURE spInsercion.CrearCuota
	@dni INT,
	@id_categoria INT
AS
BEGIN
	DECLARE @id_socio INT;
	SELECT @id_socio = fnBusqueda.BuscarSocio(@dni);
	IF @id_socio IS NULL
	BEGIN
		RAISERROR('Error: No existe un socio con el DNI (%d)', 16, 1, @dni);
	END
	ELSE
	BEGIN
		INSERT INTO tabla.Cuotas(id_socio, id_categoria)
		VALUES(@id_socio, @id_categoria);
	END
END;
GO

CREATE  or ALTER PROCEDURE spInsercion.CrearActividad
	@dni INT,
	@id_deporte INT
AS
BEGIN
	DECLARE @id_socio INT;
	SELECT @id_socio = fnBusqueda.BuscarSocio(@dni);
	IF @id_socio IS NULL
	BEGIN
		RAISERROR('Error: No existe un socio con el DNI (%d)', 16, 1, @dni);
	END
	ELSE
	BEGIN
		INSERT INTO tabla.Actividades(id_socio, id_deporte)
		VALUES(@id_socio, @id_deporte);
	END
END;
GO

CREATE  or ALTER PROCEDURE spInsercion.CrearActividadExtra
	@dni INT,
	@dni_invitado INT,
	@tipo_actividad TINYINT,
	@fecha DATE,
	@fecha_reserva DATETIME = NULL,
	@monto INT,
	@monto_invitado INT = NULL,
	@lluvia BIT = NULL
AS
BEGIN
	DECLARE @id_socio INT;
	SELECT @id_socio = fnBusqueda.BuscarSocio(@dni);
	IF @id_socio IS NULL
	BEGIN
		RAISERROR('Error: No existe un socio con el DNI (%d)', 16, 1, @dni);
	END
	ELSE
	BEGIN
		DECLARE @id_invitado INT;

		SELECT @id_invitado = fnBusqueda.BuscarInvitado(@dni_invitado);

		INSERT INTO tabla.ActividadesExtra(id_socio, id_invitado, tipo_actividad, fecha,
			fecha_reserva, monto, monto_invitado, lluvia)
		VALUES(@id_socio, @id_invitado, @tipo_actividad, @fecha, @fecha_reserva, 
			@monto, @monto_invitado, @lluvia);
	END
END;
GO

CREATE  or ALTER PROCEDURE spInsercion.CrearFacturaARCA
	@dni INT,
	@fecha_creacion DATETIME,
	@descripcion VARCHAR(200),
	@tipo CHAR(1),
	@total INT,
	@primer_vencimiento DATE,
	@segundo_vencimiento DATE,
	@recargo INT
AS
BEGIN
	DECLARE @id_socio INT;
	SELECT @id_socio = fnBusqueda.BuscarSocio(@dni);
	IF @id_socio IS NULL
	BEGIN
		RAISERROR('Error: No existe un socio con el DNI (%d)', 16, 1, @dni);
	END
	ELSE
    INSERT INTO tabla.FacturasARCA(id_socio, fecha_creacion, descripcion, tipo, total, 
		primer_vencimiento, segundo_vencimiento, recargo)
    VALUES(@id_socio, @fecha_creacion, @descripcion, @tipo, @total, 
		@primer_vencimiento, @segundo_vencimiento, @recargo);
END;
GO

CREATE  or ALTER PROCEDURE spInsercion.CrearCargoSocio
	@numero_factura INT,
	@fecha_creacion DATETIME,
	@descripcion VARCHAR(200),
	@monto_descuento INT = NULL,
	@monto_total INT,
	@id_deporte INT = NULL,
	@id_actividad_extra INT = NULL,
	@id_cuota INT = NULL
AS
BEGIN
    INSERT INTO tabla.CargosSocio(numero_factura, fecha_creacion, descripcion, monto_descuento,
		monto_total, id_deporte, id_actividad_extra, id_cuota)
    VALUES(@numero_factura, @fecha_creacion, @descripcion, @monto_descuento,
		@monto_total, @id_deporte, @id_actividad_extra, @id_cuota);
END;
GO

CREATE  or ALTER PROCEDURE spInsercion.CrearMorosidad
	@numero_factura INT,
	@monto_total INT,
	@fecha_pago DATETIME
AS
BEGIN
    INSERT INTO tabla.Morosidades(numero_factura, monto_total, fecha_pago)
    VALUES(@numero_factura, @monto_total, @fecha_pago);
END;
GO

CREATE  or ALTER PROCEDURE spInsercion.CrearCuentaSocio
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

CREATE  or ALTER PROCEDURE spInsercion.CrearPago
	@numero_factura INT,
	@id_medio_pago INT,
	@fecha DATETIME,
	@total INT,
	@reembolso INT
AS
BEGIN
    INSERT INTO tabla.Pagos(numero_factura, id_medio_pago, fecha, total, reembolso)
    VALUES(@numero_factura, @id_medio_pago, @fecha, @total, @reembolso);
END;
GO

CREATE  or ALTER PROCEDURE spInsercion.CrearReembolso
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

CREATE  or ALTER PROCEDURE spInsercion.CrearAsistenciaClase
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

CREATE  or ALTER PROCEDURE spActualizacion.ActualizarCategoria
    @id_categoria INT,
	@nombre_categoria VARCHAR(15),
	@edad_min TINYINT,
	@edad_max TINYINT,
	@precio_mensual INT,
	@estado BIT = 1
AS
BEGIN
	IF @id_categoria IS NOT NULL
	BEGIN
		IF NOT EXISTS (SELECT 1 FROM tabla.Categorias WHERE id_categoria = @id_categoria)
		BEGIN
			RAISERROR('Error: No existe una categoria con el ID (%d)',16,1,@id_categoria);
		END
		ELSE
		BEGIN
			UPDATE tabla.Categorias
			SET nombre_categoria = @nombre_categoria, edad_min = @edad_min,
				edad_max = @edad_max,  precio_mensual = @precio_mensual, estado = @estado
			WHERE id_categoria = @id_categoria;
		END
	END
END
GO

CREATE or ALTER PROCEDURE spActualizacion.ActualizarPrestadorSalud
	@id_prestador_salud INT,
	@tipo TINYINT,
	@nombre VARCHAR(50),
	@telefono INT,
	@estado BIT = 1
AS
BEGIN
	IF @id_prestador_salud IS NOT NULL
	BEGIN
		IF NOT EXISTS(SELECT 1 FROM tabla.PrestadoresSalud WHERE id_prestador_salud = @id_prestador_salud)
		BEGIN
			RAISERROR('Error: No existe un Prestador de Salud con el ID (%d)',16,1,@id_prestador_salud);
		END
		ELSE
		BEGIN
			UPDATE tabla.PrestadoresSalud
			SET tipo = @tipo, nombre = @nombre, telefono = @telefono, estado = @estado
			WHERE id_prestador_salud = @id_prestador_salud;
		END
	END	
END
GO

CREATE or ALTER PROCEDURE spActualizacion.ActualizarAdministrador
	@dni INT,
	@email VARCHAR(30) ,
	@rol TINYINT,
	@estado BIT = 1
AS
BEGIN
	DECLARE @id_admin INT;
	IF @dni IS NOT NULL
	BEGIN
		SELECT @id_admin = id_admin FROM tabla.Administradores WHERE dni = @dni;
			
		IF @id_admin IS NULL
		BEGIN
			RAISERROR('Error: No existe un Administrador con el DNI (%d)',16,1,@dni);
		END
		ELSE
		BEGIN
			UPDATE tabla.Administradores
			SET email = @email, rol = @rol, estado = @estado
			WHERE id_admin = @id_admin;
		END
	END
END;
GO

CREATE or ALTER PROCEDURE spActualizacion.ActualizarMedioPago
	@id_medio_pago INT,
	@nombre VARCHAR(50),
	@descripcion VARCHAR(50),
	@habilitado BIT = 1 
AS
BEGIN
	IF @id_medio_pago IS NOT NULL
	BEGIN
		IF NOT EXISTS(SELECT 1 FROM tabla.MediosPago WHERE id_medio_pago = @id_medio_pago)
		BEGIN
			RAISERROR('Error: No existe un Medio de Pago con el ID (%d)',16,1,@id_medio_pago);
		END
		ELSE
		BEGIN
			UPDATE tabla.MediosPago
			SET nombre = @nombre, descripcion = @descripcion, habilitado = @habilitado
			WHERE id_medio_pago = @id_medio_pago;
		END
	END
END;
GO

CREATE or ALTER PROCEDURE spActualizacion.ActualizarDeporte
	@id_deporte INT,
	@nombre VARCHAR(50),
	@precio INT,
	@estado BIT = 1
AS
BEGIN
	IF @id_deporte IS NOT NULL
	BEGIN
		IF NOT EXISTS(SELECT 1 FROM tabla.Deportes WHERE id_deporte = @id_deporte)
		BEGIN
			RAISERROR('Error: No existe un Deporte con el ID (%d)',16,1,@id_deporte);
		END
		ELSE
		BEGIN
			UPDATE tabla.Deportes
			SET nombre = @nombre, precio = @precio, estado = @estado
			WHERE id_deporte = @id_deporte;
		END
	END
END;
GO

CREATE or ALTER PROCEDURE spActualizacion.ActualizarInvitado
	@dni INT,
	@nombre VARCHAR(30),
	@apellido VARCHAR(30),
	@estado BIT = 1
AS
BEGIN
	DECLARE @id_invitado INT;
	IF @dni IS NOT NULL
	BEGIN
		SELECT @id_invitado = id_invitado FROM tabla.Invitados WHERE dni = @dni;
		IF @id_invitado IS NULL
		BEGIN
			RAISERROR('Error: No existe un Invitado con el DNI (%d)',16,1,@dni);
		END
		ELSE
		BEGIN
			UPDATE tabla.Invitados
			SET nombre = @nombre, apellido = @apellido, estado = @estado
			WHERE id_invitado = @id_invitado;
		END
	END
END;
GO

CREATE or ALTER PROCEDURE spActualizacion.ActualizarTurno
	@id_turno INT,
	@id_clase INT,
	@dia TINYINT,
	@hora_inicio TIME,
	@hora_fin TIME
AS
BEGIN
	IF @id_turno IS NOT NULL
	BEGIN
		IF NOT EXISTS(SELECT 1 FROM tabla.Turnos WHERE id_turno = @id_turno)
		BEGIN
			RAISERROR('Error: No existe un Turno con el ID (%d)',16,1,@id_turno);
		END
		ELSE
		BEGIN
			UPDATE tabla.Turnos
			SET id_clase = @id_clase, dia = @dia, hora_inicio = @hora_inicio, hora_fin = @hora_fin
			WHERE id_turno = @id_turno;
		END
	END
END;
GO

CREATE or ALTER PROCEDURE spActualizacion.ActualizarSocio
	@dni INT,
	@email VARCHAR(50),
	@telefono INT,
	@telefono_emergencia INT,
	@estado BIT,
	@id_prestador_salud INT
AS
BEGIN
	DECLARE @id_socio INT;
	IF @dni IS NOT NULL
	BEGIN
		SELECT @id_socio = id_socio FROM tabla.Socios WHERE dni = @dni;
		IF @id_socio IS NULL
		BEGIN
			RAISERROR('Error: No existe un Socio con el DNI (%d)',16,1,@dni);
		END
		ELSE
		BEGIN
			UPDATE tabla.Socios
			SET email= @email, telefono= @telefono, telefono_emergencia= @telefono_emergencia,
				estado= @estado, id_prestador_salud= @id_prestador_salud
			WHERE id_socio = @id_socio;
		END
	END
END;
GO

CREATE or ALTER PROCEDURE spActualizacion.ActualizarSocioTutor
	@dniTutor INT,
	@dniMenor INT
AS
BEGIN
	DECLARE @id_socio_tutor INT;
	DECLARE @id_socio_menor INT;

	SELECT @id_socio_tutor = id_socio FROM tabla.Socios WHERE dni = @dniTutor;
	SELECT @id_socio_menor = id_socio FROM tabla.Socios WHERE dni = @dniMenor;

	IF @id_socio_tutor IS NULL OR @id_socio_menor IS NULL
	BEGIN
		PRINT('Error: Alguno de los DNI ingresados es invalido');
	END
	ELSE
	BEGIN
		UPDATE tabla.Socios
		SET id_tutor = @id_socio_tutor
		WHERE id_socio = @id_socio_menor;
	END
END
GO

CREATE or ALTER PROCEDURE spActualizacion.ActualizarSocioGrupoFamiliar
	@dni INT,
	@dniResponsableGrupoFamiliar INT
AS
BEGIN
	DECLARE @id_socio INT;
	DECLARE @id_socio_responsable INT;

	SELECT @id_socio = id_socio FROM tabla.Socios WHERE dni = @dni;
	SELECT @id_socio_responsable = id_socio FROM tabla.Socios WHERE dni = @dniResponsableGrupoFamiliar;

	IF @id_socio IS NULL OR @id_socio_responsable IS NULL
	BEGIN
		PRINT('Error: Alguno de los DNI ingresados es invalido');
	END
	ELSE
	BEGIN
		UPDATE tabla.Socios
		SET id_grupo_familiar = @id_socio_responsable
		WHERE id_socio = @id_socio;
	END
END
GO

CREATE or ALTER PROCEDURE spActualizacion.ActualizarCuota
	@dni INT,
	@id_categoria INT
AS
BEGIN
	DECLARE @id_socio INT;
	IF @dni IS NOT NULL
	BEGIN
		SELECT @id_socio = id_socio FROM tabla.Socios WHERE dni = @dni;
		IF @id_socio IS NULL
		BEGIN
			RAISERROR('Error: No existe un Socio con el DNI (%d)',16,1,@dni);
		END
		ELSE
		BEGIN
			UPDATE tabla.Cuotas
			SET id_categoria = @id_categoria
			WHERE id_socio = @id_socio;
		END
	END
END
GO 

CREATE OR ALTER PROCEDURE spActualizacion.ActualizarActividadExtra
    @dni_socio INT,
    @dni_invitado INT = NULL,
    @id_actividad_extra INT,
    @tipo_actividad TINYINT,
    @fecha DATE,
    @fecha_reserva DATETIME = NULL,
    @monto INT,
    @monto_invitado INT = NULL,
    @lluvia BIT = NULL
AS
BEGIN
	DECLARE @id_socio INT;
	DECLARE @id_invitado INT;

	SELECT @id_socio = id_socio FROM tabla.Socios WHERE dni = @dni_socio;
	SELECT @id_invitado = id_invitado FROM tabla.Invitados WHERE dni = @dni_invitado;

	IF @id_socio IS NULL
	BEGIN
		RAISERROR('Error: No existe un Socio con el DNI (%d)',16,1,@dni_socio);
	END
	ELSE IF @id_invitado IS NULL
	BEGIN
		RAISERROR('Error: No existe un Invitado con el DNI (%d)',16,1,@dni_invitado);
	END
	ELSE
	BEGIN
		UPDATE tabla.ActividadesExtra
		SET id_socio = @id_socio, id_invitado = @id_invitado, tipo_actividad = @tipo_actividad,
			fecha = @fecha, fecha_reserva = @fecha_reserva, monto = @monto, monto_invitado = @monto_invitado, lluvia = @lluvia
		WHERE id_actividad_extra = @id_actividad_extra;
	END
END;
GO

CREATE OR ALTER PROCEDURE spActualizacion.ActualizarCuentaSocio
	@dni INT,
	@contrasena VARCHAR(30),
	@usuario VARCHAR(30),
	@rol TINYINT,
	@saldo INT,
	@fecha_vigencia_contrasena DATETIME,
	@estado_cuenta BIT
AS
BEGIN
    DECLARE @id_socio INT;

    SELECT @id_socio = id_socio FROM tabla.Socios WHERE dni = @dni;
    IF @id_socio IS NULL
    BEGIN
        RAISERROR('Error: No existe un Socio con el DNI (%d)',16,1,@dni);
    END
	ELSE
	BEGIN
		UPDATE tabla.CuentasSocios
		SET contrasena = @contrasena, usuario = @usuario, rol = @rol, saldo = @saldo, 
			fecha_vigencia_contrasena = @fecha_vigencia_contrasena, estado_cuenta = @estado_cuenta
		WHERE id_socio = @id_socio;
	END
END
GO

CREATE OR ALTER PROCEDURE spActualizacion.ActualizarPago ---REVISAR
	@id_medio_pago INT,
	@id_pago INT
AS
BEGIN
    IF NOT EXISTS(SELECT 1 FROM tabla.Pagos WHERE id_pago = @id_pago)
	BEGIN
		RAISERROR('Error: No existe un Pago con el ID (%d)',16,1,@id_pago);
	END
	ELSE
	BEGIN
		UPDATE tabla.Pagos
		SET id_medio_pago = @id_medio_pago
		WHERE id_pago = @id_pago;
	END
END
GO

CREATE OR ALTER PROCEDURE spActualizacion.ActualizarAsistenciaClase
	@id_asistencia INT,
	@dni INT, 
	@presente BIT,
	@fecha DATETIME
AS
BEGIN
    DECLARE @id_socio INT;
    SELECT @id_socio = id_socio FROM tabla.Socios WHERE dni = @dni;
    IF @id_socio IS NULL
    BEGIN
        RAISERROR('Error: No existe un Socio con el DNI (%d)',16,1,@dni);
    END
	ELSE
	BEGIN
		UPDATE tabla.AsistenciasClase
		SET presente = @presente, fecha = @fecha
		WHERE id_socio = @id_socio AND id_asistencia = @id_asistencia;
	END
END
GO

CREATE OR ALTER PROCEDURE spActualizcion.actualizarCargoSocio
	@id_cargo_socio INT,
	@numero_factura INT,
	@fecha_creacion DATETIME,
	@descripcion VARCHAR(200),
	@monto_descuento INT = NULL,
	@monto_total INT,
	@id_deporte INT = NULL,
	@id_actividad_extra INT = NULL,
	@id_cuota INT = NULL
AS
BEGIN
	IF NOT EXISTS(SELECT 1 FROM tabla.CargosSocio WHERE id_cargo_socio = @id_cargo_socio)
	BEGIN
		RAISERROR('Error: No existe un Cargo Socio con el ID (%d)',16,1,@id_cargo_socio);
	END
	ELSE
	BEGIN
		UPDATE tabla.CargosSocio
		SET numero_factura = @numero_factura, fecha_creacion = @fecha_creacion, 
			descripcion = @descripcion, monto_descuento = @monto_descuento, 
			monto_total = @monto_total, id_deporte = @id_deporte, 
			id_actividad_extra = @id_actividad_extra, id_cuota = @id_cuota
		WHERE id_cargo_socio = @id_cargo_socio;
	END
END;	

--STORE PROCEDURES ELIMINACION

CREATE OR ALTER PROCEDURE spEliminacion.EliminarCargoSocio
	@id_cargo_socio INT
AS
BEGIN
	IF NOT EXISTS(SELECT 1 FROM tabla.CargosSocio WHERE id_cargo_socio = @id_cargo_socio)
	BEGIN
		RAISERROR('Error: No existe un Cargo Socio con el ID (%d)',16,1,@id_cargo_socio);
	END
	ELSE
	BEGIN
		DELETE FROM tabla.CargosSocio
		WHERE id_cargo_socio = @id_cargo_socio;
	END
END


CREATE OR ALTER PROCEDURE spEliminacion.EliminarSocio
	@dni INT
AS
BEGIN
	DECLARE @id_socio INT;
	SELECT @id_socio = id_socio FROM tabla.Socios WHERE dni = @dni;
	IF @id_socio IS NULL
	BEGIN
		RAISERROR('Error: No existe un Socio con el DNI (%d)',16,1,@dni);
    END
	ELSE
	BEGIN
		UPDATE tabla.Socios
		SET estado = 0
		WHERE id_socio = @id_socio;

		UPDATE tabla.CuentasSocios 
		SET estado_cuenta = 0
		WHERE id_socio = @id_socio;
	END
END
GO

CREATE OR ALTER PROCEDURE spEliminacion.EliminarSocioTutor
	@dni INT
AS
BEGIN
	DECLARE @id_socio INT;
	SELECT @id_socio = id_socio FROM tabla.Socios WHERE dni = @dni;
	IF @id_socio IS NULL
	BEGIN
		RAISERROR('Error: No existe un Socio con el DNI (%d)',16,1,@dni);
    END
	ELSE
	BEGIN
		UPDATE tabla.Socios
		SET id_tutor = NULL
		WHERE id_socio = @id_socio;
	END
END
GO

CREATE OR ALTER PROCEDURE spEliminacion.EliminarSocioGrupoFamiliar
	@dni INT
AS
BEGIN
	DECLARE @id_socio INT;
	SELECT @id_socio = id_socio FROM tabla.Socios WHERE dni = @dni;
	IF @id_socio IS NULL
	BEGIN
		RAISERROR('Error: No existe un Socio con el DNI (%d)',16,1,@dni);
    END
	ELSE
	BEGIN
		UPDATE tabla.Socios
		SET id_grupo_familiar = NULL
		WHERE id_socio = @id_socio;
	END
END
GO

CREATE OR ALTER PROCEDURE spEliminacion.EliminarAdministrador
	@dni INT
AS
BEGIN
	DECLARE @id_admin INT;
	SELECT @id_admin = id_admin FROM tabla.Administradores WHERE dni = @dni;
	IF @id_admin IS NULL
	BEGIN
		RAISERROR('Error: No existe un Administrador con el DNI (%d)',16,1,@dni);
    END
	ELSE
	BEGIN
		UPDATE tabla.Administradores
		SET estado = 0
		WHERE id_admin = @id_admin;
	END
END
GO

CREATE OR ALTER PROCEDURE spEliminacion.EliminarDeporte
	@id_deporte INT
AS
BEGIN
	IF NOT EXISTS(SELECT 1 FROM tabla.Deportes WHERE id_deporte = @id_deporte)
		BEGIN
			RAISERROR('Error: No existe un Deporte con el ID (%d)',16,1,@id_deporte);
		END
	ELSE
	BEGIN
		UPDATE tabla.Deportes
		SET estado = 0
		WHERE id_deporte = @id_deporte;
	END
END
GO

CREATE OR ALTER PROCEDURE spEliminacion.EliminarMedioPago
	@id_medio_pago INT
AS
BEGIN
	IF NOT EXISTS(SELECT 1 FROM tabla.MediosPago WHERE id_medio_pago = @id_medio_pago)
		BEGIN
			RAISERROR('Error: No existe un Medio de pago con el ID (%d)',16,1,@id_medio_pago);
		END
	ELSE
	BEGIN
		UPDATE tabla.MediosPago
		SET habilitado = 0
		WHERE id_medio_pago = @id_medio_pago;
	END
END
GO

CREATE OR ALTER PROCEDURE spEliminacion.EliminarCuentaSocio
	@dni INT
AS
BEGIN
	DECLARE @id_socio INT;
	SELECT @id_socio = id_socio FROM tabla.Socios WHERE dni = @dni;
	IF @id_socio IS NULL
	BEGIN
		RAISERROR('Error: No existe un Socio con el DNI (%d)',16,1,@dni);
    END
	ELSE
	BEGIN
		UPDATE tabla.CuentasSocios
		SET estado_cuenta = 0
		WHERE id_socio = @id_socio;
	END
END
GO

CREATE OR ALTER PROCEDURE spEliminacion.EliminarInvitado
	@dni INT
AS
BEGIN
	DECLARE @id_invitado INT;
	SELECT @id_invitado = id_invitado FROM tabla.Invitados WHERE dni = @dni;
	IF @id_invitado IS NULL
	BEGIN
		RAISERROR('Error: No existe un Invitado con el DNI (%d)',16,1,@dni);
    END
	ELSE
	BEGIN
		UPDATE tabla.Invitados
		SET estado = 0
		WHERE @id_invitado = @id_invitado;
	END
END
GO

CREATE OR ALTER PROCEDURE spEliminacion.EliminarTurno
	@id_turno INT
AS
BEGIN
	IF NOT EXISTS(SELECT 1 FROM tabla.Turnos WHERE id_turno = @id_turno)
	BEGIN
		RAISERROR('Error: No existe un Turno con el ID (%d)',16,1,@id_turno);
	END
	ELSE
	BEGIN
		DELETE FROM tabla.Turnos
		WHERE id_turno = @id_turno;
	END
END
GO

CREATE OR ALTER PROCEDURE spEliminacion.EliminarClase
	@id_clase INT
AS
BEGIN
	IF NOT EXISTS(SELECT 1 FROM tabla.Clases WHERE id_clase = @id_clase)
	BEGIN
		RAISERROR('Error: No existe una Clase con el ID (%d)',16,1,@id_clase);
	END
	ELSE
	BEGIN
		DELETE FROM tabla.Turnos
		WHERE id_clase = @id_clase

		DELETE FROM tabla.AsistenciasClase
		WHERE id_clase = @id_clase

		DELETE FROM tabla.Clases
		WHERE id_clase = @id_clase;
	END
END
GO

CREATE OR ALTER PROCEDURE spEliminacion.EliminarCategoria
	@id_categoria INT
AS
BEGIN
	IF NOT EXISTS(SELECT 1 FROM tabla.Categorias WHERE id_categoria = @id_categoria)
	BEGIN
		RAISERROR('Error: No existe una Categoria con el ID (%d)',16,1,@id_categoria);
	END
	ELSE
	BEGIN
		UPDATE tabla.Categorias
		SET estado = 0
		WHERE id_categoria = @id_categoria;
	END
END
GO

CREATE OR ALTER PROCEDURE spEliminacion.EliminarPrestadorSalud
	@id_prestador_salud INT
AS
BEGIN
	IF NOT EXISTS(SELECT 1 FROM tabla.PrestadoresSalud WHERE id_prestador_salud = @id_prestador_salud)
	BEGIN
		RAISERROR('Error: No existe un Prastador de Salud con el ID (%d)',16,1,@id_prestador_salud);
	END
	ELSE
	BEGIN
		UPDATE tabla.PrestadoresSalud
		SET estado = 0
		WHERE id_prestador_salud = @id_prestador_salud;
	END
END
GO

CREATE OR ALTER PROCEDURE spEliminacion.EliminarAsistenciaClase
    @id_asistencia INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM tabla.AsistenciasClase WHERE id_asistencia = @id_asistencia)
    BEGIN
        RAISERROR('Error: No existe una Asistencia con el ID (%d)', 16, 1, @id_asistencia);
    END
	ELSE
	BEGIN
		DELETE FROM tabla.AsistenciasClase
		WHERE id_asistencia = @id_asistencia;
	END
END
GO

CREATE OR ALTER PROCEDURE spEliminacion.EliminarActividad
	@dni INT,
	@id_deporte INT
AS
BEGIN
	DECLARE @id_socio INT;
	SELECT @id_socio = id_socio FROM tabla.Socios WHERE dni = @dni;
	IF @id_socio IS NULL
	BEGIN
		RAISERROR('Error: No existe un Socio con el DNI (%d)',16,1,@dni);
    END
	ELSE
	BEGIN
		DELETE FROM tabla.Actividades
		WHERE id_socio = @id_socio AND id_deporte = @id_deporte;
	END
END
GO

------FUNCIONES

CREATE OR ALTER FUNCTION fnBusqueda.BuscarSocio (
    @dni INT
)
RETURNS INT
AS
BEGIN
    DECLARE @id_socio INT;

    SELECT @id_socio = id_socio
    FROM tabla.Socios
    WHERE dni = @dni;

    RETURN @id_socio;
END;
GO

CREATE OR ALTER FUNCTION fnBusqueda.BuscarInvitado(
    @dni INT
)
RETURNS INT
AS
BEGIN
    DECLARE @id_invitado INT;

    SELECT @id_invitado = id_invitado
    FROM tabla.Invitados
    WHERE dni = @dni;

    RETURN @id_invitado;
END;
GO
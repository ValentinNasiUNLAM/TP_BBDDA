IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'sol_norte')
BEGIN
    CREATE DATABASE sol_norte;
END;
GO
USE sol_norte
GO
--DROP DATABASE sol_norte

CREATE TABLE Categoria(
 id_categoria INT NOT NULL PRIMARY KEY IDENTITY(1,1),
 nombre_categoria VARCHAR(15),
 edad_min TINYINT,
 edad_max TINYINT,
 precio_mensual INT,
 --CONSTRAINT
 CONSTRAINT chk_rango_edades_categoria CHECK (edad_min <= edad_max),
 CONSTRAINT chk_precio_mensual_categoria CHECK (precio_mensual > 0)
)
GO

CREATE TABLE PrestadorSalud(
 id_socio_prestador_salud INT NOT NULL PRIMARY KEY IDENTITY(1,1),
 tipo TINYINT,
 nombre VARCHAR(50),
 telefono int,
 --CONSTRAINT
 CONSTRAINT chk_tipo_salud CHECK (tipo IN (1,2,3)),
)
GO

CREATE TABLE Administrador(
 id_admin INT NOT NULL PRIMARY KEY IDENTITY(1,1),
 nombre VARCHAR(30),
 apellido VARCHAR(30),
 dni INT NOT NULL UNIQUE,
 email VARCHAR(30) UNIQUE,
 rol TINYINT,
 estado BIT DEFAULT(1),
 --CONSTRAINT
 CONSTRAINT chk_dni_admin CHECK (dni > 3000000 AND dni < 99999999),
 CONSTRAINT chk_email_admin CHECK (
    CHARINDEX('@', email) > 1 AND 
    CHARINDEX('.', email, CHARINDEX('@', email)) > CHARINDEX('@', email) + 1
 ),
 CONSTRAINT chk_rol_admin CHECK (rol > 0 AND rol <5)
)
GO

CREATE TABLE MedioPago(
 id_medio_pago INT NOT NULL PRIMARY KEY IDENTITY(1,1),
 nombre VARCHAR(50),
 descripcion VARCHAR(50),
 habilitado BIT,
)
GO

CREATE TABLE Deporte(
 id_deporte INT NOT NULL PRIMARY KEY IDENTITY(1,1),
 nombre VARCHAR(50),
 precio INT,
 estado BIT,
 --CONSTRAINT
 CONSTRAINT chk_precio_deporte CHECK (precio > 0)
)
GO

CREATE TABLE Invitado(
 id_invitado INT NOT NULL PRIMARY KEY IDENTITY(1,1),
 dni INT NOT NULL UNIQUE,
 nombre VARCHAR(30),
 apellido VARCHAR(30),
 --CONSTRAINT
 --CONSTRAINT chk_invitado CHECK (id_invitado >0),--ACA HAY QUE REVISAR ESTO PORQUE REPITE DNI
 CONSTRAINT chk_dni_invitado CHECK (dni > 3000000 AND dni < 99999999)
)
GO

CREATE TABLE Clase(
 id_clase INT NOT NULL PRIMARY KEY IDENTITY(1,1),
 id_deporte INT NOT NULL,
 --CONSTRAINT
 CONSTRAINT fk_id_deporte_clase FOREIGN KEY (id_deporte) REFERENCES Deporte(id_deporte)
)
GO

CREATE TABLE Turno(
 id_turno INT NOT NULL PRIMARY KEY IDENTITY(1,1),
 id_clase INT NOT NULL,
 dia TINYINT NOT NULL,
 hora_inicio TIME NOT NULL,
 hora_fin TIME NOT NULL,
 --CONSTRAINT
 CONSTRAINT chk_dia_turno CHECK (dia >= 1 AND dia <=31),
 --CONSTRAINT chk_hora_incio CHECK (hora_inicio >= '07:00:00' AND hora_inicio <= '23:59:59'),
 --CONSTRAINT chk_hora_fin CHECK (hora_fin >= '08:00:00' AND hora_inicio <= '23:59:59'),
 CONSTRAINT fk_id_clase_turno FOREIGN KEY (id_clase) REFERENCES Clase(id_clase),
 CONSTRAINT chk_rango_horas_turno CHECK (hora_fin > hora_inicio)
)
GO

CREATE TABLE Socio(
id_socio INT NOT NULL PRIMARY KEY IDENTITY(1,1),
dni INT NOT NULL UNIQUE,
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
--CONSTRAINT
CONSTRAINT chk_dni_socio CHECK (dni > 3000000 AND dni < 99999999),
CONSTRAINT chk_email_socio CHECK (
    CHARINDEX('@', email) > 1 AND 
    CHARINDEX('.', email, CHARINDEX('@', email)) > CHARINDEX('@', email) + 1),
 CONSTRAINT chk_fecha_nacimiento_no_futuro_socio CHECK (fecha_nacimiento <= CAST(GETDATE() AS DATE)),
 CONSTRAINT fk_prestador_socio FOREIGN KEY (id_socio_prestador_salud) REFERENCES PrestadorSalud(id_socio_prestador_salud),
 CONSTRAINT fk_tutor_socio FOREIGN KEY (id_tutor) REFERENCES Socio(id_socio),
 CONSTRAINT fk_grupo_familiar_socio FOREIGN KEY (id_grupo_familiar) REFERENCES Socio(id_socio)
)
GO

CREATE TABLE Cuota(
 id_cuota INT NOT NULL PRIMARY KEY IDENTITY(1,1),
 id_categoria INT NOT NULL,
 id_socio INT NOT NULL,
 --CONSTRAINT
 CONSTRAINT fk_id_categoria_cuota FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria),
 CONSTRAINT fk_id_socio_cuota FOREIGN KEY (id_socio) REFERENCES Socio(id_socio)
)
GO

CREATE TABLE Actividad(
id_actividad INT NOT NULL PRIMARY KEY IDENTITY(1,1),
id_socio INT NOT NULL,
id_deporte INT NOT NULL,
 --CONSTRAINT
CONSTRAINT fk_id_socio_actividad FOREIGN KEY (id_socio) REFERENCES Socio(id_socio),
CONSTRAINT fk_id_deporte_actividad FOREIGN KEY (id_deporte) REFERENCES Deporte(id_deporte)
)
GO

CREATE TABLE ActividadExtra(
id_actividad_extra INT NOT NULL PRIMARY KEY IDENTITY(1,1),
id_socio INT NOT NULL,
id_invitado INT NOT NULL,
tipo_actividad TINYINT,
fecha DATE,
fecha_reserva DATE NULL,
monto INT,
monto_invitado INT NULL,
lluvia BIT,
 --CONSTRAINT
CONSTRAINT fk_id_socio_actividadextra FOREIGN KEY (id_socio) REFERENCES Socio(id_socio),
CONSTRAINT fk_id_invitado_actividadextra FOREIGN KEY (id_invitado) REFERENCES Invitado(id_invitado),
CONSTRAINT chk_tipo_activado_actividadextra CHECK ( tipo_actividad >= 1 AND tipo_actividad <=5),
CONSTRAINT chk_monto_actividadextra CHECK (monto > 0)
)
GO

CREATE TABLE FacturaARCA(
numero_factura INT NOT NULL PRIMARY KEY IDENTITY (1,1),
id_socio INT NOT NULL,
fecha_creacion DATETIME,
descripcion VARCHAR(200),
tipo CHAR(1),
total INT,
primer_vencimiento DATE,
segundo_vencimiento DATE,
recargo INT,
--CONSTRAINT
CONSTRAINT fk_id_socio_facturaarca FOREIGN KEY (id_socio) REFERENCES Socio(id_socio),
CONSTRAINT chk_tipo_facturaarca CHECK ( tipo = 'A' OR tipo = 'B' OR tipo = 'C' ),
CONSTRAINT chk_monto_facturaarca CHECK (total > 0),
CONSTRAINT chk_segundo_vencimiento_facturaarca CHECK ( segundo_vencimiento > primer_vencimiento),
CONSTRAINT chk_recargo_facturaarca CHECK (recargo >=0)
)
GO

CREATE TABLE CargoSocio(
id_cargo_socio INT NOT NULL PRIMARY KEY IDENTITY (1,1),
numero_factura INT NOT NULL,
fecha_creacion DATETIME,
descripcion VARCHAR(200),
monto_descuento INT DEFAULT(0),
monto_total INT NOT NULL,
id_actividad INT,
id_actividad_extra INT,
id_cuota INT NOT NULL,
--CONSTRAINT
 CONSTRAINT chk_fecha_nacimiento_no_futuro_cargosocio CHECK (fecha_creacion <= CAST(GETDATE() AS DATE)),
 CONSTRAINT chk_descuento_cargosocio CHECK (monto_descuento >= 0),
 CONSTRAINT chk_monto_cargosocio CHECK (monto_total >= 0),
 CONSTRAINT fk_id_actividad_cargosocio FOREIGN KEY (id_actividad) REFERENCES Actividad(id_actividad),
 CONSTRAINT fk_id_actividadesextra_cargosocio FOREIGN KEY (id_actividad_extra) REFERENCES ActividadExtra(id_actividad_extra),
 CONSTRAINT fk_id_cuota_cargosocio FOREIGN KEY (id_cuota) REFERENCES Cuota(id_cuota),
 CONSTRAINT fk_numero_factura_cargosocio FOREIGN KEY (numero_factura) REFERENCES FacturaARCA(numero_factura),
 CONSTRAINT chk_al_menos_un_item_cargosocio CHECK (
        id_actividad IS NOT NULL OR
        id_actividad_extra IS NOT NULL OR
        id_cuota IS NOT NULL
    )
)
GO

CREATE TABLE Morosidad(
id_morosidad INT NOT NULL PRIMARY KEY IDENTITY(1,1),
numero_factura INT NOT NULL,
monto_total INT,
fecha_pago DATETIME,
--CONSTRAINT
CONSTRAINT fk_numero_factura_morosidad FOREIGN KEY (numero_factura) REFERENCES FacturaARCA(numero_factura),
CONSTRAINT chk_monto_total_morosidad CHECK (monto_total >= 0)
)
GO

CREATE TABLE CuentaSocio(
id_cuenta INT NOT NULL PRIMARY KEY IDENTITY(1,1),
id_socio INT NOT NULL UNIQUE,
contrasena VARCHAR(30),
usuario VARCHAR(30),
rol TINYINT,
saldo INT,
fecha_vigencia_contrasena DATETIME,
estado_cuenta BIT,
--CONSTRAINT
CONSTRAINT fk_id_socio_cuota_socio FOREIGN KEY (id_socio) REFERENCES Socio(id_socio),
CONSTRAINT chk_rol_cuota_socio CHECK (rol >=0 AND rol <=5),
CONSTRAINT chk_contrasena_no_vacia_cuota_socio CHECK (LEN(contrasena) > 0)
)
GO

CREATE TABLE Pago(
id_pago INT NOT NULL PRIMARY KEY IDENTITY(1,1),
numero_factura INT NOT NULL,
id_medio_pago INT NOT NULL,
fecha DATETIME,
total INT,
reembolso INT,
tipo_movimiento TINYINT,
--CONSTRAINT
CONSTRAINT fk_id_medio_pago_pago FOREIGN KEY (id_medio_pago) REFERENCES MedioPago(id_medio_pago),
CONSTRAINT fk_numero_factura_pago FOREIGN KEY (numero_factura) REFERENCES FacturaARCA(numero_factura)
)
GO

CREATE TABLE AsistenciaClase(
id_asistencia INT NOT NULL PRIMARY KEY IDENTITY(1,1),
id_socio INT NOT NULL,
id_clase INT NOT NULL,
presente BIT,
fecha DATETIME,
--CONSTRAINT
CONSTRAINT fk_id_socio_asistencia_clase FOREIGN KEY (id_socio) REFERENCES Socio(id_socio),
CONSTRAINT fk_id_clase_asistencia_clase FOREIGN KEY (id_clase) REFERENCES Clase(id_clase)
)
GO

--STORED PROCEDUREs

CREATE PROCEDURE SP_Socio_Crear
    @dni INT,
    @nombre VARCHAR(30),
    @apellido VARCHAR(30),
    @email VARCHAR(50),
    @fecha_nacimiento DATE,
    @telefono INT,
    @telefono_emergencia INT,
    @estado BIT,
    @id_socio_prestador_salud INT,
    @id_tutor INT = NULL,
    @id_grupo_familiar INT = NULL

AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        INSERT INTO Socio(
        dni,
        nombre,
        apellido,
        email,
        fecha_nacimiento,
        telefono,
        telefono_emergencia,
        estado,
        id_socio_prestador_salud,
        id_tutor,
        id_grupo_familiar
        )

        VALUES(
            @dni,
            @nombre,
            @apellido,
            @email,
            @fecha_nacimiento,
            @telefono,
            @telefono_emergencia,
            @estado,
            @id_socio_prestador_salud,
            @id_tutor,
            @id_grupo_familiar
            );
        
        COMMIT TRANSACTION;

        SELECT SCOPE_IDENTITY() as id_socio_creado;
    END TRY

    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
    END CATCH;
END;
GO


--TRIGGERS

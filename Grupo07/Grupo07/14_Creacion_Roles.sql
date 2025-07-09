/*
Asigne los roles correspondientes para poder cumplir con este requisito, según el área a la
cual pertenece.
Por otra parte, se requiere que los datos de los empleados se encuentren encriptados, dado
que los mismos contienen información personal.
La información de las cuotas pagadas y adeudadas es de vital importancia para el negocio,
por ello se requiere que se establezcan políticas de respaldo tanto en las ventas diarias
generadas como en los reportes generados.
Plantee una política de respaldo adecuada para cumplir con este requisito y justifique la
misma. No es necesario que incluya el código de creación de los respaldos.
Debe documentar la programación (Schedule) de los backups por día/semana/mes (de
acuerdo a lo que decidan) e indicar el RPO.

Materia: Bases de datos aplicadas
Fecha de entrega: 08/07/2025
Grupo: 07
Alumnos: 
	Nasi Valentin 44851378
	Traversa Franco 44510896
	Arias Kevin 41246810
*/

-- Usar la base de datos
USE Com2900G07;
GO

-- Roles de Tesorería
CREATE ROLE TesoreriaJefeDeTesoreria;
CREATE ROLE TesoreriaAdministrativoDeCobranza;
CREATE ROLE TesoreriaAdministrativoDeMorosidad;
CREATE ROLE TesoreriaAdministrativoDeFacturacion;

-- Roles de Socios
CREATE ROLE SociosAdministrativoSocio;
CREATE ROLE SociosWeb; 

-- Roles de Autoridades
CREATE ROLE AutoridadesPresidente;
CREATE ROLE AutoridadesVicepresidente;
CREATE ROLE AutoridadesSecretario;
CREATE ROLE AutoridadesVocales;
GO

-- Roles de Tesorería
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::administracion TO TesoreriaJefeDeTesoreria;
DENY SELECT, INSERT, UPDATE, DELETE ON administracion.Administradores TO TesoreriaJefeDeTesoreria;
-- Por si tiene que hacer un reembolso
GRANT SELECT, UPDATE ON socios.CuentasSocios TO TesoreriaJefeDeTesoreria;
-- Consultas generales sobre los socios
GRANT SELECT ON SCHEMA::socios TO TesoreriaJefeDeTesoreria; 

GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::administracion TO TesoreriaAdministrativoDeCobranza;
DENY SELECT, INSERT, UPDATE, DELETE ON administracion.Administradores TO TesoreriaAdministrativoDeCobranza;
-- Por si tiene que hacer un reembolso
GRANT SELECT, UPDATE ON socios.CuentasSocios TO TesoreriaAdministrativoDeCobranza;
GRANT SELECT ON socios.Socios TO TesoreriaAdministrativoDeCobranza;


GRANT SELECT ON SCHEMA::administracion TO TesoreriaAdministrativoDeMorosidad;
GRANT SELECT, UPDATE, INSERT, DELETE ON administracion.Morosidades TO TesoreriaAdministrativoDeMorosidad;
GRANT SELECT ON socios.Socios TO TesoreriaAdministrativoDeMorosidad;


GRANT SELECT, INSERT, UPDATE, DELETE ON administracion.Pagos TO TesoreriaAdministrativoDeFacturacion;
GRANT SELECT, INSERT, UPDATE, DELETE ON administracion.FacturasARCA TO TesoreriaAdministrativoDeFacturacion;
GRANT SELECT, INSERT, UPDATE, DELETE ON administracion.CargosSocio TO TesoreriaAdministrativoDeFacturacion;
GRANT SELECT ON actividades.ActividadesExtra TO TesoreriaAdministrativoDeFacturacion;
GRANT SELECT ON socios.Socios TO TesoreriaAdministrativoDeFacturacion;
GRANT SELECT ON socios.Cuotas TO TesoreriaAdministrativoDeFacturacion;
GRANT SELECT ON actividades.Deportes TO TesoreriaAdministrativoDeFacturacion;

-- Roles de Socios
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::socios TO SociosAdministrativoSocio;
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::actividades TO SociosAdministrativoSocio;

-- SociosSociosWeb: Permisos de lectura muy limitados para un portal web de socios.
GRANT SELECT ON SCHEMA::socios TO SociosWeb;
GRANT SELECT ON actividades.ActividadesExtra TO SociosWeb;
GRANT SELECT ON actividades.Actividades TO SociosWeb;
GRANT SELECT ON actividades.AsistenciasClase TO SociosWeb;
GRANT SELECT ON administracion.FacturasARCA TO SociosWeb;
GRANT SELECT ON administracion.Pagos TO SociosWeb;
-- Habria que asignar permisos a nivel fila para que cada socio pueda ver su propia información y no la de otros socios.

-- Roles de Autoridades
GRANT SELECT ON SCHEMA::socios TO AutoridadesPresidente;
GRANT SELECT ON SCHEMA::actividades TO AutoridadesPresidente;
GRANT SELECT ON SCHEMA::administracion TO AutoridadesPresidente;
GRANT SELECT, UPDATE, INSERT, DELETE ON administracion.Administradores TO AutoridadesPresidente;

GRANT SELECT ON SCHEMA::socios TO AutoridadesVicepresidente;
GRANT SELECT ON SCHEMA::actividades TO AutoridadesVicepresidente;
GRANT SELECT ON SCHEMA::administracion TO AutoridadesVicepresidente;
GRANT SELECT, UPDATE, INSERT, DELETE ON administracion.Administradores TO AutoridadesVicepresidente;

GRANT SELECT ON SCHEMA::socios TO AutoridadesSecretario;
GRANT SELECT ON SCHEMA::actividades TO AutoridadesSecretario;
GRANT SELECT ON SCHEMA::administracion TO AutoridadesSecretario;
GRANT SELECT, UPDATE, INSERT, DELETE ON administracion.Administradores TO AutoridadesSecretario;

GRANT SELECT ON SCHEMA::socios TO AutoridadesVocales;
GRANT SELECT ON SCHEMA::actividades TO AutoridadesVocales;
GRANT SELECT ON SCHEMA::administracion TO AutoridadesVocales;
GRANT SELECT, UPDATE, INSERT, DELETE ON administracion.Administradores TO AutoridadesVocales;

GO


-- Jefe Tesorero
CREATE LOGIN JefeTesorero WITH PASSWORD = 'Tesorero12345';
CREATE USER JefeTesorero FOR LOGIN JefeTesorero;
ALTER ROLE TesoreriaJefeDeTesoreria ADD MEMBER JefeTesorero;

-- Administrativo Facturas
CREATE LOGIN AdministrativoFacturas WITH PASSWORD = 'AdministrativoFacturas12345';
CREATE USER AdministrativoFacturas FOR LOGIN AdministrativoFacturas;
ALTER ROLE TesoreriaAdministrativoDeFacturacion ADD MEMBER AdministrativoFacturas;

-- Administrativo Cobranzas
CREATE LOGIN AdministrativoCobranzas WITH PASSWORD = 'AdministrativoCobranzas12345';
CREATE USER AdministrativoCobranzas FOR LOGIN AdministrativoCobranzas;
ALTER ROLE TesoreriaAdministrativoDeCobranza ADD MEMBER AdministrativoCobranzas;

-- Administrativo Moorosidad
CREATE LOGIN AdministrativoMorosidad WITH PASSWORD = 'AdministrativoMorosidad12345';
CREATE USER AdministrativoMorosidad FOR LOGIN AdministrativoMorosidad;
ALTER ROLE TesoreriaAdministrativoDeMorosidad ADD MEMBER AdministrativoMorosidad;

-- Administrativo Socios
CREATE LOGIN AdministrativoSocios WITH PASSWORD = 'AdministrativoSocios12345';
CREATE USER AdministrativoSocios FOR LOGIN AdministrativoSocios;
ALTER ROLE SociosAdministrativoSocio ADD MEMBER AdministrativoSocios;

-- Administrativo Socios Web
CREATE LOGIN AdministrativoSociosWeb WITH PASSWORD = 'AdministrativoSociosWeb12345';
CREATE USER AdministrativoSociosWeb FOR LOGIN AdministrativoSociosWeb;
ALTER ROLE SociosWeb ADD MEMBER AdministrativoSocios;

-- Presidente
CREATE LOGIN Presidente WITH PASSWORD = 'Presidente12345';
CREATE USER Presidente FOR LOGIN Presidente;
ALTER ROLE AutoridadesPresidente ADD MEMBER Presidente;

-- Vicepresidente
CREATE LOGIN Vicepresidente WITH PASSWORD = 'Vicepresidente12345';
CREATE USER Vicepresidente FOR LOGIN Vicepresidente;
ALTER ROLE AutoridadesVicepresidente ADD MEMBER Vicepresidente;

-- Secretario
CREATE LOGIN Secretario WITH PASSWORD = 'Secretario12345';
CREATE USER Secretario FOR LOGIN Secretario;
ALTER ROLE AutoridadesSecretario ADD MEMBER Secretario;

-- Vocales
CREATE LOGIN Vocales WITH PASSWORD = 'Vocales12345';
CREATE USER Vocales FOR LOGIN Vocales;
ALTER ROLE AutoridadesVocales ADD MEMBER Vocales;
GO
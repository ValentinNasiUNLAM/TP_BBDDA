--Cuotas
--Se crean los TESTS para la insercion, actualizacion y eliminacion de Cuotas

USE Com2900G07
GO
/*
CONSTRAINT fk_id_socio_actividadextra FOREIGN KEY (id_socio) REFERENCES tabla.Socios(id_socio),
CONSTRAINT fk_id_invitado_actividadextra FOREIGN KEY (id_invitado) REFERENCES tabla.Invitados(id_invitado),
CONSTRAINT chk_tipo_activado_actividadextra CHECK ( tipo_actividad >= 1 AND tipo_actividad <=5),
CONSTRAINT chk_monto_actividadextra CHECK (monto > 0),
CONSTRAINT chk_fecha_reserva CHECK (fecha_reserva < CAST(GETDATE() AS DATETIME))
*/


--INSERCION
--TEST 1.1: Insercion Correcta
EXEC spInsercion.CrearCuota
    @dni = 23777221,
    @id_categoria = 1
GO
SELECT * FROM tabla.Cuotas WHERE id_categoria = @id_categoria;
--TEST 1.2: Dni Incorrecto
EXEC spInsercion.CrearCuota
    @dni = 99999999,
    @id_categoria = 1
GO

--TEST 1.3: Categoria Incorrecta
EXEC spInsercion.CrearCuota
    @dni = 23777221,
    @id_categoria = 999999
GO
SELECT * FROM tabla.Cuotas WHERE id_categoria = @id_categoria;

--ACTUALIZACION
--TEST 2.1: Actualizacion Correcta
EXEC spActualizacion.actulizarCuota
    @dni = 23777221,
    @id_categoria = 2
GO
SELECT * FROM tabla.Cuotas WHERE id_categoria = @id_categoria;
--TEST 2.2: Error DNI
EXEC spActualizacion.actulizarCuota
    @dni = 99999999,
    @id_categoria = 1
GO
SELECT * FROM tabla.Cuotas WHERE id_categoria = @id_categoria;
--TEST 2.3: Error Categoria
EXEC spActualizacion.actulizarCuota
    @dni = 23777221,
    @id_categoria = 99991
GO
SELECT * FROM tabla.Cuotas WHERE id_categoria = @id_categoria;


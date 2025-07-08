/*
Archivos indicados en Miel.
Se requiere que importe toda la información antes mencionada a la base de datos:
• Genere los objetos necesarios (store procedures, funciones, etc.) para importar los
archivos antes mencionados. Tenga en cuenta que cada mes se recibirán archivos de
novedades con la misma estructura, pero datos nuevos para agregar a cada maestro.
• Considere este comportamiento al generar el código. Debe admitir la importación de
novedades periódicamente sin eliminar los datos ya cargados y sin generar
duplicados.
• Cada maestro debe importarse con un SP distinto. No se aceptarán scripts que
realicen tareas por fuera de un SP.
• La estructura/esquema de las tablas a generar será decisión suya. Puede que deba
realizar procesos de transformación sobre los maestros recibidos para adaptarlos a la
estructura requerida. Estas adaptaciones deberán hacerla en la DB y no en los
archivos provistos.
• Los archivos CSV/JSON no deben modificarse. En caso de que haya datos mal
cargados, incompletos, erróneos, etc., deberá contemplarlo y realizar las correcciones
en el fuente SQL. (Sería una excepción si el archivo está malformado y no es posible
interpretarlo como JSON o CSV, pero los hemos verificado cuidadosamente).
• Tener en cuenta que para la ampliación del software no existen datos; se deben
preparar los datos de prueba necesarios para cumplimentar los requisitos planteados.
• El código fuente no debe incluir referencias hardcodeadas a nombres o ubicaciones
de archivo. Esto debe permitirse ser provisto por parámetro en la invocación. En el
código de ejemplo el grupo decidirá dónde se ubicarían los archivos. Esto debe
aparecer en comentarios del módulo.
• El uso de SQL dinámico no está exigido en forma explícita… pero puede que
encuentre que es la única forma de resolver algunos puntos. No abuse del SQL
dinámico, deberá justificar su uso siempre.
• Respecto a los informes XML: no se espera que produzcan un archivo nuevo en el
filesystem, basta con que el resultado de la consulta sea XML.

Materia: Bases de datos aplicadas
Fecha de entrega: 08/07/2025
Grupo: 07
Alumnos: 
	Nasi Valentin 44851378
	Traversa Franco 44510896
	Arias Kevin 41246810
*/

USE Com2900G07;
GO

-- Primero se crea para que funcione todo correctamente.
-- Medios de pago
INSERT INTO administracion.MediosPago (nombre, descripcion)
VALUES
('efectivo',        'Pago en recepción'),
('Débito',          'Tarjeta de débito / débito automático'),
('Crédito',         'Tarjeta de crédito 1 cuota'),
('Transferencia',   'Transferencia o depósito bancario'),
('Mercado Pago',    'QR o enlace de Mercado Pago'),
('PayPal',          'Pago en USD vía PayPal');
GO

EXEC administracion.ImportarPagos @ruta_archivo_pagos=N'C:\Users\kevin\TP_BBDDA\CSV\pago_cuotas.csv'; 
GO

-- Tabla formato pago_cuotas.csv
SELECT p.nro_pago as IdDePago, p.fecha as Fecha, s.nro_socio as ResponsablePago, p.total as valor FROM administracion.Pagos p
INNER JOIN administracion.FacturasARCA f
ON p.numero_factura = f.numero_factura
LEFT JOIN socios.Socios s ON s.id_socio = f.id_socio
GO
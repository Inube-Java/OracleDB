-- *** Asegúrate de haber ejecutado las secuencias y los triggers antes de esto. ***

SET DEFINE OFF; -- Para permitir el uso de &

-- 1. Insertar Clientes (Los IDs se generan por trigger)
INSERT INTO CLIENTES (NOMBRE, APATERNO, AMATERNO, RFC, FECHA_ALTA) VALUES ('Ana', 'Gomez', 'Perez', 'GOPA800101', DATE '2023-01-15');
INSERT INTO CLIENTES (NOMBRE, APATERNO, AMATERNO, RFC, FECHA_ALTA) VALUES ('Beto', 'Lopez', 'Rojas', 'LORA900505', DATE '2023-03-20');
INSERT INTO CLIENTES (NOMBRE, APATERNO, AMATERNO, RFC, FECHA_ALTA) VALUES ('Carlos', 'Mena', 'Sosa', 'MESO751111', DATE '2024-02-01');
INSERT INTO CLIENTES (NOMBRE, APATERNO, AMATERNO, RFC, FECHA_ALTA) VALUES ('Diana', 'Nuñez', 'Vela', 'NUVE881212', DATE '2024-04-10');
INSERT INTO CLIENTES (NOMBRE, APATERNO, AMATERNO, RFC, FECHA_ALTA) VALUES ('Elena', 'Ortiz', 'Cruz', 'ORCR950707', DATE '2024-06-25');
COMMIT;

-- Variables para IDs de clientes (asume IDs 1 a 5 si el sistema es limpio)
-- Si no usas variables, puedes obtener el ID manualmente de la tabla CLIENTES
-- Por simplicidad, usaremos los IDs fijos 1 a 5 para el resto de las inserciones.

-- 2. Insertar Teléfonos (Los IDs se generan por trigger)
INSERT INTO TELEFONOS (ID_CLIENTE, TELEFONO) VALUES (1, '5511223344');
INSERT INTO TELEFONOS (ID_CLIENTE, TELEFONO) VALUES (1, '5511223345');
INSERT INTO TELEFONOS (ID_CLIENTE, TELEFONO) VALUES (2, '5599887766');
INSERT INTO TELEFONOS (ID_CLIENTE, TELEFONO) VALUES (4, '5544556677');
COMMIT;

-- 3. Insertar Facturas (Los IDs, Folio y Año se generan por trigger)
-- Cliente 1: Dos facturas en 2023
INSERT INTO FACTURAS (ID_CLIENTE, MONTO_TOTAL, FECHA_FACTURA) VALUES (1, 1500.00, DATE '2023-05-10'); -- F1
INSERT INTO FACTURAS (ID_CLIENTE, MONTO_TOTAL, FECHA_FACTURA) VALUES (1, 800.00, DATE '2023-11-20'); -- F2
-- Cliente 3: Una factura grande en 2024
INSERT INTO FACTURAS (ID_CLIENTE, MONTO_TOTAL, FECHA_FACTURA) VALUES (3, 5000.00, DATE '2024-03-05'); -- F3
-- Cliente 4: Una factura en 2024
INSERT INTO FACTURAS (ID_CLIENTE, MONTO_TOTAL, FECHA_FACTURA) VALUES (4, 1200.00, DATE '2024-04-25'); -- F4
-- Cliente 5: Una factura pequeña en 2024
INSERT INTO FACTURAS (ID_CLIENTE, MONTO_TOTAL, FECHA_FACTURA) VALUES (5, 300.00, DATE '2024-06-30'); -- F5
COMMIT;

-- Variables para IDs de facturas (asume IDs 1 a 5)
-- 4. Insertar Pagos (Los IDs se generan por trigger)
-- F1 (Total 1500.00): Pago parcial y finalizado
INSERT INTO PAGOS (ID_FACTURA, MONTO, FECHA_PAGO) VALUES (1, 1000.00, DATE '2023-05-15');
INSERT INTO PAGOS (ID_FACTURA, MONTO, FECHA_PAGO) VALUES (1, 500.00, DATE '2023-05-20');
-- F2 (Total 800.00): Pago completo en una sola exhibición
INSERT INTO PAGOS (ID_FACTURA, MONTO, FECHA_PAGO) VALUES (2, 800.00, DATE '2023-11-20');
-- F3 (Total 5000.00): Pago Parcial (Queda pendiente 2000.00)
INSERT INTO PAGOS (ID_FACTURA, MONTO, FECHA_PAGO) VALUES (3, 1500.00, DATE '2024-03-06');
INSERT INTO PAGOS (ID_FACTURA, MONTO, FECHA_PAGO) VALUES (3, 1500.00, DATE '2024-03-20');
-- F4 (Total 1200.00): Sin pagos (Queda pendiente 1200.00)
-- F5 (Total 300.00): Pago completo
INSERT INTO PAGOS (ID_FACTURA, MONTO, FECHA_PAGO) VALUES (5, 300.00, DATE '2024-07-01');
COMMIT;

-- Cliente 2 (Beto) no tiene facturas. Esto nos servirá para LEFT/RIGHT JOIN.
-- Cliente 4 (Diana) tiene una factura sin pagos. Esto nos servirá para LEFT JOIN con PAGOS.
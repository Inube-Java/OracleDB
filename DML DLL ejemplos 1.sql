-- GRANT CREATE SEQUENCE TO ejemplos;
-- GRANT RESOURCE TO ejemplos;

-- Secuencias para llaves primarias (PKs)
CREATE SEQUENCE SEC_ID_CLIENTE START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEC_ID_TELEFONO START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEC_ID_FACTURA START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEC_ID_PAGO START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

-- Secuencias para llaves primarias (PKs) de BITÁCORAS
CREATE SEQUENCE SEC_ID_CLIENTE_BIT START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEC_ID_TELEFONO_BIT START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEC_ID_FACTURA_BIT START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEC_ID_PAGO_BIT START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

-- Vista donde estén los clientes con sus teléfonos
CREATE OR REPLACE VIEW VIW_CLIENTES_TELEFONOS AS
SELECT
    C.ID_CLIENTE,
    C.NOMBRE || ' ' || C.APATERNO || ' ' || C.AMATERNO AS NOMBRE_COMPLETO,
    C.RFC,
    T.TELEFONO
FROM CLIENTES C
INNER JOIN TELEFONOS T ON C.ID_CLIENTE = T.ID_CLIENTE;
COMMENT ON VIEW VIW_CLIENTES_TELEFONOS IS 'Vista de clientes y los teléfonos asociados.';

-- Vista donde estén las facturas con sus pagos
CREATE OR REPLACE VIEW VIW_FACTURAS_PAGOS AS
SELECT
    F.ID_FACTURA,
    F.FECHA_FACTURA,
    F.FOLIO || '/' || F.ANIO AS FOLIO_COMPLETO,
    F.MONTO_TOTAL AS MONTO_FACTURA,
    P.ID_PAGO,
    P.MONTO AS MONTO_PAGO,
    P.FECHA_PAGO
FROM FACTURAS F
LEFT JOIN -- Usamos LEFT JOIN para incluir facturas que aún no tienen pagos
    PAGOS P ON F.ID_FACTURA = P.ID_FACTURA
ORDER BY
    F.ID_FACTURA, P.FECHA_PAGO;
COMMENT ON VIEW VIW_FACTURAS_PAGOS IS 'Vista de facturas con el detalle de pagos realizados.';

CREATE OR REPLACE FUNCTION FN_MONTO_PAGOS_FALTANTE (
    p_id_factura IN NUMBER,
    p_tipo_calculo IN VARCHAR2 -- 'PAGADO' o 'FALTANTE'
)
RETURN NUMBER
IS
    v_monto_total_factura NUMBER(10,2);
    v_monto_total_pagado NUMBER(10,2);
    v_monto_faltante NUMBER(10,2);
BEGIN
    -- 1. Obtener el monto total de la factura
    SELECT MONTO_TOTAL INTO v_monto_total_factura
    FROM FACTURAS
    WHERE ID_FACTURA = p_id_factura;

    -- 2. Calcular el total de pagos realizados
    SELECT NVL(SUM(MONTO), 0) INTO v_monto_total_pagado
    FROM PAGOS
    WHERE ID_FACTURA = p_id_factura;

    -- 3. Calcular el monto faltante
    v_monto_faltante := v_monto_total_factura - v_monto_total_pagado;

    -- 4. Devolver el resultado según el tipo solicitado
    IF UPPER(p_tipo_calculo) = 'PAGADO' THEN
        RETURN v_monto_total_pagado;
    ELSIF UPPER(p_tipo_calculo) = 'FALTANTE' THEN
        RETURN v_monto_faltante;
    ELSE
        -- Devolver un valor para indicar error o tipo no válido
        RETURN NULL;
    END IF;

END FN_MONTO_PAGOS_FALTANTE;
COMMENT ON FUNCTION FN_MONTO_PAGOS_FALTANTE IS 'Calcula el monto total de pagos y el monto faltante para una factura.';

CREATE OR REPLACE FUNCTION FN_OBTENER_FOLIO_FACTURA (
    p_fecha_factura IN DATE
)
RETURN NUMBER
IS
    v_anio NUMBER := EXTRACT(YEAR FROM p_fecha_factura);
    v_seq_name VARCHAR2(30) := 'SEC_FOLIO_' || v_anio;
    v_folio NUMBER;
BEGIN
    -- 1. Asegurar que la secuencia anual exista
    SP_CREAR_SEC_FOLIO_ANIO(v_anio);

    -- 2. Obtener el siguiente valor de la secuencia (Folio)
    EXECUTE IMMEDIATE 'SELECT ' || v_seq_name || '.NEXTVAL FROM DUAL'
    INTO v_folio;

    RETURN v_folio;

END FN_OBTENER_FOLIO_FACTURA;
COMMENT ON FUNCTION FN_OBTENER_FOLIO_FACTURA IS 'Obtiene el folio consecutivo de la factura utilizando una secuencia anual dinámica.';

CREATE OR REPLACE PROCEDURE SP_CREAR_SEC_FOLIO_ANIO (
    p_anio IN NUMBER
)
IS
    v_seq_name VARCHAR2(30) := 'SEC_FOLIO_' || p_anio;
    v_count NUMBER;
BEGIN
    -- 1. Verificar si la secuencia ya existe
    SELECT COUNT(*)
    INTO v_count
    FROM ALL_SEQUENCES
    WHERE SEQUENCE_NAME = v_seq_name
      AND OWNER = SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA'); -- Asegura que sea el esquema actual

    -- 2. Si no existe, crearla
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'CREATE SEQUENCE ' || v_seq_name || ' START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE';
        DBMS_OUTPUT.PUT_LINE('Secuencia ' || v_seq_name || ' creada.');
    END IF;
EXCEPTION
    -- Manejar cualquier error de SQL dinámico
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error al crear la secuencia ' || v_seq_name || ': ' || SQLERRM);
END SP_CREAR_SEC_FOLIO_ANIO;
COMMENT ON PROCEDURE SP_CREAR_SEC_FOLIO_ANIO IS 'Procedimiento que crea la secuencia del folio de la factura por año';

-- Procedimiento almacenado para insertar facturas
CREATE OR REPLACE PROCEDURE SP_INSERTAR_FACTURA (
    p_id_cliente IN NUMBER,
    p_monto_total IN NUMBER,
    p_fecha_factura IN DATE,
    p_ip IN VARCHAR2 -- Necesario para el Trigger de Bitácora
)
IS
    v_new_id_factura NUMBER;
    v_folio NUMBER;
    v_anio NUMBER := EXTRACT(YEAR FROM p_fecha_factura);
BEGIN
    -- 1. Obtener nueva PK y Folio (Si no se usa el TRIGGER BEFORE)
    -- Si se usa el TRIGGER BEFORE , el trigger lo manejará,
    -- pero para asegurar la IP en el trigger, la guardaremos en una variable de sesión.

    -- 2. Insertar la factura
    INSERT INTO FACTURAS (
        ID_CLIENTE,
        MONTO_TOTAL,
        FECHA_FACTURA
        -- FOLIO y ANIO se llenarán en el Trigger BEFORE 
        -- ID_FACTURA se llenará en el Trigger BEFORE
    )
    VALUES (
        p_id_cliente,
        p_monto_total,
        p_fecha_factura
    )
    RETURNING ID_FACTURA INTO v_new_id_factura;

    -- 3. Si la inserción es exitosa, se hace COMMIT
    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        -- Si hay algún error, se hace ROLLBACK
        ROLLBACK;
        -- Opcional: Levantar el error para notificar al llamador
        RAISE;

END SP_INSERTAR_FACTURA;
COMMENT ON PROCEDURE SP_INSERTAR_FACTURA IS 'Inserta una factura con manejo de rollback en caso de error.';

-- Procedimiento almacenado para insertar pagos
CREATE OR REPLACE PROCEDURE SP_INSERTAR_PAGO (
    p_id_factura IN NUMBER,
    p_monto IN NUMBER,
    p_fecha_pago IN DATE,
    p_ip IN VARCHAR2 -- Necesario para el Trigger de Bitácora
)
IS
    v_new_id_pago NUMBER;
BEGIN
    -- 1. Insertar el pago (ID_PAGO se llenará en el Trigger BEFORE)
    INSERT INTO PAGOS (
        ID_FACTURA,
        MONTO,
        FECHA_PAGO
    )
    VALUES (
        p_id_factura,
        p_monto,
        p_fecha_pago
    )
    RETURNING ID_PAGO INTO v_new_id_pago;

    -- 2. Si la inserción es exitosa, se hace COMMIT
    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        -- Si hay algún error, se hace ROLLBACK
        ROLLBACK;
        -- Opcional: Levantar el error para notificar al llamador
        RAISE;

END SP_INSERTAR_PAGO;
COMMENT ON PROCEDURE SP_INSERTAR_PAGO IS 'Inserta un pago de factura con manejo de rollback en caso de error.';

-- Trigger BEFORE para CLIENTES (PK)
CREATE OR REPLACE TRIGGER TRG_CLIENTES_BI
BEFORE INSERT ON CLIENTES FOR EACH ROW
BEGIN
    :NEW.ID_CLIENTE := SEC_ID_CLIENTE.NEXTVAL;
END;


-- Trigger BEFORE para TELEFONOS (PK)
CREATE OR REPLACE TRIGGER TRG_TELEFONOS_BI
BEFORE INSERT ON TELEFONOS FOR EACH ROW
BEGIN
    :NEW.ID_TELEFONO := SEC_ID_TELEFONO.NEXTVAL;
END;


-- Trigger BEFORE para PAGOS (PK)
CREATE OR REPLACE TRIGGER TRG_PAGOS_BI
BEFORE INSERT ON PAGOS FOR EACH ROW
BEGIN
    :NEW.ID_PAGO := SEC_ID_PAGO.NEXTVAL;
END;


-- Trigger BEFORE para FACTURAS (PK, FOLIO, ANIO)
CREATE OR REPLACE TRIGGER TRG_FACTURAS_BI
BEFORE INSERT ON FACTURAS FOR EACH ROW
BEGIN
    -- 1. Llave Primaria
    :NEW.ID_FACTURA := SEC_ID_FACTURA.NEXTVAL;

    -- 2. Año (se obtiene de la FECHA_FACTURA)
    :NEW.ANIO := EXTRACT(YEAR FROM :NEW.FECHA_FACTURA);

    -- 3. Folio (se obtiene de la función)
    :NEW.FOLIO := FN_OBTENER_FOLIO_FACTURA(:NEW.FECHA_FACTURA);
END;


-- Función auxiliar para obtener una IP simulada o de contexto
CREATE OR REPLACE FUNCTION FN_GET_IP
RETURN VARCHAR2
IS
BEGIN
    -- Intentar obtener la IP del host conectado o del servidor
    RETURN NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), SYS_CONTEXT('USERENV', 'HOST'));
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'DESCONOCIDA';
END FN_GET_IP;


-- ---------------------------------
-- CLIENTES BITACORA
-- ---------------------------------
CREATE OR REPLACE TRIGGER TRG_CLIENTES_AIU
AFTER INSERT OR UPDATE ON CLIENTES FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO CLIENTES_BIT (
            ID_CLIENTE_BIT, ID_CLIENTE, NOMBRE, APATERNO, AMATERNO, RFC, FECHA_ALTA,
            FECHA_CREACION, FECHA_MODIFICACION, ACCION, IP
        ) VALUES (
            SEC_ID_CLIENTE_BIT.NEXTVAL, :NEW.ID_CLIENTE, :NEW.NOMBRE, :NEW.APATERNO, :NEW.AMATERNO, :NEW.RFC, :NEW.FECHA_ALTA,
            SYSDATE, NULL, 'INSERT', FN_GET_IP()
        );
    ELSIF UPDATING THEN
        INSERT INTO CLIENTES_BIT (
            ID_CLIENTE_BIT, ID_CLIENTE, NOMBRE, APATERNO, AMATERNO, RFC, FECHA_ALTA,
            FECHA_CREACION, FECHA_MODIFICACION, ACCION, IP
        ) VALUES (
            SEC_ID_CLIENTE_BIT.NEXTVAL, :NEW.ID_CLIENTE, :NEW.NOMBRE, :NEW.APATERNO, :NEW.AMATERNO, :NEW.RFC, :NEW.FECHA_ALTA,
            :OLD.FECHA_ALTA, SYSDATE, 'UPDATE', FN_GET_IP()
        );
    END IF;
END;


-- ---------------------------------
-- TELEFONOS BITACORA
-- ---------------------------------
CREATE OR REPLACE TRIGGER TRG_TELEFONOS_AIU
AFTER INSERT OR UPDATE ON TELEFONOS FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO TELEFONOS_BIT (
            ID_TELEFONO_BIT, ID_TELEFONO, ID_CLIENTE, TELEFONO,
            FECHA_CREACION, FECHA_MODIFICACION, ACCION, IP
        ) VALUES (
            SEC_ID_TELEFONO_BIT.NEXTVAL, :NEW.ID_TELEFONO, :NEW.ID_CLIENTE, :NEW.TELEFONO,
            SYSDATE, NULL, 'INSERT', FN_GET_IP()
        );
    ELSIF UPDATING THEN
        INSERT INTO TELEFONOS_BIT (
            ID_TELEFONO_BIT, ID_TELEFONO, ID_CLIENTE, TELEFONO,
            FECHA_CREACION, FECHA_MODIFICACION, ACCION, IP
        ) VALUES (
            SEC_ID_TELEFONO_BIT.NEXTVAL, :NEW.ID_TELEFONO, :NEW.ID_CLIENTE, :NEW.TELEFONO,
            :OLD.FECHA_CREACION, SYSDATE, 'UPDATE', FN_GET_IP()
        );
    END IF;
END;


-- ---------------------------------
-- FACTURAS BITACORA
-- ---------------------------------
CREATE OR REPLACE TRIGGER TRG_FACTURAS_AIU
AFTER INSERT OR UPDATE ON FACTURAS FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO FACTURAS_BIT (
            ID_FACTURA_BIT, ID_FACTURA, ID_CLIENTE, MONTO_TOTAL, FOLIO, ANIO, FECHA_FACTURA,
            FECHA_CREACION, FECHA_MODIFICACION, ACCION, IP
        ) VALUES (
            SEC_ID_FACTURA_BIT.NEXTVAL, :NEW.ID_FACTURA, :NEW.ID_CLIENTE, :NEW.MONTO_TOTAL, :NEW.FOLIO, :NEW.ANIO, :NEW.FECHA_FACTURA,
            SYSDATE, NULL, 'INSERT', FN_GET_IP()
        );
    ELSIF UPDATING THEN
        INSERT INTO FACTURAS_BIT (
            ID_FACTURA_BIT, ID_FACTURA, ID_CLIENTE, MONTO_TOTAL, FOLIO, ANIO, FECHA_FACTURA,
            FECHA_CREACION, FECHA_MODIFICACION, ACCION, IP
        ) VALUES (
            SEC_ID_FACTURA_BIT.NEXTVAL, :NEW.ID_FACTURA, :NEW.ID_CLIENTE, :NEW.MONTO_TOTAL, :NEW.FOLIO, :NEW.ANIO, :NEW.FECHA_FACTURA,
            :OLD.FECHA_CREACION, SYSDATE, 'UPDATE', FN_GET_IP()
        );
    END IF;
END;


-- ---------------------------------
-- PAGOS BITACORA
-- ---------------------------------
CREATE OR REPLACE TRIGGER TRG_PAGOS_AIU
AFTER INSERT OR UPDATE ON PAGOS FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO PAGOS_BIT (
            ID_PAGO_BIT, ID_PAGO, ID_FACTURA, MONTO, FECHA_PAGO,
            FECHA_CREACION, FECHA_MODIFICACION, ACCION, IP
        ) VALUES (
            SEC_ID_PAGO_BIT.NEXTVAL, :NEW.ID_PAGO, :NEW.ID_FACTURA, :NEW.MONTO, :NEW.FECHA_PAGO,
            SYSDATE, NULL, 'INSERT', FN_GET_IP()
        );
    ELSIF UPDATING THEN
        INSERT INTO PAGOS_BIT (
            ID_PAGO_BIT, ID_PAGO, ID_FACTURA, MONTO, FECHA_PAGO,
            FECHA_CREACION, FECHA_MODIFICACION, ACCION, IP
        ) VALUES (
            SEC_ID_PAGO_BIT.NEXTVAL, :NEW.ID_PAGO, :NEW.ID_FACTURA, :NEW.MONTO, :NEW.FECHA_PAGO,
            :OLD.FECHA_CREACION, SYSDATE, 'UPDATE', FN_GET_IP()
        );
    END IF;
END;

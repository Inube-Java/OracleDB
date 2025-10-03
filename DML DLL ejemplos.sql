-- Crear tablas
-- Creación de tabla clientes
CREATE TABLE clientes (
    id_cliente NUMBER NOT NULL,
    nombre VARCHAR2(40) NOT NULL,
    apaterno VARCHAR2(40) NOT NULL,
    amaterno VARCHAR2(40),
    rfc VARCHAR2(13),
    fecha_alta DATE DEFAULT SYSDATE,
    CONSTRAINT pk_id_cliente_clientes PRIMARY KEY (id_cliente)
);
COMMENT ON TABLE clientes IS 'Tabla que contiene la información del cliente';
COMMENT ON COLUMN clientes.id_cliente IS 'LLave primaria de la tabla clientes';
COMMENT ON COLUMN clientes.nombre IS 'Nombre del cliente';
COMMENT ON COLUMN clientes.apaterno IS 'Apellido paterno del cliente';
COMMENT ON COLUMN clientes.amaterno IS 'Apellido materno del cliente';
COMMENT ON COLUMN clientes.rfc IS 'Registro Fededal de Contribuyentes del cliente';
COMMENT ON COLUMN clientes.fecha_alta IS 'Fecha de alta del cliente';

-- Creación de la tabla teléfono
CREATE TABLE TELEFONOS (
  ID_TELEFONO NUMBER NOT NULL,
  ID_CLIENTE NUMBER NOT NULL,
  TELEFONO VARCHAR2(15) NOT NULL,
  CONSTRAINT pk_id_telefono_telefonos PRIMARY KEY (ID_TELEFONO),
  CONSTRAINT fk_id_cliente_telefonos FOREIGN KEY (ID_CLIENTE) REFERENCES CLIENTES (ID_CLIENTE)
);
COMMENT ON TABLE TELEFONOS IS 'Tabla que contiene los teléfonos de los clientes';
COMMENT ON COLUMN TELEFONOS.ID_TELEFONO IS 'Llave primaria de la tabla TELEFONOS';
COMMENT ON COLUMN TELEFONOS.ID_CLIENTE IS 'Llave foranea ID_CLIENTE que hace referencia a la tabla CLIENTES';
COMMENT ON COLUMN TELEFONOS.TELEFONO IS 'Número Teléfonico del Cliente';

-- Para renombrar un campo 
-- ALTER TABLE TELOFONOS RENAME COLUMN ID_CLINETE TO ID_CLIENTE;
-- Eliminar la tabla con todo y datos
-- DROP TABLE TELEFONOS;
-- Eliminar la tabla con todo y datos, además de las constraints
-- DROP TABLE TELEFONOS CASCADE CONSTRAINTS;
-- Consulta para revisar los comentarios sobre una tabla o todas las tablas
SELECT TABLE_NAME, COMMENTS FROM USER_TAB_COMMENTS WHERE TABLE_NAME = 'CLIENTES';

-- Creación de tabla facturas
CREATE TABLE FACTURAS (
  ID_FACTURA NUMBER NOT NULL,
  ID_CLIENTE NUMBER NOT NULL,
  MONTO_TOTAL NUMBER(10,2) NOT NULL,
  FOLIO NUMBER NOT NULL,
  ANIO NUMBER NOT NULL,
  FECHA_FACTURA DATE DEFAULT SYSDATE,
  CONSTRAINT pk_id_factura_facturas PRIMARY KEY (ID_FACTURA),
  CONSTRAINT fk_id_cliente_facturas FOREIGN KEY (ID_CLIENTE) REFERENCES CLIENTES (ID_CLIENTE)
);
COMMENT ON TABLE FACTURAS IS 'Tabla que contiene las facturas de los clientes';
COMMENT ON COLUMN FACTURAS.ID_FACTURA IS 'Llave primaria de la tabla FACTURAS';
COMMENT ON COLUMN FACTURAS.ID_CLIENTE IS 'Llave foranea ID_CLIENTE que hace referencia a la tabla CLIENTES';
COMMENT ON COLUMN FACTURAS.MONTO_TOTAL IS 'Monto total de la Factura';
COMMENT ON COLUMN FACTURAS.FOLIO IS 'Folio consecutivo por año de la Factura';
COMMENT ON COLUMN FACTURAS.ANIO IS 'Año de la factura';
COMMENT ON COLUMN FACTURAS.FECHA_FACTURA IS 'Fecha de la Factura';

-- Creación de la tabla pagos
CREATE TABLE PAGOS (
  ID_PAGO NUMBER NOT NULL,
  ID_FACTURA NUMBER NOT NULL,
  MONTO NUMBER (10,2) NOT NULL,
  FECHA_PAGO DATE DEFAULT SYSDATE,
  CONSTRAINT pk_id_pago_pagos PRIMARY KEY (ID_PAGO),
  CONSTRAINT fk_id_factura_pagos FOREIGN KEY (ID_FACTURA) REFERENCES FACTURAS (ID_FACTURA)
);
COMMENT ON TABLE PAGOS IS 'Tabla que contiene los pagos totales o parciales de una factura';
COMMENT ON COLUMN PAGOS.ID_PAGO IS 'Llave primaria de la tabla PAGOS';
COMMENT ON COLUMN PAGOS.ID_FACTURA IS 'Llave foranea ID_FACTURA que hace referencia a la tabla FACTURAS';
COMMENT ON COLUMN PAGOS.MONTO IS 'Monto del pago de la Factura';
COMMENT ON COLUMN PAGOS.FECHA_PAGO IS 'Fecha de pago de la Factura';

-- Creación de tabla de bitácora de clientes
CREATE TABLE clientes_bit (
    id_cliente_bit NUMBER NOT NULL,
    id_cliente NUMBER NOT NULL,
    nombre VARCHAR2(40) NOT NULL,
    apaterno VARCHAR2(40) NOT NULL,
    amaterno VARCHAR2(40),
    rfc VARCHAR2(13),
    fecha_alta DATE DEFAULT SYSDATE,
    fecha_creacion DATE DEFAULT SYSDATE,
    fecha_modificacion DATE,
    accion VARCHAR2(10) NOT NULL,
    ip VARCHAR2(30) NOT NULL,    
    CONSTRAINT pk_id_cliente_bit_clientes_bit PRIMARY KEY (id_cliente_bit),
    CONSTRAINT fk_id_ciente_clientes_bit FOREIGN KEY (ID_CLIENTE) REFERENCES CLIENTES (ID_CLIENTE)
);
COMMENT ON TABLE clientes_bit IS 'Tabla de bitácora que contiene la información del cliente';
COMMENT ON COLUMN clientes_bit.id_cliente_bit IS 'LLave primaria de la tabla clientes_bit';
COMMENT ON COLUMN clientes_bit.id_cliente IS 'LLave primaria de la tabla clientes';
COMMENT ON COLUMN clientes_bit.nombre IS 'Nombre del cliente';
COMMENT ON COLUMN clientes_bit.apaterno IS 'Apellido paterno del cliente';
COMMENT ON COLUMN clientes_bit.amaterno IS 'Apellido materno del cliente';
COMMENT ON COLUMN clientes_bit.rfc IS 'Registro Fededal de Contribuyentes del cliente';
COMMENT ON COLUMN clientes_bit.fecha_alta IS 'Fecha de alta del cliente';
COMMENT ON COLUMN clientes_bit.fecha_creacion IS 'Campo de control que indica la Fecha de creación en la BD';
COMMENT ON COLUMN clientes_bit.fecha_modificacion IS 'Campo de control que indica la Fecha de modifcación en la BD';
COMMENT ON COLUMN clientes_bit.accion IS 'Campo de control que indica la acción en el registro';
COMMENT ON COLUMN clientes_bit.ip IS 'Campo de control que indica ip de donde se solicito operación en el registro';

-- Creación de la tabla de bitácota de teléfono
CREATE TABLE TELEFONOS_BIT (
  ID_TELEFONO_BIT NUMBER NOT NULL,
  ID_TELEFONO NUMBER NOT NULL,
  ID_CLIENTE NUMBER NOT NULL,
  TELEFONO VARCHAR2(15) NOT NULL,
  fecha_creacion DATE DEFAULT SYSDATE,
  fecha_modificacion DATE,
  accion VARCHAR2(10) NOT NULL,
  ip VARCHAR2(30) NOT NULL,  
  CONSTRAINT pk_id_telefono_bit_telefonos_bit PRIMARY KEY (ID_TELEFONO_BIT),
  CONSTRAINT fk_id_telefono_telefonos_bit FOREIGN KEY (ID_TELEFONO) REFERENCES TELEFONOS (ID_TELEFONO),
  CONSTRAINT fk_id_cliente_telefonos_bit FOREIGN KEY (ID_CLIENTE) REFERENCES CLIENTES (ID_CLIENTE)
);
COMMENT ON TABLE TELEFONOS_BIT IS 'Tabla de bitácora que contiene los teléfonos de los clientes';
COMMENT ON COLUMN TELEFONOS_BIT.ID_TELEFONO_BIT IS 'Llave primaria de la tabla TELEFONOS_BIT';
COMMENT ON COLUMN TELEFONOS_BIT.ID_TELEFONO IS 'Llave primaria de la tabla TELEFONOS';
COMMENT ON COLUMN TELEFONOS_BIT.ID_CLIENTE IS 'Llave foranea ID_CLIENTE que hace referencia a la tabla CLIENTES';
COMMENT ON COLUMN TELEFONOS_BIT.TELEFONO IS 'Número Teléfonico del Cliente';
COMMENT ON COLUMN TELEFONOS_BIT.fecha_creacion IS 'Campo de control que indica la Fecha de creación en la BD';
COMMENT ON COLUMN TELEFONOS_BIT.fecha_modificacion IS 'Campo de control que indica la Fecha de modifcación en la BD';
COMMENT ON COLUMN TELEFONOS_BIT.accion IS 'Campo de control que indica la acción en el registro';
COMMENT ON COLUMN TELEFONOS_BIT.ip IS 'Campo de control que indica ip de donde se solicito operación en el registro';



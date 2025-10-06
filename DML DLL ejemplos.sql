-- Script que crea tablas y sus bitácoras de ejemplo
-- Crear tablas

-- Creación de tabla CLIENTES
CREATE TABLE CLIENTES (
    ID_CLIENTE NUMBER NOT NULL,
    NOMBRE VARCHAR2(40) NOT NULL,
    APATERNO VARCHAR2(40) NOT NULL,
    AMATERNO VARCHAR2(40),
    RFC VARCHAR2(13),
    FECHA_ALTA DATE DEFAULT SYSDATE,
    CONSTRAINT pk_id_cliente_clientes PRIMARY KEY (ID_CLIENTE)
);
COMMENT ON TABLE CLIENTES IS 'Tabla que contiene la información del Cliente';
COMMENT ON COLUMN CLIENTES.ID_CLIENTE IS 'LLave primaria de la tabla Clientes';
COMMENT ON COLUMN CLIENTES.NOMBRE IS 'Nombre del Cliente';
COMMENT ON COLUMN CLIENTES.APATERNO IS 'Apellido Paterno del Cliente';
COMMENT ON COLUMN CLIENTES.AMATERNO IS 'Apellido Materno del Cliente';
COMMENT ON COLUMN CLIENTES.RFC IS 'Registro Fededal de Contribuyentes del Cliente';
COMMENT ON COLUMN CLIENTES.FECHA_ALTA IS 'Fecha de Alta del Cliente';

-- Creación de tabla de Bitácora de CLIENTES
CREATE TABLE CLIENTES_BIT (
    ID_CLIENTE_BIT NUMBER NOT NULL,
    ID_CLIENTE NUMBER NOT NULL,
    NOMBRE VARCHAR2(40) NOT NULL,
    APATERNO VARCHAR2(40) NOT NULL,
    AMATERNO VARCHAR2(40),
    RFC VARCHAR2(13),
    FECHA_ALTA DATE DEFAULT SYSDATE,
    FECHA_CREACION DATE DEFAULT SYSDATE,
    FECHA_MODIFICACION DATE,
    ACCION VARCHAR2(10) NOT NULL,
    IP VARCHAR2(30) NOT NULL,    
    CONSTRAINT pk_id_cliente_bit_clientes_bit PRIMARY KEY (ID_CLIENTE_BIT),
    CONSTRAINT fk_id_ciente_clientes_bit FOREIGN KEY (ID_CLIENTE) REFERENCES CLIENTES (ID_CLIENTE)
);
COMMENT ON TABLE CLIENTES_BIT IS 'Tabla de Bitácora que contiene la información del Cliente';
COMMENT ON COLUMN CLIENTES_BIT.ID_CLIENTE_BIT IS 'LLave primaria de la tabla CLIENTES_BIT';
COMMENT ON COLUMN CLIENTES_BIT.ID_CLIENTE IS 'Llave foranea ID_CLIENTE que hace referencia a la tabla CLIENTES';
COMMENT ON COLUMN CLIENTES_BIT.NOMBRE IS 'Nombre del Cliente';
COMMENT ON COLUMN CLIENTES_BIT.APATERNO IS 'Apellido Paterno del Cliente';
COMMENT ON COLUMN CLIENTES_BIT.AMATERNO IS 'Apellido Materno del Cliente';
COMMENT ON COLUMN CLIENTES_BIT.RFC IS 'Registro Fededal de Contribuyentes del Cliente';
COMMENT ON COLUMN CLIENTES_BIT.FECHA_ALTA IS 'Fecha de Alta del Cliente';
COMMENT ON COLUMN CLIENTES_BIT.FECHA_CREACION IS 'Campo de control que indica la Fecha de Creación en la BD';
COMMENT ON COLUMN CLIENTES_BIT.FECHA_MODIFICACION IS 'Campo de control que indica la Fecha de Modifcación en la BD';
COMMENT ON COLUMN CLIENTES_BIT.ACCION IS 'Campo de control que indica la Acción en el Registro';
COMMENT ON COLUMN CLIENTES_BIT.IP IS 'Campo de control que indica IP de donde se solicito operación en el registro';

-- Creación de la tabla TELEFONOS
CREATE TABLE TELEFONOS (
  ID_TELEFONO NUMBER NOT NULL,
  ID_CLIENTE NUMBER NOT NULL,
  TELEFONO VARCHAR2(15) NOT NULL,
  CONSTRAINT pk_id_telefono_telefonos PRIMARY KEY (ID_TELEFONO),
  CONSTRAINT fk_id_cliente_telefonos FOREIGN KEY (ID_CLIENTE) REFERENCES CLIENTES (ID_CLIENTE)
);
COMMENT ON TABLE TELEFONOS IS 'Tabla que contiene los Teléfonos de los Clientes';
COMMENT ON COLUMN TELEFONOS.ID_TELEFONO IS 'Llave primaria de la tabla TELEFONOS';
COMMENT ON COLUMN TELEFONOS.ID_CLIENTE IS 'Llave foranea ID_CLIENTE que hace referencia a la tabla CLIENTES';
COMMENT ON COLUMN TELEFONOS.TELEFONO IS 'Número Teléfonico del Cliente';

-- Creación de la tabla de Bitácota de TELEFONOS
CREATE TABLE TELEFONOS_BIT (
  ID_TELEFONO_BIT NUMBER NOT NULL,
  ID_TELEFONO NUMBER NOT NULL,
  ID_CLIENTE NUMBER NOT NULL,
  TELEFONO VARCHAR2(15) NOT NULL,
  FECHA_CREACION DATE DEFAULT SYSDATE,
  FECHA_MODIFICACION DATE,
  ACCION VARCHAR2(10) NOT NULL,
  IP VARCHAR2(30) NOT NULL,  
  CONSTRAINT pk_id_telefono_bit_telefonos_bit PRIMARY KEY (ID_TELEFONO_BIT),
  CONSTRAINT fk_id_telefono_telefonos_bit FOREIGN KEY (ID_TELEFONO) REFERENCES TELEFONOS (ID_TELEFONO),
  CONSTRAINT fk_id_cliente_telefonos_bit FOREIGN KEY (ID_CLIENTE) REFERENCES CLIENTES (ID_CLIENTE)
);
COMMENT ON TABLE TELEFONOS_BIT IS 'Tabla de Bitácora que contiene los Teléfonos de los Clientes';
COMMENT ON COLUMN TELEFONOS_BIT.ID_TELEFONO_BIT IS 'Llave primaria de la tabla TELEFONOS_BIT';
COMMENT ON COLUMN TELEFONOS_BIT.ID_TELEFONO IS 'Llave foranea ID_TELEFONO que hace referencia a la tabla TELEFONOS';
COMMENT ON COLUMN TELEFONOS_BIT.ID_CLIENTE IS 'Llave foranea ID_CLIENTE que hace referencia a la tabla CLIENTES';
COMMENT ON COLUMN TELEFONOS_BIT.TELEFONO IS 'Número Teléfonico del Cliente';
COMMENT ON COLUMN TELEFONOS_BIT.FECHA_CREACION IS 'Campo de control que indica la Fecha de Creación en la BD';
COMMENT ON COLUMN TELEFONOS_BIT.FECHA_MODIFICACION IS 'Campo de control que indica la Fecha de Modifcación en la BD';
COMMENT ON COLUMN TELEFONOS_BIT.ACCION IS 'Campo de control que indica la Acción en el Registro';
COMMENT ON COLUMN TELEFONOS_BIT.IP IS 'Campo de control que indica IP de donde se solicito operación en el Registro';

-- Creación de Tabla FACTURAS
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
COMMENT ON TABLE FACTURAS IS 'Tabla que contiene las Facturas de los Clientes';
COMMENT ON COLUMN FACTURAS.ID_FACTURA IS 'Llave primaria de la tabla FACTURAS';
COMMENT ON COLUMN FACTURAS.ID_CLIENTE IS 'Llave foranea ID_CLIENTE que hace referencia a la tabla CLIENTES';
COMMENT ON COLUMN FACTURAS.MONTO_TOTAL IS 'Monto total de la Factura';
COMMENT ON COLUMN FACTURAS.FOLIO IS 'Folio Consecutivo por Año de la Factura';
COMMENT ON COLUMN FACTURAS.ANIO IS 'Año de la Factura';
COMMENT ON COLUMN FACTURAS.FECHA_FACTURA IS 'Fecha de la Factura';

-- Creación de Tabla de Bitácora de FACTURAS
CREATE TABLE FACTURAS_BIT (
  ID_FACTURA_BIT NUMBER NOT NULL,
  ID_FACTURA NUMBER NOT NULL,
  ID_CLIENTE NUMBER NOT NULL,
  MONTO_TOTAL NUMBER(10,2) NOT NULL,
  FOLIO NUMBER NOT NULL,
  ANIO NUMBER NOT NULL,
  FECHA_FACTURA DATE DEFAULT SYSDATE,
  FECHA_CREACION DATE DEFAULT SYSDATE,
  FECHA_MODIFICACION DATE,
  ACCION VARCHAR2(10) NOT NULL,
  IP VARCHAR2(30) NOT NULL, 
  CONSTRAINT pk_id_factura_bit_facturas_bit PRIMARY KEY (ID_FACTURA_BIT),
  CONSTRAINT fk_id_factura_facturas_bit FOREIGN KEY (ID_FACTURA) REFERENCES FACTURAS (ID_FACTURA),
  CONSTRAINT fk_id_cliente_facturas_bit FOREIGN KEY (ID_CLIENTE) REFERENCES CLIENTES (ID_CLIENTE)
);
COMMENT ON TABLE FACTURAS_BIT IS 'Tabla de Bitácora que contiene las Facturas de los Clientes';
COMMENT ON COLUMN FACTURAS_BIT.ID_FACTURA_BIT IS 'Llave primaria de la tabla FACTURAS_BIT';
COMMENT ON COLUMN FACTURAS_BIT.ID_FACTURA IS 'Llave foranea ID_FACTURA que hace referencia a la tabla FACTURAS';
COMMENT ON COLUMN FACTURAS_BIT.ID_CLIENTE IS 'Llave foranea ID_CLIENTE que hace referencia a la tabla CLIENTES';
COMMENT ON COLUMN FACTURAS_BIT.MONTO_TOTAL IS 'Monto Total de la Factura';
COMMENT ON COLUMN FACTURAS_BIT.FOLIO IS 'Folio Consecutivo por Año de la Factura';
COMMENT ON COLUMN FACTURAS_BIT.ANIO IS 'Año de la Factura';
COMMENT ON COLUMN FACTURAS_BIT.FECHA_FACTURA IS 'Fecha de la Factura';
COMMENT ON COLUMN FACTURAS_BIT.FECHA_CREACION IS 'Campo de control que indica la Fecha de Creación en la BD';
COMMENT ON COLUMN FACTURAS_BIT.FECHA_MODIFICACION IS 'Campo de control que indica la Fecha de Modifcación en la BD';
COMMENT ON COLUMN FACTURAS_BIT.ACCION IS 'Campo de control que indica la Acción en el Registro';
COMMENT ON COLUMN FACTURAS_BIT.IP IS 'Campo de control que indica IP de donde se solicito operación en el Registro';

-- Creación de la tabla pagos
CREATE TABLE PAGOS (
  ID_PAGO NUMBER NOT NULL,
  ID_FACTURA NUMBER NOT NULL,
  MONTO NUMBER (10,2) NOT NULL,
  FECHA_PAGO DATE DEFAULT SYSDATE,
  CONSTRAINT pk_id_pago_pagos PRIMARY KEY (ID_PAGO),
  CONSTRAINT fk_id_factura_pagos FOREIGN KEY (ID_FACTURA) REFERENCES FACTURAS (ID_FACTURA)
);
COMMENT ON TABLE PAGOS IS 'Tabla que contiene los Pagos Totales o Parciales de una Factura';
COMMENT ON COLUMN PAGOS.ID_PAGO IS 'Llave primaria de la tabla PAGOS';
COMMENT ON COLUMN PAGOS.ID_FACTURA IS 'Llave foranea ID_FACTURA que hace referencia a la tabla FACTURAS';
COMMENT ON COLUMN PAGOS.MONTO IS 'Monto del Pago de la Factura';
COMMENT ON COLUMN PAGOS.FECHA_PAGO IS 'Fecha de Pago de la Factura';

-- Creación de la tabla pagos
CREATE TABLE PAGOS_BIT (
  ID_PAGO_BIT NUMBER NOT NULL,
  ID_PAGO NUMBER NOT NULL,
  ID_FACTURA NUMBER NOT NULL,
  MONTO NUMBER (10,2) NOT NULL,
  FECHA_PAGO DATE DEFAULT SYSDATE,
  FECHA_CREACION DATE DEFAULT SYSDATE,
  FECHA_MODIFICACION DATE,
  ACCION VARCHAR2(10) NOT NULL,
  IP VARCHAR2(30) NOT NULL,
  CONSTRAINT pk_id_pago_bit_pagos_bit PRIMARY KEY (ID_PAGO_BIT),
  CONSTRAINT fk_id_pago_pagos_bit FOREIGN KEY (ID_PAGO) REFERENCES PAGOS (ID_PAGO),
  CONSTRAINT fk_id_factura_pagos_bit FOREIGN KEY (ID_FACTURA) REFERENCES FACTURAS (ID_FACTURA)
);
COMMENT ON TABLE PAGOS_BIT IS 'Tabla de Bitácora que contiene los Pagos Totales o Parciales de una Factura';
COMMENT ON COLUMN PAGOS_BIT.ID_PAGO_BIT IS 'Llave primaria de la tabla PAGOS_BIT';
COMMENT ON COLUMN PAGOS_BIT.ID_PAGO IS 'Llave foranea ID_PAGO que hace referencia a la tabla PAGOS';
COMMENT ON COLUMN PAGOS_BIT.ID_FACTURA IS 'Llave foranea ID_FACTURA que hace referencia a la tabla FACTURAS';
COMMENT ON COLUMN PAGOS_BIT.MONTO IS 'Monto del Pago de la Factura';
COMMENT ON COLUMN PAGOS_BIT.FECHA_PAGO IS 'Fecha de Pago de la Factura';
COMMENT ON COLUMN PAGOS_BIT.FECHA_CREACION IS 'Campo de control que indica la Fecha de Creación en la BD';
COMMENT ON COLUMN PAGOS_BIT.FECHA_MODIFICACION IS 'Campo de control que indica la Fecha de Modifcación en la BD';
COMMENT ON COLUMN PAGOS_BIT.ACCION IS 'Campo de control que indica la Acción en el Registro';
COMMENT ON COLUMN PAGOS_BIT.IP IS 'Campo de control que indica IP de donde se solicito operación en el Registro';

-- Para renombrar un campo 
-- ALTER TABLE TELOFONOS RENAME COLUMN ID_CLINETE TO ID_CLIENTE;
-- Eliminar la tabla con todo y datos
-- DROP TABLE TELEFONOS;
-- Eliminar la tabla con todo y datos, además de las constraints
-- DROP TABLE TELEFONOS CASCADE CONSTRAINTS;
-- Consulta para revisar los comentarios sobre una tabla o todas las tablas
--SELECT TABLE_NAME, COMMENTS FROM USER_TAB_COMMENTS WHERE TABLE_NAME = 'CLIENTES';



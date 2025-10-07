-- Crear el usuario
CREATE USER ejemplos IDENTIFIED BY ejemplo
DEFAULT TABLESPACE users
TEMPORARY TABLESPACE temp
QUOTA UNLIMITED ON users;

-- Dar privilegios básicos para conectarse y trabajar con sus tablas
GRANT CREATE SESSION TO ejemplos;  -- Permiso para hacer login
GRANT CREATE TABLE TO ejemplos; --Permiso para crear tablas
GRANT CREATE SEQUENCE TO ejemplos; -- Permiso para crear secuencias
GRANT CREATE VIEW TO ejemplos; -- Permiso para crear vistas
GRANT CREATE TRIGGER TO ejemplos;  -- Permioso para crear triggers
GRANT CREATE PROCEDURE TO ejemplos; -- Permiso para crear funciones y procedimientos almacenados
GRANT CREATE MATERIALIZED VIEW TO ejemplos; -- Permiso para crear vistas materializadas

-- Rol resource
GRANT RESOURCE TO ejemplos;





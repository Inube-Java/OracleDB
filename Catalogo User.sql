-- Crear el usuario
CREATE USER catalogos IDENTIFIED BY catalogos
DEFAULT TABLESPACE users
TEMPORARY TABLESPACE temp
QUOTA UNLIMITED ON users;

-- Dar privilegios básicos para conectarse y trabajar con sus tablas
GRANT CREATE SESSION TO catalogos;  -- Permiso para hacer login
GRANT CREATE TABLE TO catalogos; --Permiso para crear tablas
GRANT CREATE SEQUENCE TO catalogos; -- Permiso para crear secuencias
GRANT CREATE VIEW TO catalogos; -- Permiso para crear vistas
GRANT CREATE TRIGGER TO catalogos;  -- Permioso para crear triggers
GRANT CREATE PROCEDURE TO catalogos; -- Permiso para crear funciones y procedimientos almacenados
GRANT CREATE MATERIALIZED VIEW TO catalogos; -- Permiso para crear vistas materializadas
GRANT CREATE DATABASE LINK TO catalogos; -- Permiso para crear database link
GRANT CREATE SYNONYM TO catalogos; -- Permiso para crear sinonimos

-- Rol resource
GRANT RESOURCE TO catalogos;

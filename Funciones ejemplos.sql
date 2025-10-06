-- Función para obtener la IP de la solicitud
-- Para llamar a una función
-- SELECT FN_GET_IP() FROM DUAL;
CREATE OR REPLACE FUNCTION FN_GET_IP
RETURN VARCHAR2
IS
BEGIN
  -- Intento de obtener IP del host que hace conexión
  RETURN NVL(SYS_CONTEXT('USERENV', 'IP_ADDRESS'), SYS_CONTEXT('USERENV', 'HOST'));
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 'LOCALHOST';
END FN_GET_IP;
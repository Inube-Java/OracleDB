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

-- Función que nos devuelva el folio de la factura
CREATE OR REPLACE FUNCTION FN_OBTENER_FOLIO_FACTURA (
  p_fecha_factura IN DATE
)
RETURN NUMBER
IS
  v_anio NUMBER := EXTRACT(YEAR FROM p_fecha_factura);
  v_seq_name VARCHAR(30) := 'SEC_FOLIO_' || v_anio;
  v_folio NUMBER := 1;
BEGIN  
  -- Validar que la secuencia exista o se cree
  SP_CREAR_SEQ_FOLIO_ANIO(v_anio);
  -- Obtener el valor de la secuencia
  EXECUTE IMMEDIATE 'SELECT ' || v_seq_name || '.NEXTVAL FROM DUAL' INTO v_folio;
  return v_folio;
END;

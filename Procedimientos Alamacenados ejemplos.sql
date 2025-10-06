-- Crear el procedimiento almacenado que genera la secuencia del folio de factura por año
CREATE OR REPLACE PROCEDURE SP_CREAR_SEQ_FOLIO_ANIO (
  p_anio IN NUMBER
)
IS
  v_seq_name VARCHAR(30):= 'SEC_FOLIO_' || p_anio;
  v_count NUMBER := 0;
BEGIN
  -- Verificar si la secuencia existe
  SELECT COUNT(*) INTO v_count FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = v_seq_name
  AND SEQUENCE_OWNER = SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA');
  -- Si no existe la secuencia se debe de crear
  IF v_count = 0 THEN
    EXECUTE IMMEDIATE 'CREATE SEQUENCE ' || v_seq_name || ' START WITH 1 INCREMENT BY 1 NOCACHE NOCYLE';
    DBMS_OUTPUT.PUT_LINE('Secuencia ' || v_seq_name || 'creada.');    
  END IF;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20001, 'Error al crear la secuencia ' || v_seq_name || ':' || SQLERRM);
END;

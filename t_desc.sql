create or replace 
trigger t_desc
AFTER UPDATE OF categoria ON Cliente FOR EACH ROW 

DECLARE 
  v_numDescuentos NUMBER;
BEGIN
  SELECT count(*) into v_numDescuentos
  FROM Descuento
  WHERE email = :OLD.email;
  
  IF :NEW.categoria = 'Frecuente' THEN
  
    INSERT INTO Descuento VALUES(v_numDescuentos + 1, ADD_MONTHS(SYSDATE,3), 10.00, null, :OLD.email); 
    
  ELSIF :NEW.categoria = 'Experto' THEN 
  
    INSERT INTO Descuento VALUES(v_numDescuentos + 1, ADD_MONTHS(SYSDATE,3), 25.00, null, :OLD.email); 
  
  END IF;
END;
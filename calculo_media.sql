create or replace 
PROCEDURE calculo_medias
IS
  DECLARE 
    CURSOR cursorReservas IS
    SELECT NIF, calidad, precio, servicio 
    FROM INFO_RESERVA
    GROUP BY NIF;
    v_calidad INFO_RESERVA.calidad%TYPE;
    v_precio INFO_RESERVA.calidad%TYPE;
    v_servicio INFO_RESERVA.calidad%TYPE;
    v_total NUMBER;
BEGIN
 OPEN cursorReservas;
 LOOP
  FETCH cursorReservas INTO v_calidad, v_precio, v_servicio
  -----------------------
  EXIT WHEN cursorReservas%NOTFOUND;
  END LOOP;
END;



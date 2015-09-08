create or replace 
PROCEDURE ejercicio4
IS
  CURSOR cursorlistado is
  SELECT avg(calidad), avg(precio), avg(servicio)
  FROM info_reserva;
  media_precio info_reserva.precio%TYPE;
  media_calidad info_reserva.calidad%TYPE;
  media_servicio info_reserva.servicio%TYPE;
  
  total_media NUMBER;
BEGIN
  open cursorlistado;
  loop
    fetch cursorlistado into media_calidad, media_precio, media_servicio;
    exit when cursorlistado%NOTFOUND;
    
    select media_calidad + media_precio + media_servicio into total_media
    from dual
    order by total_media desc;
    
    dbms_output.put_line(' calidad ' || media_calidad || ' precio ' || media_precio || ' servicio ' || media_servicio 
    || ' total ' || total_media);
  end loop;
  close cursorlistado;
END;
create or replace 
PROCEDURE ejercicio4
IS
  CURSOR cursorlistado is
  
  SELECT  restaurante.tipo_comida, restaurante.nif, avg(calidad), avg(precio), avg(servicio), 
          ROUND((avg(calidad) + avg(precio) + avg(servicio))/3, 2) as Media_Total
  FROM info_reserva, restaurante
  WHERE restaurante.nif = info_reserva.nif
  GROUP BY restaurante.nif, restaurante.tipo_comida
  ORDER BY restaurante.tipo_comida asc, Media_Total desc;
  
  media_precio info_reserva.precio%TYPE;
  media_calidad info_reserva.calidad%TYPE;
  media_servicio info_reserva.servicio%TYPE;
  comida restaurante.tipo_comida%TYPE;
  nif_rest restaurante.nif%TYPE;
  
  total_media NUMBER;
BEGIN
  open cursorlistado;
  
  dbms_output.put_line(' TIPO COMIDA    RESTAURANTE    MEDIA CALIDAD    MEDIA PRECIO    MEDIA SERVICIO    MEDIA TOTAL');
  dbms_output.put_line(rpad('-',95,'-'));
  
  loop
    fetch cursorlistado into comida, nif_rest, media_calidad, media_precio, media_servicio, total_media; 
    exit when cursorlistado%NOTFOUND;
    
    dbms_output.put_line( rpad(comida, 17, ' ') || rpad(nif_rest, 20, ' ') || rpad(media_calidad, 17, ' ') || 
                          rpad(media_precio, 17, ' ') || rpad(media_servicio, 15, ' ') ||  total_media);
  end loop;
  close cursorlistado;
END;
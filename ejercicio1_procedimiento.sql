create or replace 
PROCEDURE EJERCICIO3 IS 

/*Cursor para reservas*/
CURSOR cursorReservas is
SELECT email, idReserva, nif, opinion_calidad, opinion_precio, opinion_servicio     
FROM reserva
WHERE add_months(fecha,1) < sysdate and asistencia = 'SI';

/*Cursor para el descuento*/
CURSOR cursorDescuento is 
SELECT numDesc, email, caducidad, importe
FROM descuento
WHERE caducidad < sysdate;

correo_cliente reserva.email%TYPE;
id_reserva reserva.idreserva%TYPE;
nif_rest reserva.nif%TYPE;
op_calidad reserva.opinion_calidad%TYPE;
op_precio reserva.opinion_precio%TYPE;
op_servicio reserva.opinion_servicio%TYPE;
num_descuento descuento.numdesc%TYPE;
cad_descuento descuento.caducidad%TYPE;
importe_desc descuento.importe%TYPE;
visitas_totales NUMBER;

BEGIN
  open cursorReservas;
  loop
    fetch cursorReservas into correo_cliente, id_reserva, nif_rest, op_calidad, op_precio, op_servicio;
    exit when cursorReservas%NOTFOUND;

    /*insertamos la informacion de las opiniones de las reservas anteriores a los ultimos 30 dias*/
    insert into info_reserva values(id_reserva, op_calidad, op_servicio, op_precio, nif_rest);
    
    /*Actualizamos el numero de visitas del cliente que haya reservado y haya asistido*/
    update asistencia
    set numVisitas = numvisitas + 1
    where asistencia.email= correo_cliente and asistencia.nif = nif_rest; /*CONTEMPLAR EL CASO QUE NUNCA HAYA ASISTIDO*/
    
    /*Actualizamos la categoria del usuario, obteniendo d ela tabla de asistencia el numero de visitas que ha realizado**/
    select sum(numvisitas), cliente.email into visitas_totales, correo_cliente
    from asistencia, cliente
    where cliente.email= correo_cliente and asistencia.email= cliente.email
    group by cliente.email;
    /*REVISAR QUE SI EL CLIENTE YA ESTA EN ESA CATEGORIA NO HAY QUE CAMBIARLO**/
    if visitas_totales > 15 then
      update cliente
      set categoria = 'Experto'
      where email = correo_cliente;
    elsif visitas_totales > 8 then
      update cliente
      set categoria = 'Frecuente'
      where email = correo_cliente;
    end if;  
    /*Borrar las reservas con más de 30 días de antigüedad*/
    delete from Reserva where idReserva = id_reserva;   
  end loop;
  close cursorReservas;
  
  open cursorDescuento;
    dbms_output.put_line(' CLIENTE          IMPORTE    NÚMERO DE DESCUENTO ');
    dbms_output.put_line(rpad('-',48,'-'));
  loop
    fetch cursorDescuento into num_descuento, correo_cliente, cad_descuento, importe_desc;  
    exit when cursorDescuento%NOTFOUND;
    
    dbms_output.put_line( rpad(correo_cliente, 20, ' ') || rpad(importe_desc, 18, ' ') || rpad(num_descuento, 10, ' '));
    delete from descuento where numDesc = num_descuento and email = correo_cliente;
  end loop;
  close cursorDescuento;  
END;
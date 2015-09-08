/*Diseñar un trigger asociado a la operación de inserción de la tabla Marcas, 
de modo que si el tiempo de la prueba que se inserte es un nuevo record 
se actualice el registro correspondiente 
en la tabla Records. */
drop table Records; 
drop table Marcas; 

create table Records(
prueba number primary key, 
tiempo number
); 
create table Marcas(
prueba number, 
fecha date, 
tiempo number, 
primary key (prueba,fecha)
);

create or replace trigger actualizarMarca after insert on Marcas
for each row
declare
  cursor cur is
  select prueba, tiempo 
  from records
  where prueba = :new.prueba
  group by prueba, tiempo;
  
 numFilas number;
begin
dbms_output.put_line(' ');
  select count(*) as filas
  into numFilas  
  from records
  where prueba = :new.prueba;

  for i in cur loop
    if i.tiempo < :new.tiempo then
      update records set tiempo = :new.tiempo;
    end if;
  end loop;
  
   if numFilas = 0 then
      insert into records values (:new.prueba, :new.tiempo);
    end if;
end;

/

delete from Marcas; 
delete from Records;

insert into Marcas values (1, to_date('01/02/2013'),3.8); 
insert into Marcas values (1, to_date('02/02/2013'),4.2); 
insert into Marcas values (1, to_date('03/02/2013'),3.5); 
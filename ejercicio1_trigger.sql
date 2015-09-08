drop table Libros cascade constraints; 
drop table Ejemplares cascade constraints; 

create table Libros(isbn char(13) primary key, copias integer); 

create table Ejemplares
(signatura char(5) primary key, isbn char(13) not null, 
FOREIGN KEY(isbn) REFERENCES Libros); 

/*Escribir un trigger asociado a la inserción de filas en Ejemplares, 
de forma que si el isbn no aparece en Libros, se cree una fila en Libros 
con dicho isbn y copias con valor 1, de forma que se evite el error por la 
violación de la foreign key. En caso de existir, el número de ejemplares 
se incrementará en uno. 
*/

CREATE OR REPLACE TRIGGER ACTUALIZARLIBROS 
AFTER INSERT ON EJEMPLARES FOR EACH ROW

DECLARE

v_filas NUMBER;
v_copias libros.copias%TYPE;

BEGIN
  SELECT count(*) INTO v_filas
  FROM libros
  WHERE isbn= :NEW.isbn;
  
  IF v_filas = 0 then 
    insert into libros(:new.isbn, 1);
  ELSIF v_filas > 0 then
    SELECT copias into v_copias
    FROM libros
    where isbn = :new.isbn;
    
    UPDATE libros SET copias = v_copias +1;
  END IF;
END;

/
delete from ejemplares;
delete from libros;
insert into ejemplares values ('4896l','123478596781A');
insert into ejemplares values ('7894j','789456123478D');
insert into ejemplares values ('1234y','789456123478D');
insert into ejemplares values ('9755r','789456123478D');
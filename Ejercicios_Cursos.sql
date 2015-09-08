drop table cursos cascade constraints; 
drop table inscripciones cascade constraints;
drop table cuotas cascade constraints;


create sequence cursoSC  MINVALUE 1 START WITH 1
    INCREMENT BY 1 NOCACHE;

 

create table cuotas (
 nivel varchar(20) DEFAULT 'Principiante' NOT NULL
                  CONSTRAINT Nivel_CK CHECK (nivel IN ('Principiante','Intermedio', 'Avanzado')),
 tipo  varchar(10) DEFAULT 'Regular' NOT NULL
                  CONSTRAINT Tip_CK CHECK (tipo IN ('Regular','Intensivo', 'Particular')),       
importe  NUMBER(6,2) DEFAULT 0,
primary key (nivel,tipo));

create table cursos (
 codigo char(8) PRIMARY KEY, 
 nombre varchar(50) NOT NULL,
 nivel varchar(20) NOT NULL,
 tipo  varchar(10) NOT NULL,
 horas NUMBER(3) NOT NULL,
 plazas NUMBER(3) DEFAULT 12,
 foreign key (nivel,tipo) REFERENCES cuotas);

create table inscripciones (
 codigo char(8) NOT NULL,
 id_participante varchar(10) NOT NULL,
 importe NUMBER(6,2) DEFAULT 0,
 ant_alumno NUMBER(1) DEFAULT 0
                 CONSTRAINT alumno_CK CHECK (ant_alumno IN (0,1)),
 primary key(codigo,id_participante),
 foreign key (codigo) references cursos);

insert into cuotas values('Principiante', 'Regular', 675);
insert into cuotas values('Principiante', 'Intensivo', 460);
insert into cuotas values('Principiante', 'Particular', 50);
insert into cuotas values('Intermedio', 'Intensivo', 500);
insert into cuotas values('Intermedio', 'Regular', 800);
insert into cuotas values('Intermedio', 'Particular', 60);
insert into cuotas values('Avanzado', 'Intensivo', 750);
insert into cuotas values('Avanzado', 'Regular', 1000);
insert into cuotas values('Avanzado', 'Particular', 90);

 


create or replace
procedure "LOADEVENTS" is

begin

delete from cursos;

FOR curso_ingles in 1..5 LOOP

insert into cursos (codigo, nombre, nivel, tipo, horas) values('C'||cursoSC.NEXTVAL,'Curso de Inglés '||cursoSC.CURRVAL,'Principiante', 'Regular', 10+ (2*cursoSC.CURRVAL));
insert into cursos (codigo, nombre, nivel, tipo, horas) values('C'||cursoSC.NEXTVAL,'Curso de Inglés '||cursoSC.CURRVAL,'Principiante', 'Intensivo', 10+ (2*cursoSC.CURRVAL));
insert into cursos (codigo, nombre, nivel, tipo, horas) values('C'||cursoSC.NEXTVAL,'Curso de Inglés '||cursoSC.CURRVAL,'Principiante', 'Particular', 10+ (2*cursoSC.CURRVAL));
insert into cursos (codigo, nombre, nivel, tipo, horas) values('C'||cursoSC.NEXTVAL,'Curso de Inglés '||cursoSC.CURRVAL,'Intermedio', 'Regular', 10+ (2*cursoSC.CURRVAL));
insert into cursos (codigo, nombre, nivel, tipo, horas) values('C'||cursoSC.NEXTVAL,'Curso de Inglés '||cursoSC.CURRVAL,'Intermedio', 'Intensivo', 10+ (2*cursoSC.CURRVAL));
insert into cursos (codigo, nombre, nivel, tipo, horas) values('C'||cursoSC.NEXTVAL,'Curso de Inglés '||cursoSC.CURRVAL,'Intermedio', 'Particular', 10+ (2*cursoSC.CURRVAL));
insert into cursos (codigo, nombre, nivel, tipo, horas) values('C'||cursoSC.NEXTVAL,'Curso de Inglés '||cursoSC.CURRVAL,'Avanzado', 'Regular', 10+ (2*cursoSC.CURRVAL));
insert into cursos (codigo, nombre, nivel, tipo, horas) values('C'||cursoSC.NEXTVAL,'Curso de Inglés '||cursoSC.CURRVAL,'Avanzado', 'Intensivo', 10+ (2*cursoSC.CURRVAL));
insert into cursos (codigo, nombre, nivel, tipo, horas) values('C'||cursoSC.NEXTVAL,'Curso de Inglés '||cursoSC.CURRVAL,'Avanzado', 'Particular', 10+ (2*cursoSC.CURRVAL));

END LOOP;

end;


create or replace 
FUNCTION HAYCUPO
(v_codigo cursos.codigo%TYPE)
RETURN number 
is 
v_plazas cursos.plazas%TYPE;
BEGIN
  SELECT plazas into v_plazas
  FROM cursos
  WHERE cursos.codigo = v_codigo;
  IF v_plazas > 0 THEN
    return 1;
  ELSE 
    return 0;
  END IF;
END HAYCUPO;


/
create or replace procedure inscripcion
(v_codigo cursos.codigo%type, v_id inscripciones.id_participante%type, v_antiguo inscripciones.ant_alumno%type)
is
v_importe number;
v_horas number;
v_tipo cursos.tipo%type;
begin
  select importe, tipo, horas into v_importe, v_tipo, v_horas
  from cursos, cuotas
  where cursos.codigo = v_codigo and cursos.tipo = cuotas.tipo and cursos.nivel = cuotas.nivel;
  if haycupo(v_codigo) then
    if v_tipo = 'Particular' then
      v_importe = v_importe*v_horas;
    end if;
    
    if v_antiguo = 1 then -- con decuento
      insert into inscripcion values(v_codigo, v_id, v_importe*0.95, v_antiguo);
    else --sin descuento
      insert into inscripcion values(v_codigo, v_id, v_importe, v_antiguo);
    end if
  else
    dbms_output.put_line('Ya no hay plazas en ese curso');
  end if;
end;


/
create or replace procedure listado
is
  cursor cursorCursos is
  select codigo, nombre, nivel
  from cursos
  order by nivel;
  v_codigo cursos.codigo%type;
  v_nombre cursos.nombre%type;
  v_nivel cursos.nivel%type;
  
  v_tinscripciones number;
  v_timporte number;
begin
  open cursorCursos;
  loop
    fetch cursorCursos into v_codigo, v_nombre, v_nivel;
    exit when cursorCursos%NOTFOUND;
    
    select count(*), sum(importe) into  v_tinscripciones, v_timporte
    from inscripciones
    where codigo = v_codigo;
    
    dbms_output.put_line(' Curso ' || v_codigo || ' nombre ' || v_nombre || ' nivel ' || v_nivel || ' inscripciones '
    || v_tinscripciones || ' importe ' || v_timporte);
  end loop;
  close cursorCursos;
end;


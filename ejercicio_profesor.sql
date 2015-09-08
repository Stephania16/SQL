drop table PROFESOR [cascade constraints]
Create table PROFESOR
( SS Char(15) PRIMARY KEY,
  Rango Char(10) NOT NULL,
  Nombre Varchar(20) NOT NULL,
  Fecha Ingreso DATE NOT NULL,
  Especialidad Investigadora Varchar(20) NOT NULL);
  
drop table PROYECTO [cascade constraints] 
Create table PROYECTO
( Numero Proyecto Char(2) PRIMARY KEY,
  Patrocinador Varchar(20) NOT NULL,
  Fecha Inicio DATE NOT NULL,
  Fecha Final DATE,
  Presupuesto Char(4) NOT NULL,
  SS Char(15) CONSTRAINT proy_ss_FK REFERENCES PROFESOR on delete cascade);

drop table ESTUDIANTE [cascade constraints]
Create table ESTUDIANTE
( DNI Char(9) PRIMARY KEY,
  Nombre Varchar(20) NOT NULL,
  Edad Char(2) NOT NULL,
  Postgrado Varchar(20) NOT NULL,
  DNI_Asesor Char(9) CONSTRAINT est_dniA_FK REFERENCES ESTUDIANTE on delete set null,
  CONSTRAINT est_post CHECK (Postgrado = 'Master' || Postgrado = 'Doctorado'));
  
drop table DEPARTAMENTO [cascade constraints]
Create table DEPARTAMENTO
( Numero Departamento Char(4) PRIMARY KEY,
  Nombre Varchar(20) NOT NULL,
  SS Char(15) CONSTRAINT dep_ss_FK REFERENCES PROFESOR on delete cascade);

drop table PARTICIPA [cascade constraints]  
Create table PARTICIPA
( Numero Proyecto Char(2) CONSTRAINT part_proy_FK REFERENCES PROYECTO on delete set null,
  DNI Char(9) NOT NULL,
  CONSTRAINT part_PK PRIMARY KEY (Numero Proyecto, DNI),
  CONSTRAINT part_dni_FK FOREIGN KEY (DNI) REFERENCES ESTUDIANTE on delete set null);

drop table Co_Investiga [cascade constraints]
Create table Co_Investiga
( SS Char(15) CONSTRAINT inv_ss_FK REFERENCES PROFESOR on delete set null,
  Numero Proyecto Char(2) NOT NULL,
  CONSTRAINT trab_PK PRIMARY KEY (SS, Numero Proyecto),
  CONSTRAINT inv_proy_FK FOREIGN KEY (Numero Proyecto) REFERENCES PROYECTO on delete set null);
  
drop table TRABAJA [cascade constraints]  
  Create table TRABAJA
( SS Char(15) CONSTRAINT trab_ss_FK REFERENCES PROFESOR on delete set null,
  Numero Departamento Char(4) NOT NULL,
  Horas Char(4) NOT NULL,
  CONSTRAINT trab_PK PRIMARY KEY (SS, Numero Departamento),
  CONSTRAINT trab_dep_FK FOREIGN KEY (Numero Departamento) REFERENCES DEPARTAMENTO on delete set null);
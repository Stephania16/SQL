drop table LIBRO [cascade constraints]
Create table LIBRO
( ISBN Char(15) PRIMARY KEY,
  Titulo Varchar(20) NOT NULL,
  Precio Venta Char(4) NOT NULL,
  Precio Compra Char(4) NOT NULL,
  APublicacion DATE NOT NULL );
  
drop table AUTOR [cascade constraints]
Create table AUTOR
( Nombre Varchar(20) PRIMARY KEY);

drop table CLIENTE [cascade constraints]
Create table CLIENTE
( Numero Usuario Char(2) PRIMARY KEY,
  Nombre Varchar(20) NOT NULL,
  Direccion Varchar(30) NOT NULL,
  Numero Tarjeta Char(10) NOT NULL);
  
drop table PEDIDO [cascade constraints]
Create table PEDIDO
( Codigo Unico Char(10) PRIMARY KEY,
  Numero Usuario Char(15) CONSTRAINT ped_user_FK REFERENCES CLIENTE on delete cascade,
  Fecha Pedido DATE NOT NULL,
  Fecha Expedicion DATE );
  
drop table ESCRITOR [cascade constraints]  
Create table ESCRITOR
( ISBN Char(15) CONSTRAINT esc_isbn_FK REFERENCES LIBRO on delete cascade,
  Nombre Varchar(20) References AUTOR,
  CONSTRAINT esc_PK PRIMARY KEY (ISBN, Nombre),
  CONSTRAINT esc_nomb_FK FOREIGN KEY (Nombre) REFERENCES AUTOR on delete cascade);
  
drop table DETALLE [cascade constraints]
Create table DETALLE
( Codigo Unico Char(10) CONSTRAINT det_cod_FK REFERENCES PEDIDO on delete cascade,
  ISBN Char(15) NOT NULL,
  Cantidad Char(4) NOT NULL,
  CONSTRAINT det_PK PRIMARY KEY (ID, ISBN),
  CONSTRAINT det_lib_FK FOREIGN KEY (ISBN) REFERENCES LIBRO on delete cascade);
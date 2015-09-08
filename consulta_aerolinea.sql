/*1. Código y nombre de los pilotos certificados para pilotar aviones Boeing. */
SELECT empleado.eid, empleado.nombre
FROM empleado, certificado, avion
WHERE empleado.eid = certificado.eid and
      certificado.aid= avion.aid and
      avion.nombre  like 'Boeing%';   

/*2. Código de aviones que pueden hacer el recorrido de Los Angeles a Chicago sin 
repostar.

NOSE SI ESTA BIEN*/
SELECT avion.aid
FROM avion, vuelo 
WHERE vuelo.origen = 'Los Angeles' and 
      vuelo.destino= 'Chicago';

/*
3. Identificar los vuelos que pueden ser pilotados por todos los pilotos con salario superior 
100.000 euros. 
*/
SELECT avion.nombre, empleado.eid, empleado.salario
FROM avion, certificado, empleado
WHERE empleado.eid = certificado.eid and
      certificado.aid= avion.aid and
      empleado.salario > '100000';
      
/*4. Pilotos certificados para operar con aviones con una autonomía superior a 3000 millas 
pero no certificados para aviones Boeing. 
*/
SELECT empleado.eid, avion.nombre, avion.autonomia
FROM empleado, certificado, avion
WHERE empleado.eid= certificado.eid and
      certificado.aid= avion.aid and
      avion.autonomia > '3000' and
      avion.nombre NOT LIKE 'Boeing%';
      
/*5. Empleados con el salario más elevado. 
*/
SELECT *
FROM empleado
WHERE empleado.salario = (select MAX(salario) from empleado);

/*6. Empleados con el segundo salario más alto. 
INCOMPLETO
*/
SELECT *
FROM empleado
WHERE empleado.salario < (select MAX(salario) from empleado);

/*7. Empleados con mayor número de certificaciones para volar. 
*/
SELECT empleado.nombre
FROM empleado, certificado
WHERE empleado.eid= certificado.eid and
      certificado.aid = (select MAX(aid) from certificado) ;

/*8. Empleados certificados para 3 modelos de avión. 
*/
SELECT empleado.nombre
FROM empleado, certificado
WHERE empleado.eid= certificado.eid and
      certificado.aid = '3';


/*9. Importe total del salario de los empleados de la compañía. 
*/
SELECT sum(salario) "Total Salario"
FROM empleado
GROUP BY salario;

/*10. Nombre de los aviones tales que todos los pilotos certificados para operar con ellos 
tengan salarios superiores a 80.000 euros. 
*/
SELECT DISTINCT(avion.nombre), salario
FROM avion, empleado, certificado
WHERE empleado.eid= certificado.eid and
      certificado.aid= avion.aid and
      empleado.salario > '80000';

/*11. Para cada piloto certificado para operar con más de 3 modelos de avión indicar el 
código de empleado y la autonomía máxima de los aviones que puede pilotar. 
CORREGIR LO DE AUTONOMIA MAX
*/
SELECT empleado.eid, avion.aid, (select max(autonomia) from avion)
FROM empleado, avion, certificado
WHERE empleado.eid= certificado.eid and
       certificado.aid= avion.aid and
       avion.aid > '3';
       

/*12. Nombre de los pilotos cuyo salario es inferior a la ruta más barata entre Los Ángeles y 
Honolulu. 
CORREGIR
*/
SELECT empleado.nombre, vuelo.origen, vuelo.destino
FROM empleado, vuelo
WHERE vuelo.origen = 'Los Ángeles' and
      vuelo.destino= 'Honolulu' and
      empleado.salario < min(vuelo.precio);

/*13. Mostrar el nombre de los aviones con autonomía de vuelo superior a 1.000 millas junto 
con la media salarial de los pilotos certificados. 
VER SI ESTA BIEN
*/
SELECT avion.nombre, (select avg(salario) from empleado where empleado.eid= certificado.eid )
FROM avion, empleado, certificado
WHERE avion.autonomia > '1000' and
      empleado.eid= certificado.eid and
      certificado.aid= avion.aid;

/*14. Calcular la diferencia entre la media salarial de todos los empleados (incluidos los 
pilotos) y la de los pilotos. 
CORREGIR
*/
SELECT (select avg(salario) from empleados) - (select avg(salario) from empleados where empleados.eid= certificado.eid)
FROM empleados, certificado;


/*1. Lista de libros disponibles con su autor y a�o de publicaci�n ordenada por este ultimo.*/
SELECT libro.isbn, autor, a�o
FROM libro, autor_libro
WHERE libro.isbn= autor_libro.isbn 
ORDER BY a�o;

/*2. Lista de libros disponibles publicados despu�s del a�o 2000.*/
SELECT libro.isbn, titulo, a�o
FROM libro
WHERE a�o > '2000';

/*3. Lista de Clientes que han realizado alg�n pedido*/
SELECT DISTINCT(cliente.nombre)
FROM cliente, pedido
WHERE pedido.idcliente = cliente.idcliente;

/*4. Lista de clientes que han adquirido el libro con ISBN= 4554672899910.*/
SELECT cliente.nombre, libros_pedido.isbn
FROM cliente, pedido, libros_pedido
WHERE pedido.idcliente = cliente.idcliente AND 
      pedido.idpedido = libros_pedido.idpedido AND 
      libros_pedido.isbn = '4554672899910';
      
/* 5. Lista de los clientes y los libros adquiridos por ellos cuyo nombre contenga �San�.*/
SELECT cliente.nombre, libros_pedido.isbn
FROM cliente, pedido, libros_pedido
WHERE cliente.idcliente= pedido.idcliente AND
      pedido.idpedido=libros_pedido.idpedido AND
      cliente.nombre LIKE '%San%';
      
/*6. Lista de Clientes que hayan comprado libros de m�s de 10 euros.*/
SELECT DISTINCT(cliente.nombre)
FROM cliente, libro, pedido, libros_pedido
WHERE cliente.idcliente=pedido.idcliente AND
      pedido.idpedido=libros_pedido.idpedido AND
      libro.isbn= libros_pedido.isbn AND
      libro.precioventa > 10;
      
/*7. Clientes que han hecho m�s de un pedido el mismo d�a.*/
SELECT cliente.nombre, libros_pedido.cantidad, pedido.fechapedido
FROM cliente, pedido, libros_pedido
WHERE cliente.idcliente= pedido.idcliente AND
      pedido.idpedido= libros_pedido.idpedido AND
      libros_pedido.cantidad > 1;
      
/*8. Clientes y fecha de pedidos que no han sido expedidos aun.*/
SELECT cliente.nombre, pedido.fechapedido
FROM cliente, pedido
WHERE pedido.idcliente = cliente.idcliente AND 
      pedido.fechaexped IS NULL;

/*9. Lista de clientes que no han comprado libros de precio superior a 10 euros*/
SELECT cliente.nombre, libro.precioventa
FROM cliente, libro, pedido, libros_pedido
WHERE cliente.idcliente = pedido.idcliente AND 
      libro.isbn = libros_pedido.isbn AND
      pedido.idpedido= libros_pedido.idpedido
MINUS 
SELECT cliente.nombre, libro.precioventa
FROM cliente, libro, pedido, libros_pedido
WHERE libro.precioventa > 10 AND 
      libro.isbn= libros_pedido.isbn AND
      cliente.idcliente = pedido.idcliente AND 
      pedido.idcliente = cliente.idcliente;

/*10. Lista de libros vendidos con precio superior a 30 euros o publicados antes del a�o 2000*/
SELECT DISTINCT(libro.titulo), libro.precioventa, libro.a�o
FROM libro, libros_pedido, pedido
WHERE libro.isbn= libros_pedido.isbn AND 
      pedido.idpedido= libros_pedido.idpedido AND
      (precioventa > 30 OR libro.a�o < '2000');

/*11. Lista de ventas de libros*/
SELECT DISTINCT(libro.titulo), libro.precioventa
FROM libro, pedido, libros_pedido
WHERE libros_pedido.isbn = libro.isbn AND
      pedido.idpedido = libros_pedido.idpedido AND 
      libro.precioventa IS NOT NULL;
      
/*12. Lista de Clientes con el importe total gastado en la librer�a*/
SELECT cliente.nombre, SUM(libros_pedido.cantidad * libro.precioventa) "TOTAL_GASTADO"
FROM cliente, libro, pedido, libros_pedido
WHERE cliente.idcliente = pedido.idcliente AND 
      pedido.idpedido = libros_pedido.idpedido AND
      libro.isbn = libros_pedido.isbn
GROUP BY cliente.nombre;

/*13. Ganancias obtenidas con las ventas*/
SELECT libro.isbn, libro.titulo, SUM(libro.precioventa - libro.preciocompra) "GANANCIA"
FROM libro, pedido, libros_pedido
WHERE libro.isbn = libros_pedido.isbn AND 
      pedido.idpedido= libros_pedido.idpedido
GROUP BY libro.isbn, libro.titulo;

/*14. Lista de importe total de pedidos por fecha, que se hayan realizado despu�s del 01/12/2011 y no hayan sido expedidos*/
SELECT libro.titulo, SUM(libros_pedido.cantidad * libro.precioventa) "TOTAL"
FROM libro, pedido, libros_pedido
WHERE libro.isbn= libros_pedido.isbn AND 
      pedido.idpedido = libros_pedido.idpedido AND 
      pedido.fechapedido > '01/12/2011' AND pedido.fechaexped IS NULL
GROUP BY libro.titulo;

/*15. Detalle l�neas de pedido
VERIFICAR*/
SELECT *
FROM pedido;

/*16. Pedidos con importe superior -----VERIFICAR si es 16 o 19*/
SELECT libro.isbn, libro.titulo, SUM(precioventa * libros_pedido.cantidad) "total"
FROM libro,pedido, libros_pedido
WHERE libro.isbn= libros_pedido.isbn AND pedido.idpedido = libros_pedido.idpedido
GROUP BY libro.isbn, libro.titulo
HAVING SUM(precioventa * libros_pedido.cantidad) >= ALL (SELECT SUM(precioventa * libros_pedido.cantidad) 
                                                          FROM libro, libros_pedido
                                                          WHERE libro.isbn= libros_pedido.isbn /*AND pedido.idpedido = libros_pedido.idpedido*/
                                                          GROUP BY libro.isbn);

/*
17. Pedidos con importe total que contengan m�s de un titulo*/
SELECT pedido.idpedido, count(titulo) "NUM_LIBROS", SUM(precioventa * libros_pedido.cantidad) "total"
FROM libro,pedido, libros_pedido
WHERE libro.isbn = libros_pedido.isbn AND pedido.idpedido = libros_pedido.idpedido
GROUP BY pedido.idpedido
HAVING COUNT(libro.titulo) > 1;



/*18. Pedidos con importe total que contengan m�s de 4 libros (ejemplares)---VERIFICAR*/
SELECT pedido.idpedido, SUM(precioventa * libros_pedido.cantidad) "total"
FROM libro,pedido, libros_pedido
WHERE libro.isbn = libros_pedido.isbn AND 
      pedido.idpedido = libros_pedido.idpedido AND
      libros_pedido.cantidad > 4
GROUP BY pedido.idpedido;


/*19. Lista de libros m�s caros.
*/
SELECT libro.isbn, libro.precioventa
FROM libro, libros_pedido
WHERE libro.isbn = libros_pedido.isbn 
GROUP BY libro.isbn,  libro.precioventa
HAVING libro.precioventa >= ALL (SELECT precioventa FROM libro);

  
/*20. Libros de los que no se haya vendido ning�n ejemplar o cuyo beneficio sea inferior a 5 euros*/
SELECT DISTINCT(libro.titulo), precioventa - preciocompra "BENEFICIO"
FROM libro, libros_pedido, pedido
WHERE NOT EXISTS (SELECT isbn FROM libros_pedido
      WHERE libros_pedido.isbn= libro.isbn) 
      OR (precioventa - preciocompra < 5);


   
/*21. Clientes que hayan comprado m�s de un ejemplar de un titulo en alguna ocasi�n*/
SELECT cliente.nombre, libro.titulo, cantidad
FROM cliente, libro, libros_pedido, pedido
WHERE cliente.idcliente= pedido.idcliente AND
      libro.isbn = libros_pedido.isbn AND
      libros_pedido.idpedido= pedido.idpedido AND
      libros_pedido.cantidad > 1;



/*22. Lista de Nombre de cliente, numero de pedido, isbn y t�tulo de libros adquiridos usando relaciones*/
SELECT cliente.nombre, pedido.idpedido, libro.isbn, libro.titulo
FROM cliente, pedido, libro, libros_pedido
WHERE cliente.idcliente = pedido.idcliente AND
      libro.isbn= libros_pedido.isbn AND
      libros_pedido.idpedido= pedido.idpedido;


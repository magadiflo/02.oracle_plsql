/***************************************************************************************************
Ámbito de las variables en un paquete
****************************************************************************************************
- La primera vez que se invoca a un paquete, éste se abre y contúa así durante toda la sesión.
- Las variables públicas creadas dentro del spec del packete, permanecen con el mismo valor 
  durante toda la sesión, solo se eliminan si se borra durante el proceso (obviamente)
  o cuando salimos de la sesión.
*/

SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
*/
CREATE OR REPLACE PACKAGE package_sum
AS
    value NUMBER := 10;
END;
/

-- Usando el package
BEGIN
    /* Aquí la variable 'value' del paquete contendrá el nuevo valor durante toda la sesión,
       es decir, tendra 30, pero si volvemos a ejecutar este bloque pl/sql el valor de value
       se volverá a sumar 20, teniendo a 50 como nuevo valor. Este proceso se repetirá hasta
       que finalice la sesión.
       
       Si finalizamos la sesión y volvemos a iniciar ejecutando ahora nuevamente este
       bloque pl/sql veremos que el valor que nos imprimirá será 30, es decir, se 
       reinician los valores de las variables públicas.*/
    package_sum.value := package_sum.value + 20;
    dbms_output.put_line(package_sum.value);
END;
/
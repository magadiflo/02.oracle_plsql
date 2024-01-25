/***************************************************************************************************
Práctica adicional con variables, constantes y %TYPE
****************************************************************************************************
*/

/* Ejemplo 01
******************************************************
Queremos calcular el impuesto de un producto. 
El impuesto del 21% lo ponemos en una constante.
Creamos una variable de tipo number (5,2) para poner el precio del producto.
Creamos otra variable para el resultado. 
Le decimos que es del mismo tipo (type) que la anterior, hacemos el cálculo y
visualizamos el resultado.

*/
SET SERVEROUTPUT ON;

DECLARE 
    tax CONSTANT NUMBER := 21; --21%, tax = impuesto (traducción)
    price NUMBER(5,2);
    result price%TYPE;
    
BEGIN
    price := 100.50;
    result := price * tax / 100;
    dbms_output.put_line(result);
END;
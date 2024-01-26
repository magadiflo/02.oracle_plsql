/***************************************************************************************************
Sintaxis de las excepciones
****************************************************************************************************
Para trabajar con excepciones en PLSQL debemos agregar el bloque EXCEPTION dentro del bloque
anónimo con el que hemos venido trabajando hasta ahora.

EXCEPTION, es el bloque de excepciones, eso significa que, cuando se produzca algún tipo de 
error en el bloque principal BEGIN, automáticamente el flujo se redirige a la zona de 
excepciones.
*/

SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
A continuación se muestra la sintaxis de cómo manejar las excepciones en el 
bloque EXCEPTION.
*/
DECLARE
    employee employees%ROWTYPE;
BEGIN
    SELECT * 
    INTO employee
    FROM employees
    WHERE employee_id = 1000;
    
    dbms_output.put_line(employee.first_name);
EXCEPTION
    WHEN exception_1 THEN
        NULL;
    WHEN exception_2 THEN
        NULL;
    WHEN OTHERS THEN
        NULL;
END;
/
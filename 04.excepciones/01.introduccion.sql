/***************************************************************************************************
Introducción a las excepciones
****************************************************************************************************
Hay dos tipos de excepciones:

1. Generadas por Oracle
2. Generadas por el Usuario
*/

SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
En el siguiente código nos mostrará el siguiente error:

ORA-01403: no data found
ORA-06512: at line 4
01403. 00000 -  "no data found"
*Cause:    No data was found from the objects.
*Action:   There was no data from the objects which may be due to end of fetch

Esto ocurre porque el id buscado no existe.
*/
DECLARE
    employee employees%ROWTYPE;
BEGIN
    SELECT * 
    INTO employee
    FROM employees
    WHERE employee_id = 1000;
    
    dbms_output.put_line(employee.first_name);
END;
/
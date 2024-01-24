/***************************************************************************************************
Atributo %type
****************************************************************************************************
Permite crear una variable del mismo tipo que de otra variable. Por ejemplo, una variable puede
ser del mismo tipo que de una columna de una tabla.
*/

/* Ejemplo 01
*******************************************************/
SET SERVEROUTPUT ON;

DECLARE
    name      VARCHAR2(50);
    last_name name%TYPE;
    salary    employees.salary%TYPE;
BEGIN
    name := 'Liz';
    last_name := 'Pino';
    salary := 2500.50;
    dbms_output.put_line(name || ' recibe S/' || salary);
END;
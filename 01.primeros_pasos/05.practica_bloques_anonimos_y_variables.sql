/***************************************************************************************************
Práctica: Bloques anónimos y variables
****************************************************************************************************/

/* Ejemplo 01
******************************************************
Visualizar el nombre y apellidos. Primero separados y luego concatenados con el operador ||
*/

SET SERVEROUTPUT ON; 

DECLARE
    firstname VARCHAR2(50) := 'Greysi';
    lastname  VARCHAR2 (50) := 'Briones';
BEGIN
    dbms_output.put_line(firstName);
    dbms_output.put_line(lastName);
    dbms_output.put_line(firstName || ' ' || lastName);
END;

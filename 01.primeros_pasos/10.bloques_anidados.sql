/***************************************************************************************************
Bloques anidados
****************************************************************************************************
*/

/* Ejemplo 01
******************************************************
*/
SET SERVEROUTPUT ON;

BEGIN
    dbms_output.put_line('Primer bloque');
    
    DECLARE
        age NUMBER := 32;
    BEGIN
        dbms_output.put_line('Segundo bloque');
        dbms_output.put_line('Edad: ' || age);
    END;
END;
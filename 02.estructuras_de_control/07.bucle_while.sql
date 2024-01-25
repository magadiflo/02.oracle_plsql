/***************************************************************************************************
Bucle WHILE
****************************************************************************************************
*/
SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************.
*/

DECLARE
    done BOOLEAN := false;
    count_number NUMBER := 0;
BEGIN
    WHILE done LOOP
        dbms_output.put_line('No imprimirá esto');
        done := false;
    END LOOP;
    
    WHILE NOT done LOOP
        dbms_output.put_line('He pasado por aquí');
        done := true;
    END LOOP;
    
    WHILE count_number < 10 LOOP
        dbms_output.put_line(count_number);
        count_number := count_number + 1;
        EXIT WHEN count_number = 5;
    END LOOP;
END;
/
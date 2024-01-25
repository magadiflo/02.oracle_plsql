/***************************************************************************************************
Bucle LOOP
****************************************************************************************************
*/
SET SERVEROUTPUT ON;

/* Ejemplo 01
*******************************************************/
 DECLARE
    number_count NUMBER := 1;
 BEGIN
    LOOP
        dbms_output.put_line(number_count);
        number_count := number_count + 1;
        
        EXIT WHEN number_count > 20;
    END LOOP;
 END;
 /
 
 
/* Ejemplo 02
*******************************************************/
 DECLARE
    number_count NUMBER := 1;
 BEGIN
    LOOP
        dbms_output.put_line(number_count);
        number_count := number_count + 1;
        
        IF number_count = 11 THEN
            EXIT;
        END IF;
    END LOOP;
 END;
 /
/***************************************************************************************************
Comando CONTINUE
****************************************************************************************************
*/
SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
Imprimir números pares hasta el 10
*/
DECLARE
    count_number NUMBER := -1;
BEGIN
    LOOP
        count_number := count_number + 1;
        
        IF MOD(count_number, 2) != 0 THEN
            CONTINUE;
        END IF;
        
        dbms_output.put_line('Loop: count_number = ' || count_number);
  
        EXIT WHEN count_number = 10;
    END LOOP;
END;
/


/* Ejemplo 02
******************************************************
Imprimir números impares hasta el 9
*/
DECLARE
    count_number NUMBER := 0;
BEGIN
    LOOP
        count_number := count_number + 1;
        
        CONTINUE WHEN MOD(count_number, 2) = 0;
        
        dbms_output.put_line('Loop: count_number = ' || count_number);
  
        EXIT WHEN count_number = 9;
    END LOOP;
END;
/
/***************************************************************************************************
Comando CASE
****************************************************************************************************
*/
SET SERVEROUTPUT ON;

/* Ejemplo 01
*******************************************************/
DECLARE
    clasification CHAR(1);
BEGIN
    clasification := 'B';
    
    CASE clasification
        WHEN 'A' THEN dbms_output.put_line('Excellent');
        WHEN 'B' THEN dbms_output.put_line('Very good');
        WHEN 'C' THEN dbms_output.put_line('Good');
        WHEN 'D' THEN dbms_output.put_line('Fair');
        WHEN 'E' THEN dbms_output.put_line('Poor');
    ELSE
        dbms_output.put_line('No such value');
    END CASE;
END;
/


/* Ejemplo 02
*******************************************************/
DECLARE
    bonus NUMBER;
BEGIN
    bonus := 100;
    CASE
        WHEN bonus > 500 THEN dbms_output.put_line('Excellent');
        WHEN bonus <= 500 AND bonus > 250 THEN dbms_output.put_line('Very good');
        WHEN bonus <= 250 AND bonus > 100 THEN dbms_output.put_line('Good');
    ELSE
        dbms_output.put_line('Poor');
    END CASE;
END;
/
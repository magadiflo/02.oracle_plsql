/***************************************************************************************************
Selects múltiples con arrays asociativos
****************************************************************************************************
*/
SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
*/
DECLARE
    TYPE departments_type IS TABLE OF
    departments%ROWTYPE
    INDEX BY PLS_INTEGER;
    
    departments_array departments_type;
BEGIN
    FOR i IN 1..10 LOOP
        SELECT * 
        INTO departments_array(i)
        FROM departments
        WHERE department_id = i * 10;
    END LOOP;
    
    FOR i IN departments_array.first..departments_array.last LOOP
        dbms_output.put_line(departments_array(i).department_name);
    END LOOP;
END;
/

SELECT *
FROM departments;
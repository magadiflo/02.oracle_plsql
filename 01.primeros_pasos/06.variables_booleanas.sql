/***************************************************************************************************
Variables Booleanas
****************************************************************************************************
Las variables booleanas pueden ser: TRUE, FALSE o NULL, este último como cualquier otra variable.
*/

/* Ejemplo 01
*******************************************************/
SET SERVEROUTPUT ON;

DECLARE
    is_active BOOLEAN;
    response VARCHAR2(20);
BEGIN
    is_active := NULL;
    is_active := TRUE;
    is_active := FALSE;
    
    response := (CASE
                    WHEN is_active THEN 'Es verdadero'
                    WHEN NOT is_active THEN 'Es falso'
                    ELSE 'Es NULL'
                END);
    dbms_output.put_line(response);    
END;
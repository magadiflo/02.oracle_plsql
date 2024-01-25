/***************************************************************************************************
DELETE en PLSQL
****************************************************************************************************
*/

SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
*/
DECLARE
    id test.id%TYPE;
BEGIN
    id := 1;
    
    DELETE FROM test t WHERE t.id = id;
    
    COMMIT;
END;
/

-- Verificando cambios
SELECT * 
FROM test;

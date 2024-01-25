/***************************************************************************************************
UPDATE en PLSQL
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
    
    UPDATE test t
    SET t.name = 'Nvo. Chimbote'
    WHERE t.id = id;
    
    COMMIT;    
END;
/

-- Verificando cambios
SELECT * 
FROM test;
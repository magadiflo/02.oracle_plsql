/***************************************************************************************************
UPDATE en PLSQL
****************************************************************************************************
*/

SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
*/
DECLARE
    col_id test.id%TYPE;
BEGIN
    col_id := 1;
    
    UPDATE test
    SET name = 'Nvo. Chimbote'
    WHERE id = col_id;
    
    COMMIT;    
END;
/

-- Verificando cambios
SELECT * 
FROM test;
/***************************************************************************************************
Ámbito de las excepciones
****************************************************************************************************
El ámbito de las excepciones es similar al ámbito de las variables.

Las excepciones declaradas en el bloque padre podrán ser leídas por el bloque hijo, mientras
que las excepciones declaradas en el hijo no podrán ser leídas desde el bloque padre.

Las excepciones debemos declararlas en el ámbito donde queremos manejarlas.
*/

SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
En este caso, como las variables están definidas en el nivel del padre, el bloque 
hijo la va a reconocer sin problemas.
*/
DECLARE
    LIMIT_MAX_ID_REGION EXCEPTION;
    id regions.region_id%TYPE;
    name regions.region_name%TYPE;
BEGIN
    id := 101;
    name := 'Oceanía';
    
    -- -----------------------------------------------
    BEGIN
        IF id > 100 THEN
            RAISE LIMIT_MAX_ID_REGION;
        ELSE
            INSERT INTO regions(region_id, region_name)
            VALUES(id, name);
            
            COMMIT;
        END IF;
    END;
    -- -----------------------------------------------
EXCEPTION
    WHEN LIMIT_MAX_ID_REGION THEN
        dbms_output.put_line('[Bloque padre] La región no puede ser mayor de 100');
    WHEN OTHERS THEN
        dbms_output.put_line('Error indefinido');
END;
/

/* Ejemplo 02
******************************************************
En este ejemplo estamos definido la variable de excepción LIMIT_MAX_ID_REGION
dentro del bloque hijo, por lo tanto debemos manejar dicha variable dentro del
bloque EXCEPTION del hijo.
*/
DECLARE
    id regions.region_id%TYPE;
    name regions.region_name%TYPE;
BEGIN
    id := 101;
    name := 'Oceanía';
    
    -- -----------------------------------------------
    DECLARE
        LIMIT_MAX_ID_REGION EXCEPTION;
    BEGIN
        IF id > 100 THEN
            RAISE LIMIT_MAX_ID_REGION;
        ELSE
            INSERT INTO regions(region_id, region_name)
            VALUES(id, name);
            
            COMMIT;
        END IF;
    EXCEPTION
        WHEN LIMIT_MAX_ID_REGION THEN
            dbms_output.put_line('[Bloque hijo] La región no puede ser mayor de 100');
    END;
    -- -----------------------------------------------
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Error indefinido');
END;
/


SELECT * 
FROM regions;
DELETE FROM regions WHERE region_id = 101;

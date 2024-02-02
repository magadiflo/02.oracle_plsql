/***************************************************************************************************
Triggers tipo Compound (Compuesto)
****************************************************************************************************
Los triggers compuestos aparecieron en la versión 11R2 de Oracle.
Los triggers compuestos permiten tener en un mismo objeto distintos tipos de triggers.

Trigger Compound
> Declaración (tipo, evento, etc.)
> Los tipos de triggers
    - Before statement is
    - After statement is
    - Before each row
    - After each row
    
¡IMPORTANTE!
Tener en cuenta que la sintaxis es algo distinta al de los triggers normales.
*/

SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
*/
CREATE OR REPLACE TRIGGER tx_compound_regions
FOR INSERT OR UPDATE OR DELETE
ON regions
COMPOUND TRIGGER

    BEFORE STATEMENT
    IS
    BEGIN
        INSERT INTO logs(event, table_name, username)
        VALUES('BEFORE STATEMENT', 'regions', USER);
    END BEFORE STATEMENT;
----------------------------------------------------------------------------   
    AFTER STATEMENT
    IS
    BEGIN
        INSERT INTO logs(event, table_name, username)
        VALUES('AFTER STATEMENT', 'regions', USER);
    END AFTER STATEMENT;
----------------------------------------------------------------------------
    BEFORE EACH ROW
    IS
    BEGIN
        INSERT INTO logs(event, table_name, username)
        VALUES('BEFORE EACH ROW', 'regions', USER);
    END BEFORE EACH ROW;
----------------------------------------------------------------------------    
    AFTER EACH ROW
    IS
    BEGIN
        INSERT INTO logs(event, table_name, username)
        VALUES('AFTER EACH ROW', 'regions', USER);
    END AFTER EACH ROW;

END tx_compound_regions;
/

-- Probando trigger
INSERT INTO regions(region_id, region_name)
VALUES(5, 'Antártida');

DELETE FROM regions WHERE region_id = 5;

SELECT *
FROM regions;

SELECT * 
FROM logs;

TRUNCATE TABLE logs;
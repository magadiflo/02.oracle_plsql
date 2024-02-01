/***************************************************************************************************
Cláusula WHEN
****************************************************************************************************
La cláusula WHEN permite que el trigger se dispare bajo ciertas circunstancias.
*/

SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
Queremos que el trigger se dispare solo si el region_id es > 1000.
*/
CREATE OR REPLACE TRIGGER tx_regions
BEFORE INSERT OR UPDATE OR DELETE
ON regions
FOR EACH ROW
WHEN (NEW.region_id > 1000) -- Aquí se coloca el NEW sin anteponer los dos puntos (:)
BEGIN
    IF INSERTING THEN
        :NEW.region_name := UPPER(TRIM(:NEW.region_name));
        
        INSERT INTO logs(event, table_name, username)
        VALUES('insert', 'regions', USER);
    ELSIF UPDATING('region_name') THEN
        :NEW.region_name := UPPER(TRIM(:NEW.region_name));
    
        INSERT INTO logs(event, table_name, username)
        VALUES('update column region_name', 'regions', USER);
    ELSIF UPDATING('region_id') THEN   
        INSERT INTO logs(event, table_name, username)
        VALUES('update column region_id', 'regions', USER);
    ELSIF DELETING THEN
        INSERT INTO logs(event, table_name, username)
        VALUES('delete', 'regions', USER);
    END IF;
END tx_regions;
/

-- Probando trigger
INSERT INTO regions(region_id, region_name)
VALUES(1500, 'Antártida');

DELETE FROM regions WHERE region_id = 1500;

SELECT *
FROM regions;

SELECT * 
FROM logs;
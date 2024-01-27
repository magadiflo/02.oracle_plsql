/***************************************************************************************************
Insert y updates con PL/SQL RECORDS
****************************************************************************************************
*/
SET SERVEROUTPUT ON;


--Preparando escenario: 
--Creamos la tabla regions_test a partir de la tabla regions pero sin registros.
CREATE TABLE regions_test 
AS
SELECT * 
FROM regions
WHERE region_id = 0;

SELECT *
FROM regions_test;
SELECT * 
FROM regions;

/* Ejemplo 01
******************************************************
*/
DECLARE
    region regions%ROWTYPE;
BEGIN
    SELECT *
    INTO region
    FROM regions
    WHERE region_id = 1;
    
    INSERT INTO regions_test
    VALUES region;
    
    COMMIT;    
END;
/

DECLARE
    region regions%ROWTYPE;
BEGIN
    region.region_id := 1;
    region.region_name := 'Américas';
    
    UPDATE regions_test
    SET ROW = region
    WHERE region_id = 1;
    
    COMMIT;
END;
/
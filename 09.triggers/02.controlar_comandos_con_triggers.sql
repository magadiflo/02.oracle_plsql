/***************************************************************************************************
Controlar comandos con triggers
****************************************************************************************************
*/

SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
Queremos controlar con un trigger que solo podrá insertar datos en la tabla
regions el usuario HR.
*/
CREATE OR REPLACE TRIGGER tx_check_user
BEFORE INSERT
ON regions
BEGIN
    IF USER <> 'HR' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Solo puede insertar el usuario HR en la tabla regions');
    END IF;
END tx_check_user;
/

-- Probando trigger
SELECT *
FROM regions;

DELETE FROM regions WHERE region_id = 5;

SELECT *
FROM logs;

INSERT INTO regions(region_id, region_name)
VALUES(5, 'Oceanía');
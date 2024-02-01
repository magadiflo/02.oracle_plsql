/***************************************************************************************************
Controlar tipo de evento
****************************************************************************************************
Existen unas cláusulas en los triggers:
- INSERTING, indica que la operación que ha disparado el trigger es el INSERT
- UPDATING, indica que la operación que ha disparado el trigger es el UPDATE
- DELETING, indica que la operación que ha disparado el trigger es el DELETE
*/

SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
*/
CREATE OR REPLACE TRIGGER tx_regions
BEFORE INSERT OR UPDATE OR DELETE
ON regions
DECLARE
    action VARCHAR2(50);
BEGIN
    dbms_output.put_line('Lanzando trigger');

    action := CASE
                WHEN INSERTING THEN 'INSERT'
                WHEN UPDATING THEN 'UPDATE'
                WHEN DELETING THEN 'DELETE'
              END;
    
    dbms_output.put_line('evento a lanzar: ' || action );
    
    INSERT INTO logs(event, table_name, username)
    VALUES(action, 'regions', USER);
END tx_regions;
/

-- Probando trigger
CREATE TABLE logs(
    event VARCHAR2(200),
    table_name VARCHAR2(100),
    username VARCHAR2(50),
    create_at TIMESTAMP DEFAULT SYSDATE
);

SELECT *
FROM regions;

SELECT * 
FROM logs;

INSERT INTO regions(region_id, region_name)
VALUES(5, 'Oceanía');

-- Insertando con usuario system (Abrir dicha conxión)
DELETE FROM hr.regions WHERE region_id = 5;

UPDATE hr.regions
SET region_name = 'Antártida'
WHERE region_id = 5;

/* Ejemplo 02
******************************************************
Controlar qué columna se está actualizando
*/
CREATE OR REPLACE TRIGGER tx_regions
BEFORE INSERT OR UPDATE OR DELETE
ON regions
DECLARE
    action VARCHAR2(50);
BEGIN
    dbms_output.put_line('Lanzando trigger');

    action := CASE
                WHEN INSERTING THEN 'INSERT'
                WHEN UPDATING('region_name') THEN 'UPDATE region_name'
                WHEN UPDATING('region_id') THEN 'UPDATE region_id'
                WHEN DELETING THEN 'DELETE'
              END;
    
    dbms_output.put_line('evento a lanzar: ' || action );
    
    INSERT INTO logs(event, table_name, username)
    VALUES(action, 'regions', USER);
END tx_regions;
/

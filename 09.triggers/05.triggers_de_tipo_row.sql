/***************************************************************************************************
Crear un triggers de tipo row
****************************************************************************************************
Un trigger del tipo row es aquel que se dispara por cada fila de la operación.
Cuando se trabajan con triggers de tipo row se tienen dos tipos de datos disponibles:

- :OLD
- :NEW

Estos tipos de datos nos sirven para poder acceder a la información antes de ejecutar
la consulta SQL o después de haberla ejecutado. Por ejemplo, si realizamos la 
consulta UPDATE de alguna tabla, con el :OLD obtenemos la información antigua y
con el :NEW obtenemos la nueva información con el que se quiere actualizar.

Veamos el siguiente cuadro para entender mejor:

OPERACIÓN           :OLD                :NEW
--------------------------------------------------------
insert              null                valor del insert
update              valor anterior      valor nuevo
delete              valor anterior      null
*/

SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
Queremos que cada vez que se haga un insert o un update siempre las regiones
se guarden en mayúscula.
*/
CREATE OR REPLACE TRIGGER tx_regions
BEFORE INSERT OR UPDATE OR DELETE
ON regions
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        /*
        Antes de que se vaya a la tabla regions y lo inserte, lo que hacemos
        aquí es convertir a mayúscula la información que trae el :NEW.region_name
        */
        :NEW.region_name := UPPER(TRIM(:NEW.region_name));
        
        -- Este es el insert pero del log.
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
VALUES(5, 'Antártida');

UPDATE regions
SET region_name = 'oceanía'
WHERE region_id  = 5;

DELETE FROM regions WHERE region_id = 5;

SELECT *
FROM regions;

SELECT * 
FROM logs;

DESCRIBE logs;
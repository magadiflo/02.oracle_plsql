/***************************************************************************************************
Crear un trigger
****************************************************************************************************
Existen tres tipos de Triggers:

1. DML: insert, update, delete.
2. DDL: create, drop, etc.
3. DATABASE: logon, shutdown, etc.

Triggers DML: Tipos eventos

Tipos           eventos                     filas afectadas
BEFORE          INSERT, UPDATE, DELETE      STATEMENT (Solo se dispara una vez), ROW (Se dispara por cada fila)
AFTER
INSTEAD OF
*/

SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
Cada vez que se haga una inserción en la tabla regions, debemos registrar en la
tabla logs el usuario que lo insertó.
*/
-- Preparand escenario
CREATE TABLE logs(
    event VARCHAR2(200),
    table_name VARCHAR2(100),
    username VARCHAR2(50),
    create_at TIMESTAMP DEFAULT SYSDATE
);
/

-- Creando el trigger
CREATE OR REPLACE TRIGGER tx_insert_regions
AFTER INSERT
ON regions
BEGIN
    INSERT INTO logs(event, table_name, username)
    VALUES('insert', 'regions', USER);
END tx_insert_regions;
/

-- Probando trigger
INSERT INTO regions(region_id, region_name)
VALUES(5, 'Oceanía');

SELECT *
FROM regions;

-- Verificando tabla logs luego de insertar en regions
SELECT *
FROM logs;


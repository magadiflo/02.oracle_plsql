/***************************************************************************************************
Triggers del tipo DDL
****************************************************************************************************
*/

SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
Controlar que nadie pueda eliminar tablas del usuario HR
*/
CREATE OR REPLACE TRIGGER tx_ddl
BEFORE DROP
ON HR.SCHEMA
BEGIN
    RAISE_APPLICATION_ERROR(-20001, 'No se pueden eliminar las tablas del usuario HR');
END tx_ddl;
/

-- Probando trigger
DROP TABLE regions;

SELECT *
FROM regions;
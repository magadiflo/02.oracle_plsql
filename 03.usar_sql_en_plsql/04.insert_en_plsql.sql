/***************************************************************************************************
INSERT en PLSQL
****************************************************************************************************

¡IMPORTANTE!

Los INSERT, UPDATE y DELETED deberían de llevar un COMMIT o un ROLLBACK en aquellos
puntos donde consideremos que deben guardarse definitavamente la información en
la base de datos, ya que si no lo hacemos, los datos podrían perderse si es que 
no tenemos activado el commit automático y cerramos sin guardar el editor.
*/

SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
*/

-- Preparando escenario
CREATE TABLE test(
    id NUMBER NOT NULL,
    name VARCHAR2(20)    
);

SELECT * 
FROM test;

-- Usando INSERT dentro de PLSQL
DECLARE
    id test.id%TYPE;
BEGIN
    id := 1;
    
    INSERT INTO test(id, name)
    VALUES(id, 'Nuevo Chimbote');
    
    COMMIT;
END;
/

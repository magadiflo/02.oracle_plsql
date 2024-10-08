/***************************************************************************************************
INSERT en PLSQL
****************************************************************************************************

�IMPORTANTE!

Los INSERT, UPDATE y DELETED deber�an de llevar un COMMIT o un ROLLBACK en aquellos
puntos donde consideremos que deben guardarse definitavamente la informaci�n en
la base de datos, ya que si no lo hacemos, los datos podr�an perderse si es que 
no tenemos activado el commit autom�tico y cerramos sin guardar el editor.
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
    col_id test.id%TYPE;
BEGIN
    col_id := 1;
    
    INSERT INTO test(id, name)
    VALUES(col_id, 'Nuevo Chimbote');
    
    COMMIT;
END;
/

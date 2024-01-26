/***************************************************************************************************
Práctica excepciones personalizadas
****************************************************************************************************
*/

SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
Crear una Excepción personalizada denominada CONTROL_REGIONS.

- Debe dispararse cuando al insertar o modificar una región queramos poner una 
  clave superior a 200. Por ejemplo usando una variable con ese valor.
- En ese caso debe generar un texto indicando algo así como “Codigo no permitido. 
  Debe ser inferior a 200”
- Recordemos que las excepciones personalizadas deben dispararse de forma manual
  con el RAISE.
*/
DECLARE
    CONTROL_REGIONS EXCEPTION;
    id NUMBER;
BEGIN
    id := 200;
    
    IF id >= 200 THEN
        RAISE CONTROL_REGIONS;
    ELSE
        INSERT INTO regions(region_id, region_name)
        VALUES(id, 'Oceanía');
    END IF;
EXCEPTION
    WHEN CONTROL_REGIONS THEN
        dbms_output.put_line('Código no permitido, debe ser interior a 200');
    WHEN OTHERS THEN
        dbms_output.put_line('Ocurrió un error al procesar bloque plsql');
END;
/

SELECT * 
FROM regions;

DELETE FROM regions WHERE region_id = 199;
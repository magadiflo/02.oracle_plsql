/***************************************************************************************************
Recorrer un cursor con el bucle FOR
****************************************************************************************************
Cuando se usa el bucle FOR para recorrer un cursor, las sentencias:
OPE, FETCH y CLOSE están implícitos, es decir, no tenemos que ponerlos.
*/

SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
*/
DECLARE
    CURSOR c_regions
    IS SELECT *
        FROM regions;
BEGIN
    FOR region IN c_regions LOOP
        dbms_output.put_line(region.region_name);
    END LOOP;
END;
/
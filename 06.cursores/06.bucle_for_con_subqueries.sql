/***************************************************************************************************
Bucle FOR con subQueries
****************************************************************************************************
*/

SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
Abrimos un cursor directamente en un bucle FOR declarando el SELECT dentro de él.
*/
BEGIN
    FOR region IN (SELECT * FROM regions) LOOP
        dbms_output.put_line(region.region_name);
    END LOOP;
END;
/
/***************************************************************************************************
Recorrer un cursor con el bucle LOOP
****************************************************************************************************
Recordar los atributos:

nombre_cursor%NOTFOUND
nombre_cursor%FOUND
nombre_cursor%ISOPEN
nombre_cursor%ROWCOUNT
*/

SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
*/
DECLARE
    CURSOR c_regions
    IS SELECT *
        FROM regions;
        
    row_region regions%ROWTYPE;
BEGIN
    OPEN c_regions;
    
    LOOP
        FETCH c_regions INTO row_region;
        EXIT WHEN c_regions%NOTFOUND;
        
        dbms_output.put_line(row_region.region_name);
    END LOOP;
    
    CLOSE c_regions;
END;
/

/***************************************************************************************************
Crear un cursor
****************************************************************************************************
¡IMPORTANTE!
En otras bases de datos, los cursores nos permite ir hacia adelante, hacia atrás, etc. en ORACLE eso
no es posible, es decir, el poder moverse en cualquier dirección que se quiera. En ORACLE podemos 
avanzar únicamente hacia adelante, es decir, abrimos el cursor, leemos de manera secuecial y cerramos
el cursor.

Si quisiéramos movermos en cualquier dirección debemos usar ARRAYS o tipos TABLES.
*/

SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
*/
DECLARE
    --1. declaramos el cursor
    CURSOR c_regions
    IS SELECT * 
        FROM regions;
        
    row_region regions%ROWTYPE;
BEGIN
    --2. abrimos el cursor
    OPEN c_regions;
    
    --3. Leemos datos del cursor
    FETCH c_regions INTO row_region;
    dbms_output.put_line(row_region.region_name);
    
    --4.cerramos el cursor
    CLOSE c_regions;
END;
/
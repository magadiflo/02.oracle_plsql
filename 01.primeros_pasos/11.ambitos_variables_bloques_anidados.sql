/***************************************************************************************************
Ámbitos de variables en bloques anidados
****************************************************************************************************
Variables Globales, se refiere a las variables definidas en el bloque padre. Estas variables
podrán ser accedidas desde los bloques hijos.

Variables Locales, son variables que han sido definidas dentro de los bloques hijos.
*/

/* Ejemplo 01
******************************************************
*/
SET SERVEROUTPUT ON;

DECLARE 
    /* Variables Globales */
    x NUMBER := 20;
    z NUMBER := 30;
    father NUMBER := 33;
BEGIN
    dbms_output.put_line('--------------');
    dbms_output.put_line('x := ' || x);
    dbms_output.put_line('--------------');
    
    DECLARE
        /* Variables Locales */
        x NUMBER := 10;
        z NUMBER := 100;
        y NUMBER := 200;
    BEGIN
        dbms_output.put_line('x := ' || x);
        dbms_output.put_line('z := ' || z);
        dbms_output.put_line('father := ' || father);
    END;
    
    dbms_output.put_line('--------------');
    dbms_output.put_line('z := ' || z);
    dbms_output.put_line('--------------');
END;
/***************************************************************************************************
Bucles anidados
****************************************************************************************************
*/
SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
<<parent_bucle>>, representa una etiqueta, en este caso esta etiqueta corresponde
al primer bucle. El nombre de la etiqueta es parent_bucle.
*/
DECLARE 
    i PLS_INTEGER := 0;
    j PLS_INTEGER;
BEGIN
    <<parent_bucle>>
    LOOP
        i := i + 1;
        j := 100;
        dbms_output.put_line('----------------');
        dbms_output.put_line('Parent bucle: ' || i);
        dbms_output.put_line('----------------');
        
        <<child_bucle>>
        LOOP
            EXIT parent_bucle WHEN i > 3;
            dbms_output.put_line('Child bucle: ' || j);
            j := j + 1;
            
            EXIT child_bucle WHEN j > 105;
        END LOOP child_bucle;
        
    END LOOP parent_bucle;
    
    dbms_output.put_line('¡Fin de bucles!');
END;
/
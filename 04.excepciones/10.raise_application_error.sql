/***************************************************************************************************
RAISE_APPLICATION_ERROR
****************************************************************************************************
Es una función que nos permite devolver un excepción personalizada deteniendo la ejecución
del bloque. Lanza la excepción con un código de error y un mensaje personalizado. El código
de error debe estar entre -20000 y -20999.

Es como lo errores que lanza ORACLE cuando ocurre alguna excepción.
*/

SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
*/
DECLARE
    id NUMBER;
    name VARCHAR2(200);
BEGIN
    id := 101;
    name := 'Oceanía';
    
    IF id > 100 THEN
        RAISE_APPLICATION_ERROR(-20001, 'El id no puede ser mayor que 100');
    ELSE
        INSERT INTO regions
        VALUES(id, name);
        
        COMMIT;
    END IF;
END;
/

/* Ejemplo 01
******************************************************
Modificar la practica anterior para disparar un error con RAISE_APPLICATION en 
vez de con PUT_LINE. 
*/
DECLARE
    LIMIT_MAX_ID EXCEPTION;
    id NUMBER;
    name VARCHAR2(200);
BEGIN
    id := 101;
    name := 'Oceanía';
    
    IF id > 100 THEN
        RAISE LIMIT_MAX_ID;
    ELSE
        INSERT INTO regions
        VALUES(id, name);
        
        COMMIT;
    END IF;
EXCEPTION
    WHEN LIMIT_MAX_ID THEN
        RAISE_APPLICATION_ERROR(-20001, 'El id no puede ser mayor que 100');
    WHEN OTHERS THEN
        dbms_output.put_line('Error no reconocido');
END;
/


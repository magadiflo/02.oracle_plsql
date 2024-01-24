/***************************************************************************************************
Constantes y variables NOT NULL
****************************************************************************************************
- Una constante siempre debe estar inicializada y no podrá ser modificada una vez definida su valor.
- Una variable NOT NULL, no admite valores Nulos. Permite modificar el valor.
*/

/* Ejemplo 01
******************************************************
Ctrl + F7, permite formatear el código
*/
SET SERVEROUTPUT ON;

DECLARE
    pi    CONSTANT NUMBER := 3.141516;
    email VARCHAR2(100) NOT NULL := 'martin@gmail.com';
BEGIN
    dbms_output.put_line('Pi: ' || pi);
    dbms_output.put_line('Email: ' || email);
    email := 'martin.system@gmail.com';
    dbms_output.put_line('New email: ' || email);
END;
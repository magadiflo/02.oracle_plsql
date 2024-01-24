/***************************************************************************************************
Visualizar datos por pantalla
****************************************************************************************************
SET SERVEROUTPUT ON, habilita la salida por pantalla.
*/

SET SERVEROUTPUT ON;

BEGIN
    DBMS_OUTPUT.PUT_LINE('Hola ' || ' mundo!');
    DBMS_OUTPUT.PUT_LINE(3.141516);
END;
/***************************************************************************************************
Visualizar datos por pantalla
****************************************************************************************************
SET SERVEROUTPUT ON, habilita la salida por pantalla.

La barra / se limita a ejecutar el bloque actual, es decir, evita que otros
bloques anónimos se ejecuten, centrándose únicamente en la ejecución del bloque
actual.

Por ejemplo: 
Si quitamos las barras / de ambos bloques anónimos y nos posicionamos en el 
primer bloque anónimo y ejecutamos Ctrl + enter, veremos que en consola nos
mostrará un error, eso sucede porque está ejecutandose todo el script. Entonces,
para limitarnos a ejecutar el bloque anónimo actual, es que usamos la barra /
*/

SET SERVEROUTPUT ON;

BEGIN
    DBMS_OUTPUT.PUT_LINE('Hola ' || ' mundo!');
    DBMS_OUTPUT.PUT_LINE(3.141516);
END;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE('Segundo bloque anónimo ');
END;
/
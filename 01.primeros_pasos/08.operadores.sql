/***************************************************************************************************
Operadores
****************************************************************************************************
Los operadores más habituales son:

+ Suma
- Resta
/ División
* Multiplicación
** Exponente
|| Concatenación
*/

/* Ejemplo 01
*******************************************************/
SET SERVEROUTPUT ON;

DECLARE
    x NUMBER := 5;
    z NUMBER := 10;
    a VARCHAR2(100) := 'Example';
    d DATE := '2024-01-24';    
BEGIN
    dbms_output.put_line(sysdate);
    dbms_output.put_line(d + 1);
    dbms_output.put_line(a || ' ' || x);
END;


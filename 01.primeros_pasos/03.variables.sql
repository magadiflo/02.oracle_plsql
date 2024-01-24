/***************************************************************************************************
Variables
****************************************************************************************************
- Las variables deben ser declaradas antes de ser usadas.
- Las variables se declaran e inicializan en la sección DECLARE.
*/

/* Ejemplo 01
******************************************************
*/
SET SERVEROUTPUT ON;

DECLARE
    salary NUMBER(6,2)  := 2500.50;
    name VARCHAR2(100)  := 'Leonardo';
    amount NUMBER(6,2);
BEGIN
    amount := 3500.55;
    
    DBMS_OUTPUT.PUT_LINE('Salary: ' || salary);
    DBMS_OUTPUT.PUT_LINE('Name: ' || name);
    DBMS_OUTPUT.PUT_LINE('Amount: ' || amount);
END;
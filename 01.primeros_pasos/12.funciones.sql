/***************************************************************************************************
Funciones PL/SQL
****************************************************************************************************
*/
SET SERVEROUTPUT ON;

/* Ejemplo 01
*******************************************************/
DECLARE 
    name VARCHAR2(100);
    current_date DATE := SYSDATE;
BEGIN
    name := 'Milagros';
    dbms_output.put_line(UPPER(SUBSTR(name, 1, 4))); --Salida: MILA
    dbms_output.put_line(TO_CHAR(current_date, 'dd/mm/yyyy'));
END;

/* Ejemplo 02
*******************************************************/
DECLARE
    firstName VARCHAR2(50) := 'jasmin';
    lastName1 VARCHAR2(50) := 'campos';
    lastName2 VARCHAR2(50) := 'Suyón';
    cad VARCHAR(10);
BEGIN
    cad := SUBSTR(firstName, 1,1) || '.' || SUBSTR(lastName1, 1,1) || '.' || SUBSTR(lastName2, 1,1);
    dbms_output.put_line(UPPER(cad));
END;

/* Ejemplo 03
*******************************************************/
DECLARE
    birth_day DATE := '2002-01-14';
BEGIN
    dbms_output.put_line(TO_CHAR(birth_day, 'DD'));
    dbms_output.put_line(TO_CHAR(birth_day, 'MM'));
    dbms_output.put_line(TO_CHAR(birth_day, 'YYYY'));
    dbms_output.put_line(TO_CHAR(birth_day, 'DAY'));
END;
/***************************************************************************************************
SELECT dentro de PL/SQL
****************************************************************************************************
Siempre que uso un SELECT dentro de PLSQL, debemos usar la cláusula INTO para decirle
dónde dejaremos el resultado de dicha select.
*/
SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
El siguiente ejemplo muestra cómo imprimir los datos de 1 solo registro.
NOTA:
- El código de abajo debe retornar 1 y solo 1 fila.
- Si retorna múltiples filas, el INTO no va a servir.
- Si no retorna ningún registro (por que el id no existe) arrojará el
  error ORA-01403: no data found
*/
DECLARE
    salary employees.salary%TYPE;
    full_name employees.first_name%TYPE;
    
BEGIN
    SELECT salary, first_name || ' ' || last_name
    INTO salary, full_name
    FROM employees
    WHERE employee_id = 100;    
    
    dbms_output.put_line(salary);
    dbms_output.put_line(full_name);
END;
/




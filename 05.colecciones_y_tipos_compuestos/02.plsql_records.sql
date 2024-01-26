/***************************************************************************************************
PL/SQL RECORDS
****************************************************************************************************
*/

SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
*/
DECLARE
    TYPE employee_record IS RECORD(
        full_name VARCHAR2(200),
        salary NUMBER,
        hire_date employees.hire_date%TYPE,
        full_data employees%ROWTYPE
    );
    
    employee employee_record;
BEGIN
    SELECT * 
    INTO employee.full_data
    FROM employees
    WHERE employee_id = 100;
    
    employee.full_name := employee.full_data.first_name || ' ' || employee.full_data.last_name;
    employee.salary := employee.full_data.salary * 0.8;
    employee.hire_date := employee.full_data.hire_date;
    
    dbms_output.put_line('Nombre completo: ' || employee.full_name);
    dbms_output.put_line('Salario: ' || employee.salary);
    dbms_output.put_line('Fecha de contratación: ' || TO_CHAR(employee.hire_date, 'dd-mm-yyyy'));
    dbms_output.put_line('Primer nombre: ' || employee.full_data.first_name);
END;
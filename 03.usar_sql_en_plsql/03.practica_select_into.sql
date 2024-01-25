/***************************************************************************************************
Práctica SELECT INTO
****************************************************************************************************
*/
SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
Crear un bloque PL/SQL que devuelva al salario máximo del departamento 100 y lo
deje  en una variable denominada salario_maximo y la visualice.
*/
DECLARE
    max_salary employees.salary%TYPE;
BEGIN
    SELECT MAX(salary)
    INTO max_salary
    FROM employees
    WHERE department_id = 100;
    
    dbms_output.put_line('El salario máximo es: ' || max_salary);
END;
/

/* Ejemplo 02
******************************************************
Visualizar el tipo de trabajo del empleado número 100
*/
DECLARE
    job_title jobs.job_title%TYPE;
BEGIN
    SELECT  j.job_title
    INTO job_title
    FROM employees e
        INNER JOIN jobs j ON(e.job_id = j.job_id)
    WHERE e.employee_id = 100;
    
    dbms_output.put_line('Tipo de trabajo: ' || job_title);
END;
/

/* Ejemplo 03
******************************************************
Crear una variable de tipo DEPARTMENT_ID y ponerla algún valor, por ejemplo 10.
Visualizar el nombre de ese departamento y el número de empleados que tiene, 
poniendo. Crear dos variables para albergar los valores.
*/
DECLARE
    department_name departments.department_name%TYPE;
    total_employees NUMBER;
BEGIN
    SELECT d.department_name, COUNT(*) AS count
    INTO department_name, total_employees
    FROM employees e
        INNER JOIN departments d ON(e.department_id = d.department_id)
    WHERE d.department_id = 10
    GROUP BY d.department_name;
    
    
    dbms_output.put_line('Nombre del departamento: ' || department_name);
    dbms_output.put_line('Número de empleados: ' || total_employees);
END;
/



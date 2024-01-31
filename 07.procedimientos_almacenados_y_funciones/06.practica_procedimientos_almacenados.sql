/***************************************************************************************************
Práctica con procedimientos almacenados
****************************************************************************************************
*/

SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
Crear un procedimiento llamado visualizar que visualice el nombre y salario de 
todos los empleados.
*/
CREATE OR REPLACE PROCEDURE sp_show_employee
AS
    CURSOR c_employee 
    IS SELECT first_name, salary
        FROM employees;
        
    TYPE r_employee IS RECORD(
        first_name employees.first_name%TYPE,
        salary employees.salary%TYPE
    );
    
    employee r_employee;
BEGIN
    OPEN c_employee;
    
    LOOP
        FETCH c_employee INTO employee;
        EXIT WHEN c_employee%NOTFOUND;
        
        dbms_output.put_line(employee.first_name || ', ' || employee.salary);        
    END LOOP;  

    CLOSE c_employee;
END;
/

EXECUTE sp_show_employee();

/* Ejemplo 02
******************************************************
Modificar el programa anterior para incluir un parámetro que pase el número de 
departamento para que visualice solo los empleados de ese departamento.
Debe devolver el número de empleados en una variable de tipo OUT.
*/
CREATE OR REPLACE PROCEDURE sp_show_employee_from_department(
    p_department_id employees.department_id%TYPE,
    p_total_employees OUT NUMBER
)
AS
    CURSOR c_employee 
    IS SELECT first_name, salary
        FROM employees
        WHERE department_id = p_department_id;
        
    TYPE r_employee IS RECORD(
        first_name employees.first_name%TYPE,
        salary employees.salary%TYPE
    );
    
    employee r_employee;
BEGIN
    p_total_employees := 0;
    
    OPEN c_employee;
    
    LOOP
        FETCH c_employee INTO employee;
        EXIT WHEN c_employee%NOTFOUND;        
        p_total_employees := p_total_employees + 1;
        dbms_output.put_line(p_total_employees || '. ' || employee.first_name || ', ' || employee.salary);        
    END LOOP;  

    CLOSE c_employee;
END;
/

-- Ejecutando sp
DECLARE
    total_employees NUMBER;
BEGIN
    sp_show_employee_from_department(100, total_employees);
    dbms_output.put_line('Total de empleados: ' || total_employees);
END;
/


/* Ejemplo 03
******************************************************
Crear un bloque por el cual se de formato a un nº de cuenta suministrado por 
completo, por ej , 11111111111111111111
- Formateado a: 1111-1111-11-1111111111
- Debemos usar un parámetro de tipo IN-OUT
*/
CREATE OR REPLACE PROCEDURE sp_format_account(
    p_account IN OUT VARCHAR2
)
AS
BEGIN
    IF LENGTH(TRIM(p_account)) != 20 THEN
        RAISE_APPLICATION_ERROR(-20001, 'El valor del acount debe tener una longitud de 20 caracteres');
    END IF;
    dbms_output.put_line('Formateando: ' || p_account);    
    p_account :=    SUBSTR(p_account, 1, 4) || '-' || 
                    SUBSTR(p_account, 5, 4)  || '-' || 
                    SUBSTR(p_account, 9, 2)  || '-' ||
                    SUBSTR(p_account, 11);
END;
/

-- Ejecutando sp
DECLARE
    account VARCHAR2(23);
BEGIN
    account := '15210457901111111111';
    sp_format_account(account);
    dbms_output.put_line('Formateado: ' || account);
END;
/


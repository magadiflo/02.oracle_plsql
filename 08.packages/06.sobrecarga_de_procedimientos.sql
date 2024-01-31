/***************************************************************************************************
Sobrecarga de procedimientos
****************************************************************************************************
*/

SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
*/
CREATE OR REPLACE PACKAGE package_employees
AS
    -- Aplicando sobrecarga de métodos: mismo nombre pero distintos parámetros.
    FUNCTION fn_count_employees RETURN NUMBER;
    FUNCTION fn_count_employees(p_department_id NUMBER) RETURN NUMBER;
END;
/

CREATE OR REPLACE PACKAGE BODY package_employees
AS
    FUNCTION fn_count_employees
    RETURN NUMBER
    AS
        total NUMBER;
    BEGIN
        SELECT COUNT(*) AS total
        INTO total
        FROM employees;
        
        RETURN total;
    END fn_count_employees;
    
    FUNCTION fn_count_employees(
        p_department_id NUMBER
    )
    RETURN NUMBER
    AS
        total NUMBER;
    BEGIN
        SELECT COUNT(*) AS total
        INTO total
        FROM employees e
        WHERE e.department_id = p_department_id;
        
        RETURN total;
    END fn_count_employees;    
END package_employees;
/

-- Utilizando paquete
BEGIN
    dbms_output.put_line('Total de empleados: ' || package_employees.fn_count_employees());
    dbms_output.put_line('Total de empleados en departamento 100: ' || package_employees.fn_count_employees(100));
END;
/

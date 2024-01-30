/***************************************************************************************************
Parámetro tipo IN/OUT
****************************************************************************************************
*/

SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
*/
CREATE OR REPLACE PROCEDURE sp_calculate_tax_in_out(
    p_id IN employees.employee_id%TYPE,
    p_tax IN OUT NUMBER                             -- Variable del tipo IN OUT
)
AS
    salary NUMBER := 0;
BEGIN
    IF p_tax < 0 OR p_tax > 60 THEN
        RAISE_APPLICATION_ERROR(-20001, 'El porcentaje debe estar entre 0 y 60');
    END IF;
    
    SELECT e.salary
    INTO salary
    FROM employees e
    WHERE e.employee_id = p_id;

    p_tax := salary * p_tax/100; 
    
    dbms_output.put_line('Salario: ' || salary);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('No existe el empleado.');
END;
/

-- Ejecutando procedimiento
DECLARE
    id employees.employee_id%TYPE;
    tax NUMBER;
BEGIN
    id := 100;
    tax := 20;
    
    sp_calculate_tax_in_out(id, tax);
    dbms_output.put_line('Impuesto: ' || tax);
END;
/
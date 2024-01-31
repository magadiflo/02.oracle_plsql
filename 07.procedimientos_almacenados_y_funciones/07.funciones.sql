/***************************************************************************************************
Funciones
****************************************************************************************************
También pueden usar variables del tipo IN, OUT, pero no 
es recomendable. Si queremos usar IN, OUT, es mejor usar
procedimientos almacenados.
*/

SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
*/
CREATE OR REPLACE FUNCTION fn_calculate_tax(
    p_employee_id employees.employee_id%TYPE,
    p_tax NUMBER
)
RETURN NUMBER
AS
    salary NUMBER := 0;
    tax NUMBER := 0;
BEGIN
    IF p_tax < 0 OR p_tax > 60 THEN
        RAISE_APPLICATION_ERROR(-20001, 'El porentaje debe estar entre 0 y 60');
    END IF;
    
    SELECT e.salary
    INTO salary
    FROM employees e
    WHERE e.employee_id = p_employee_id;
    
    tax := salary * p_tax/100;
    
    return tax;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('No existe el empleado');
END;
/

-- Ejecutando función
DECLARE
    tax NUMBER := 0;
BEGIN
    tax := fn_calculate_tax(120, 10);
    dbms_output.put_line(tax);
END;
/
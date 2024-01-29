/***************************************************************************************************
Update y deletes con where current of
****************************************************************************************************
(1) FOR UPDATE, bloquea la consulta para que otros usuarios no la alteren mientras se ejecuta el cursor.    
(2) CURRENT OF c_cursor, fila en la que actualmente nos encontramos.
*/

SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
*/
DECLARE
    CURSOR c_employees 
    IS SELECT *
        FROM employees
    FOR UPDATE;                                         --(1)
    employee employees%ROWTYPE;
BEGIN
    OPEN c_employees;
    LOOP
        FETCH c_employees INTO employee;
        EXIT WHEN c_employees%NOTFOUND;
        
        IF employee.commission_pct IS NOT NULL THEN
            UPDATE employees
            SET salary = salary * 1.10
            WHERE CURRENT OF c_employees;               --(2)
        ELSE
            UPDATE employees
            SET salary = salary * 1.15
            WHERE CURRENT OF c_employees;
        END IF;
    END LOOP;
    
    CLOSE c_employees;
END;
/

SELECT * 
FROM employees;
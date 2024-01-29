/***************************************************************************************************
Cursores con parámetros
****************************************************************************************************
*/

SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
*/
DECLARE
    CURSOR c_employees(sal NUMBER)
    IS SELECT *
        FROM employees e
        WHERE e.salary > sal;
        
    employee employees%ROWTYPE;    
BEGIN
    OPEN c_employees(8000);
    
    LOOP 
        FETCH c_employees INTO employee;
        EXIT WHEN c_employees%NOTFOUND;
        dbms_output.put_line(employee.first_name || ' ' || employee.last_name);
    END LOOP;
    
    dbms_output.put_line('Se hanencontrado ' || c_employees%ROWCOUNT || ' empleados');
    
    CLOSE c_employees;
END;
/

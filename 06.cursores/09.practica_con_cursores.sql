/***************************************************************************************************
Práctica con cursores
****************************************************************************************************
*/

SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
Hacer un programa que tenga un cursor que vaya visualizando los salarios de los empleados. 
Si en el cursor aparece el jefe (Steven King) se debe generar un RAISE_APPLICATION_ERROR 
indicando que el sueldo del jefe no se puede ver.
*/
DECLARE
    TYPE employee_record IS RECORD(
        full_name VARCHAR(200),
        salary employees.salary%TYPE
    );
    
    CURSOR c_employees
    IS SELECT first_name || ' ' || last_name AS fullname, salary
        FROM employees;
        
    employee employee_record;
BEGIN
    OPEN c_employees;
    
    LOOP
        FETCH c_employees INTO employee;
        EXIT WHEN c_employees%NOTFOUND;
        
        IF employee.full_name = 'Steven King' THEN
            RAISE_APPLICATION_ERROR(-20001, 'El sueldo del jefe no se puede ver');
        END IF;
        
        dbms_output.put_line('Employee: ' || employee.full_name || ', ' || 'salary: ' || employee.salary);
    END LOOP;
    
    CLOSE c_employees;
END;
/
/* Ejemplo 02
******************************************************
Hacemos un bloque con dos cursores. (Esto se puede hacer fácilmente con una sola 
SELECT pero vamos a hacerlo de esta manera para probar parámetros en cursores)

- El primero de empleados.
- El segundo de departamentos que tenga como parámetro el MANAGER_ID.
- Por cada fila del primero, abrimos el segundo curso pasando el ID del MANAGER.
- Debemos pintar el Nombre del departamento y el nombre del MANAGER_ID.
- Si el empleado no es MANAGER de ningún departamento debemos poner “No es jefe de nada”.
*/
DECLARE
    CURSOR c_employees 
    IS SELECT * 
        FROM employees;
        
    CURSOR c_departments(mng_id NUMBER)
    IS SELECT * 
        FROM departments
        WHERE manager_id = mng_id;
        
    employee employees%ROWTYPE;
    department departments%ROWTYPE;
BEGIN
    OPEN c_employees;
    
    LOOP
        FETCH c_employees INTO employee;
        EXIT WHEN c_employees%NOTFOUND;
        --------------------------------------------------
        OPEN c_departments(employee.employee_id);        
        FETCH c_departments INTO department;
        
        IF c_departments%NOTFOUND THEN
            dbms_output.put_line(employee.first_name || ',' || 'No es jefe de nada');
        ELSE
            dbms_output.put_line('----------------->[' || employee.first_name || ', ' || department.department_name || ']');        
        END IF;
                
        CLOSE c_departments;
        --------------------------------------------------
    END LOOP;
    
    CLOSE c_employees;
END;
/

-- Su equivalente en SQL
SELECT  jefe.employee_id,
        jefe.first_name || ' ' || jefe.last_name AS jefe,
        NVL(dep.department_name, 'No es jefe de nada?') AS departamento
FROM employees jefe 
    LEFT JOIN departments dep ON(jefe.employee_id = dep.manager_id)
ORDER BY departamento;
/

/* Ejemplo 03
******************************************************
Crear un cursor con parámetros que pasando el número de departamento visualice 
el número de empleados de ese departamento.
*/
DECLARE
    CURSOR c_departments(id departments.department_id%TYPE)
    IS SELECT COUNT(*) AS total
        FROM employees
        WHERE department_id = id;
        
    total_employees NUMBER;
BEGIN
    --OPEN c_departments(50);
    OPEN c_departments(270);
    
    FETCH c_departments INTO total_employees;
    dbms_output.put_line('Hay ' || total_employees || ' empleados');
    
    CLOSE c_departments;
END;
/

/* Ejemplo 04
******************************************************
Crear un bucle FOR donde declaramos una subconsulta que nos devuelva el nombre de los 
empleados que sean ST_CLERCK. Es decir, no declaramos el cursor sino que lo indicamos 
directamente en el FOR.
*/
BEGIN
    FOR employee IN (SELECT first_name FROM employees WHERE job_id = 'ST_CLERK') LOOP
        dbms_output.put_line(employee.first_name);
    END LOOP;
END;
/

/* Ejemplo 05
******************************************************
Creamos un bloque que tenga un cursor para empleados. Debemos crearlo con FOR UPDATE.

- Por cada fila recuperada, si el salario es mayor de 8000 incrementamos el salario un 2%
- Si es menor de 800 lo hacemos en un 3%
- Debemos modificarlo con la cláusula CURRENT OF
- Comprobar que los salarios se han modificado correctamente.
*/
DECLARE
    CURSOR c_employees
    IS SELECT * 
        FROM employees
    FOR UPDATE;
    
    employee employees%ROWTYPE;
BEGIN
    OPEN c_employees;
    
    LOOP
        FETCH c_employees INTO employee;
        EXIT WHEN c_employees%NOTFOUND;
        
        IF employee.salary > 8000 THEN
            UPDATE employees
            SET salary = salary * 1.02
            WHERE CURRENT OF c_employees;
        ELSIF employee.salary < 800 THEN
            UPDATE employees
            SET salary = salary * 1.03
            WHERE CURRENT OF c_employees;
        END IF;    
    END LOOP;
    
    COMMIT;
    
    CLOSE c_employees;
END;
/

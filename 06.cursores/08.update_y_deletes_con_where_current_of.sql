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

/*
¿Qué hace WHERE CURRENT OF?

- WHERE CURRENT OF c_employees;: Esta cláusula le indica a Oracle que la actualización debe aplicarse
  a la fila actual que fue recuperada por el cursor c_employees. En lugar de escribir una condición 
  específica (como WHERE employee_id = employee.employee_id), usas CURRENT OF para referirte directamente 
  a la fila actual que está siendo procesada por el cursor.

Esto es muy útil para evitar recalcular la clave primaria o usar múltiples condiciones en el WHERE y 
asegura que la actualización afecte solo la fila que fue recuperada por el cursor en ese momento.

Requisitos para usar CURRENT OF:

- El cursor debe estar definido con la cláusula FOR UPDATE, lo cual ya haces en tu script.
- La tabla que estás actualizando debe ser la misma que la tabla que estás iterando con el cursor.

Resumen del flujo:

1. El cursor abre y bloquea las filas seleccionadas debido a la cláusula FOR UPDATE.
2. Dentro del ciclo, obtienes la fila actual con FETCH.
3. Con WHERE CURRENT OF c_employees, Oracle sabe que debe actualizar la fila que el cursor ha recuperado.
*/
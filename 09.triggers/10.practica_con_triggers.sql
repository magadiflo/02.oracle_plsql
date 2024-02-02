/***************************************************************************************************
Práctica con triggers
****************************************************************************************************
*/

SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
Crear un TRIGGER BEFORE DELETE sobre la tabla EMPLOYEES que impida borrar un 
registro si su JOB_ID es algo relacionado con CLERK
*/
CREATE OR REPLACE TRIGGER tx_employees
BEFORE DELETE
ON employees
FOR EACH ROW
BEGIN
    IF :OLD.job_id LIKE '%CLERK%' THEN
        RAISE_APPLICATION_ERROR(-20001, 'El empleado con el job_id: ' || :OLD.job_id || ' no puede ser eliminado');
    END IF;
END tx_employees;
/

-- Probando trigger
DELETE FROM employees WHERE job_id LIKE '%CLERK%';
DELETE FROM employees WHERE employee_id = 116; -- Su job_id contiene el CLERK.

/* Ejemplo 02
******************************************************
Crear una tabla denominada AUDITORIA con las siguientes columnas:

CREATE TABLE AUDITORIA (
USUARIO VARCHAR(50),
FECHA DATE,
SALARIO_ANTIGUO NUMBER,
SALARIO_NUEVO NUMBER);
*/
CREATE TABLE auditories(
    username VARCHAR2(50),
    create_at DATE,
    old_salary NUMBER,
    new_salary NUMBER
);

/* Ejemplo 03
******************************************************
Crear un TRIGGER BEFORE INSERT de tipo STATEMENT, de forma que cada vez que se 
haga un INSERT en la tabla REGIONS guarde una fila en la tabla AUDITORIA con el 
usuario y la fecha en la que se ha hecho el INSERT
*/
CREATE OR REPLACE TRIGGER tx_regions
BEFORE INSERT 
ON regions
BEGIN
    INSERT INTO auditories(username, create_at)
    VALUES(USER, SYSDATE);
END tx_regions;
/

-- Probando trigger
INSERT INTO regions(region_id, region_name)
VALUES(5, 'Oceanía');

SELECT * 
FROM auditories;

DELETE FROM regions WHERE region_id = 5;

/* Ejemplo 04
******************************************************
Realizar otro trigger BEFORE UPDATE de la columna SALARY de tipo EACH ROW. 
- Si la modificación supone rebajar el salario el TRIGGER debe disparar un 
  RAISE_APPLICATION_ERROR“no se puede bajar un salario”. 
- Si el salario es mayor debemos dejar el salario antiguo y el salario nuevo en 
  la tabla AUDITORIA.
*/
CREATE OR REPLACE TRIGGER tx_employees_update
BEFORE UPDATE OF salary
ON employees
FOR EACH ROW
BEGIN    
    IF (:NEW.salary < :OLD.salary) THEN
        RAISE_APPLICATION_ERROR(-20001, 'No se puede bajar un salario');
    ELSIF (:NEW.salary > :OLD.salary) THEN
        INSERT INTO auditories(username, create_at, old_salary, new_salary)
        VALUES(USER, SYSDATE, :OLD.salary, :NEW.salary);
    END IF;
END tx_employees_update;
/

-- Probando trigger
SELECT * FROM employees;
SELECT * FROM auditories;

--Salario actual del empleado 100 = 20400, al actualizar debe lanzar el error.
UPDATE employees
SET salary = 20000
WHERE employee_id = 100;

--Salario actual del empleado 100 = 20400, al actualizar debe registrar en la tabla auditories.
UPDATE employees
SET salary = 50400
WHERE employee_id = 100;

/* Ejemplo 05
******************************************************
Crear un TRIGGER BEFORE INSERT en la tabla DEPARTMENTS que al insertar un 
departamento compruebe que el código no esté repetido y luego que si el 
LOCATION_ID es NULL le ponga 1700 y si el MANAGER_ID es NULL le ponga 200
*/
CREATE OR REPLACE TRIGGER tx_departments
BEFORE INSERT
ON departments
FOR EACH ROW
DECLARE
    rows_affected NUMBER;
BEGIN   
    SELECT COUNT(*) 
    INTO rows_affected
    FROM departments 
    WHERE department_id = :NEW.department_id;
    
    IF rows_affected > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'El id del departamento ya está registrado');
    END IF;
    
    IF :NEW.location_id IS NULL THEN
        :NEW.location_id := 1700;
    END IF;
    
    IF :NEW.manager_id IS NULL THEN
        :NEW.manager_id := 200;
    END IF;
END tx_departments;
/

--Probando trigger
SELECT * 
FROM departments;

--Result. El departamento ya existe
INSERT INTO departments
VALUES(10, 'Sistemas', 204, 2700);

--Result. Por defecto insertará: manager_id = 200, location_ID = 1700
INSERT INTO departments(department_id, department_name)
VALUES(280, 'Sistemas');


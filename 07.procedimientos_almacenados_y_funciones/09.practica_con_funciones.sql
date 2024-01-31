/***************************************************************************************************
Práctica con funciones
****************************************************************************************************
*/

SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
Crear una función que tenga como parámetro un número de departamento y que 
devuelve la suma de los salarios de dicho departamento. La imprimimos por pantalla.

- Si el departamento no existe debemos generar una excepción con dicho mensaje.
*/
CREATE OR REPLACE FUNCTION fn_sum_salary_by_department(
    p_department_id departments.department_id%TYPE
)
RETURN NUMBER
AS
    sum_salary NUMBER := 0;
    id departments.department_id%TYPE;
BEGIN

    -- Comprobamos que el departamento existe, caso contrario arrojará la excepción en automático
    SELECT department_id 
    INTO id
    FROM departments
    WHERE department_id = p_department_id;
    
    SELECT SUM(salary)
    INTO sum_salary
    FROM employees
    WHERE department_id = p_department_id;
    
    RETURN sum_salary;    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('No se encontraron datos para ese id de departamento');
        RAISE_APPLICATION_ERROR(-20001, 'El departamento con id ' || p_department_id || ' no existe.');
        
END;
/

--Ejecutando función
DECLARE
    sum_salary NUMBER := 0;
BEGIN
    sum_salary := fn_sum_salary_by_department(90);
    dbms_output.put_line('La suma del salario es: ' || sum_salary);
END;
/

/* Ejemplo 02
******************************************************
Modificar el programa anterior para incluir un parámetro de tipo OUT por el que 
vaya el número de empleados afectados por la query. Debe ser visualizada en el 
programa que llama a la función. De esta forma vemos que se puede usar este tipo
de parámetros también en una función
*/
CREATE OR REPLACE FUNCTION fn_sum_salary_by_department_out(
    p_department_id departments.department_id%TYPE,
    p_affected_rows OUT NUMBER
)
RETURN NUMBER
AS
    sum_salary NUMBER := 0;
    id departments.department_id%TYPE;
BEGIN

    -- Comprobamos que el departamento existe, caso contrario arrojará la excepción en automático
    SELECT department_id 
    INTO id
    FROM departments
    WHERE department_id = p_department_id;
    
    SELECT SUM(salary), COUNT(salary)
    INTO sum_salary, p_affected_rows
    FROM employees
    WHERE department_id = p_department_id;
    
    RETURN NVL(sum_salary, 0);    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('No se encontraron datos para ese id de departamento');
        RAISE_APPLICATION_ERROR(-20001, 'El departamento con id ' || p_department_id || ' no existe.');
        
END;
/

--Ejecutando función
DECLARE
    sum_salary NUMBER;
    rows NUMBER;
BEGIN
    sum_salary := fn_sum_salary_by_department_out(100, rows);
    dbms_output.put_line('La suma del salario es: ' || sum_salary ||  ', en un total de ' || rows || ' registros.');
END;
/

/* Ejemplo 03
******************************************************
Crear una función llamada FN_CREATE_REGION:

- A la función se le debe pasar como parámetro un nombre de región y debe 
  devolver un número, que es el código de región que calculamos dentro de la función.
- Se debe crear una nueva fila con el nombre de esa REGION
- El código de la región se debe calcular de forma automática. Para ello se debe 
  averiguar cual es el código de región  más alto que tenemos en la tabla en ese 
  momento,  le sumamos 1 y el resultado lo ponemos como el código para la nueva
  región que estamos creando.
- Si tenemos algún problema debemos generar un error
- La función debe devolver el número que ha asignado a la región
*/
CREATE OR REPLACE FUNCTION fn_create_region(
    p_region_name regions.region_name%TYPE
)
RETURN NUMBER
AS
    max_id NUMBER;
    name regions.region_name%TYPE;
BEGIN

    SELECT region_name 
    INTO name
    FROM regions
    WHERE region_name = p_region_name;

    IF LENGTH(TRIM(name)) > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'La región ' || p_region_name || ' ya está registrado');
    END IF;

    SELECT MAX(region_id)
    INTO max_id
    FROM regions;
   
    max_id := max_id + 1;
   
    INSERT INTO regions(region_id, region_name)
    VALUES(max_id, p_region_name);
   
    COMMIT;
   
    RETURN max_id;
END;
/


--Ejecutando función
DECLARE
    region_id NUMBER;
BEGIN
    region_id := fn_create_region('CASMA');
    dbms_output.put_line('Nuevo id registrado: ' || region_id);
END;
/

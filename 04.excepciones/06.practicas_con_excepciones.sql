/***************************************************************************************************
Prácticas con excepciones
****************************************************************************************************
*/

SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
Crear una SELECT (no un cursor explícito) que devuelva el nombre de un empleado 
pasándole el EMPLOYEE_ID en el WHERE,  

- Comprobar en primer lugar que funciona pasando un empleado existente
- Pasar un empleado inexistente y comprobar que genera un error
- Crear una zona de EXCEPTION controlando el NO_DATA_FOUND para que pinte un 
  mensaje como “Empleado inexistente”
*/
DECLARE
    name employees.first_name%TYPE;
    id employees.employee_id%TYPE;
BEGIN
    --id := 100; -- sí existe
    id := 10; -- no existe
    
    
    SELECT first_name
    INTO name
    FROM employees
    WHERE employee_id = id;
    
    dbms_output.put_line('Empleado: ' || name);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('Empleado con id: ' || id || ' inexistente');
    WHEN OTHERS THEN
        dbms_output.put_line(SQLCODE);
        dbms_output.put_line(SQLERRM);
END;
/

/* Ejemplo 02
******************************************************
Modificar la SELECT para que devuelva más de un empleado, por ejemplo poniendo
EMPLOYEE_ID> 100. Debe generar un error. Controlar la excepción para que genere 
un mensaje como “Demasiados empleados en la consulta”
*/
DECLARE
    employee employees%ROWTYPE;
BEGIN 
    SELECT *
    INTO employee
    FROM employees
    WHERE employee_id > 100;
    
    dbms_output.put_line('Empleado: ' || employee.first_name);
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        dbms_output.put_line('Demasiados empleados en la consulta no pueden 
        asignarse a una variable de una sola fila');
    WHEN OTHERS THEN
        dbms_output.put_line(SQLCODE);
        dbms_output.put_line(SQLERRM);
END;
/


/* Ejemplo 03
******************************************************
Modificar la consulta para que devuelva un error de división por CERO, por ejemplo, 
vamos a devolver el salario en vez del nombre y lo dividimos por 0. En este caso, 
en vez de controlar la excepción directamente, creamos una sección WHEN OTHERS y 
pintamos el error con SQLCODE y SQLERR
*/
DECLARE
    salary employees.salary%TYPE;
BEGIN 
    SELECT salary
    INTO salary
    FROM employees
    WHERE employee_id = 100;
    
    salary := salary / 0;
    
    dbms_output.put_line('Salario: ' || salary);
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line(SQLCODE);
        dbms_output.put_line(SQLERRM);
END;
/

/* Ejemplo 04
******************************************************
El error -00001 es clave primaria duplicada. Aunque ya existe una predefinida 
(DUP_VAL_ON_INDEX) vamos a crear una excepción no -predefinida que haga lo mismo. 
- Vamos a usar la tabla REGIONS para hacerlo más fácil.
- Usamos PRAGMA EXCEPTION_INIT y creamos una excepción denominada “duplicado”. 
  Cuando se genere ese error debemos pintar “Clave duplicada, intente otra”. 
- Insertamos una fila en la tabla REGIONS que esté duplicada y vemos que se
  controla el error.
*/
SELECT *
FROM regions;

DECLARE
    DUPLICATED_VALUE EXCEPTION;
    PRAGMA EXCEPTION_INIT(DUPLICATED_VALUE, -1);
BEGIN
    INSERT INTO regions(region_id, region_name)
    VALUES(1, 'Perú');
EXCEPTION
    WHEN DUPLICATED_VALUE THEN
        dbms_output.put_line('Clave duplicada, intente otra');
    WHEN OTHERS THEN
        dbms_output.put_line('Ocurrió un error en PLSQL');    
END;
/


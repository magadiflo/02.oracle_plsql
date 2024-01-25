/***************************************************************************************************
Atributo %ROWTYPE
****************************************************************************************************
Con el atributo %ROWTYPE le decimos que la variable a la que tipamos tome el número de columnas
que tiene la tabla a la que hacemos referencia. Por ejemplo:

    employee employees%ROWTYPE;

En el caso anterior, vemos que a la variable employee le definimos el atributo %ROWTYPE, eso significa
que la variable employee contendrá la misma estructura que la tabla employees.
*/
SET SERVEROUTPUT ON;

/* Ejemplo 01
*******************************************************/

DECLARE
    employee employees%ROWTYPE;
BEGIN
    SELECT *
    INTO employee
    FROM employees
    WHERE employee_id = 100;

    dbms_output.put_line('Salario: ' || employee.salary);
    dbms_output.put_line('Nombre: ' || employee.first_name);
    dbms_output.put_line('Apellido: ' || employee.last_name);
    dbms_output.put_line('Correo: ' || employee.email);
END;
/
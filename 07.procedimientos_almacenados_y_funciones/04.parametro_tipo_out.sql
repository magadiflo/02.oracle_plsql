/***************************************************************************************************
Parámetro tipo OUT
****************************************************************************************************
- Un parámetro tipo OUT permite devolver un valor desde dentro del procedimiento.
- Los parámetros de tipo OUT asignan un espacio de memoria que serán visibles desde donde
  se llama el procedimiento almacenado, es decir, no necesitamos usar un return para retornar
  el valor en el parámetro del tipo OUT, ya que podemos acceder a su dirección de memoria
  directamente desde afuera del procedimiento almacenado.
*/

SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
*/
CREATE OR REPLACE PROCEDURE sp_calculate_tax_out(
    p_id IN employees.employee_id%TYPE,
    p_tax NUMBER,
    p_result OUT NUMBER -- Este parámetro es del tipo OUT.
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
    
    /*
    Asignamos el valor al parámetro de tipo OUT. Esta variable 
    podrá ser accedida desde afuera de este procedimiento almacenado.
    */
    p_result := salary * p_tax/100; 
    
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
    result NUMBER;
BEGIN
    id := 100;
    tax := 20;
    
    sp_calculate_tax_out(id, tax, result);    
    /*
    El tercer parámetro que le asignamos a la llamada del procedimiento anterior
    fue "result", esta variable, dentro del procedimiento almacenado es el 
    p_result que es del tipo OUT, eso significa que luego de ejecutado el SP,
    podemos acceder al valor que obtuvo el p_result desde afuera del procedimiento
    almacenado, a través de la variable "result".
    */
    dbms_output.put_line('resultado: ' || result);
END;
/
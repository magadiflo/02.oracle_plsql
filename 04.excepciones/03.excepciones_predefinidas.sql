/***************************************************************************************************
Excepciones predefinidas
****************************************************************************************************

A continuación se muestran algunas excepciones propias de Oracle:

NO_DATA_FOUND        -> ORA-01403
TOO_MANY_ROWS        -> ORA-01422
ZERO_DIVIDE          -> ORA-01476
DUP_VAL_ON_INDEX     -> ORA-00001


Los errores en Oracle está definidos como negativos (-), por ejemplo en el 
NO_DATA_FOUND tiene el valor -1403.
*/

SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
*/
DECLARE
    employee employees%ROWTYPE;
BEGIN
    SELECT * 
    INTO employee
    FROM employees
    WHERE employee_id > 1;
    
    dbms_output.put_line(employee.first_name);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('El empleado buscado no existe');
    WHEN TOO_MANY_ROWS THEN
        dbms_output.put_line('Se devolvieron más de un registro');
    WHEN OTHERS THEN
        dbms_output.put_line('Ocurrió un error al procesar bloque plsql');
END;
/
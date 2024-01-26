/***************************************************************************************************
SQLCODE y SQLERRM
****************************************************************************************************
Existen dos funcioens integradas dentro de PLSQL para la gestión de excepciones:

SQLCODE, muestra el código de error producido.
SQLERRM, muestra el mensaje de error producido.
*/

SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
En el ejemplo siguiente provocaremos una excepción dentro del bloque BEGIN. 
Al producirse la excepción pasaremos al bloque EXCEPTION e imprimiremos lo
siguiente: 

    SQLCODE: -1422
    SQLERRM: ORA-01422: exact fetch returns more than requested number of rows
*/

DECLARE
    employee employees%ROWTYPE;
BEGIN
    SELECT * 
    INTO employee
    FROM employees;
    
    dbms_output.put_line(employee.salary);
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line(SQLCODE);
        dbms_output.put_line(SQLERRM);
END;
/

/* Ejemplo 02
******************************************************
Crear una tabla errors donde iremos guardando los errores que se vayan produciendo.

Si queremos usar las funciones SQLCODE y SQLERRM dentro de una instrucción 
SQL como un INSERT INTO..., necesitamos asignarlos a variables, y luego usar
dichas variables dentro de las instrucciones SQL, ya que, si usamos directamente
el SQLCODE y el SQLERRM directamebte en las instrucciones SQL, ORACLE nos 
mostrará un error.
*/

-- Preparando escenario
CREATE TABLE errors(
    code NUMBER,
    message VARCHAR2(100),
    create_at DATE
);

SELECT code, message, TO_CHAR(create_at, 'dd-MM-yyyy HH:MI:SS') 
FROM errors;

-- Creando bloque PLSQL
DECLARE
    employee employees%ROWTYPE;
    code NUMBER;
    message VARCHAR2(100);
BEGIN
    SELECT * 
    INTO employee
    FROM employees;
    
    dbms_output.put_line(employee.salary);
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line(SQLCODE);
        dbms_output.put_line(SQLERRM);
        dbms_output.put_line(SYSDATE);        
        /*
            Importante asignalos a variables para poder usarlos en sentencias 
            SQL como el INSERT INTO... pues si usamos directamente el SQLCODE 
            y el SQLERRM dentro de las sentencias SQL, oracle nos mostrará un
            error.
        */
        code := SQLCODE;
        message := SQLERRM;
        
        INSERT INTO errors(code, message, create_at)
        VALUES(code, message, SYSDATE);
        
        COMMIT;        
END;
/
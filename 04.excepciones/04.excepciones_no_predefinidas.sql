/***************************************************************************************************
Excepciones no predefinidas
****************************************************************************************************
Cuando hablamos de excepciones no predefinidas no estamos hablamos de excepciones 
de usuarios (excepciones personalizadas), sino más bien, son excepciones de ORACLE, 
que como no están predefinidas nosotros las queremos manipular, pero siguen siendo 
excepciones de ORACLE.

Recordar que todos los errores de ORACLE son números negativos, menos el 100.
*/

SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
Para este ejemplo, vamos a usar la excepción no predefinida que surge cuando 
se usan funciones de agregación (SUM(), COUNT(), AVG(), ETC.) que en ORACLE
está definida como:

    ORA-00937 not a single-group group function
    
Para definir la excepción no personalizada debemos crear un objeto del tipo 
EXCEPTION, en nuestro caso crearemos el objeto al que le llamaremos EXCEPTION_GROUP.

A continuación debemos usar la siguiente cláusula: 
    PRAGMA EXCEPTION_INIT(nombre_de_la_excepción, código_de_la_excepción);
    
PRAGMA, es una especie de orden al compilador de PLSQL, es decir, es como si le
dijera: "Oye, siempre que aparezca el código_de_la_excepción, sustitúyelo por
el nombre_de_la_excepción".

En nuestro ejemplo, al usar PRAGMA con el EXCEPTION_INIT, estamos asociando el
EXCEPTION_GROUP con el código -937, lo que significa que cuando ocurra la 
excepción de ORACLE cón código -937, podremos usar nuestra variable de excepción
EXCEPTION_GROUP en el bloque EXCEPTION.
*/
DECLARE
    EXCEPTION_GROUP EXCEPTION;
    PRAGMA EXCEPTION_INIT(EXCEPTION_GROUP, -937);
    id employees.employee_id%TYPE;
    salary_sum NUMBER;
BEGIN
    SELECT employee_id, SUM(salary)
    INTO id, salary_sum
    FROM employees;
    
    dbms_output.put_line(id);
EXCEPTION
    WHEN EXCEPTION_GROUP THEN
        dbms_output.put_line('Función de grupo incorrecto');
    WHEN OTHERS THEN
        dbms_output.put_line('No se pudo procesar el bloque plsql');
END;
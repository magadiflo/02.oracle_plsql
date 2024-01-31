/***************************************************************************************************
Usar funciones de un paquete en comandos SQL
****************************************************************************************************
*/

SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
*/
CREATE OR REPLACE PACKAGE package_transform
AS
    FUNCTION fn_transform_text(name VARCHAR2, conversion_type CHAR) RETURN VARCHAR2;
END;
/

CREATE OR REPLACE PACKAGE BODY package_transform
AS
    FUNCTION upper_text(
        name VARCHAR2
    )
    RETURN VARCHAR2
    AS
    BEGIN
        RETURN UPPER(name);
    END upper_text;
    
    FUNCTION lower_text(
        name VARCHAR2
    )
    RETURN VARCHAR2
    AS
    BEGIN
        RETURN LOWER(name);
    END lower_text;
    
    FUNCTION fn_transform_text(
        name VARCHAR2,
        conversion_type CHAR
    )
    RETURN VARCHAR2
    AS
    BEGIN
        IF conversion_type = 'U' THEN
            RETURN upper_text(name);
        ELSIF conversion_type = 'L' THEN
            RETURN lower_text(name);
        ELSE
            RAISE_APPLICATION_ERROR(-20001, 'La función fn_transform_text solo acepta valores U o L');
        END IF;
    END fn_transform_text;
END package_transform;
/

-- Usando función del paquete dentro de una query SQL
SELECT package_transform.fn_transform_text(first_name, 'L') AS first_name,
        package_transform.fn_transform_text(last_name, 'U') AS last_name
FROM employees;

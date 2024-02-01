/***************************************************************************************************
Prácticas con paquete
****************************************************************************************************
*/

SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
Crear un paquete denominado package_regions que tenga los siguientes componentes:
PROCEDIMIENTOS:
    - ALTA_REGION, con parámetro de código y nombre Región. Debe devolver un error 
        si la región ya existe. Inserta una nueva región en la tabla. Debe llamar 
        a la función EXISTE_REGION para controlarlo.
    - BAJA_REGION, con parámetro de código de región y que debe borrar una región. 
        Debe generar un error si la región no existe, Debe llamar a la 
        función EXISTE_REGION para controlarlo.
    - MOD_REGION: se le pasa un código y el nuevo nombre de la región Debe modificar 
        el nombre de una región ya existente. Debe generar un error si la región 
        no existe, Debe llamar a la función EXISTE_REGION para controlarlo.

 FUNCIONES
    - CON_REGION. Se le pasa un código de región y devuelve el nombre.
    - EXISTE_REGION. Devuelve verdadero si la región existe. Se usa en los 
        procedimientos y por tanto es PRIVADA, no debe aparecer en la especificación 
        del paquete.
*/
CREATE OR REPLACE PACKAGE package_regions
AS
    PROCEDURE sp_create_region(p_region_id NUMBER, p_region_name VARCHAR2);
    PROCEDURE sp_delete_region(p_region_id NUMBER);
    PROCEDURE sp_update_region(p_region_id NUMBER, p_region_new_name VARCHAR2);
    FUNCTION fn_with_region(p_region_id NUMBER) RETURN VARCHAR2;
END package_regions;
/

CREATE OR REPLACE PACKAGE BODY package_regions
AS
    FUNCTION fn_region_exist(
        p_region_id NUMBER
    )
    RETURN BOOLEAN
    AS
        result NUMBER;
    BEGIN
        SELECT COUNT(*) 
        INTO result
        FROM regions
        WHERE region_id = p_region_id;
        
        IF result > 0 THEN
            RETURN TRUE;
        END IF;
        
        RETURN FALSE;
    END fn_region_exist;
    
    FUNCTION fn_region_exist(
        p_region_name VARCHAR2
    )
    RETURN BOOLEAN
    AS
        result NUMBER;
    BEGIN
        SELECT COUNT(*) 
        INTO result
        FROM regions
        WHERE LOWER(region_name) = LOWER(TRIM(p_region_name));
        
        IF result > 0 THEN
            RETURN TRUE;
        END IF;
        
        RETURN FALSE;
    END fn_region_exist;
   
    FUNCTION fn_with_region(
        p_region_id NUMBER
    ) 
    RETURN VARCHAR2
    AS
        name VARCHAR2(100);
    BEGIN
        SELECT region_name
        INTO name
        FROM regions
        WHERE region_id = p_region_id;
        
        RETURN name;
    END fn_with_region;
    
    PROCEDURE sp_create_region(
        p_region_id NUMBER, 
        p_region_name VARCHAR2
    )
    AS
    BEGIN
        IF fn_region_exist(p_region_id) OR fn_region_exist(p_region_name) THEN
            RAISE_APPLICATION_ERROR(-20001, 'El id o nombre de la región ya existe');
        END IF;
        
        INSERT INTO regions(region_id, region_name)
        VALUES(p_region_id, p_region_name);
        
        COMMIT;
    END sp_create_region;
    
    PROCEDURE sp_delete_region(
        p_region_id NUMBER
    )
    AS
    BEGIN
        IF NOT fn_region_exist(p_region_id) THEN
            RAISE_APPLICATION_ERROR(-20001, 'La región no existe');
        END IF;
        
        DELETE FROM regions WHERE region_id = p_region_id;
        COMMIT;
    END sp_delete_region;
    
    PROCEDURE sp_update_region(
        p_region_id NUMBER, 
        p_region_new_name VARCHAR2
    )
    AS
    BEGIN
        IF NOT fn_region_exist(p_region_id) THEN
            RAISE_APPLICATION_ERROR(-20001, 'La región no existe');
        END IF;
        
        UPDATE regions
        SET region_name = p_region_new_name
        WHERE region_id = p_region_id;
        
        COMMIT;
    END sp_update_region;
END package_regions;
/

-- Probando package
DECLARE
    current_id NUMBER;
BEGIN
    SELECT MAX(region_id)
    INTO current_id
    FROM regions;
    
    --package_regions.sp_create_region(current_id + 1, 'MI-REGION');
    --package_regions.sp_update_region(5, 'ASGARD');  
    package_regions.sp_delete_region(5);
END;
/

SELECT * FROM regions;

/* Ejemplo 02
******************************************************
Crear un paquete denominado NOMINA que tenga sobrecargado la función CALCULAR_NOMINA 
de la siguiente forma:

- CALCULAR_NOMINA(NUMBER): se calcula el salario del empleado restando un 15% de IRPF.
- CALCULAR_NOMINA(NUMBER,NUMBER): el segundo parámetro es el porcentaje a aplicar. 
    Se calcula el salario del empleado restando ese porcentaje al salario.
- CALCULAR_NOMINA(NUMBER,NUMBER,CHAR): el segundo parámetro es el porcentaje a aplicar, 
    el tercero vale ‘V’ . Se calcula el salario del empleado aumentando la comisión
    que le pertenece y restando ese porcentaje al salario siempre y cuando el empleado
    tenga comisión.
*/
CREATE OR REPLACE PACKAGE package_salaries
AS
    FUNCTION fn_calculate_salary(p_employee_id NUMBER) RETURN NUMBER;
    FUNCTION fn_calculate_salary(p_employee_id NUMBER, p_percent VARCHAR2) RETURN NUMBER;
    FUNCTION fn_calculate_salary(p_employee_id NUMBER, p_percent NUMBER, aux CHAR := 'V') RETURN NUMBER;
END package_salaries;
/

CREATE OR REPLACE PACKAGE BODY package_salaries
AS
    FUNCTION fn_calculate_salary(
        p_employee_id NUMBER
    ) 
    RETURN NUMBER
    AS
        salary_proccesed NUMBER;
    BEGIN
        SELECT salary
        INTO salary_proccesed 
        FROM employees 
        WHERE employee_id = p_employee_id;
        
        RETURN salary_proccesed * 0.85;
    END fn_calculate_salary;
    
    FUNCTION fn_calculate_salary(
        p_employee_id NUMBER, 
        p_percent VARCHAR2
    ) 
    RETURN NUMBER
    AS
        salary_proccesed NUMBER;
    BEGIN
        SELECT salary
        INTO salary_proccesed 
        FROM employees 
        WHERE employee_id = p_employee_id;
        
        RETURN salary_proccesed * (1 - TO_NUMBER(p_percent)/100);
    END fn_calculate_salary;
    
    FUNCTION fn_calculate_salary(
        p_employee_id NUMBER, 
        p_percent NUMBER, 
        aux CHAR := 'V'
    ) 
    RETURN NUMBER
    AS
        salary_proccesed NUMBER;
    BEGIN
        SELECT CASE
                    WHEN commission_pct IS NULL THEN salary
                    ELSE salary * (1 - p_percent/100) + (salary * commission_pct)
                END
        INTO salary_proccesed
        FROM employees
        WHERE employee_id = p_employee_id;
        
        RETURN salary_proccesed;
    END fn_calculate_salary;
    
END package_salaries;
/

-- Probando package
SELECT * FROM employees;

DECLARE
    salary NUMBER;
BEGIN
    salary := package_salaries.fn_calculate_salary(100);
    dbms_output.put_line(salary);
    
    salary := package_salaries.fn_calculate_salary(100, '90');
    dbms_output.put_line(salary);
    
    salary := package_salaries.fn_calculate_salary(100, 10, 'V');
    dbms_output.put_line(salary);
END;

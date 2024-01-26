/***************************************************************************************************
Excepciones personalizadas
****************************************************************************************************
Son excepciones desarrolladas por el propio usuario. Para lanzar una excepción se
usa la cláusula RAISE.

RAISE, es una cláusula que se usa en excepciones personalizadas y nos permite 
lanzarlas. Cuando RAISE lanza la excepción personalizada, esta se dirige al 
bloque EXCEPTION donde debemos capturarlo.

Cuando tenemos una excepción personalizada ORACLE no sabe en qué momento lanzar
la excepción, así que nosotros somos los responsables de indicarle explícitamente
cuándo debe lanzarse, y eso se hace con la cláusula RAISE.

Pasos para trabajar con excepciones personalizadas:

PASO 1. Declarar la excepción.
PASO 2. Determinar en qué momento debe lanzarse la excepción.
PASO 3. Capturar la excepción.
*/

SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
En este ejemplo no podemos insertar id en la tabla regions mayores a 100, así 
que debemos controlar dicha operación.
*/
DECLARE
    LIMIT_REGION_ID EXCEPTION;                          -- PASO 1
    name regions.region_name%TYPE;
    id regions.region_id%TYPE;
BEGIN
    id := 101;
    name := 'Oceanía';
    
    IF id > 100 THEN
        RAISE LIMIT_REGION_ID;                          -- PASO 2
    ELSE
        INSERT INTO regions(region_id, region_name)
        VALUES(id, name);
        
        COMMIT;
    END IF;
EXCEPTION
    WHEN LIMIT_REGION_ID THEN                           -- PASO 3
        dbms_output.put_line('La región no puede tener un id mayor a 100');
    WHEN OTHERS THEN
        dbms_output.put_line('Error no definido');
END;
/

SELECT * 
FROM regions;

DELETE FROM regions WHERE region_id = 100;
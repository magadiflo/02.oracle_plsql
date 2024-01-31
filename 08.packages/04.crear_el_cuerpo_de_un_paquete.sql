/***************************************************************************************************
Crear el cuerpo de un paquete
****************************************************************************************************
*/

SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
- Crearemos el Spec y Body del packete package_conversion.
- Recordar que tanto el Spec como el Body se crean de manera separada. Es decir,
  los podríamos haber creado en archivos separados o como en este caso, en el
  mismo archivo separados por la barra inclinada (/).
*/
-- 1. Spec ---------------------------------------------------------------------
CREATE OR REPLACE PACKAGE package_conversion
AS
    -- Declaramos la firma del store procedure sp_convertion
    PROCEDURE sp_conversion(name VARCHAR2, conversion_type CHAR);
END;
/

-- 2. Body ---------------------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY package_conversion
AS
    /* 
    -  Creando funciones que serán usadas en la implementación del Store Procedure.
       Recordar que estas funciones como no fueron declaradas ene l Spec, serán 
       privadas, es decir, solo estarán disponibles dentro del body de este package.
       
    -  Como el sp_conversion usará funciones privadas para realizar su trabajo,estas
       funciones deben ser creadas antes de que el sp_conversion sea creada, sino 
       cuando se trate de compilar el body, oracle marcará un error diciendo que 
       no encuentra las funciones que el sp_conversion está usando.
    */
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
    
    -- Implementamos el store procedure declarado en el spec
    PROCEDURE sp_conversion(
        name VARCHAR2,
        conversion_type CHAR
    )
    AS
    BEGIN
        IF conversion_type = 'U' THEN
            dbms_output.put_line(upper_text(name));
        ELSIF conversion_type = 'L' THEN
            dbms_output.put_line(lower_text(name));
        ELSE
            dbms_output.put_line('El parámetro debe ser U o L');
        END IF;
    END sp_conversion;
END package_conversion;
/

-- Usando paquete
BEGIN
    package_conversion.sp_conversion('mARtín', 'L');
    package_conversion.sp_conversion('mARtín', 'U');
END;
/

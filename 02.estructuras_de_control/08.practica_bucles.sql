/***************************************************************************************************
Práctica de bucles
****************************************************************************************************
*/
SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************.
Vamos a crear la tabla de multiplicar del 1 al 10, con los tres tipos de bucles:
LOOP, WHILE y FOR
*/
DECLARE
    a NUMBER;
    b NUMBER;    
    product NUMBER;
BEGIN
    a := 1;
    
    <<table_parent>>
    LOOP
        dbms_output.put_line('Tabla del ' || a);
        dbms_output.put_line('-----------');
        
        b := 0;
        <<secuence_child>>
        LOOP
            b := b + 1;
            product := a * b;            
            
            dbms_output.put_line(a || 'x' || b || '=' || product);
            
            EXIT secuence_child WHEN b = 12;
        END LOOP secuence_child;
        
        a := a + 1;
        
        EXIT table_parent WHEN a = 11;
    END LOOP table_parent;
END;
/

/* Ejemplo 02
******************************************************.
Crear una variable llamada TEXTO de tipo VARCHAR2(100).
Poner alguna frase.
Mediante un bucle, escribir la frase al revés, Usamos el bucle WHILE
*/
DECLARE
    my_text VARCHAR2(100);
    count_number NUMBER;
    reverse_text my_text%TYPE;
BEGIN
    my_text := 'Ingeniería de Sistemas e Informática';
    count_number := LENGTH(my_text);
    dbms_output.put_line( 'Original: ' || my_text);

    WHILE count_number > 0 LOOP
        reverse_text := reverse_text || SUBSTR(my_text, count_number, 1);
        count_number := count_number - 1;
    END LOOP;
    
    dbms_output.put_line( 'Reverso.: ' || reverse_text);
END;
/


/* Ejemplo 03
******************************************************.
Usando la práctica anterior, si en el texto aparece el carácter "x" debe salir 
del bucle. Es igual en mayúsculas o minúsculas.
Debemos usar la cláusula EXIT.
*/
DECLARE
    my_text VARCHAR2(100);
    count_number NUMBER;
    reverse_text my_text%TYPE;
    cad_text VARCHAR2(1);
BEGIN
    my_text := 'eXamen';
    count_number := LENGTH(my_text);
    dbms_output.put_line( 'Original: ' || my_text);

    WHILE count_number > 0 LOOP
        cad_text := SUBSTR(my_text, count_number, 1);
        
        EXIT WHEN LOWER(cad_text) = 'x';
        
        reverse_text := reverse_text || cad_text;
        count_number := count_number - 1;
    END LOOP;
    
    dbms_output.put_line( 'Reverso.: ' || reverse_text);
END;
/


/* Ejemplo 04
******************************************************.
Debemos crear una variable llamada NOMBRE
Debemos pintar tantos asteriscos como letras tenga el nombre. Usamos un bucle FOR
Por ejemplo  Alberto --> *******
*/
DECLARE
    name VARCHAR2(50) := 'Martín';
    concat_text name%TYPE;
BEGIN
    dbms_output.put_line('Name: ' || name);
    dbms_output.put_line('N° de asteriscos a pintar: ' || LENGTH(name));
    
    FOR i IN 1..LENGTH(name) LOOP
        concat_text := concat_text || '*';        
    END LOOP;
    
    dbms_output.put_line(name || ': ' || concat_text);
END;
/

/***************************************************************************************************
Atributos implícitos
****************************************************************************************************

> SQL%ISOPEN, como un atributo implícito siempre nos devolverá "false", ya que el cursor es manejado
  por debajo, de manera transparence se abrirá y al final siempre estará cerrado, mientras que si 
  hablamos de un cursor explícito, aquí si nos servirá este atributo.
  
> SQL%FOUND

> SQL%NOTFOUND

> SQL%ROWCOUNT

- SQL, es el nombre que se le pone a los cursores implícitos.
- Estos atributos implícitos lo podemos consultar justo cuando hemos ejecutado el 
  cursor.
- Los atributos SQL%FOUND, SQL%NOTFOUND solo están disponibles para las sentencias:
  INSERT, UPDATE y DELETE. Para la sentencia SELECT no están disponibles, ya que
  si el SELECT no encuentra cierta fila, lanzará una EXCEPTION de NOT_FOUND.
  
*/

SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
En el ejemplo siguiente vemos que el UPDATE ..... WHERE id = 1; es un cursor
implícito, es decir, ORACLE por debajo abrirá un cursor, ejecutará, etc.. hasta
el punto donde nos retorna el control del script, por eso es que se le llama
cursor implícito.

Justo cuando hemos ejecutado el cursor implícito (en eset caso el UPDATE) los
atributos que mencionamos al inicio serán rellenados, así que podemos ver sus
valores si los imprimimos justo a continuación de la ejecución del cursor 
implícito:
*/
BEGIN
    UPDATE test 
    SET name = 'probando'
    WHERE id = 1;
    
    dbms_output.put_line(SQL%ROWCOUNT);
    --Como el dbms_output.put_line() no admite booleanos, usaremos un if para ver los otros atributos.
    IF SQL%FOUND THEN
        dbms_output.put_line('Encontrado!');
    ELSIF SQL%NOTFOUND THEN
        dbms_output.put_line('Registro no encontrado!');
    END IF;
END;
/

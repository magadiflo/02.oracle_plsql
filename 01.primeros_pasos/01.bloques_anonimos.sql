/***************************************************************************************************
Bloques anónimos
****************************************************************************************************
El objeto básico de PL/SQL es un bloque.
Los bloques están divididos en las siguientes secciones:

DECLARE
BEGIN       (Obligatorio) Inicia el bloque
EXCEPTION
END;        (Obligatorio) Indica el fin del bloque. Debe terminar en ; para 
             indicare a PL/SQL que se ha terminado ese trozo de código.


Para crear un bloque, en este caso un bloque anónimo, solo son obligatorios tener
definidas las cláusulas BEGIN y END;
*/

/* Ejemplo 01
******************************************************
- Entre el BEGIN y END colocaremos todos los comandos PL/SQL que estemos creando.
- Un bloque PL/SQL no puede estar vacío, al menos debe haber un comando.
- El NULL, que le colocamos dentro nos servirá para poder ejecutar el bloque 
  sin que tenga contenido, de esa manera no nos mostrará error.
*/

BEGIN
    NULL;
END;
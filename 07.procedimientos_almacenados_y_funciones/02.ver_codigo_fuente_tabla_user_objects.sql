/***************************************************************************************************
Ver el código fuente de procedimientos y funciones
****************************************************************************************************
user_objects, contiene todas las tablas, vistas, procedimientos, etc.
*/

SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
*/
SELECT * 
FROM user_objects
WHERE object_type = 'PROCEDURE';

/* Ejemplo 02
******************************************************
Ver cantidad de objetos
*/
SELECT object_type, COUNT(*) AS total
FROM user_objects
GROUP BY object_type;

/* Ejemplo 03
******************************************************
Ver código fuente
*/
SELECT *
FROM user_source
WHERE name = 'SP_PRINT_VALUE';
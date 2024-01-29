/***************************************************************************************************
Colecciones y tipos compuestos
****************************************************************************************************
Son componentes que pueden albergar múltiples valores, a diferencia de los escalares que solo pueden
tener 1.

Son de dos posibles tipos:

1. RECORDS
2. COLLECTIONS
    - Array asociativo (index by)
    - Nested tables
    - Varrays
    
1. PL/SQL RECORDS
-----------------
- Son similares a los registros de una tabla.
- Pueden albergar una "fila" de datos de distintos tipos.
- Ya hemos visto un ejemplo al usar el atributo %ROWTYPE: 
    employee employees%ROWTYPE;
- Podemos definirlos de forma personalizada con la cláusula RECORD. 
  ¿Como lo hacemos?
    a. Primero debemos declarar o crear el tipo. Su formato es el siguiente:
        TYPE nombre_del_record IS RECORD(campo1, campo2, campo3,...);
    b. Una vez declarado el tipo (plantilla) podemos crear variables de ese tipo
        variable nombre_del_record;
    c. Los campos pueden ser de cualquier tipo, incluido otros RECORDS o COLLECTIONS.
    d. Pueden llevar cláusula NULL y cláusula DEFAULT.
    
> Ejemplo:
    a. Creando el record:
        TYPE employee IS RECORD(
            name VARCHAR2(200),
            salary NUMBER,
            hire_date employees.hire_date%TYPE,
            full_data employees%ROWTYPE
        );
    b. Usando record:
        employee1 employee;
*/
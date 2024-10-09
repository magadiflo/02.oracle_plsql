/***************************************************************************************************
Pr�ctica de colecciones y records
****************************************************************************************************
*/
SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
Creamos un TYPE RECORD que tenga las siguientes columnas

    NAME VARCHAR2(100),
    SAL EMPLOYEES.SALARY%TYPE,
    COD_DEPT EMPLOYEES.DEPARTMENT_ID%TYPE);

- Creamos un TYPE TABLE basado en el RECORD anterior.
- Mediante un bucle cargamos en la colecci�n los empleados. El campo NAME 
  debe contener FIRST_NAME y LAST_NAME concatenado.
- Para cargar las filas y siguiendo un ejemplo parecido que hemos visto en el 
  v�deo usamos el EMPLOYEE_ID que va de 100 a 206.
- A partir de este momento y ya con la colecci�n cargada, hacemos las siguientes 
  operaciones, usando m�todos de la colecci�n.

    Visualizamos toda la colecci�n
    Visualizamos el primer empleado
    Visualizamos el �ltimo empleado
    Visualizamos el n�mero de empleados
    Borramos los empleados que ganan menos de 7000 y visualizamos de nuevo la colecci�n
    Volvemos a visualizar el n�mero de empleados para ver cuantos se han borrado
*/
DECLARE
    TYPE employee_r IS RECORD(
        name VARCHAR2(100),
        salary employees.salary%TYPE,
        cod_department employees.department_id%TYPE
    );
    
    TYPE employees_t IS TABLE OF
    employee_r
    INDEX BY PLS_INTEGER;
    
    employees_array employees_t;
    count_employees NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO count_employees
    FROM employees;
    
    IF count_employees > 0 THEN
        FOR i IN 1..count_employees LOOP
            SELECT first_name || ' ' || last_name, salary, department_id
            INTO employees_array(i).name, employees_array(i).salary, employees_array(i).cod_department
            FROM employees
            WHERE employee_id = i + 99;
        END LOOP;
        
        dbms_output.put_line('Usando m�todos de colecci�n');
        dbms_output.put_line('Visualizamos toda la colecci�n');
        dbms_output.put_line('-----------------------------------------------');
        FOR i IN employees_array.first..employees_array.last LOOP
            dbms_output.put_line(employees_array(i).name || ', ' || employees_array(i).salary || ' ' || employees_array(i).cod_department);
        END LOOP;
        
        dbms_output.put_line('-----------------------------------------------');
        dbms_output.put_line('Visualizamos el primer empleado');
        dbms_output.put_line('-----------------------------------------------');
        dbms_output.put_line(employees_array(employees_array.first).name || ', ' || employees_array(employees_array.first).salary || ' ' || employees_array(employees_array.first).cod_department);
        
        dbms_output.put_line('-----------------------------------------------');
        dbms_output.put_line('Visualizamos el �ltimo empleado');
        dbms_output.put_line('-----------------------------------------------');
        dbms_output.put_line(employees_array(employees_array.last).name || ', ' || employees_array(employees_array.last).salary || ' ' || employees_array(employees_array.last).cod_department);
        
        dbms_output.put_line('-----------------------------------------------');
        dbms_output.put_line('N�mero de empleados: ' || employees_array.count);
        dbms_output.put_line('-----------------------------------------------');
        
        dbms_output.put_line('-----------------------------------------------');
        dbms_output.put_line('Borrando empleados que ganan menos de 7000');
        dbms_output.put_line('-----------------------------------------------');
        FOR i IN employees_array.first..employees_array.last LOOP
            IF employees_array(i).salary < 7000 THEN
                dbms_output.put_line(employees_array(i).name || ' eliminado!');
                employees_array.delete(i);
            END IF;
        END LOOP;
        dbms_output.put_line('----------------------------------------');
        dbms_output.put_line('Número de empleados luego de la eliminación: ' || employees_array.count);     --47
        dbms_output.put_line('first: ' || employees_array.first);                                           --1
        dbms_output.put_line('last: ' || employees_array.last);                                             --107
        dbms_output.put_line('----------------------------------------');

        employees_array.delete(1);
        employees_array.delete(107);
        
        dbms_output.put_line('----------------------------------------');
        dbms_output.put_line('Número de empleados luego de la eliminación: ' || employees_array.count);     --45
        dbms_output.put_line('first: ' || employees_array.first);                                           --2
        dbms_output.put_line('last: ' || employees_array.last);                                             --106
        dbms_output.put_line('----------------------------------------');

    END IF;
    
    dbms_output.put_line('Fin del bloque');
END;
/

/*
Observemos en el resultado anterior que luego de la eliminación el count 
nos dice que quedan 47 elemntos, pero eso no lo vemos reflejado en el valor
del last, el cual nos da 107 (número de elementos antes de la eliminación), 
mientras que el first nos va 1. Este comportamiento es muy importante aclararlo.

1. Uso de employees_array.delete(i): Estás eliminando empleados con salario inferior a 7000 dentro del ciclo. 
   Esto es correcto, pero ten en cuenta que al borrar un elemento de un arreglo en PL/SQL, podría crear huecos 
   en los índices del arreglo, lo que puede afectar el ciclo en el que recorres los elementos. Si tienes huecos, 
   employees_array.first y employees_array.last pueden no representar el rango completo de índices.

2. Impresión de los valores después de la eliminación: Estás imprimiendo el first y last del arreglo después de
   haber eliminado elementos. Esto podría generar confusión, ya que no representará la posición real 
   de los elementos si hay huecos.

El comportamiento que observas está relacionado con cómo PL/SQL maneja los arreglos asociativos cuando
 se eliminan elementos, especialmente en lo que respecta a los índices de los primeros y últimos elementos (first y last).

1. employees_array.count: Este te está mostrando correctamente el número total de elementos que quedan en el arreglo, 
   que son 47. Esto refleja que 47 registros siguen existiendo en el arreglo después de las eliminaciones.

2. employees_array.first y employees_array.last: Aunque hayas eliminado algunos elementos intermedios en el arreglo,
   el first y el last aún reflejan los índices originales de los elementos. Esto significa que el primer elemento
   sigue estando en la posición 1 (el índice más bajo que no ha sido eliminado), y el último elemento sigue teniendo el
   índice 107 (el índice más alto que tampoco ha sido eliminado).

PL/SQL no reorganiza los índices automáticamente cuando se elimina un elemento en un arreglo asociativo. Por lo tanto, 
aunque hayas eliminado varios elementos intermedios, los índices en los extremos (first y last) siguen siendo los mismos
mientras queden elementos en esos índices.

¿Qué significa esto?

- employees_array.count: te está diciendo cuántos elementos quedan, pero no reorganiza los índices.
- employees_array.first y employees_array.last: siguen representando el primer y último índice que 
  aún existen en el arreglo.

Los arreglos asociativos en PL/SQL sigue ciertas reglas al eliminar elementos:

1. Cuando eliminas first o last: Si eliminas explícitamente el primer o el último índice del arreglo asociativo 
   (usando employees_array.delete(employees_array.first) o employees_array.delete(employees_array.last)), PL/SQL ajusta esos valores. 
   Es decir, el siguiente índice disponible se convierte en el nuevo first o last. Por ejemplo, si first era 1 y lo eliminas, 
   entonces el nuevo first será el próximo índice más bajo que no haya sido eliminado.

2. Cuando eliminas elementos entre first y last: Si eliminas un elemento que está entre esos dos extremos 
   (es decir, no es ni first ni last), PL/SQL no ajusta automáticamente los valores de first o last. Los índices originales se mantienen, 
   aunque el contenido del arreglo en esos índices haya sido eliminado. Los índices intermedios que quedan vacíos simplemente existen sin datos, 
   pero siguen siendo parte del rango.

Ejemplo:
Supón que tienes un arreglo con índices del 1 al 5, con los siguientes elementos:

employees_array(1) = 'A'
employees_array(2) = 'B'
employees_array(3) = 'C'
employees_array(4) = 'D'
employees_array(5) = 'E'

- Si eliminas employees_array(1) (el primer índice), el nuevo first será 2, porque es el siguiente índice que tiene un valor.
- Si eliminas employees_array(5) (el último índice), el nuevo last será 4, porque es el último índice con un valor.

Ahora, si eliminas employees_array(3) (un índice intermedio), el first y last no cambiarán. 
Seguirás teniendo first = 1 y last = 5, aunque employees_array(3) esté vacío.

Posibles soluciones:

Si quieres evitar que los índices first y last reflejen los índices originales, una opción sería:

1. Reordenar el arreglo: Podrías crear una nueva tabla temporal y copiar los elementos válidos, 
  ignorando los índices de los elementos eliminados, lo que te daría una secuencia continua.

2. Usar una iteración cuidadosa: En lugar de confiar en first y last para la iteración,
   podrías usar una estructura que verifique si el índice realmente tiene un valor válido antes
   de procesarlo, por ejemplo, usando EXISTS.
*/
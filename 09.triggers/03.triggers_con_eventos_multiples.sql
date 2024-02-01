/***************************************************************************************************
Triggers con eventos múltiples
****************************************************************************************************
*/

SET SERVEROUTPUT ON;

/* Ejemplo 01
******************************************************
Queremos controlar con un trigger que solo podrá insertar, actualizar o eliminar
datos en la tabla regions el usuario HR.
*/
CREATE OR REPLACE TRIGGER tx_check_user
BEFORE INSERT OR UPDATE OR DELETE
ON regions
BEGIN
    IF USER <> 'HR' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Solo puede insertar, actualizar o eliminar el usuario HR en la tabla regions');
    END IF;
END tx_check_user;
/

-- Probando trigger: Insertando región con usuario SYSTEM (conectacnos con dicho usuario)
SELECT *
FROM HR.regions;

INSERT INTO HR.regions(region_id, region_name)
VALUES(5, 'Oceanía');


/* Ejemplo 02
******************************************************
Queremos controlar con un trigger que solo el usuario HR podrá actualizar las columnas
salary y commission_pct de la tabla employees, es decir, cualquier otro usuario podrá 
actualizar las otras columnas sin problema.

El UPDATE OF nombre_columna, [columnas] solo aplica precisamente para el UPDATE, 
no existe para el INSERT ni el DELETE, ya que por su propia funcionalidad,
estos tienen que ser completos, es decir, cuando llamamos por ejemplo al DELETE,
nosotros no le decimos que solo haga el DELETE de una columna, sino más bien o
borramos toda la fila o no la borramos, es la misma idea con el INSERT.
*/
CREATE OR REPLACE TRIGGER tx_check_employee
BEFORE UPDATE OF salary, commission_pct
ON employees
BEGIN
    IF USER <> 'HR' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Las columnas salary y commission_pct solo pueden ser actualizadas por el usuario HR');
    END IF;
END tx_check_employee;
/
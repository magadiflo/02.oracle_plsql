/***************************************************************************************************
Comprobar el estado de los triggers
****************************************************************************************************
*/
DESCRIBE user_triggers;

SELECT * 
FROM user_triggers;

SELECT * 
FROM user_errors;

ALTER TRIGGER tx_regions DISABLE;
ALTER TRIGGER tx_regions ENABLE;
/***************************************************************************************************
Práctica final PL/SQL 12c
****************************************************************************************************
Esta práctica pretende hacer un repaso de los componentes más importantes de PL/SQL: procedimintos, 
funciones, paquetes y triggers.
*/

SET SERVEROUTPUT ON;

/* Ejercicio 01
******************************************************
Vamos a crear cuatro tablas. Podemos ejecutar el script “creación_ddl.sql” que
se encuentra en los recursos del capítulo o bien podéis copiarlo y pegarlo de este
documento
*/
CREATE TABLE invoices(
    code NUMBER,
    create_at DATE,
    description VARCHAR2(100),
    CONSTRAINT pk_invoices PRIMARY KEY(code)
);

CREATE TABLE products(
    code NUMBER,
    name VARCHAR2(100),
    price NUMBER,
    total_sold NUMBER,
    CONSTRAINT pk_products PRIMARY KEY(code)
);

CREATE TABLE invoice_items(
    product_code NUMBER,
    invoice_code NUMBER,
    price NUMBER,
    units NUMBER,
    create_at DATE,
    CONSTRAINT pk_invoice_items PRIMARY KEY(invoice_code, product_code),
    CONSTRAINT fk_inovices_invoice_items FOREIGN KEY(invoice_code) REFERENCES invoices(code),
    CONSTRAINT fk_invoices_products FOREIGN KEY(product_code) REFERENCES products(code)
);

CREATE TABLE control_logs(
    user_db VARCHAR2(100),
    create_at DATE,
    affected_table VARCHAR2(50),
    operation_code CHAR(1),
    CONSTRAINT ck_operation_code CHECK(operation_code IN ('I','U', 'D'))
);

/* Ejercicio 02
******************************************************
*/
CREATE OR REPLACE PACKAGE package_invoices
AS
    PROCEDURE sp_create_invoice(p_invoice_code NUMBER, p_create DATE, p_description VARCHAR);
    PROCEDURE sp_delete_invoice(p_invoice_code NUMBER);
    PROCEDURE sp_modify_description(p_invoice_code NUMBER, p_description VARCHAR2);
    PROCEDURE sp_modify_date(p_invoice_code NUMBER, p_new_date DATE);
    FUNCTION fn_invoices_number(p_initial_date DATE, p_end_date DATE) RETURN NUMBER;
    FUNCTION fn_invoices_total(p_invoice_code NUMBER) RETURN NUMBER;
END package_invoices;
/

CREATE OR REPLACE PACKAGE BODY package_invoices
AS
    FUNCTION fn_invoice_exists(
        p_invoice_code NUMBER
    ) RETURN BOOLEAN
    AS
        rows NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO rows
        FROM invoices
        WHERE code = p_invoice_code;
        
        IF rows > 0 THEN
            RETURN TRUE;
        END IF;
        
        RETURN FALSE;
    END;
    
    PROCEDURE sp_create_invoice(
        p_invoice_code NUMBER, p_create DATE, p_description VARCHAR
    )
    AS        
    BEGIN
        IF fn_invoice_exists(p_invoice_code) THEN
            RAISE_APPLICATION_ERROR(-20001, 'El código de la factura ya fue registrado, use otro.');
        END IF;
        
        INSERT INTO invoices(code, create_at, description)
        VALUES(p_invoice_code, p_create, p_description);
        COMMIT;
    END;

    PROCEDURE sp_delete_invoice(
        p_invoice_code NUMBER
    )
    AS
        NO_INVOICE_EXISTS EXCEPTION;
    BEGIN
        IF NOT fn_invoice_exists(p_invoice_code) THEN
            RAISE NO_INVOICE_EXISTS;    
        END IF;
        
        DELETE FROM invoice_items WHERE invoice_code = p_invoice_code;
        DELETE FROM invoices WHERE code = p_invoice_code;
        COMMIT;
        
    EXCEPTION
        WHEN NO_INVOICE_EXISTS THEN
            RAISE_APPLICATION_ERROR(-20001, 'Error, el código de factura no existe');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000, 'Ocurrió un error: ' || SQLCODE);
    END;
    
    PROCEDURE sp_modify_description(
        p_invoice_code NUMBER, 
        p_description VARCHAR2
    )
    AS
        NO_INVOICE_EXISTS EXCEPTION;
    BEGIN
        IF NOT fn_invoice_exists(p_invoice_code) THEN
            RAISE NO_INVOICE_EXISTS;    
        END IF;
        
        UPDATE invoices
        SET description = p_description
        WHERE code = p_invoice_code;
        
        COMMIT;
    EXCEPTION
        WHEN NO_INVOICE_EXISTS THEN
            RAISE_APPLICATION_ERROR(-20001, 'Error, el código de factura no existe');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000, 'Ocurrió un error: ' || SQLCODE);
    END;
    
    PROCEDURE sp_modify_date(
        p_invoice_code NUMBER, 
        p_new_date DATE
    )
    AS
        NO_INVOICE_EXISTS EXCEPTION;
    BEGIN
        IF NOT fn_invoice_exists(p_invoice_code) THEN
                RAISE NO_INVOICE_EXISTS;    
        END IF;
        
        UPDATE invoices
        SET create_at = p_new_date
        WHERE code = p_invoice_code;
        
        COMMIT;
    EXCEPTION
        WHEN NO_INVOICE_EXISTS THEN
            RAISE_APPLICATION_ERROR(-20001, 'Error, el código de factura no existe');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000, 'Ocurrió un error: ' || SQLCODE);
    END;

    FUNCTION fn_invoices_number(
        p_initial_date DATE, 
        p_end_date DATE
    ) 
    RETURN NUMBER
    AS
        total NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO total
        FROM invoices
        WHERE create_at BETWEEN p_initial_date AND p_end_date;
        
        RETURN total;
    END;   
    
    FUNCTION fn_invoices_total(
        p_invoice_code NUMBER
    ) 
    RETURN NUMBER
    AS
        total NUMBER;
    BEGIN
        SELECT SUM(price * units) 
        INTO total
        FROM invoice_items
        WHERE invoice_code = p_invoice_code;
        
        RETURN total;
    END;
END package_invoices;
/

-- Probando paquete
DECLARE
    total NUMBER;
BEGIN
    --package_invoices.sp_create_invoice(1, TO_DATE('2024-02-02'), 'Compra herramientas eléctricas');
    --package_invoices.sp_delete_invoice(1);
    --package_invoices.sp_modify_description(1, 'Descuento en herramientas eléctricas');
    --package_invoices.sp_modify_date(1, TO_DATE('2024-02-14'));
    --total := package_invoices.fn_invoices_number(sysdate, TO_DATE('2024-02-28'));
    total := package_invoices.fn_invoices_total(1);
    dbms_output.put_line(total);
END;
/

SELECT * 
FROM invoices;

SELECT *
FROM invoice_items;
    
INSERT INTO products(code, name, price, total_sold)
VALUES(1, 'Monitor LG', 25.50, 0);

INSERT INTO invoice_items(product_code, invoice_code, price, units, create_at)
VALUES(1, 1, 15.50, 2, SYSDATE);

TRUNCATE TABLE INVOICES;

/* Ejercicio 03
******************************************************
*/
CREATE OR REPLACE PACKAGE package_invoices_items
AS
    PROCEDURE sp_create_invoice_item(p_invoice_code NUMBER, p_product_code NUMBER, p_units NUMBER, p_create_at DATE);
    PROCEDURE sp_delete_invoice_item(p_invoice_code NUMBER, p_product_code NUMBER);
    PROCEDURE sp_modify_product(p_invoice_code NUMBER, p_product_code NUMBER, p_units NUMBER);
    PROCEDURE sp_modify_product(p_invoice_code NUMBER, p_product_code NUMBER, p_new_date DATE);
    FUNCTION fn_total_items(p_invoice_code NUMBER) RETURN NUMBER;
END package_invoices_items;
/


CREATE OR REPLACE PACKAGE BODY package_invoices_items
AS
    FUNCTION fn_invoice_exists(
        p_invoice_code NUMBER
    ) 
    RETURN BOOLEAN
    AS
        rows NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO rows
        FROM invoices
        WHERE code = p_invoice_code;
        
        IF rows > 0 THEN
            RETURN TRUE;
        END IF;
        
        RETURN FALSE;
    END fn_invoice_exists;
    
    FUNCTION fn_product_exists(
        p_product_code NUMBER
    ) 
    RETURN BOOLEAN
    AS
        rows NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO rows
        FROM products
        WHERE code = p_product_code;
        
        IF rows > 0 THEN
            RETURN TRUE;
        END IF;
        
        RETURN FALSE;
    END fn_product_exists;
    
    FUNCTION fn_item_exists(
        p_invoice_code NUMBER,
        p_product_code NUMBER
    ) 
    RETURN BOOLEAN
    AS
        rows NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO rows
        FROM invoice_items
        WHERE invoice_code = p_invoice_code AND product_code = p_product_code;
        
        IF rows > 0 THEN
            RETURN TRUE;
        END IF;
        
        RETURN FALSE;
    END fn_item_exists;
    
    PROCEDURE sp_create_invoice_item(
        p_invoice_code NUMBER, 
        p_product_code NUMBER, 
        p_units NUMBER, 
        p_create_at DATE
    )
    AS
        NO_INVOICE_EXISTS EXCEPTION;
        NO_PRODUCT_EXISTS EXCEPTION;
        price NUMBER;
    BEGIN
        IF NOT fn_invoice_exists(p_invoice_code) THEN
            RAISE NO_INVOICE_EXISTS;
        END IF;
        
        IF NOT fn_product_exists(p_product_code) THEN
            RAISE NO_PRODUCT_EXISTS;
        END IF;
        
        SELECT p.price
        INTO price
        FROM products p
        WHERE p.code = p_product_code;
        
        INSERT INTO invoice_items(product_code, invoice_code, price, units, create_at)
        VALUES(p_product_code, p_invoice_code, price, p_units, p_create_at);
        
        COMMIT;
    EXCEPTION
        WHEN NO_INVOICE_EXISTS THEN
            RAISE_APPLICATION_ERROR(-20001, 'Error, el código de factura no existe');
        WHEN NO_PRODUCT_EXISTS THEN
            RAISE_APPLICATION_ERROR(-20002, 'Error, el código del producto no existe');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000, 'Ocurrió un error: ' || SQLCODE);
    END sp_create_invoice_item;
    
    PROCEDURE sp_delete_invoice_item(
        p_invoice_code NUMBER, 
        p_product_code NUMBER
    )
    AS
        NO_INVOICE_PRODUCT_EXISTS EXCEPTION;
    BEGIN
        IF NOT fn_item_exists(p_invoice_code, p_product_code) THEN
            RAISE NO_INVOICE_PRODUCT_EXISTS;
        END IF;
        DELETE FROM invoice_items WHERE invoice_code = p_invoice_code AND product_code = p_product_code;
        COMMIT;
    EXCEPTION
        WHEN NO_INVOICE_PRODUCT_EXISTS THEN
            RAISE_APPLICATION_ERROR(-20001, 'El item con el código de factura y producto ingresado no existe');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000, 'Ocurrió un error: ' || SQLCODE);
    END sp_delete_invoice_item;
    
    PROCEDURE sp_modify_product(
        p_invoice_code NUMBER, 
        p_product_code NUMBER, 
        p_units NUMBER
    )
    AS
        NO_INVOICE_EXISTS EXCEPTION;
        NO_PRODUCT_EXISTS EXCEPTION;
    BEGIN
        IF NOT fn_invoice_exists(p_invoice_code) THEN
            RAISE NO_INVOICE_EXISTS;
        END IF;
        IF NOT fn_product_exists(p_product_code) THEN
            RAISE NO_PRODUCT_EXISTS;
        END IF;
        UPDATE invoice_items
        SET units = p_units
        WHERE product_code = p_product_code AND invoice_code = p_invoice_code;
        
        COMMIT;
    EXCEPTION
        WHEN NO_INVOICE_EXISTS THEN
            RAISE_APPLICATION_ERROR(-20001, 'Error, el código de la factura no existe');
        WHEN NO_PRODUCT_EXISTS THEN
            RAISE_APPLICATION_ERROR(-20001, 'Error, el código del producto no existe');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000, 'Ocurrió un error: ' || SQLCODE);
    END sp_modify_product;
    
    PROCEDURE sp_modify_product(
        p_invoice_code NUMBER, 
        p_product_code NUMBER, 
        p_new_date DATE
    )
    AS
        NO_INVOICE_EXISTS EXCEPTION;
        NO_PRODUCT_EXISTS EXCEPTION;
    BEGIN
        IF NOT fn_invoice_exists(p_invoice_code) THEN
            RAISE NO_INVOICE_EXISTS;
        END IF;
        IF NOT fn_product_exists(p_product_code) THEN
            RAISE NO_PRODUCT_EXISTS;
        END IF;
        UPDATE invoice_items
        SET create_at = p_new_date
        WHERE product_code = p_product_code AND invoice_code = p_invoice_code;
        
        COMMIT;
    EXCEPTION
        WHEN NO_INVOICE_EXISTS THEN
            RAISE_APPLICATION_ERROR(-20001, 'Error, el código de la factura no existe');
        WHEN NO_PRODUCT_EXISTS THEN
            RAISE_APPLICATION_ERROR(-20001, 'Error, el código del producto no existe');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20000, 'Ocurrió un error: ' || SQLCODE);
    END sp_modify_product;
    
    FUNCTION fn_total_items(
        p_invoice_code NUMBER
    ) 
    RETURN NUMBER
    AS
        total NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO total
        FROM invoice_items
        WHERE invoice_code = p_invoice_code;
        
        RETURN total;
    END fn_total_items;
END package_invoices_items;
/

-- Probando paquete
DECLARE
    total NUMBER;
BEGIN
    --package_invoices_items.sp_create_invoice_item(1, 1, 10, SYSDATE);
    --package_invoices_items.sp_delete_invoice_item(1, 1);
    --package_invoices_items.sp_modify_product(1, 1, 100);
    --package_invoices_items.sp_modify_product(1, 1, TO_DATE('2024-01-31'));
    total := package_invoices_items.fn_total_items(1);
    dbms_output.put_line('Total de items: ' || total);
END;
/

SELECT * 
FROM invoices;

SELECT * 
FROM products;

SELECT * 
FROM invoice_items;

TRUNCATE TABLE invoice_items;
TRUNCATE TABLE invoices;

/* Ejercicio 04
******************************************************
*/
CREATE OR REPLACE TRIGGER tx_invoices
AFTER INSERT OR UPDATE OR DELETE
ON invoices
DECLARE
    operation CHAR(1);
BEGIN
    IF INSERTING THEN
        operation := 'I';
    ELSIF UPDATING THEN
        operation := 'U';
    ELSIF DELETING THEN
        operation := 'D';
    END IF;
    
    INSERT INTO control_logs(user_db, create_at, affected_table, operation_code)
    VALUES(USER, SYSDATE, 'invoices', operation);
END tx_invoices;
/

-- Probando trigger
SELECT *
FROM control_logs;

DESCRIBE invoices;

SELECT *
FROM invoices;

INSERT INTO invoices(code, create_at, description)
VALUES(1, SYSDATE, 'Pinturas');

DELETE FROM invoices WHERE code = 1;

UPDATE invoices
SET description = 'Pinturas de esmalte'
WHERE code = 1;

/* Ejercicio 05
******************************************************
*/
CREATE OR REPLACE TRIGGER tx_invoice_items
AFTER INSERT OR UPDATE OR DELETE
ON invoice_items
DECLARE
    operation CHAR(1);
BEGIN
    IF INSERTING THEN
        operation := 'I';
    ELSIF UPDATING THEN
        operation := 'U';
    ELSIF DELETING THEN
        operation := 'D';
    END IF;
    
    INSERT INTO control_logs(user_db, create_at, affected_table, operation_code)
    VALUES(USER, SYSDATE, 'invoice_items', operation);
END tx_invoices;
/

-- Probando trigger
SELECT *
FROM invoices;

SELECT * 
FROM invoice_items;

INSERT INTO invoices(code, create_at, description)
VALUES(1, SYSDATE, 'Pinturas');

INSERT INTO invoice_items(product_code, invoice_code, price, units, create_at)
VALUES(1, 1, 15.50, 2, SYSDATE);

SELECT * 
FROM control_logs;


/* Ejercicio 06
******************************************************
*/
CREATE OR REPLACE TRIGGER tx_products
AFTER INSERT OR UPDATE OR DELETE
ON invoice_items
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        UPDATE products
        SET total_sold = total_sold + (:NEW.price * :NEW.units)
        WHERE code = :NEW.product_code;
    ELSIF UPDATING THEN
        UPDATE products
        SET total_sold = total_sold - (:OLD.price * :OLD.units) + (:NEW.price * :NEW.units)
        WHERE code = :NEW.product_code;
    ELSIF DELETING THEN
        UPDATE products
        SET total_sold = total_sold - (:OLD.price * :OLD.units)
        WHERE code = :OLD.product_code;
    END IF;
END tx_products;
/

-- Probando trigger
TRUNCATE TABLE invoice_items;
TRUNCATE TABLE invoices;

SELECT *
FROM invoices;

SELECT *
FROM invoice_items;

SELECT * 
FROM products;

INSERT INTO invoices(code, create_at, description)
VALUES(1, SYSDATE, 'Pinturas');

INSERT INTO invoice_items(product_code, invoice_code, price, units, create_at)
VALUES(1, 1, 15.50, 2, SYSDATE);

DELETE FROM invoice_items WHERE product_code = 1 AND invoice_code = 1;
--Mateo Alvarez
--David Torres

--1

CREATE OR REPLACE TRIGGER controlCliente AFTER INSERT OR UPDATE OR DELETE ON cliente
DECLARE
c NUMBER;
BEGIN
    c := cantauditoria;
    INSERT INTO auditoria (codigo, fecha, tabla) 
    VALUES ((c + 1), TO_DATE(sysdate, 'dd/mm/yyyy  hh24:mi:ss'), 'Cliente');
END;
/
------------------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER controlGasto AFTER INSERT OR UPDATE OR DELETE ON gasto
DECLARE
c NUMBER;
BEGIN
    c := cantauditoria;
    INSERT INTO auditoria (codigo, fecha, tabla) 
    VALUES ((c + 1), TO_DATE(sysdate, 'dd/mm/yyyy  hh24:mi:ss'), 'Gasto');
END;
/
------------------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER controlEmpleo AFTER INSERT OR UPDATE OR DELETE ON empleo
DECLARE
c NUMBER;
BEGIN
    c := cantauditoria;
    INSERT INTO auditoria (codigo, fecha, tabla) 
    VALUES ((c + 1), TO_DATE(sysdate, 'dd/mm/yyyy  hh24:mi:ss'), 'Empleo');
END;
/
------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION cantAuditoria
RETURN NUMBER IS
cod NUMBER;
BEGIN
    SELECT NVL(COUNT(*), 0) 
    INTO cod
    FROM auditoria;
    return cod;
END;
--2
CREATE OR REPLACE TRIGGER gastoMayor BEFORE INSERT ON gasto FOR EACH ROW
DECLARE
ing NUMBER(8);
BEGIN
    SELECT valor_mensual INTO ing FROM empleo
    WHERE ced = :NEW.ced;
    IF ing < :NEW.valor_mensual THEN
        RAISE_APPLICATION_ERROR(-20212,'El cliente no puede tener un gasto mayor al ingreso.');
    END IF;
END;

SELECT * FROM empleo;

INSERT INTO empleo (ced, nit_empresa, valor_mensual) VALUES (6, 35, 12);
INSERT INTO gasto (cod_gasto, ced, valor_mensual, desc_gasto) VALUES (47, 6, 32, 2);
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
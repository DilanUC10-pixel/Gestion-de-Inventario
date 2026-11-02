-- ============================================================
-- 05_pruebas.sql
-- ============================================================

-- PRUEBA 1: inserciones directas (datos cargados en 02_inserciones.sql)

SELECT * FROM categoria;
SELECT * FROM producto;
SELECT * FROM cliente;
SELECT * FROM venta;


-- PRUEBA 2: vistas

SELECT * FROM vw_producto_categoria;
SELECT * FROM vw_venta_detalle;


-- PRUEBA 3: SP - venta correcta (cliente 2 compra 3 mouse, producto 2)

SELECT id_producto, nombre, stock FROM producto WHERE id_producto = 2;   -- stock antes

DECLARE
    v_id_venta NUMBER;
BEGIN
    sp_registrar_venta(2, 2, 3, 'admin', v_id_venta);
    DBMS_OUTPUT.PUT_LINE('Venta registrada con ID: ' || v_id_venta);
END;
/

SELECT id_producto, nombre, stock FROM producto WHERE id_producto = 2;   -- stock despues (47)
SELECT * FROM vw_venta_detalle;


-- PRUEBA 4: SP - stock insuficiente (debe fallar con ORA-20005)

DECLARE
    v_id_venta NUMBER;
BEGIN
    sp_registrar_venta(1, 1, 500, 'admin', v_id_venta);
    DBMS_OUTPUT.PUT_LINE('PRUEBA 4 FALLO: la venta se registro y no debia.');
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -20005 THEN
            DBMS_OUTPUT.PUT_LINE('PRUEBA 4 OK: el SP rechazo la venta -> ' || SQLERRM);
        ELSE
            DBMS_OUTPUT.PUT_LINE('PRUEBA 4 FALLO: error inesperado -> ' || SQLERRM);
        END IF;
END;
/


-- PRUEBA 5: SP - cliente inexistente (debe fallar con ORA-20002)

DECLARE
    v_id_venta NUMBER;
BEGIN
    sp_registrar_venta(999, 1, 1, 'admin', v_id_venta);
    DBMS_OUTPUT.PUT_LINE('PRUEBA 5 FALLO: la venta se registro y no debia.');
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -20002 THEN
            DBMS_OUTPUT.PUT_LINE('PRUEBA 5 OK: el SP rechazo la venta -> ' || SQLERRM);
        ELSE
            DBMS_OUTPUT.PUT_LINE('PRUEBA 5 FALLO: error inesperado -> ' || SQLERRM);
        END IF;
END;
/


-- PRUEBA 6: SP - producto inexistente (debe fallar con ORA-20003)

DECLARE
    v_id_venta NUMBER;
BEGIN
    sp_registrar_venta(1, 999, 1, 'admin', v_id_venta);
    DBMS_OUTPUT.PUT_LINE('PRUEBA 6 FALLO: la venta se registro y no debia.');
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -20003 THEN
            DBMS_OUTPUT.PUT_LINE('PRUEBA 6 OK: el SP rechazo la venta -> ' || SQLERRM);
        ELSE
            DBMS_OUTPUT.PUT_LINE('PRUEBA 6 FALLO: error inesperado -> ' || SQLERRM);
        END IF;
END;
/


-- PRUEBA 7: funcion fn_total_venta (cantidad x precio)

SELECT id_venta, cantidad, fn_total_venta(id_venta) AS total
FROM venta
ORDER BY id_venta;


-- PRUEBA 8: funcion fn_calcular_iva

SELECT fn_calcular_iva(1000)       AS iva_16,
       fn_calcular_iva(1000, 0.08) AS iva_8
FROM dual;

SELECT id_venta,
       fn_total_venta(id_venta)                      AS total,
       fn_calcular_iva(fn_total_venta(id_venta))     AS iva
FROM venta
ORDER BY id_venta;

-- ============================================================
-- 04_funciones_sp.sql
-- ============================================================

-- FUNCION 1: total de una venta (cantidad x precio)

CREATE OR REPLACE FUNCTION fn_total_venta (p_id_venta IN NUMBER)
RETURN NUMBER
IS
    v_total NUMBER;
BEGIN
    SELECT v.cantidad * p.precio
    INTO v_total
    FROM venta v
    JOIN producto p ON p.id_producto = v.id_producto
    WHERE v.id_venta = p_id_venta;

    RETURN v_total;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END fn_total_venta;
/


-- FUNCION 2: calcular IVA de un monto (tasa por defecto 16%)

CREATE OR REPLACE FUNCTION fn_calcular_iva (
    p_monto IN NUMBER,
    p_tasa  IN NUMBER DEFAULT 0.16
)
RETURN NUMBER
IS
BEGIN
    RETURN ROUND(p_monto * p_tasa, 2);
END fn_calcular_iva;
/


-- STORED PROCEDURE: registrar una venta
-- Valida cliente, producto, estatus y stock; genera el ID de venta
-- automaticamente (IDENTITY) y descuenta el stock.

CREATE OR REPLACE PROCEDURE sp_registrar_venta (
    p_id_cliente  IN  NUMBER,
    p_id_producto IN  NUMBER,
    p_cantidad    IN  NUMBER,
    p_usuario     IN  VARCHAR2,
    p_id_venta    OUT NUMBER
)
IS
    v_existe  NUMBER;
    v_stock   producto.stock%TYPE;
    v_estatus producto.estatus%TYPE;
BEGIN
    -- Cantidad valida
    IF p_cantidad IS NULL OR p_cantidad <= 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'La cantidad debe ser mayor que cero.');
    END IF;

    -- Validar cliente
    SELECT COUNT(*) INTO v_existe
    FROM cliente
    WHERE id_cliente = p_id_cliente;

    IF v_existe = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'El cliente no existe.');
    END IF;

    -- Validar producto (se bloquea la fila mientras se registra la venta)
    BEGIN
        SELECT stock, estatus
        INTO v_stock, v_estatus
        FROM producto
        WHERE id_producto = p_id_producto
        FOR UPDATE;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20003, 'El producto no existe.');
    END;

    IF v_estatus = 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'El producto esta inactivo.');
    END IF;

    -- Validar stock
    IF v_stock < p_cantidad THEN
        RAISE_APPLICATION_ERROR(-20005, 'Stock insuficiente. Disponible: ' || v_stock);
    END IF;

    -- Registrar la venta (el ID se genera automaticamente)
    INSERT INTO venta (id_cliente, id_producto, cantidad, usuario_registro)
    VALUES (p_id_cliente, p_id_producto, p_cantidad, p_usuario)
    RETURNING id_venta INTO p_id_venta;

    -- Actualizar el stock
    UPDATE producto
    SET stock = stock - p_cantidad,
        fecha_modificacion = SYSDATE
    WHERE id_producto = p_id_producto;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END sp_registrar_venta;
/

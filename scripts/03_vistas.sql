-- ============================================================
-- 03_vistas.sql
-- ============================================================

CREATE OR REPLACE VIEW vw_producto_categoria AS
SELECT
    p.id_producto,
    p.nombre   AS producto,
    p.precio,
    p.stock,
    p.estatus,
    c.id_categoria,
    c.nombre   AS categoria
FROM producto p
JOIN categoria c ON c.id_categoria = p.id_categoria;


CREATE OR REPLACE VIEW vw_venta_detalle AS
SELECT
    v.id_venta,
    v.fecha_venta,
    cl.id_cliente,
    cl.nombre || ' ' || cl.apellidos AS cliente,
    cl.correo,
    p.id_producto,
    p.nombre                         AS producto,
    p.precio,
    v.cantidad,
    v.cantidad * p.precio            AS total,
    v.usuario_registro
FROM venta v
JOIN cliente cl ON cl.id_cliente  = v.id_cliente
JOIN producto p ON p.id_producto  = v.id_producto;

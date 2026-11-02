-- ============================================================
-- 02_inserciones.sql
-- ============================================================

-- CATEGORIA

INSERT INTO categoria (nombre, descripcion) VALUES ('Electronica', 'Equipos y accesorios electronicos');
INSERT INTO categoria (nombre, descripcion) VALUES ('Ropa', 'Prendas de vestir');
INSERT INTO categoria (nombre, descripcion) VALUES ('Papeleria', 'Articulos de oficina y escolares');


-- PRODUCTO

INSERT INTO producto (nombre, precio, stock, id_categoria, descripcion)
VALUES ('Laptop 14 pulgadas', 15000.00, 10, (SELECT id_categoria FROM categoria WHERE nombre = 'Electronica'), 'Laptop para uso general');

INSERT INTO producto (nombre, precio, stock, id_categoria, descripcion)
VALUES ('Mouse inalambrico', 250.00, 50, (SELECT id_categoria FROM categoria WHERE nombre = 'Electronica'), 'Mouse optico inalambrico');

INSERT INTO producto (nombre, precio, stock, id_categoria, descripcion)
VALUES ('Teclado USB', 400.00, 30, (SELECT id_categoria FROM categoria WHERE nombre = 'Electronica'), 'Teclado en espanol con cable USB');

INSERT INTO producto (nombre, precio, stock, id_categoria, descripcion)
VALUES ('Playera basica', 180.00, 40, (SELECT id_categoria FROM categoria WHERE nombre = 'Ropa'), 'Playera de algodon');

INSERT INTO producto (nombre, precio, stock, id_categoria, descripcion)
VALUES ('Cuaderno profesional', 45.00, 100, (SELECT id_categoria FROM categoria WHERE nombre = 'Papeleria'), 'Cuaderno de 100 hojas');


-- CLIENTE

INSERT INTO cliente (nombre, apellidos, correo, telefono)
VALUES ('Ana', 'Lopez Martinez', 'ana.lopez@correo.com', '5511111111');

INSERT INTO cliente (nombre, apellidos, correo, telefono)
VALUES ('Carlos', 'Perez Gomez', 'carlos.perez@correo.com', '5522222222');

INSERT INTO cliente (nombre, apellidos, correo, telefono)
VALUES ('Maria', 'Ramirez Cruz', 'maria.ramirez@correo.com', '5533333333');


-- VENTA (insercion directa de ejemplo; se descuenta el stock manualmente
-- para mantener consistente el inventario. Las demas ventas se registran con el SP)

INSERT INTO venta (id_cliente, id_producto, cantidad, usuario_registro)
VALUES (
    (SELECT id_cliente FROM cliente WHERE correo = 'ana.lopez@correo.com'),
    (SELECT id_producto FROM producto WHERE nombre = 'Laptop 14 pulgadas'),
    1,
    'admin'
);

UPDATE producto
SET stock = stock - 1,
    fecha_modificacion = SYSDATE
WHERE nombre = 'Laptop 14 pulgadas';

COMMIT;

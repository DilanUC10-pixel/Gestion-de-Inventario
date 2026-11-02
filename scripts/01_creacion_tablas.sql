-- ============================================================
-- 01_creacion_tablas.sql
-- ============================================================

-- ELIMINAR TABLAS (permite volver a ejecutar el script)

BEGIN
    FOR t IN (SELECT column_value AS nombre
              FROM TABLE(sys.odcivarchar2list('VENTA', 'PRODUCTO', 'CLIENTE', 'CATEGORIA')))
    LOOP
        BEGIN
            EXECUTE IMMEDIATE 'DROP TABLE ' || t.nombre || ' CASCADE CONSTRAINTS';
        EXCEPTION WHEN OTHERS THEN
            IF SQLCODE != -942 THEN RAISE; END IF;
        END;
    END LOOP;
END;
/

-- TABLA CATEGORIA

CREATE TABLE categoria (
    id_categoria       NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre             VARCHAR2(100) NOT NULL,
    descripcion        VARCHAR2(500),
    fecha_creacion     DATE DEFAULT SYSDATE NOT NULL,
    fecha_modificacion DATE DEFAULT SYSDATE NOT NULL
);

COMMENT ON TABLE categoria IS 'Tabla que almacena las categorias utilizadas para clasificar los productos del inventario.';
COMMENT ON COLUMN categoria.id_categoria IS 'Identificador unico de la categoria, generado automaticamente.';
COMMENT ON COLUMN categoria.nombre IS 'Nombre de la categoria.';
COMMENT ON COLUMN categoria.descripcion IS 'Descripcion general de la categoria.';
COMMENT ON COLUMN categoria.fecha_creacion IS 'Fecha de creacion del registro de categoria.';
COMMENT ON COLUMN categoria.fecha_modificacion IS 'Fecha de la ultima modificacion realizada al registro de categoria.';


-- TABLA PRODUCTO

CREATE TABLE producto (
    id_producto        NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre             VARCHAR2(150) NOT NULL,
    precio             NUMBER(10,2) NOT NULL,
    stock              NUMBER(10) NOT NULL,
    id_categoria       NUMBER NOT NULL,
    descripcion        VARCHAR2(500),
    estatus            NUMBER(1) DEFAULT 1 NOT NULL,
    fecha_creacion     DATE DEFAULT SYSDATE NOT NULL,
    fecha_modificacion DATE DEFAULT SYSDATE NOT NULL,
    CONSTRAINT fk_producto_categoria FOREIGN KEY (id_categoria) REFERENCES categoria (id_categoria)
);

COMMENT ON TABLE producto IS 'Tabla que almacena la informacion de los productos disponibles en el catalogo y su inventario.';
COMMENT ON COLUMN producto.id_producto IS 'Identificador unico del producto, generado automaticamente.';
COMMENT ON COLUMN producto.nombre IS 'Nombre comercial del producto.';
COMMENT ON COLUMN producto.precio IS 'Precio unitario del producto en moneda local.';
COMMENT ON COLUMN producto.stock IS 'Cantidad de unidades disponibles en inventario.';
COMMENT ON COLUMN producto.id_categoria IS 'Identificador de la categoria a la que pertenece el producto. Clave foranea.';
COMMENT ON COLUMN producto.descripcion IS 'Descripcion y caracteristicas generales del producto.';
COMMENT ON COLUMN producto.estatus IS 'Estatus del producto: 1 activo, 0 inactivo.';
COMMENT ON COLUMN producto.fecha_creacion IS 'Fecha de creacion del registro del producto.';
COMMENT ON COLUMN producto.fecha_modificacion IS 'Fecha de la ultima modificacion realizada al registro del producto.';


-- TABLA CLIENTE

CREATE TABLE cliente (
    id_cliente         NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre             VARCHAR2(100) NOT NULL,
    apellidos          VARCHAR2(150) NOT NULL,
    correo             VARCHAR2(150) NOT NULL,
    telefono           VARCHAR2(20),
    fecha_registro     DATE DEFAULT SYSDATE NOT NULL,
    fecha_creacion     DATE DEFAULT SYSDATE NOT NULL,
    fecha_modificacion DATE DEFAULT SYSDATE NOT NULL
);

COMMENT ON TABLE cliente IS 'Tabla que almacena la informacion personal y los datos de contacto de los clientes.';
COMMENT ON COLUMN cliente.id_cliente IS 'Identificador unico del cliente, generado automaticamente.';
COMMENT ON COLUMN cliente.nombre IS 'Nombre o nombres del cliente.';
COMMENT ON COLUMN cliente.apellidos IS 'Apellidos del cliente.';
COMMENT ON COLUMN cliente.correo IS 'Correo electronico del cliente.';
COMMENT ON COLUMN cliente.telefono IS 'Numero telefonico de contacto del cliente.';
COMMENT ON COLUMN cliente.fecha_registro IS 'Fecha en que el cliente fue registrado en el sistema.';
COMMENT ON COLUMN cliente.fecha_creacion IS 'Fecha de creacion del registro del cliente.';
COMMENT ON COLUMN cliente.fecha_modificacion IS 'Fecha de la ultima modificacion realizada al registro del cliente.';


-- TABLA VENTA

CREATE TABLE venta (
    id_venta           NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_cliente         NUMBER NOT NULL,
    id_producto        NUMBER NOT NULL,
    cantidad           NUMBER(10) NOT NULL,
    fecha_venta        DATE DEFAULT SYSDATE NOT NULL,
    usuario_registro   VARCHAR2(100) NOT NULL,
    fecha_creacion     DATE DEFAULT SYSDATE NOT NULL,
    fecha_modificacion DATE DEFAULT SYSDATE NOT NULL,
    CONSTRAINT fk_venta_cliente  FOREIGN KEY (id_cliente)  REFERENCES cliente (id_cliente),
    CONSTRAINT fk_venta_producto FOREIGN KEY (id_producto) REFERENCES producto (id_producto)
);

COMMENT ON TABLE venta IS 'Tabla que almacena las transacciones de venta realizadas a los clientes.';
COMMENT ON COLUMN venta.id_venta IS 'Identificador unico de la venta, generado automaticamente.';
COMMENT ON COLUMN venta.id_cliente IS 'Identificador del cliente que realiza la compra. Clave foranea.';
COMMENT ON COLUMN venta.id_producto IS 'Identificador del producto vendido. Clave foranea.';
COMMENT ON COLUMN venta.cantidad IS 'Numero de unidades del producto registradas en la venta.';
COMMENT ON COLUMN venta.fecha_venta IS 'Fecha en que se realiza la venta.';
COMMENT ON COLUMN venta.usuario_registro IS 'Usuario responsable de registrar la venta.';
COMMENT ON COLUMN venta.fecha_creacion IS 'Fecha de creacion del registro de venta.';
COMMENT ON COLUMN venta.fecha_modificacion IS 'Fecha de la ultima modificacion realizada al registro de venta.';

# Base de Datos - Taller Tienda

## Código SQL

```sql
CREATE DATABASE IF NOT EXISTS taller_tienda;

USE taller_tienda;

DROP TABLE IF EXISTS Venta;

DROP TABLE IF EXISTS Producto;


-- 1. Tabla Producto

CREATE TABLE Producto (

    id INT PRIMARY KEY,

    nombre VARCHAR(100),

    precio DECIMAL(10,2),

    categoria VARCHAR(50)

);


-- 2. Tabla Venta, relacionada con Producto mediante llave foranea

CREATE TABLE Venta (

    id INT PRIMARY KEY,

    id_producto INT,

    cantidad INT,

    fecha DATE,

    FOREIGN KEY (id_producto) REFERENCES Producto(id)

);


INSERT INTO Producto (id, nombre, precio, categoria) VALUES

(1,  'Televisor LED 50 pulgadas',       1850000.00, 'Electrodomesticos'),

(2,  'Licuadora Oster',                   145000.00, 'Electrodomesticos'),

(3,  'Camiseta deportiva Nike',            89000.00, 'Ropa'),

(4,  'Jean clasico Levis',                159000.00, 'Ropa'),

(5,  'Zapatillas running Adidas',         320000.00, 'Calzado'),

(6,  'Sandalias de playa',                 45000.00, 'Calzado'),

(7,  'Portatil HP 15 pulgadas',          2350000.00, 'Tecnologia'),

(8,  'Mouse inalambrico Logitech',         65000.00, 'Tecnologia'),

(9,  'Audifonos Bluetooth JBL',           189000.00, 'Tecnologia'),

(10, 'Cafetera electrica',               120000.00, 'Electrodomesticos'),

(11, 'Silla de oficina ergonomica',       480000.00, 'Hogar'),

(12, 'Lampara de escritorio LED',          38000.00, 'Hogar'),

(13, 'Mochila para portatil',              95000.00, 'Accesorios'),

(14, 'Reloj inteligente Xiaomi',          210000.00, 'Tecnologia'),

(15, 'Set de ollas antiadherentes',       310000.00, 'Hogar');


INSERT INTO Venta (id, id_producto, cantidad, fecha) VALUES

(1,  1,  1, '2026-01-15'),

(2,  2,  4, '2026-01-18'),

(3,  3,  6, '2026-02-02'),

(4,  4,  2, '2026-02-10'),

(5,  5,  3, '2026-02-14'),

(6,  6,  8, '2026-03-01'),

(7,  7,  1, '2026-03-05'),

(8,  8,  5, '2026-03-09'),

(9,  9,  2, '2026-03-20'),

(10, 10, 4, '2026-04-01'),

(11, 11, 1, '2026-04-08'),

(12, 12, 7, '2026-04-15'),

(13, 13, 3, '2026-05-02'),

(14, 14, 2, '2026-05-10'),

(15, 15, 1, '2026-05-18'),

(16, 3,  2, '2026-05-22'),

(17, 8,  6, '2026-06-01'),

(18, 5,  1, '2026-06-05'),

(19, 9,  4, '2026-06-12'),

(20, 2,  1, '2026-06-19');


-- 4. Crear tabla de productos caros

CREATE TABLE IF NOT EXISTS productos_caros AS

SELECT nombre, precio

FROM Producto

WHERE precio > 100000;

DESCRIBE productos_caros;


-- 5. Alias de tabla combinando Producto y Venta

SELECT p.nombre, v.cantidad, v.fecha

FROM Producto p

JOIN Venta v ON p.id = v.id_producto;


-- 6. Al menos 3 funciones sobre campos

SELECT UPPER(p.categoria) AS categoria_mayus,

       ROUND(p.precio, 0) AS precio_redondeado,

       CONCAT(p.nombre, ' - ', p.categoria) AS detalle

FROM Producto p;


-- 7. Clasificar productos con IF

SELECT nombre, precio,

       IF(precio > 100000, 'Premium', 'Estandar') AS categoria_precio

FROM Producto;


-- 8. Consulta final integradora: alias

SELECT p.nombre AS producto,

       UPPER(p.categoria) AS categoria,

       v.cantidad,

       IF(v.cantidad > 3, p.precio * 0.9, p.precio) AS precio_final

FROM Producto p

JOIN Venta v ON p.id = v.id_producto;


-- Consulta final de productos

SELECT * FROM Producto;
```

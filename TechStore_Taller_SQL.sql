-- ============================================================
-- TALLER PRACTICO DE SQL - TechStore
-- MySQL 8.0+
-- ============================================================

-- ------------------------------------------------------------
-- EJ. 01 - Construir la base
-- ------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS techstore;
USE techstore;

CREATE TABLE productos (
  id_producto INT PRIMARY KEY AUTO_INCREMENT,
  nombre      VARCHAR(100) NOT NULL,
  categoria   VARCHAR(50) NOT NULL,
  precio      DECIMAL(10,2) NOT NULL CHECK (precio >= 0),
  stock       INT NOT NULL CHECK (stock >= 0)
);

CREATE TABLE clientes (
  id_cliente INT PRIMARY KEY AUTO_INCREMENT,
  nombre     VARCHAR(100) NOT NULL,
  email      VARCHAR(150) UNIQUE,
  ciudad     VARCHAR(60),
  telefono   VARCHAR(20)
);

CREATE TABLE ventas (
  id_venta    INT PRIMARY KEY AUTO_INCREMENT,
  id_cliente  INT NOT NULL,
  id_producto INT NOT NULL,
  cantidad    INT NOT NULL CHECK (cantidad > 0),
  fecha_venta DATE NOT NULL,
  FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
  FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- ------------------------------------------------------------
-- EJ. 02 - Modificar una estructura
-- ------------------------------------------------------------
ALTER TABLE clientes
  ADD COLUMN telefono_alt VARCHAR(20);

ALTER TABLE productos
  MODIFY COLUMN nombre VARCHAR(150);

-- (telefono_alt se deja como columna adicional de ejemplo del ALTER;
--  el telefono principal ya existia en la tabla clientes del EJ.01)

-- ------------------------------------------------------------
-- EJ. 03 - Cargar productos y clientes
-- ------------------------------------------------------------
INSERT INTO productos (nombre, categoria, precio, stock) VALUES
('Mouse Inalambrico X200', 'Perifericos', 45000, 50),
('Teclado Mecanico RGB', 'Perifericos', 180000, 25),
('Monitor 24" Full HD', 'Monitores', 650000, 12),
('Monitor 27" 4K', 'Monitores', 1250000, 8),
('Laptop Core i5 8GB', 'Computadores', 2800000, 10),
('Laptop Core i7 16GB', 'Computadores', 4200000, 6),
('Disco SSD 1TB', 'Almacenamiento', 320000, 30),
('Memoria RAM 16GB', 'Componentes', 210000, 40),
('Audifonos Bluetooth', 'Audio', 150000, 22),
('Mochila para Laptop', 'Accesorios', 90000, 35);

INSERT INTO clientes (nombre, email, ciudad, telefono) VALUES
('Juan Ramirez', 'juan.ramirez@mail.com', 'Cucuta', '3101112233'),
('Camila Rojas', 'camila.rojas@mail.com', 'Bogota', '3112223344'),
('Diego Martinez', 'diego.martinez@mail.com', 'Medellin', '3123334455'),
('Valentina Cruz', 'valentina.cruz@mail.com', 'Cucuta', '3134445566'),
('Santiago Peña', 'santiago.pena@mail.com', 'Cali', '3145556677'),
('Isabella Moreno', 'isabella.moreno@mail.com', 'Bucaramanga', '3156667788');

-- ------------------------------------------------------------
-- EJ. 04 - Registrar ventas con sentido
-- ------------------------------------------------------------
INSERT INTO ventas (id_cliente, id_producto, cantidad, fecha_venta) VALUES
(1, 1, 2, '2026-01-05'),
(1, 7, 1, '2026-02-10'),
(2, 3, 1, '2026-01-08'),
(2, 9, 2, '2026-03-02'),
(3, 5, 1, '2026-01-15'),
(3, 8, 1, '2026-02-20'),
(4, 2, 1, '2026-01-20'),
(4, 10, 1, '2026-03-05'),
(5, 6, 1, '2026-02-01'),
(5, 4, 1, '2026-02-14'),
(6, 1, 1, '2026-01-25'),
(6, 9, 1, '2026-03-10');

-- ------------------------------------------------------------
-- EJ. 05 - Corregir y eliminar con seguridad
-- ------------------------------------------------------------
-- Verificar antes de corregir el precio
SELECT * FROM productos WHERE id_producto = 3;

UPDATE productos
SET precio = 690000
WHERE id_producto = 3;

-- Verificar antes de ajustar stock tras una venta
SELECT * FROM productos WHERE id_producto = 1;

UPDATE productos
SET stock = stock - 2
WHERE id_producto = 1;

-- Verificar antes de eliminar un registro creado por error
SELECT * FROM productos WHERE nombre = 'Mochila para Laptop';

DELETE FROM productos
WHERE id_producto = 10
  AND nombre = 'Mochila para Laptop';

-- ------------------------------------------------------------
-- EJ. 06 - Primera exploracion
-- ------------------------------------------------------------
-- Ver todos los productos
SELECT * FROM productos;

-- Mostrar solo nombre y precio
SELECT nombre, precio FROM productos;

-- Presentar el precio con un nombre de columna mas comprensible
SELECT nombre, precio AS precio_venta FROM productos;

-- ------------------------------------------------------------
-- EJ. 07 - Filtrar por una condicion
-- ------------------------------------------------------------
-- Productos con precio superior a un umbral
SELECT nombre, precio
FROM productos
WHERE precio > 500000;

-- Clientes de una ciudad concreta
SELECT nombre, ciudad
FROM clientes
WHERE ciudad = 'Cucuta';

-- Productos de una categoria determinada
SELECT nombre, categoria
FROM productos
WHERE categoria = 'Monitores';

-- ------------------------------------------------------------
-- EJ. 08 - Combinar condiciones
-- ------------------------------------------------------------
-- Productos de una categoria y por debajo de cierto precio
SELECT nombre, categoria, precio
FROM productos
WHERE categoria = 'Computadores'
  AND precio < 3000000;

-- Clientes de dos ciudades posibles
SELECT nombre, ciudad
FROM clientes
WHERE ciudad = 'Cucuta' OR ciudad = 'Bogota';

-- ------------------------------------------------------------
-- EJ. 09 - Buscar por rangos y texto
-- ------------------------------------------------------------
-- Productos dentro de un rango de precios
SELECT nombre, precio
FROM productos
WHERE precio BETWEEN 100000 AND 700000;

-- Productos de un conjunto de categorias
SELECT nombre, categoria
FROM productos
WHERE categoria IN ('Perifericos', 'Audio', 'Accesorios');

-- Productos cuyo nombre contenga una palabra indicada
SELECT nombre
FROM productos
WHERE nombre LIKE '%Laptop%';

-- ------------------------------------------------------------
-- EJ. 10 - Ordenar resultados
-- ------------------------------------------------------------
-- Del mas barato al mas caro
SELECT nombre, precio
FROM productos
ORDER BY precio ASC;

-- Del mayor stock al menor
SELECT nombre, stock
FROM productos
ORDER BY stock DESC;

-- Combinar un filtro con un ordenamiento
SELECT nombre, categoria, precio
FROM productos
WHERE categoria = 'Perifericos'
ORDER BY precio DESC;

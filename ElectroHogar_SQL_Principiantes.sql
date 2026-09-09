-- ============================================================
-- ELECTROHOGAR S.A. - SQL para Principiantes
-- MySQL 8.0+
-- ============================================================

CREATE DATABASE IF NOT EXISTS electrohogar;
USE electrohogar;

-- ============================================================
-- TABLAS (modelo corregido y completo con todas las FK del caso)
-- ============================================================

CREATE TABLE categorias (
  id_categoria   INT PRIMARY KEY AUTO_INCREMENT,
  nombre         VARCHAR(80) NOT NULL UNIQUE,
  descripcion    VARCHAR(255)
);

CREATE TABLE productos (
  id_producto    INT PRIMARY KEY AUTO_INCREMENT,
  nombre         VARCHAR(100) NOT NULL UNIQUE,
  precio         DECIMAL(10,2) NOT NULL CHECK (precio >= 0),
  stock          INT NOT NULL CHECK (stock >= 0),
  id_categoria   INT,
  fecha_registro DATE DEFAULT (CURRENT_DATE),
  FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

CREATE TABLE departamentos (
  id_departamento INT PRIMARY KEY AUTO_INCREMENT,
  nombre          VARCHAR(80) NOT NULL
);

CREATE TABLE empleados (
  id_empleado         INT PRIMARY KEY AUTO_INCREMENT,
  nombre              VARCHAR(100) NOT NULL,
  email               VARCHAR(150) UNIQUE,
  salario             DECIMAL(10,2) CHECK (salario >= 0),
  id_departamento     INT,
  fecha_contratacion  DATE DEFAULT (CURRENT_DATE),
  correo_corporativo  VARCHAR(150),
  FOREIGN KEY (id_departamento) REFERENCES departamentos(id_departamento)
);

CREATE TABLE clientes (
  id_cliente          INT PRIMARY KEY AUTO_INCREMENT,
  nombre              VARCHAR(100) NOT NULL,
  email               VARCHAR(150),
  ciudad              VARCHAR(60),
  fecha_registro      DATE DEFAULT (CURRENT_DATE),
  acepta_promociones  BOOLEAN,
  telefono            VARCHAR(20)
);

CREATE TABLE ventas (
  id_venta     INT PRIMARY KEY AUTO_INCREMENT,
  id_cliente   INT,
  id_empleado  INT,
  fecha        DATE NOT NULL,
  total        DECIMAL(12,2) NOT NULL CHECK (total >= 0),
  FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
  FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado)
);

CREATE TABLE detalle_ventas (
  id_detalle      INT PRIMARY KEY AUTO_INCREMENT,
  id_venta        INT,
  id_producto     INT,
  cantidad        INT NOT NULL CHECK (cantidad > 0),
  precio_unitario DECIMAL(10,2) NOT NULL CHECK (precio_unitario >= 0),
  FOREIGN KEY (id_venta) REFERENCES ventas(id_venta),
  FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- ============================================================
-- 2. TIPOS DE DATOS
-- ============================================================

-- Ejemplo (productos) ya cubierto arriba en la creacion de tablas.

-- Reto: CREATE TABLE clientes
-- (ya integrado en la tabla clientes de arriba, con telefono agregado despues)

-- ============================================================
-- 3. MODIFICADORES Y RESTRICCIONES
-- ============================================================

-- Ejemplo (productos) y Reto (empleados) ya integrados en las tablas de arriba.

-- ============================================================
-- 4. DDL
-- ============================================================

-- Ejemplo: crear departamentos y agregar columna a empleados
-- (ya integrado arriba)

-- Reto: eliminar tabla de prueba y agregar telefono a clientes
DROP TABLE IF EXISTS productos_prueba;

-- ALTER TABLE clientes ADD COLUMN telefono VARCHAR(20);
-- (ya integrado directamente en la definicion de la tabla clientes)

-- ============================================================
-- DATOS DE PRUEBA (necesarios para poder ejecutar las consultas)
-- ============================================================

INSERT INTO categorias (nombre, descripcion) VALUES
('Electrodomesticos', 'Linea blanca y electrodomesticos de hogar'),
('Tecnologia', 'Computadores, celulares y accesorios'),
('Audio', 'Equipos de sonido y audio');

INSERT INTO departamentos (nombre) VALUES
('Ventas'), ('Compras'), ('RR. HH.'), ('Contabilidad'), ('E-commerce');

INSERT INTO empleados (nombre, email, salario, id_departamento) VALUES
('Laura Gomez', 'laura.gomez@electrohogar.com', 2500000, 1),
('Carlos Perez', 'carlos.perez@electrohogar.com', 2800000, 1),
('Ana Ruiz', 'ana.ruiz@electrohogar.com', 3200000, 2);

INSERT INTO clientes (nombre, email, ciudad, acepta_promociones, telefono) VALUES
('Maria Torres', 'maria.torres@mail.com', 'Bogota', TRUE, '3001234567'),
('Jorge Diaz', 'jorge.diaz@mail.com', 'Bogota', FALSE, '3009876543'),
('Sofia Leon', 'sofia.leon@mail.com', 'Medellin', TRUE, '3011122233'),
('Pedro Nino', 'pedro.nino@mail.com', 'Bogota', TRUE, '3022233344'),
('Lucia Vargas', 'lucia.vargas@mail.com', 'Bogota', TRUE, '3033344455'),
('Andres Castro', 'andres.castro@mail.com', 'Cali', FALSE, '3044455566');

INSERT INTO productos (nombre, precio, stock, id_categoria) VALUES
('Refrigerador Inverter 400L', 1899.90, 15, 1),
('Lavadora Carga Frontal 18kg', 1499.50, 10, 1),
('Smart TV 55" 4K', 2199.00, 8, 2),
('Smartphone Galaxy Smart X', 1299.00, 20, 2),
('Parlante Bluetooth Smart Bass', 349000, 30, 3),
('Microondas Digital 25L', 549000, 12, 1);

-- ============================================================
-- 5. DML
-- ============================================================

-- Ejemplo: registrar producto nuevo y reflejar venta
INSERT INTO productos (nombre, precio, stock, id_categoria)
VALUES ('Congelador Vertical 250L', 1899.90, 15, 1);

UPDATE productos
SET stock = stock - 1
WHERE id_producto = 1;

-- Reto: corregir precio del producto 4 (ejemplo del id 310 -> se usa id existente 4)
UPDATE productos
SET precio = 549.00
WHERE id_producto = 4;

-- Reto: eliminar producto descontinuado (ejemplo del id 118 -> se usa id existente 6)
DELETE FROM productos
WHERE id_producto = 6;

-- ============================================================
-- 6. DQL
-- ============================================================

-- Ejemplo: productos con poco stock (< 10) para reponer
SELECT nombre, stock, precio
FROM productos
WHERE stock < 10
ORDER BY stock ASC;

-- Reto: 5 clientes mas recientes de Bogota
SELECT nombre, fecha_registro
FROM clientes
WHERE ciudad = 'Bogota'
ORDER BY fecha_registro DESC
LIMIT 5;

-- ============================================================
-- 7. OPERADORES
-- ============================================================

INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES
(1, 1, '2026-01-05', 620000),
(2, 2, '2026-01-15', 480000),
(3, 1, '2026-01-20', 750000),
(4, 2, '2026-02-01', 900000);

-- Ejemplo: ventas > $500.000 en enero de 2026
SELECT id_venta, fecha, total
FROM ventas
WHERE total > 500000
  AND fecha BETWEEN '2026-01-01' AND '2026-01-31'
ORDER BY fecha;

-- Reto: productos de categorias 'Electrodomesticos' o 'Tecnologia' que contengan 'Smart'
SELECT p.nombre, p.precio, c.nombre AS categoria
FROM productos p
JOIN categorias c ON p.id_categoria = c.id_categoria
WHERE c.nombre IN ('Electrodomesticos', 'Tecnologia')
  AND p.nombre LIKE '%Smart%';

-- ============================================================
-- 8. AGRUPACION Y AGREGACION
-- ============================================================

-- Ejemplo: total vendido por empleado
SELECT
  id_empleado,
  COUNT(*)   AS num_ventas,
  SUM(total) AS total_vendido
FROM ventas
GROUP BY id_empleado
ORDER BY total_vendido DESC;

-- Reto: categorias con precio promedio mayor a 300000
SELECT
  id_categoria,
  AVG(precio) AS precio_promedio
FROM productos
GROUP BY id_categoria
HAVING AVG(precio) > 300000;

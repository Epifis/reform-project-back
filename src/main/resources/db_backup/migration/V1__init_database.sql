-- ============================================
-- ELIMINAR TABLAS EXISTENTES (si existen)
-- ============================================
DROP TABLE IF EXISTS usuario_distribuidor CASCADE;
DROP TABLE IF EXISTS usuario_estacion CASCADE;
DROP TABLE IF EXISTS reporte CASCADE;
DROP TABLE IF EXISTS venta CASCADE;
DROP TABLE IF EXISTS regla_precio CASCADE;
DROP TABLE IF EXISTS normativa CASCADE;
DROP TABLE IF EXISTS entrega CASCADE;
DROP TABLE IF EXISTS distribuidor CASCADE;
DROP TABLE IF EXISTS inventario CASCADE;
DROP TABLE IF EXISTS estacion CASCADE;
DROP TABLE IF EXISTS vehiculo CASCADE;
DROP TABLE IF EXISTS usuario CASCADE;
DROP TABLE IF EXISTS combustible CASCADE;
DROP TABLE IF EXISTS tipo_vehiculo CASCADE;

-- ============================================
-- TABLA: tipo_vehiculo
-- ============================================
CREATE TABLE tipo_vehiculo (
    id SMALLINT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(200),
    activo BOOLEAN DEFAULT TRUE,
    orden_display SMALLINT DEFAULT 0
);

-- Insertar tipos de vehículo
INSERT INTO tipo_vehiculo (id, nombre, descripcion, orden_display) VALUES
(1, 'particular', 'Vehículos de uso particular', 1),
(2, 'diplomatico', 'Vehículos de cuerpo diplomático', 2),
(3, 'oficial', 'Vehículos oficiales del gobierno', 3),
(4, 'publico', 'Transporte público (buses, taxis)', 4),
(5, 'carga', 'Vehículos de carga (camiones)', 5),
(6, 'todos', 'Aplica a todos los tipos de vehículo', 0);

-- ============================================
-- TABLA: combustible
-- ============================================
CREATE TABLE combustible (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    precio_base DECIMAL(10,2) NOT NULL
);

-- ============================================
-- TABLA: usuario
-- ============================================
CREATE TABLE usuario (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL DEFAULT '',
    telefono VARCHAR(20),
    direccion TEXT,
    tipo_usuario VARCHAR(20) NOT NULL,
    enabled BOOLEAN NOT NULL DEFAULT false,
    confirmation_token VARCHAR(255)
);

-- ============================================
-- TABLA: vehiculo
-- ============================================
CREATE TABLE vehiculo (
    id SERIAL PRIMARY KEY,
    usuario_id INT NOT NULL,
    placa VARCHAR(20) UNIQUE NOT NULL,
    tipo_vehiculo_id SMALLINT NOT NULL,
    combustible_id INT NOT NULL,
    marca VARCHAR(100),
    modelo VARCHAR(100),

    CONSTRAINT fk_vehiculo_usuario
        FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE,
    
    CONSTRAINT fk_vehiculo_tipo
        FOREIGN KEY (tipo_vehiculo_id) REFERENCES tipo_vehiculo(id),
    
    CONSTRAINT fk_vehiculo_combustible
        FOREIGN KEY (combustible_id) REFERENCES combustible(id) ON DELETE RESTRICT
);

-- ============================================
-- TABLA: estacion
-- ============================================
CREATE TABLE estacion (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(150),
    ciudad VARCHAR(100),
    zona_regulada BOOLEAN DEFAULT FALSE
);

-- ============================================
-- TABLA: inventario
-- ============================================
CREATE TABLE inventario (
    id SERIAL PRIMARY KEY,
    estacion_id INT NOT NULL,
    combustible_id INT NOT NULL,
    cantidad_disponible DECIMAL(10,2) NOT NULL DEFAULT 0,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT unique_estacion_combustible UNIQUE(estacion_id, combustible_id),

    FOREIGN KEY (estacion_id) REFERENCES estacion(id) ON DELETE CASCADE,
    FOREIGN KEY (combustible_id) REFERENCES combustible(id) ON DELETE CASCADE
);

-- ============================================
-- TABLA: distribuidor
-- ============================================
CREATE TABLE distribuidor (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    zona_operacion VARCHAR(100)
);

-- ============================================
-- TABLA: entrega
-- ============================================
CREATE TABLE entrega (
    id SERIAL PRIMARY KEY,
    distribuidor_id INT NOT NULL,
    estacion_id INT NOT NULL,
    combustible_id INT NOT NULL,
    cantidad_entregada DECIMAL(10,2) NOT NULL,
    fecha_entrega TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (distribuidor_id) REFERENCES distribuidor(id) ON DELETE RESTRICT,
    FOREIGN KEY (estacion_id) REFERENCES estacion(id) ON DELETE RESTRICT,
    FOREIGN KEY (combustible_id) REFERENCES combustible(id) ON DELETE RESTRICT
);

-- ============================================
-- TABLA: normativa
-- ============================================
CREATE TABLE normativa (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT,
    aplica_subsidio BOOLEAN DEFAULT FALSE,
    porcentaje_ajuste DECIMAL(5,2),
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    activa BOOLEAN DEFAULT TRUE
);

-- ============================================
-- TABLA: regla_precio
-- ============================================
CREATE TABLE regla_precio (
    id SERIAL PRIMARY KEY,
    normativa_id INT NOT NULL,
    combustible_id INT NOT NULL,
    tipo_vehiculo_id SMALLINT NOT NULL,
    porcentaje_ajuste DECIMAL(5,2),

    CONSTRAINT unique_normativa_combustible_tipo UNIQUE(normativa_id, combustible_id, tipo_vehiculo_id),

    FOREIGN KEY (normativa_id) REFERENCES normativa(id) ON DELETE CASCADE,
    FOREIGN KEY (combustible_id) REFERENCES combustible(id) ON DELETE CASCADE,
    FOREIGN KEY (tipo_vehiculo_id) REFERENCES tipo_vehiculo(id)
);

-- ============================================
-- TABLA: venta
-- ============================================
CREATE TABLE venta (
    id SERIAL PRIMARY KEY,
    estacion_id INT NOT NULL,
    usuario_id INT,
    vehiculo_id INT,
    combustible_id INT NOT NULL,
    cantidad DECIMAL(10,2) NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    monto_total DECIMAL(10,2) NOT NULL,
    subsidio_aplicado BOOLEAN DEFAULT FALSE,
    fecha_venta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    normativa_id INT,

    FOREIGN KEY (estacion_id) REFERENCES estacion(id) ON DELETE RESTRICT,
    FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE SET NULL,
    FOREIGN KEY (vehiculo_id) REFERENCES vehiculo(id) ON DELETE SET NULL,
    FOREIGN KEY (combustible_id) REFERENCES combustible(id) ON DELETE RESTRICT,
    FOREIGN KEY (normativa_id) REFERENCES normativa(id) ON DELETE SET NULL
);

-- ============================================
-- TABLA: reporte
-- ============================================
CREATE TABLE reporte (
    id SERIAL PRIMARY KEY,
    estacion_id INT NOT NULL,
    fecha_generacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_ventas DECIMAL(12,2),
    total_combustible_vendido DECIMAL(12,2),
    detalles JSONB,

    FOREIGN KEY (estacion_id) REFERENCES estacion(id) ON DELETE CASCADE
);

-- ============================================
-- TABLA: usuario_estacion
-- ============================================
CREATE TABLE usuario_estacion (
    usuario_id INT PRIMARY KEY,
    estacion_id INT NOT NULL,

    FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE,
    FOREIGN KEY (estacion_id) REFERENCES estacion(id) ON DELETE CASCADE
);

-- ============================================
-- TABLA: usuario_distribuidor
-- ============================================
CREATE TABLE usuario_distribuidor (
    usuario_id INT PRIMARY KEY,
    distribuidor_id INT NOT NULL,

    FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE CASCADE,
    FOREIGN KEY (distribuidor_id) REFERENCES distribuidor(id) ON DELETE CASCADE
);

-- ============================================
-- ÍNDICES PARA OPTIMIZAR CONSULTAS
-- ============================================
CREATE INDEX idx_vehiculo_usuario ON vehiculo(usuario_id);
CREATE INDEX idx_vehiculo_tipo ON vehiculo(tipo_vehiculo_id);
CREATE INDEX idx_venta_estacion ON venta(estacion_id);
CREATE INDEX idx_venta_fecha ON venta(fecha_venta);
CREATE INDEX idx_venta_usuario ON venta(usuario_id);
CREATE INDEX idx_regla_normativa ON regla_precio(normativa_id);
CREATE INDEX idx_inventario_estacion ON inventario(estacion_id);
CREATE INDEX idx_entrega_fecha ON entrega(fecha_entrega);

-- ============================================
-- DATOS DE PRUEBA
-- ============================================

-- Combustibles
INSERT INTO combustible (nombre, precio_base) VALUES
('ACPM', 9500.00),
('Gasolina Corriente', 10500.00);

-- Estaciones de servicio
INSERT INTO estacion (nombre, direccion, ciudad, zona_regulada) VALUES
('Estación Centro', 'Calle 10 #20-30', 'Bogotá', TRUE),
('Estación Norte', 'Carrera 15 #100-50', 'Bogotá', FALSE);

-- Distribuidor mayorista
INSERT INTO distribuidor (nombre, zona_operacion) VALUES
('Distribuidor Nacional S.A.', 'Zona Centro');

-- Normativa: Decreto 1428/2025
INSERT INTO normativa (nombre, descripcion, aplica_subsidio, porcentaje_ajuste, fecha_inicio, fecha_fin, activa)
VALUES (
    'Decreto 1428/2025', 
    'Mecanismo diferencial de estabilización de precios del ACPM para vehículos particulares, diplomáticos y oficiales, excluyendo transporte público y carga.', 
    TRUE, 
    -5.00, 
    '2025-01-01', 
    NULL, 
    TRUE
);

-- Reglas de precio asociadas al decreto (aplica a ACPM para tipos específicos)
-- tipo_vehiculo_id: 1=particular, 2=diplomatico, 3=oficial
INSERT INTO regla_precio (normativa_id, combustible_id, tipo_vehiculo_id, porcentaje_ajuste)
VALUES 
    (1, 1, 1, -5.00),  -- particular
    (1, 1, 2, -5.00),  -- diplomatico
    (1, 1, 3, -5.00);  -- oficial

-- Usuario consumidor
INSERT INTO usuario (nombre, email, password, telefono, direccion, tipo_usuario, enabled) 
VALUES (
    'Juan Perez', 
    'juan@email.com', 
    '$2a$10$8Un1VRYxJXQzYvQvqLbYPO6qZqXqXqXqXqXqXqXqXqXqXqXqXqXq', -- password: "123456" encriptado con BCrypt
    '1234567', 
    'Calle 123', 
    'consumidor',
    true
);

-- Vehículo del consumidor
INSERT INTO vehiculo (usuario_id, placa, tipo_vehiculo_id, combustible_id, marca, modelo) 
VALUES (1, 'ABC123', 1, 1, 'Toyota', 'Hilux');

-- Usuario personal de estación
INSERT INTO usuario (nombre, email, password, telefono, direccion, tipo_usuario, enabled) 
VALUES (
    'Maria Gomez', 
    'maria@estacioncentro.com',
    '$2a$10$8Un1VRYxJXQzYvQvqLbYPO6qZqXqXqXqXqXqXqXqXqXqXqXqXqX',
    '7654321', 
    'Calle 10', 
    'estacion',
    true
);

-- Asignar usuario a estación
INSERT INTO usuario_estacion (usuario_id, estacion_id) VALUES (2, 1);

-- Usuario personal de distribuidor
INSERT INTO usuario (nombre, email, password, telefono, direccion, tipo_usuario, enabled) 
VALUES (
    'Carlos Ruiz', 
    'carlos@distribuidornacional.com',
    '$2a$10$8Un1VRYxJXQzYvQvqLbYPO6qZqXqXqXqXqXqXqXqXqXqXqXqXqX',
    '112233', 
    'Av. Siempre Viva', 
    'distribuidor',
    true
);

-- Asignar usuario a distribuidor
INSERT INTO usuario_distribuidor (usuario_id, distribuidor_id) VALUES (3, 1);

-- Inventario inicial en estación Centro
INSERT INTO inventario (estacion_id, combustible_id, cantidad_disponible) VALUES
(1, 1, 10000.00),
(1, 2, 5000.00),
(2, 1, 8000.00),
(2, 2, 6000.00);

-- Entrega de combustible a estación Centro
INSERT INTO entrega (distribuidor_id, estacion_id, combustible_id, cantidad_entregada) 
VALUES (1, 1, 1, 2000.00);

-- Venta de ejemplo con subsidio
INSERT INTO venta (estacion_id, usuario_id, vehiculo_id, combustible_id, cantidad, precio_unitario, monto_total, subsidio_aplicado, normativa_id)
VALUES (1, 1, 1, 1, 50.00, 9025.00, 451250.00, TRUE, 1); -- 9500 * 0.95 = 9025

-- Venta sin subsidio
INSERT INTO venta (estacion_id, usuario_id, vehiculo_id, combustible_id, cantidad, precio_unitario, monto_total, subsidio_aplicado)
VALUES (1, 1, 1, 2, 30.00, 10500.00, 315000.00, FALSE);

-- Reporte de ejemplo (usando JSONB de PostgreSQL)
INSERT INTO reporte (estacion_id, total_ventas, total_combustible_vendido, detalles) 
VALUES (
    1, 
    766250.00, 
    80.00, 
    '{"ventas": [{"combustible": "ACPM", "cantidad": 50, "monto": 451250}, {"combustible": "Gasolina Corriente", "cantidad": 30, "monto": 315000}]}'
);

-- ============================================
-- VERIFICACIÓN DE DATOS
-- ============================================
SELECT COUNT(*) FROM usuario;
-- SELECT COUNT(*) FROM vehiculo;
-- SELECT COUNT(*) FROM estacion;
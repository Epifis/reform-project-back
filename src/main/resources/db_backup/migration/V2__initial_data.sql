INSERT INTO combustible (nombre, precio_base) VALUES
('ACPM', 9500.00),
('Gasolina Corriente', 10500.00);

INSERT INTO estacion (nombre, direccion, ciudad, zona_regulada) VALUES
('Estación Centro', 'Calle 10 #20-30', 'Bogotá', TRUE),
('Estación Norte', 'Carrera 15 #100-50', 'Bogotá', FALSE);

INSERT INTO distribuidor (nombre, zona_operacion) VALUES
('Distribuidor Nacional S.A.', 'Zona Centro');

INSERT INTO normativa (nombre, descripcion, aplica_subsidio, porcentaje_ajuste, fecha_inicio, activa)
VALUES (
'Decreto 1428/2025',
'Mecanismo diferencial ACPM',
TRUE,
-5.00,
'2025-01-01',
TRUE
);
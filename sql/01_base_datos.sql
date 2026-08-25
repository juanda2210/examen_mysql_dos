CREATE DATABASE eventos_premier;
USE eventos_premier;

-- =========================================
-- 1. TABLA: encargados
-- =========================================
CREATE TABLE encargados (
    id_encargado INT AUTO_INCREMENT,
    nombre_completo VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    correo VARCHAR(100),

    PRIMARY KEY (id_encargado)
);


-- =========================================
-- 2. TABLA: salones
-- =========================================
CREATE TABLE salones (
    id_salon INT AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    capacidad INT NOT NULL,
    precio_hora DECIMAL(10,2) NOT NULL,
    estado ENUM('Disponible', 'En mantenimiento', 'Ocupado') NOT NULL DEFAULT 'Disponible',
    id_encargado INT NOT NULL,

    PRIMARY KEY (id_salon),

    CONSTRAINT fk_salon_encargado
        FOREIGN KEY (id_encargado)
        REFERENCES encargados(id_encargado)
);


-- =========================================
-- 3. TABLA: clientes
-- =========================================
CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT,
    nombre_completo VARCHAR(100) NOT NULL,
    identificacion VARCHAR(30) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    correo VARCHAR(100),
    tipo_cliente ENUM('Individual', 'Corporativo') NOT NULL,

    PRIMARY KEY (id_cliente)
);


-- =========================================
-- 4. TABLA: reservas
-- =========================================
CREATE TABLE reservas (
    id_reserva INT AUTO_INCREMENT,
    fecha_inicio DATETIME NOT NULL,
    fecha_fin DATETIME NOT NULL,
    horas DECIMAL(5,2) NOT NULL,
    total DECIMAL(12,2) NOT NULL,
    estado ENUM('Activa', 'Cancelada', 'Finalizada') NOT NULL DEFAULT 'Activa',
    id_cliente INT NOT NULL,
    id_salon INT NOT NULL,

    PRIMARY KEY (id_reserva),

    CONSTRAINT fk_reserva_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES clientes(id_cliente),

    CONSTRAINT fk_reserva_salon
        FOREIGN KEY (id_salon)
        REFERENCES salones(id_salon)
);


-- =========================================
-- 5. TABLA: pagos
-- =========================================
CREATE TABLE pagos (
    id_pago INT AUTO_INCREMENT,
    fecha_pago DATETIME NOT NULL,
    monto DECIMAL(12,2) NOT NULL,
    metodo_pago ENUM('Efectivo', 'Tarjeta', 'Transferencia') NOT NULL,
    id_reserva INT NOT NULL,

    PRIMARY KEY (id_pago),

    CONSTRAINT fk_pago_reserva
        FOREIGN KEY (id_reserva)
        REFERENCES reservas(id_reserva)
);


-- =========================================
-- 6. TABLA: auditoria_precios
-- =========================================
CREATE TABLE auditoria_precios (
    id_auditoria INT AUTO_INCREMENT,
    id_salon INT NOT NULL,
    usuario VARCHAR(100) NOT NULL,
    fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    valor_anterior DECIMAL(10,2) NOT NULL,
    valor_nuevo DECIMAL(10,2) NOT NULL,

    PRIMARY KEY (id_auditoria),

    CONSTRAINT fk_auditoria_salon
        FOREIGN KEY (id_salon)
        REFERENCES salones(id_salon)
);


-- CONTENIDO DE LAS TABLAS



USE eventos_premier;


-- =========================================
-- 1. ENCARGADOS
-- =========================================

INSERT INTO encargados (nombre_completo, telefono, correo) VALUES
('Carlos Martínez', '3004567891', 'carlos.martinez@eventospremier.com'),
('Laura Gómez', '3015678902', 'laura.gomez@eventospremier.com'),
('Andrés Rodríguez', '3026789013', 'andres.rodriguez@eventospremier.com'),
('Valentina Pérez', '3037890124', 'valentina.perez@eventospremier.com');


-- =========================================
-- 2. SALONES
-- =========================================

INSERT INTO salones 
(nombre, capacidad, precio_hora, estado, id_encargado) VALUES

('Salón Imperial', 100, 150000.00, 'Disponible', 1),
('Salón París', 50, 90000.00, 'Disponible', 2),
('Salón Real', 200, 250000.00, 'En mantenimiento', 3),
('Salón Ejecutivo', 80, 120000.00, 'Disponible', 4),
('Salón Gran Colombia', 150, 200000.00, 'Disponible', 1),
('Salón Diamante', 300, 350000.00, 'En mantenimiento', 2);


-- =========================================
-- 3. CLIENTES
-- =========================================

INSERT INTO clientes
(nombre_completo, identificacion, telefono, correo, tipo_cliente) VALUES

('Juan David Arias', '1001001001', '3101234567', 'juan.arias@gmail.com', 'Individual'),
('María Fernanda López', '1002002002', '3112345678', 'maria.lopez@gmail.com', 'Individual'),
('Empresa Tech Solutions S.A.S.', '9001001001', '3203456789', 'contacto@techsolutions.com', 'Corporativo'),
('Corporación Educativa del Norte', '9002002002', '3214567890', 'administracion@cen.edu.co', 'Corporativo'),
('Carlos Andrés Torres', '1003003003', '3125678901', 'carlos.torres@gmail.com', 'Individual'),
('Eventos Corporativos S.A.', '9003003003', '3226789012', 'reservas@eventoscorp.com', 'Corporativo'),
('Grupo Empresarial Andino', '9004004004', '3237890123', 'contacto@grupoandino.com', 'Corporativo'),
('Sofía Ramírez', '1004004004', '3138901234', 'sofia.ramirez@gmail.com', 'Individual');


-- =========================================
-- 4. RESERVAS
-- =========================================

INSERT INTO reservas
(fecha_inicio, fecha_fin, horas, total, estado, id_cliente, id_salon) VALUES

-- Cliente 1 - Juan David
('2026-08-20 14:00:00', '2026-08-20 18:00:00', 4, 714000.00, 'Finalizada', 1, 1),

-- Cliente 2 - María Fernanda
('2026-08-21 09:00:00', '2026-08-21 13:00:00', 4, 428400.00, 'Finalizada', 2, 2),

-- Cliente 3 - Tech Solutions - Reserva 1
('2026-08-22 08:00:00', '2026-08-22 14:00:00', 6, 1071000.00, 'Finalizada', 3, 4),

-- Cliente 3 - Tech Solutions - Reserva 2
('2026-08-25 14:00:00', '2026-08-25 18:00:00', 4, 714000.00, 'Finalizada', 3, 1),

-- Cliente 3 - Tech Solutions - Reserva 3
('2026-08-28 09:00:00', '2026-08-28 15:00:00', 6, 857400.00, 'Activa', 3, 2),

-- Cliente 3 - Tech Solutions - Reserva 4
('2026-09-02 08:00:00', '2026-09-02 12:00:00', 4, 571200.00, 'Activa', 3, 4),

-- Cliente 3 - Tech Solutions - Reserva 5
('2026-09-05 14:00:00', '2026-09-05 20:00:00', 6, 1285200.00, 'Activa', 3, 5),

-- Cliente 4 - Corporación Educativa - Reserva 1
('2026-08-23 08:00:00', '2026-08-23 12:00:00', 4, 952000.00, 'Finalizada', 4, 5),

-- Cliente 4 - Corporación Educativa - Reserva 2
('2026-08-30 14:00:00', '2026-08-30 18:00:00', 4, 952000.00, 'Activa', 4, 5),

-- Cliente 5 - Carlos Andrés
('2026-08-24 10:00:00', '2026-08-24 13:00:00', 3, 428400.00, 'Finalizada', 5, 4),

-- Cliente 6 - Eventos Corporativos - Reserva 1
('2026-08-26 08:00:00', '2026-08-26 16:00:00', 8, 1428000.00, 'Finalizada', 6, 1),

-- Cliente 6 - Eventos Corporativos - Reserva 2
('2026-09-01 09:00:00', '2026-09-01 14:00:00', 5, 714000.00, 'Activa', 6, 2),

-- Cliente 6 - Eventos Corporativos - Reserva 3
('2026-09-04 13:00:00', '2026-09-04 18:00:00', 5, 714000.00, 'Activa', 6, 4),

-- Cliente 6 - Eventos Corporativos - Reserva 4
('2026-09-07 08:00:00', '2026-09-07 14:00:00', 6, 1428000.00, 'Activa', 6, 5),

-- Cliente 7 - Grupo Empresarial Andino
('2026-08-27 09:00:00', '2026-08-27 13:00:00', 4, 714000.00, 'Finalizada', 7, 1);


-- =========================================
-- 5. PAGOS
-- =========================================

INSERT INTO pagos
(fecha_pago, monto, metodo_pago, id_reserva) VALUES

('2026-08-18 10:30:00', 714000.00, 'Transferencia', 1),

('2026-08-19 09:15:00', 428400.00, 'Tarjeta', 2),

('2026-08-20 11:00:00', 1071000.00, 'Transferencia', 3),

('2026-08-23 15:30:00', 714000.00, 'Tarjeta', 4),

('2026-08-25 10:00:00', 428700.00, 'Transferencia', 5),

('2026-08-27 14:20:00', 571200.00, 'Tarjeta', 6),

('2026-08-29 16:00:00', 642600.00, 'Transferencia', 7),

('2026-08-21 12:00:00', 952000.00, 'Transferencia', 8),

('2026-08-28 10:45:00', 500000.00, 'Tarjeta', 9),

('2026-08-22 09:30:00', 428400.00, 'Efectivo', 10),

('2026-08-24 13:00:00', 1428000.00, 'Transferencia', 11),

('2026-08-30 11:15:00', 714000.00, 'Tarjeta', 12),

('2026-09-01 10:00:00', 714000.00, 'Transferencia', 13),

('2026-09-03 09:20:00', 714000.00, 'Transferencia', 14),

('2026-08-26 14:30:00', 714000.00, 'Efectivo', 15);


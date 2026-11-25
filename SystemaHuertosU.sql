CREATE DATABASE gestion_huertos;
USE gestion_huertos;

CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    telefono VARCHAR(20),
    fecha_nacimiento DATE,
    genero ENUM('M', 'F', 'Otro') DEFAULT 'Otro'
);
INSERT INTO usuarios (nombre, apellido, email, telefono, fecha_nacimiento, genero) VALUES
('Alessandro', 'Aguayo', 'alessandro.aguayo@email.com', '70000001', '2000-01-15', 'M'),
('Maximo Javier', 'Quispe Cruz', 'maximo.quispe@email.com', '70000002', '1999-05-22', 'M'),
('Joel', 'Huanca Poma', 'joel.huanca@email.com', '70000003', '2001-08-10', 'M'),
('Abigail Yesenia', 'Huanca Poma', 'abigail.huanca@email.com', '70000004', '2002-03-18', 'F'),
('Pablo Angel', 'Churata Pablo', 'pablo.churata@email.com', '70000005', '1998-11-30', 'M');


--Tabla Huertos
CREATE TABLE IF NOT EXISTS huertos (
    id_huerto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    ubicacion VARCHAR(150) NOT NULL,
    superficie_total_m2 DECIMAL(10,2) NOT NULL,
    fecha_registro DATE DEFAULT (CURRENT_DATE)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--Tabla Parcelas (relacionada con Huertos)
CREATE TABLE IF NOT EXISTS parcelas (
    id_parcela INT AUTO_INCREMENT PRIMARY KEY,
    id_huerto INT NOT NULL,
    codigo_parcela VARCHAR(20) NOT NULL UNIQUE,
    area_m2 DECIMAL(8,2) NOT NULL,
    tipo_suelo VARCHAR(50),
    disponible BOOLEAN DEFAULT TRUE,
    CONSTRAINT fk_parcela_huerto 
        FOREIGN KEY (id_huerto) REFERENCES huertos(id_huerto) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--Datos de prueba
INSERT INTO huertos (nombre, ubicacion, superficie_total_m2) VALUES 
('Huerto Comunitario Don Musk', 'Zona Sur - Sector A, Calle 12', 500.00),
('Huerto Urbano El Mirador', 'Zona Norte - Av. Principal #45', 320.50),
('Huerto Ecológico La Pradera', 'Distrito Central - Parque Sur', 410.00);

INSERT INTO parcelas (id_huerto, codigo_parcela, area_m2, tipo_suelo, disponible) VALUES 
(1, 'P-MUSK-01', 25.00, 'Franco-arenoso', FALSE),
(1, 'P-MUSK-02', 25.00, 'Franco-arenoso', TRUE),
(1, 'P-MUSK-03', 30.00, 'Humífero', TRUE),
(2, 'P-MIR-01', 35.00, 'Arcilloso', FALSE),
(2, 'P-MIR-02', 35.00, 'Franco', TRUE),
(3, 'P-PRA-01', 40.00, 'Humífero', TRUE);



--MÓDULO 3: COSECHAS E HISTORIAL (Integrante 4)
--Depende de: siembras, parcelas, huertos, cultivos


-- Tabla cosechas (relacionada con siembras)
CREATE TABLE IF NOT EXISTS cosechas (
    id_cosecha         INT AUTO_INCREMENT PRIMARY KEY,
    id_siembra         INT NOT NULL,
    fecha_cosecha      DATE NOT NULL,
    cantidad_cosechada DECIMAL(10,2) NOT NULL,
    unidad             VARCHAR(20) DEFAULT 'kg',
    observaciones      VARCHAR(255),
    CONSTRAINT fk_cosecha_siembra
        FOREIGN KEY (id_siembra) REFERENCES siembras(id_siembra)
        ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Datos de prueba (ajustar id_siembra a los reales)
INSERT INTO cosechas (id_siembra, fecha_cosecha, cantidad_cosechada, unidad, observaciones) VALUES
(1, '2026-10-15', 45.50, 'kg', 'Primera cosecha de Musk Melon, buena calidad'),
(1, '2026-10-29', 38.00, 'kg', 'Segunda cosecha Musk Melon'),
(2, '2026-10-20', 12.75, 'kg', 'Cosecha en parcela musk');

-- Consulta: historial de cosechas por parcela
SELECT
    p.id_parcela,
    p.codigo_parcela AS parcela,
    h.nombre         AS huerto,
    c.nombre         AS cultivo,
    s.fecha_siembra,
    co.fecha_cosecha,
    co.cantidad_cosechada,
    co.unidad
FROM cosechas co
JOIN siembras s ON co.id_siembra = s.id_siembra
JOIN parcelas p ON s.id_parcela  = p.id_parcela
JOIN huertos  h ON p.id_huerto   = h.id_huerto
JOIN cultivos c ON s.id_cultivo  = c.id_cultivo
WHERE p.id_parcela = 1
ORDER BY co.fecha_cosecha DESC;

-- Consulta: total cosechado por parcela
SELECT p.codigo_parcela AS parcela, SUM(co.cantidad_cosechada) AS total_kg
FROM cosechas co
JOIN siembras s ON co.id_siembra = s.id_siembra
JOIN parcelas p ON s.id_parcela = p.id_parcela
GROUP BY p.id_parcela, p.codigo_parcela;
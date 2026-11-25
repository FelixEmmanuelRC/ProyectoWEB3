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




-- MÓDULO 2: CATÁLOGO DE CULTIVOS Y SIEMBRAS
-- Responsable: Integrante 3

CREATE TABLE IF NOT EXISTS cultivos (
    id_cultivo INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    variedad VARCHAR(100),
    dias_cosecha INT NOT NULL DEFAULT 60,
    descripcion VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS siembras (
    id_siembra INT AUTO_INCREMENT PRIMARY KEY,
    id_parcela INT NOT NULL,
    id_cultivo INT NOT NULL,
    id_usuario INT NULL,
    fecha_siembra DATE NOT NULL,
    fecha_estimada_cosecha DATE NULL,
    estado ENUM('activa', 'cosechada', 'cancelada') DEFAULT 'activa',
    observaciones VARCHAR(255),
    CONSTRAINT fk_siembras_parcelas
        FOREIGN KEY (id_parcela) REFERENCES parcelas(id_parcela)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_siembras_cultivos
        FOREIGN KEY (id_cultivo) REFERENCES cultivos(id_cultivo)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_siembras_usuarios
        FOREIGN KEY (id_usuario) REFERENCES usuarios(id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO cultivos (nombre, variedad, dias_cosecha, descripcion) VALUES
('Musk Melon', 'Melón Cantalupo', 75, 'Cultivo de clima templado y buen drenaje'),
('Tomate', 'Cherry / Saladette', 70, 'Hortaliza de fruto con tutorado'),
('Lechuga', 'Crespa verde', 45, 'Hortaliza de hoja de ciclo corto'),
('Zanahoria', 'Nantesa', 80, 'Raíz tubércula en suelo suelto');

INSERT INTO siembras (id_parcela, id_cultivo, id_usuario, fecha_siembra, fecha_estimada_cosecha, estado, observaciones) VALUES
(1, 1, 1, '2026-08-01', '2026-10-15', 'activa', 'Siembra principal en parcela P-MUSK-01'),
(4, 1, 2, '2026-08-05', '2026-10-20', 'activa', 'Siembra secundaria en parcela P-MIR-01'),
(2, 3, 3, '2026-09-10', '2026-10-25', 'activa', 'Ciclo corto de lechuga');

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
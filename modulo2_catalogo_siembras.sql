USE gestion_huertos;

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

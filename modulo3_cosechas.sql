
-- MÓDULO 3: COSECHAS E HISTORIAL
-- Responsable: Integrante 4
-- Requiere: huertos, parcelas, cultivos, siembras
-- 1. TABLA COSECHAS
CREATE TABLE IF NOT EXISTS cosechas (
    id_cosecha         INT AUTO_INCREMENT PRIMARY KEY,
    id_siembra         INT NOT NULL,
    fecha_cosecha      DATE NOT NULL,
    cantidad_cosechada DECIMAL(10,2) NOT NULL,
    unidad             VARCHAR(20) DEFAULT 'kg',
    observaciones      VARCHAR(255),
    CONSTRAINT fk_cosechas_siembras
        FOREIGN KEY (id_siembra) REFERENCES siembras(id_siembra)
        ON DELETE CASCADE
);
-- 2. DATOS DE PRUEBA
INSERT INTO cosechas (id_siembra, fecha_cosecha, cantidad_cosechada, unidad, observaciones) VALUES
(1, '2026-10-15', 45.50, 'kg', 'Primera cosecha de Musk Melon, buena calidad'),
(1, '2026-10-29', 38.00, 'kg', 'Segunda cosecha Musk Melon'),
(2, '2026-10-20', 12.75, 'kg', 'Cosecha en parcela musk norte');
-- 3. CONSULTA: HISTORIAL POR PARCELA
SELECT 
    p.id_parcela,
    p.nombre AS parcela,
    h.nombre AS huerto,
    c.nombre AS cultivo,
    s.fecha_siembra,
    co.fecha_cosecha,
    co.cantidad_cosechada,
    co.unidad
FROM cosechas co
JOIN siembras s ON co.id_siembra = s.id_siembra
JOIN parcelas p ON s.id_parcela = p.id_parcela
JOIN huertos h  ON p.id_huerto = h.id_huerto
JOIN cultivos c ON s.id_cultivo = c.id_cultivo
WHERE p.id_parcela = 1
ORDER BY co.fecha_cosecha DESC;
-- 4. TOTAL COSECHADO POR PARCELA
SELECT p.nombre AS parcela, SUM(co.cantidad_cosechada) AS total_kg
FROM cosechas co
JOIN siembras s ON co.id_siembra = s.id_siembra
JOIN parcelas p ON s.id_parcela = p.id_parcela
GROUP BY p.id_parcela, p.nombre;
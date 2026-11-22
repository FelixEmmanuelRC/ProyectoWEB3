
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
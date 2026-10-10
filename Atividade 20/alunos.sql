
CREATE DATABASE IF NOT EXISTS escola_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE escola_db;

DROP TABLE IF EXISTS alunos;
CREATE TABLE alunos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    nota DECIMAL(4,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO alunos (nome, nota) VALUES
('Ana Souza', 8.50),
('Bruno Lima', 6.00),
('Carlos Mendes', 7.00),
('Daniel Oliveira', 5.50),
('Eduarda Santos', 9.00),
('Felipe Albuquerque', 6.80);

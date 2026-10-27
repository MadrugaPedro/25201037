CREATE TABLE IF NOT EXISTS voos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(10) NOT NULL,
    origem VARCHAR(50) NOT NULL,
    destino VARCHAR(50) NOT NULL,
    partida DATETIME NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE voos
    ADD COLUMN deleted_at DATETIME NULL DEFAULT NULL;

CREATE INDEX idx_voos_deleted_at ON voos (deleted_at);

ALTER TABLE voos
    ADD COLUMN ativo_flag TINYINT GENERATED ALWAYS AS (IF(deleted_at IS NULL, 1, NULL)) VIRTUAL,
    ADD CONSTRAINT uq_voos_codigo_ativo UNIQUE (codigo, ativo_flag);

CREATE TABLE IF NOT EXISTS auditoria (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    tabela VARCHAR(50) NOT NULL,
    registro_id INT NOT NULL,
    acao VARCHAR(20) NOT NULL,
    usuario_id INT NOT NULL,
    dados_antes JSON NULL,
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_auditoria_tabela_registro (tabela, registro_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE DATABASE IF NOT EXISTS aeroporto_dw CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE aeroporto_dw;

DROP TABLE IF EXISTS fato_voo;
DROP TABLE IF EXISTS dim_tempo;
DROP TABLE IF EXISTS dim_destino;
DROP TABLE IF EXISTS dim_companhia;
DROP TABLE IF EXISTS dim_aeroporto;
DROP TABLE IF EXISTS tabela_controle;

CREATE TABLE dim_tempo (
    sk_tempo    INT AUTO_INCREMENT PRIMARY KEY,
    data_hora   DATETIME NOT NULL,
    data        DATE NOT NULL,
    ano         SMALLINT NOT NULL,
    mes         TINYINT NOT NULL,
    ano_mes     CHAR(7) NOT NULL,
    dia         TINYINT NOT NULL,
    dia_semana  VARCHAR(15) NOT NULL,
    hora        TINYINT NOT NULL,
    UNIQUE KEY uq_tempo_data_hora (data_hora),
    KEY ix_tempo_ano_mes (ano, mes)
);

CREATE TABLE dim_destino (
    sk_destino   INT AUTO_INCREMENT PRIMARY KEY,
    codigo_iata  VARCHAR(10) NOT NULL,
    nome_cidade  VARCHAR(100) NOT NULL,
    UNIQUE KEY uq_destino_codigo (codigo_iata)
);

CREATE TABLE dim_companhia (
    sk_companhia     INT AUTO_INCREMENT PRIMARY KEY,
    codigo_iata      VARCHAR(10) NOT NULL,
    nome_companhia   VARCHAR(60) NOT NULL,
    UNIQUE KEY uq_companhia_codigo (codigo_iata)
);

CREATE TABLE dim_aeroporto (
    sk_aeroporto    INT AUTO_INCREMENT PRIMARY KEY,
    codigo_iata     VARCHAR(10) NOT NULL,
    nome_aeroporto  VARCHAR(80) NOT NULL,
    UNIQUE KEY uq_aeroporto_codigo (codigo_iata)
);

CREATE TABLE tabela_controle (
    nome           VARCHAR(50) PRIMARY KEY,
    ultimo_id      INT NOT NULL DEFAULT 0,
    atualizado_em  DATETIME NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO tabela_controle (nome, ultimo_id) VALUES ('voo', 0);

CREATE TABLE fato_voo (
    sk_fato        BIGINT AUTO_INCREMENT PRIMARY KEY,
    voo_id_oltp    INT NOT NULL,
    numero_voo     VARCHAR(20) NOT NULL,
    sk_tempo       INT NOT NULL,
    sk_destino     INT NOT NULL,
    sk_companhia   INT NOT NULL,
    sk_aeroporto   INT NOT NULL,
    qtd_voos       TINYINT UNSIGNED NOT NULL DEFAULT 1,
    passageiros    INT UNSIGNED NULL,
    UNIQUE KEY uq_fato_voo_oltp (voo_id_oltp),
    KEY ix_fato_tempo (sk_tempo),
    KEY ix_fato_destino (sk_destino),
    KEY ix_fato_companhia (sk_companhia),
    KEY ix_fato_aeroporto (sk_aeroporto),
    CONSTRAINT fk_fato_tempo FOREIGN KEY (sk_tempo) REFERENCES dim_tempo (sk_tempo),
    CONSTRAINT fk_fato_destino FOREIGN KEY (sk_destino) REFERENCES dim_destino (sk_destino),
    CONSTRAINT fk_fato_companhia FOREIGN KEY (sk_companhia) REFERENCES dim_companhia (sk_companhia),
    CONSTRAINT fk_fato_aeroporto FOREIGN KEY (sk_aeroporto) REFERENCES dim_aeroporto (sk_aeroporto)
);

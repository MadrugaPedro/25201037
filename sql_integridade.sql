CREATE DATABASE IF NOT EXISTS aeroporto;
USE aeroporto;

-- 1. Criação da Tabela Passageiro
CREATE TABLE passageiro (
    id_passageiro INT AUTO_INCREMENT PRIMARY KEY,
    cpf VARCHAR(11) NOT NULL UNIQUE,          -- Integridade: Unicidade do documento
    nome VARCHAR(100) NOT NULL,               -- Integridade: Obrigatoriedade
    data_nascimento DATE NOT NULL
) ENGINE=InnoDB;

-- 2. Criação da Tabela Aeronave
CREATE TABLE aeronave (
    id_aeronave INT AUTO_INCREMENT PRIMARY KEY,
    modelo VARCHAR(50) NOT NULL,
    capacidade INT NOT NULL,
    -- Regra de Negócio: Avião deve ter capacidade operacional positiva
    CONSTRAINT chk_capacidade CHECK (capacidade > 0)
) ENGINE=InnoDB;

-- 3. Criação da Tabela Voo
CREATE TABLE voo (
    id_voo INT AUTO_INCREMENT PRIMARY KEY,
    id_aeronave INT NOT NULL,
    origem VARCHAR(50) NOT NULL,
    destino VARCHAR(50) NOT NULL,
    data_hora_partida DATETIME NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Agendado',
    
    -- Integridade Referencial
    CONSTRAINT fk_voo_aeronave FOREIGN KEY (id_aeronave) 
        REFERENCES aeronave(id_aeronave) 
        ON DELETE RESTRICT      -- Não permite apagar aeronave com voos vinculados
        ON UPDATE CASCADE,      -- Se a chave da aeronave alterar, atualiza em cascata
        
    -- Regra de Negócio: Restrição de Domínio para estados do voo
    CONSTRAINT chk_status_voo CHECK (status IN ('Agendado', 'Em voo', 'Atrasado', 'Cancelado', 'Concluído'))
) ENGINE=InnoDB;

-- 4. Criação da Tabela Passagem
CREATE TABLE passagem (
    id_passagem INT AUTO_INCREMENT PRIMARY KEY,
    id_voo INT NOT NULL,
    id_passageiro INT NOT NULL,
    assento VARCHAR(10) NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    data_compra DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    -- Integridade Referencial
    CONSTRAINT fk_passagem_voo FOREIGN KEY (id_voo) 
        REFERENCES voo(id_voo) 
        ON DELETE CASCADE       -- Se o voo for excluído, cancela/apaga os bilhetes emitidos
        ON UPDATE CASCADE,
    CONSTRAINT fk_passagem_passageiro FOREIGN KEY (id_passageiro) 
        REFERENCES passageiro(id_passageiro) 
        ON DELETE RESTRICT      -- Não permite deletar passageiro com passagens compradas
        ON UPDATE CASCADE,
        
    -- Regras de Negócio
    -- Evita duplicidade de assento no mesmo voo
    CONSTRAINT uk_voo_assento UNIQUE (id_voo, assento),
    -- Garante que a passagem não tenha valor financeiro negativo ou nulo
    CONSTRAINT chk_valor CHECK (valor > 0)
) ENGINE=InnoDB;

-- =============================================
-- Sistema de Orçamentos - Eletrica.com
-- Banco de Dados Normalizado até 3FN
-- =============================================

DROP DATABASE IF EXISTS eletrica_com;
CREATE DATABASE eletrica_com CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE eletrica_com;

-- Tabelas principais
CREATE TABLE Cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    cpf_cnpj VARCHAR(18) NOT NULL UNIQUE,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(150),
    telefone VARCHAR(20),
    email VARCHAR(100),
    data_cadastro DATE DEFAULT (CURRENT_DATE)
);

CREATE TABLE Servico (
    id_servico INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(200) NOT NULL,
    valor_mao_obra_hora DECIMAL(10,2) NOT NULL,
    tempo_estimado_horas DECIMAL(6,2)
);

CREATE TABLE Material (
    id_material INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(20) UNIQUE,
    descricao VARCHAR(200) NOT NULL,
    unidade_medida VARCHAR(10) NOT NULL,
    valor_unitario DECIMAL(10,2) NOT NULL
);

CREATE TABLE Orcamento (
    id_orcamento INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    data_emissao DATE DEFAULT (CURRENT_DATE),
    data_validade DATE,
    valor_total DECIMAL(12,2) DEFAULT 0.00,
    status ENUM('Pendente', 'Aprovado', 'Rejeitado') DEFAULT 'Pendente',
    observacoes TEXT,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente) ON DELETE RESTRICT
);

-- Tabela de itens (resolve N:N entre Orçamento ↔ Serviço e Orçamento ↔ Material)
CREATE TABLE Item_Orcamento (
    id_item INT AUTO_INCREMENT PRIMARY KEY,
    id_orcamento INT NOT NULL,
    tipo_item ENUM('Serviço', 'Material') NOT NULL,
    id_servico INT NULL,
    id_material INT NULL,
    quantidade DECIMAL(10,3) NOT NULL,
    valor_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(12,2) AS (quantidade * valor_unitario) STORED,
    
    FOREIGN KEY (id_orcamento) REFERENCES Orcamento(id_orcamento) ON DELETE CASCADE,
    FOREIGN KEY (id_servico) REFERENCES Servico(id_servico) ON DELETE RESTRICT,
    FOREIGN KEY (id_material) REFERENCES Material(id_material) ON DELETE RESTRICT,
    
    CONSTRAINT chk_um_dos_dois_not_null 
        CHECK ((id_servico IS NOT NULL AND id_material IS NULL) OR 
               (id_servico IS NULL AND id_material IS NOT NULL))
);

-- Índices para performance
CREATE INDEX idx_orcamento_cliente ON Orcamento(id_cliente);
CREATE INDEX idx_item_orcamento ON Item_Orcamento(id_orcamento);
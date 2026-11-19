-- 1. Tabela de Beneficiários
CREATE TABLE IF NOT EXISTS boleto_beneficiario (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    cnpj VARCHAR(20) NOT NULL,
    endereco VARCHAR(200),
    agencia_codigo VARCHAR(30)
);

-- 2. Tabela de Pagadores (Sacados)
CREATE TABLE IF NOT EXISTS boleto_pagador (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    cnpj_cpf VARCHAR(20) NOT NULL,
    endereco VARCHAR(200)
);

-- 3. Tabela Principal do Boleto (Título)
CREATE TABLE IF NOT EXISTS boleto_cobranca (
    id SERIAL PRIMARY KEY,
    banco_codigo VARCHAR(10) DEFAULT '001-9',
    beneficiario_id INT NOT NULL,
    pagador_id INT NOT NULL,
    
    -- Dados do Título
    numero_documento VARCHAR(30) NOT NULL,
    nosso_numero VARCHAR(30) NOT NULL,
    linha_digitavel VARCHAR(100),
    valor_documento DECIMAL(12,2) NOT NULL,
    data_vencimento DATE NOT NULL,
    data_documento DATE,
    data_processamento DATE,
    
    -- Detalhes operacionais
    carteira VARCHAR(10),
    especie_documento VARCHAR(10) DEFAULT 'DM',
    aceite VARCHAR(2) DEFAULT 'S',
    instrucoes TEXT,
    
    FOREIGN KEY (beneficiario_id) REFERENCES boleto_beneficiario(id),
    FOREIGN KEY (pagador_id) REFERENCES boleto_pagador(id)
);

-- =======
-- Tabela de Clientes (Cobrança e Envio)
CREATE TABLE IF NOT EXISTS cliente_fatura (
    id SERIAL PRIMARY KEY,
    id_cliente_codigo VARCHAR(20) UNIQUE NOT NULL, -- Ex: A246
    atencao_departamento VARCHAR(100),
    nome_empresa VARCHAR(150) NOT NULL,
    endereco VARCHAR(150),
    cidade_uf_cep VARCHAR(100),
    telefone VARCHAR(30),
    email VARCHAR(100)
);

-- Tabela Principal da Fatura (Cabeçalho)
CREATE TABLE IF NOT EXISTS fatura_cobranca (
    id SERIAL PRIMARY KEY,
    numero_fatura VARCHAR(30) UNIQUE NOT NULL, -- Ex: 100001
    data_emissao DATE NOT NULL,
    condicoes_pagamento VARCHAR(50), -- Ex: Venc. em 30 dias
    cliente_cobranca_id INT,
    cliente_envio_id INT,
    subtotal DECIMAL(12,2) NOT NULL,
    percentual_imposto DECIMAL(5,2) DEFAULT 3.80,
    valor_imposto DECIMAL(12,2) NOT NULL,
    valor_total DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (cliente_cobranca_id) REFERENCES cliente_fatura(id),
    FOREIGN KEY (cliente_envio_id) REFERENCES cliente_fatura(id)
);

-- Tabela de Itens da Fatura
CREATE TABLE IF NOT EXISTS fatura_itens (
    id SERIAL PRIMARY KEY,
    fatura_id INT NOT NULL,
    descricao TEXT NOT NULL,
    quantidade DECIMAL(10,2) NOT NULL,
    preco_unitario DECIMAL(12,2) NOT NULL,
    valor_total DECIMAL(12,2) GENERATED ALWAYS AS (quantidade * preco_unitario) STORED,
    FOREIGN KEY (fatura_id) REFERENCES fatura_cobranca(id) ON DELETE CASCADE
);


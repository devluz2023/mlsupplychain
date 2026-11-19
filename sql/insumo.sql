-- ==========================================
-- 1. MÓDULO DE NECESSIDADE DE DEMANDA (MRP / Previsão)
-- ==========================================

CREATE TABLE IF NOT EXISTS necessidade_demanda (
    id SERIAL PRIMARY KEY,
    produto_id BIGINT UNSIGNED NOT NULL,
    quantidade_necessaria DECIMAL(12,4) NOT NULL,
    data_necessidade DATE NOT NULL,
    origem_demanda VARCHAR(50) NOT NULL, -- Ex: 'PREVISAO_VENDAS', 'ORDEM_PRODUCAO', 'MRP'
    status_demanda VARCHAR(30) DEFAULT 'ABERTO', -- ABERTO, ATENDIDO, CANCELADO
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (produto_id) REFERENCES produtos(id)
);

-- ==========================================
-- 2. MÓDULO DE AGENDAMENTO (Docas, Entregas ou Visitas)
-- ==========================================

CREATE TABLE IF NOT EXISTS agendamentos (
    id SERIAL PRIMARY KEY,
    tipo_agendamento VARCHAR(30) NOT NULL, -- Ex: 'RECEBIMENTO_FORNECEDOR', 'EXPEDICAO_CLIENTE'
    entidade_nome VARCHAR(150) NOT NULL, -- Nome do Fornecedor ou Cliente
    data_hora_agendada TIMESTAMP NOT NULL,
    doca_ou_local VARCHAR(50), -- Ex: 'Doca 02', 'Almoxarifado B'
    status_agendamento VARCHAR(30) DEFAULT 'AGENDADO', -- AGENDADO, CONCLUIDO, CANCELADO
    observacoes TEXT,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================
-- 3. MÓDULO DE ENTREGAS (Logística e Expedição)
-- ==========================================

CREATE TABLE IF NOT EXISTS entregas (
    id SERIAL PRIMARY KEY,
    agendamento_id BIGINT UNSIGNED, -- Opcional: Vinculado a um agendamento prévio
    pedido_venda_id BIGINT UNSIGNED, -- Opcional: Vinculado ao pedido de venda
    transportadora VARCHAR(100),
    codigo_rastreio VARCHAR(100),
    data_saida TIMESTAMP,
    data_entrega_prevista DATE,
    data_entrega_realizada TIMESTAMP,
    status_entrega VARCHAR(30) DEFAULT 'EM_TRANSITO', -- EM_TRANSITO, ENTREGUE, ATRASADO, DEVOLVIDO
    FOREIGN KEY (agendamento_id) REFERENCES agendamentos(id) ON DELETE SET NULL,
    FOREIGN KEY (pedido_venda_id) REFERENCES pedidos_venda(id) ON DELETE SET NULL
);

-- ==========================================
-- 4. MÓDULO DE INSUMOS RECEBIDOS (Recebimento de Materiais)
-- ==========================================

CREATE TABLE IF NOT EXISTS insumos_recebidos (
    id SERIAL PRIMARY KEY,
    produto_id BIGINT UNSIGNED NOT NULL,
    fornecedor_nome VARCHAR(150) NOT NULL,
    quantidade_recebida DECIMAL(12,4) NOT NULL,
    nota_fiscal VARCHAR(50) NOT NULL,
    data_recebimento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status_inspecao VARCHAR(30) DEFAULT 'APROVADO', -- APROVADO, REPROVADO, QUARENTENA
    observacao_qualidade TEXT,
    FOREIGN KEY (produto_id) REFERENCES produtos(id)
);

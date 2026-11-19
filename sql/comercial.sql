-- ==========================================
-- 1. MÓDULO DE ESTOQUE (Produtos e Almoxarifado)
-- ==========================================

CREATE TABLE IF NOT EXISTS produtos (
    id SERIAL PRIMARY KEY,
    codigo_sku VARCHAR(50) UNIQUE NOT NULL,
    nome VARCHAR(150) NOT NULL,
    tipo VARCHAR(20) NOT NULL, -- 'MATERIA_PRIMA', 'PRODUTO_ACABADO'
    unidade_medida VARCHAR(10) DEFAULT 'UN',
    preco_venda DECIMAL(12,2) DEFAULT 0.00,
    estoque_atual DECIMAL(12,4) DEFAULT 0.00
);

-- ==========================================
-- 2. MÓDULO DE VENDAS (Pedidos e Itens)
-- ==========================================

CREATE TABLE IF NOT EXISTS pedidos_venda (
    id SERIAL PRIMARY KEY,
    numero_pedido VARCHAR(30) UNIQUE NOT NULL,
    cliente_nome VARCHAR(150) NOT NULL,
    data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status_pedido VARCHAR(30) DEFAULT 'ABERTO', -- ABERTO, FATURADO, CANCELADO
    valor_total DECIMAL(12,2) NOT NULL
);

CREATE TABLE IF NOT EXISTS itens_pedido_venda (
    id SERIAL PRIMARY KEY,
    pedido_id BIGINT UNSIGNED NOT NULL,
    produto_id BIGINT UNSIGNED NOT NULL,
    quantidade DECIMAL(12,4) NOT NULL,
    preco_unitario DECIMAL(12,2) NOT NULL,
    subtotal DECIMAL(12,2) GENERATED ALWAYS AS (quantidade * preco_unitario) STORED,
    FOREIGN KEY (pedido_id) REFERENCES pedidos_venda(id) ON DELETE CASCADE,
    FOREIGN KEY (produto_id) REFERENCES produtos(id)
);

-- ==========================================
-- 3. MÓDULO DE FABRICAÇÃO (Ordens de Produção)
-- ==========================================

CREATE TABLE IF NOT EXISTS ordens_producao (
    id SERIAL PRIMARY KEY,
    numero_op VARCHAR(30) UNIQUE NOT NULL,
    produto_id BIGINT UNSIGNED NOT NULL, -- Produto a ser fabricado (Acabado)
    quantidade_planejada DECIMAL(12,4) NOT NULL,
    quantidade_produzida DECIMAL(12,4) DEFAULT 0.00,
    status_op VARCHAR(30) DEFAULT 'PLANEJADA', -- PLANEJADA, EM_ANDAMENTO, CONCLUIDA, CANCELADA
    data_inicio TIMESTAMP,
    data_fim TIMESTAMP,
    FOREIGN KEY (produto_id) REFERENCES produtos(id)
);

-- Estrutura de insumos necessários por Ordem de Produção (Baixa de Estoque)
CREATE TABLE IF NOT EXISTS op_consumo_insumos (
    id SERIAL PRIMARY KEY,
    ordem_producao_id BIGINT UNSIGNED NOT NULL,
    produto_materia_prima_id BIGINT UNSIGNED NOT NULL,
    quantidade_necessaria DECIMAL(12,4) NOT NULL,
    quantidade_empenhada DECIMAL(12,4) DEFAULT 0.00,
    FOREIGN KEY (ordem_producao_id) REFERENCES ordens_producao(id) ON DELETE CASCADE,
    FOREIGN KEY (produto_materia_prima_id) REFERENCES produtos(id)
);

-- ==========================================
-- 4. MÓDULO DE MOVIMENTAÇÃO DE ESTOQUE (Kardex)
-- ==========================================

CREATE TABLE IF NOT EXISTS movimentacoes_estoque (
    id SERIAL PRIMARY KEY,
    produto_id BIGINT UNSIGNED NOT NULL,
    tipo_movimento VARCHAR(10) NOT NULL, -- 'ENTRADA', 'SAIDA'
    origem_motivo VARCHAR(50) NOT NULL, -- 'VENDA', 'PRODUCAO', 'COMPRA'
    documento_referencia_id INT, -- ID do pedido de venda ou da OP
    quantidade DECIMAL(12,4) NOT NULL,
    data_movimento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (produto_id) REFERENCES produtos(id)
);

-- ==========================================
-- EXEMPLO PRÁTICO DE INSERÇÃO (DML)
-- ==========================================

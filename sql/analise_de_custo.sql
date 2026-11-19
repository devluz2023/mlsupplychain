-- Criação da tabela de Custos e Indicadores Industriais
CREATE TABLE IF NOT EXISTS analise_custos_produto (
    id SERIAL PRIMARY KEY,
    produto_nome VARCHAR(100) NOT NULL,
    preco_venda_unitario DECIMAL(10,2) NOT NULL,
    custo_materia_prima DECIMAL(10,2) NOT NULL,
    custo_mod DECIMAL(10,2) NOT NULL, -- Mão de Obra Direta
    custo_indireto_variavel DECIMAL(10,2) NOT NULL,
    custos_fixos_periodo DECIMAL(12,2) NOT NULL,
    despesa_variavel_unitaria DECIMAL(10,2) NOT NULL,
    despesas_fixas_periodo DECIMAL(12,2) NOT NULL,
    quantidade_produzida INT NOT NULL,
    margem_contribuicao_unitaria DECIMAL(10,2) GENERATED ALWAYS AS (
        preco_venda_unitario - (custo_materia_prima + custo_mod + custo_indireto_variavel + despesa_variavel_unitaria)
    ) STORED
);

-- Criação da tabela para Teste de Recuperabilidade de Ativos (Impairment - Questão 54)
CREATE TABLE IF NOT EXISTS ativo_imobilizado_impairment (
    id SERIAL PRIMARY KEY,
    descricao_ativo VARCHAR(150) NOT NULL,
    valor_contabil DECIMAL(12,2) NOT NULL,
    valor_justo DECIMAL(12,2) NOT NULL,
    valor_em_uso DECIMAL(12,2) NOT NULL,
    valor_residual DECIMAL(12,2) NOT NULL,
    despesas_venda DECIMAL(12,2) NOT NULL,
    valor_recuperavel DECIMAL(12,2) GENERATED ALWAYS AS (
        GREATEST(valor_justo - despesas_venda, valor_em_uso)
    ) STORED,
    perda_desvalorizacao DECIMAL(12,2) GENERATED ALWAYS AS (
        CASE 
            WHEN valor_contabil > GREATEST(valor_justo - despesas_venda, valor_em_uso) 
            THEN valor_contabil - GREATEST(valor_justo - despesas_venda, valor_em_uso)
            ELSE 0.00
        END
    ) STORED
);

-- Populando os dados da questão de custos
INSERT INTO analise_custos_produto (
    produto_nome, preco_venda_unitario, custo_materia_prima, custo_mod, 
    custo_indireto_variavel, custos_fixos_periodo, despesa_variavel_unitaria, 
    despesas_fixas_periodo, quantidade_produzida
) VALUES (
    'Produto Único Industrial', 100.00, 20.00, 10.00, 
    6.00, 240000.00, 10.00, 
    140000.00, 10000
);

-- Populando os dados da Questão 54 (Ativo Imobilizado / Impairment)
INSERT INTO ativo_imobilizado_impairment (
    descricao_ativo, valor_contabil, valor_justo, valor_em_uso, valor_residual, despesas_venda
) VALUES (
    'Ativo Imobilizado - Companhia Aberta', 250000.00, 240000.00, 230000.00, 50000.00, 3000.00
);
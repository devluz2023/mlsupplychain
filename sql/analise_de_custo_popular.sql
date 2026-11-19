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

-- 1. Inserir Produtos (Matéria-prima e Produto Acabado)
INSERT INTO produtos (codigo_sku, nome, tipo, unidade_medida, preco_venda, estoque_atual) VALUES 
('MP-001', 'Chapa de Aço', 'MATERIA_PRIMA', 'UN', 0.00, 500.0000),
('PA-100', 'Lâmpada LED Industrial', 'PRODUTO_ACABADO', 'UN', 100.0000, 10.0000);

-- 2. Inserir Pedido de Venda
INSERT INTO pedidos_venda (numero_pedido, cliente_nome, valor_total) 
VALUES ('PED-5001', 'Indústria ABC Ltda', 500.00);

-- 3. Inserir Itens do Pedido de Venda
INSERT INTO itens_pedido_venda (pedido_id, produto_id, quantidade, preco_unitario) 
VALUES (1, 2, 5.0000, 100.00);

-- 4. Inserir Ordem de Produção (Fabricação de 50 lâmpadas)
INSERT INTO ordens_producao (numero_op, produto_id, quantidade_planejada, status_op, data_inicio) 
VALUES ('OP-2026-01', 2, 50.0000, 'EM_ANDAMENTO', CURRENT_TIMESTAMP);

-- 5. Inserir Consumo de Insumos da OP (Gastando a chapa de aço)
INSERT INTO op_consumo_insumos (ordem_producao_id, produto_materia_prima_id, quantidade_necessaria) 
VALUES (1, 1, 25.0000);

-- 6. Registrar Movimentação de Estoque (Saída por Venda)
INSERT INTO movimentacoes_estoque (produto_id, tipo_movimento, origem_motivo, documento_referencia_id, quantidade) 
VALUES (2, 'SAIDA', 'VENDA', 1, 5.0000);
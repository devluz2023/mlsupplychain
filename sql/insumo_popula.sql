

-- 1. Inserir Necessidade de Demanda (Ex: Projeção de uso para o produto ID 1)
INSERT INTO necessidade_demanda (produto_id, quantidade_necessaria, data_necessidade, origem_demanda) 
VALUES (1, 150.0000, '2026-12-10', 'PREVISAO_VENDAS');

-- 2. Inserir Agendamento (Ex: Agendamento de recebimento de carga na doca)
INSERT INTO agendamentos (tipo_agendamento, entidade_nome, data_hora_agendada, doca_ou_local, observacoes) 
VALUES ('RECEBIMENTO_FORNECEDOR', 'Metalúrgica Aço Forte', '2026-12-05 09:30:00', 'Doca 01', 'Trazer nota fiscal impressa e EPI');

-- 3. Inserir Entrega (Ex: Logística de saída de um pedido)
INSERT INTO entregas (agendamento_id, pedido_venda_id, transportadora, codigo_rastreio, data_entrega_prevista, status_entrega) 
VALUES (1, 1, 'Transportes Rápidos Ltda', 'TR987654321BR', '2026-12-08', 'EM_TRANSITO');

-- 4. Inserir Insumo Recebido (Ex: Entrada de matéria-prima no estoque)
INSERT INTO insumos_recebidos (produto_id, fornecedor_nome, quantidade_recebida, nota_fiscal, status_inspecao, observacao_qualidade) 
VALUES (1, 'Metalúrgica Aço Forte', 200.0000, 'NF-45892', 'APROVADO', 'Material conferido e testado no laboratório.');
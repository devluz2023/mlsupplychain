
-- ==========================================
-- EXEMPLOS PRÁTICOS DE INSERÇÃO (DML)
-- ==========================================

-- 1. Inserir Veículo da Frota
INSERT INTO veiculos (placa, modelo, marca, ano, capacidade_peso_kg, capacidade_volume_m3, status_veiculo) 
VALUES ('ABC-1234', 'Delivery 11.180', 'Volkswagen', 2023, 6000.00, 30.00, 'DISPONIVEL');

-- 2. Inserir Motorista
INSERT INTO motoristas (nome, cpf, cnh, categoria_cnh, telefone, status_motorista) 
VALUES ('Cristiano Pires', '123.456.789-00', '98765432100', 'D', '(11) 98888-7777', 'DISPONIVEL');

-- 3. Inserir Pedidos de Transporte
INSERT INTO pedidos_transporte (codigo_pedido, cliente_nome, endereco_origem, endereco_destino, peso_carga_kg, valor_frete, status_pedido) VALUES 
('TR-1001', 'Comércio Central SP', 'São Paulo - SP', 'Campinas - SP', 1200.00, 850.00, 'Roteirizado'),
('TR-1002', 'Distribuidora Jundiaí', 'São Paulo - SP', 'Jundiaí - SP', 800.00, 500.00, 'Roteirizado');

-- 4. Inserir Rota de Entrega (Planejando a viagem unindo veículo e motorista)
INSERT INTO rotas_entrega (codigo_rota, veiculo_id, motorista_id, data_saida, data_chegada_prevista, status_rota) 
VALUES ('ROTA-SP-INT-01', 1, 1, '2026-12-20 08:00:00', '2026-12-20 18:00:00', 'PLANEJADA');

-- 5. Associar os Pedidos à Rota Criada (Com a ordem sequencial das entregas)
INSERT INTO rota_pedidos (rota_id, pedido_id, ordem_parada) VALUES 
(1, 1, 1), -- 1ª Parada: Campinas
(1, 2, 2); -- 2ª Parada: Jundiaí
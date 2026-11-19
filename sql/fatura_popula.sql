-- ==========================================
-- INSERÇÃO DOS DADOS DA FATURA DA IMAGEM
-- ==========================================

-- 1. Inserir Cliente (Cobrar de / Enviar para)
INSERT INTO cliente_fatura (id_cliente_codigo, atencao_departamento, nome_empresa, endereco, cidade_uf_cep, telefone)
VALUES ('A246', 'Nome/Departamento', 'Nome da empresa', 'Rua Principal, 123', 'São Paulo, SP 44416', '(321) 456-7890');

-- 2. Inserir Fatura (Cabeçalho)
INSERT INTO fatura_cobranca (numero_fatura, data_emissao, condicoes_pagamento, cliente_cobranca_id, cliente_envio_id, subtotal, valor_imposto, valor_total)
VALUES ('100001', '2016-02-15', 'Venc. em 30 dias', 1, 1, 680.00, 25.84, 705.84);

-- 3. Inserir os Itens da Fatura
INSERT INTO fatura_itens (fatura_id, descricao, quantidade, preco_unitario) VALUES 
(1, 'Consultoria', 1.00, 150.00),
(1, 'Design - 7 horas a US$ 80 por hora', 7.00, 80.00),
(1, 'Desconto', 1.00, -30.00);
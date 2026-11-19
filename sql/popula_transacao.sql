-- 1. Inserir Cliente
INSERT INTO clientes (nome, email, cpf_cnpj) 
VALUES ('Fábio da Luz', 'fabio.jdluz@gmail.com', '111.222.333-44');

-- 2. Inserir Pedido (Ex: R$ 705,84)
INSERT INTO pedidos (cliente_id, valor_total, status_pedido) 
VALUES (1, 705.84, 'PENDENTE');

-- 3. Registrar Pagamento via CARTÃO DE CRÉDITO
INSERT INTO transacoes_pagamento (
    pedido_id, gateway_metodo, status_pagamento, valor_pago, taxa_gateway, 
    transacao_id_gateway, cartao_bandeira, cartao_ultimos_digitos, parcelas
) VALUES (
    1, 'CARTAO_CREDITO', 'APROVADO', 705.84, 21.17, 
    'pay_loc_9837483920', 'Mastercard', '8842', 3
);

-- 4. Registrar Pagamento via BOLETO BANCÁRIO
INSERT INTO transacoes_pagamento (
    pedido_id, gateway_metodo, status_pagamento, valor_pago, taxa_gateway, 
    linha_digitavel_boleto, data_vencimento_boleto, url_boleto
) VALUES (
    1, 'BOLETO', 'PENDENTE', 705.84, 3.50, 
    '34191.79001 01043.515005 02000.816000 1 89320000070584', '2026-12-18', 'https://banco.com/boleto/fatura123'
);

-- 5. Registrar Pagamento via PAYPAL
INSERT INTO transacoes_pagamento (
    pedido_id, gateway_metodo, status_pagamento, valor_pago, taxa_gateway, moeda, transacao_id_gateway
) VALUES (
    1, 'PAYPAL', 'APROVADO', 705.84, 35.29, 'PAYID-M4K7X9L029384', 'BRL', 'PAYID-M4K7X9L029384'
);

-- 6. Registrar Pagamento via PAGSEGURO
INSERT INTO transacoes_pagamento (
    pedido_id, gateway_metodo, status_pagamento, valor_pago, taxa_gateway, transacao_id_gateway
) VALUES (
    1, 'PAGSEGURO', 'APROVADO', 705.84, 28.23, 'A7B8C9D0-1234-5678-ABCD-EF0123456789'
);
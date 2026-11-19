===================================
-- INSERÇÃO DOS DADOS DO BOLETO DA IMAGEM
-- ==========================================

-- 1. Inserir Beneficiário
INSERT INTO boleto_beneficiario (nome, cnpj, endereco, agencia_codigo)
VALUES ('TESTE', '12.628.502/0001-40', 'rua jonas venancio, 12, Centro, casa verde - 86975-000 Araçagi-PB', '1234-3/00001234-3');

-- 2. Inserir Pagador
INSERT INTO boleto_pagador (nome, cnpj_cpf, endereco)
VALUES ('SACADO DE TESTE', '01.001.001/0001-13', 'Rua teste, 987, 987, Fundos - Centro - 87098-765 Maringá-PR');

-- 3. Inserir o Boleto / Título
INSERT INTO boleto_cobranca (
    banco_codigo, beneficiario_id, pagador_id, numero_documento, nosso_numero, 
    linha_digitavel, valor_documento, data_vencimento, data_documento, 
    data_processamento, carteira, especie_documento, aceite, instrucoes
) VALUES (
    '001-9', 1, 1, '01012020', '03123166663-2', 
    '00190.31236 16666.312349 00001.234111 6 90940000000002', 0.02, '2022-08-31', '2022-08-04', 
    '2022-08-04', '11', 'DM', 'S', 
    'Juros de 0,01 ao dia. Nao receber apos 30 dias de atraso. Titulo sujeito a protesto apos 30 dias'
);
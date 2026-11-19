-- 1. Inserir Emitente
INSERT INTO cte_emitente (razao_social, endereco, bairro, municipio_uf, cep, cnpj, inscricao_estadual)
VALUES ('EMPRESA EXEMPLO DE TRANSPORTADORA', 'Endereço Exemplo, 1', 'Bairro Exemplo', 'IMBITUVA - PR', '00000-000', '00.000.000/0000-01', '0000000000');

-- 2. Inserir Conhecimento de Transporte (Cabeçalho)
INSERT INTO conhecimento_transporte (
    modelo, serie, numero, chave_acesso, data_emissao, tipo_cte, tipo_servico, tomador_servico, 
    natureza_operacao, municipio_origem, municipio_destino, emitente_id, 
    remetente_nome, remetente_cnpj, remetente_ie, remetente_endereco, 
    destinatario_nome, destinatario_cnpj, destinatario_ie, destinatario_endereco, 
    produto_predominante, especie_carga, peso_bruto, valor_total_servico, valor_a_receber, situacao_tributaria
)
VALUES (
    '57', '001', '000.000.001', '41200700000000000001570010000000011000001357', '2020-07-16 16:13:32', 
    'Normal', 'Normal', 'Destinatário', '6352 - TRANSPORTE INTERESTADUAL - INDUSTRIAL', 
    'Curitiba - PR', 'Florianópolis - SC', 1, 
    'REMETENTE EXEMPLO', '00.000.000/0000-00', '000000000', 'Endereço Exemplo, nº 42 - Bairro Exemplo', 
    'DESTINATARIO EXEMPLO', '00.000.000/0000-00', '000000000', 'Endereço Exemplo, nº 05 - Bairro Exemplo', 
    'NATUREZA EXEMPLO', 'ESPECIE EXEMPLO', 2.00, 100.00, 100.00, '90 - SIMPLES NACIONAL'
);

-- 3. Inserir Componentes do Valor do Serviço
INSERT INTO cte_componentes_valor (cte_id, nome_componente, valor)
VALUES (1, 'Frete Valor', 100.00);

-- 4. Inserir Documentos Originários
INSERT INTO cte_documentos_originarios (cte_id, tipo_documento, cnpj_emitente, serie, numero_documento)
VALUES (1, 'Outros', '00.000.000/0000-00', '001', '001');
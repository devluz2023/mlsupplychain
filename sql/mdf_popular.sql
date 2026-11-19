-- 1. Inserir Emitente
INSERT INTO mdf_emitente (razao_social, endereco, municipio_uf, cep, cnpj, inscricao_estadual, rntrc, telefone)
VALUES ('Hive Teste 4.0', 'Rua Entrerios', 'SÃO PAULO - SP', '12220-001', '00.000.000/0000-00', '46505809900', '11111111', '(62) 3237-1010');

-- 2. Inserir Manifesto (Cabeçalho)
INSERT INTO manifesto_mdf (modelo, serie, numero, chave_acesso, data_emissao, uf_carregamento, uf_descarregamento, forma_emissao, tipo_emitente, tipo_ambiente, emitente_id, quantidade_nfe, peso_total, valor_total, responsavel)
VALUES ('58', '1', '1147', '3525.0230.9572.3800.0170.5800.1000.0011.4710.0000.0002', '2025-02-12 12:42:37', 'SP', 'BA', 'NORMAL', 'TRANSPORTADOR DE CARGA PRÓPRIA', 'HOMOLOGAÇÃO', 1, 2, 40.00, 6001515.00, 'Emitente do MDF-e');

-- 3. Inserir Veículo
INSERT INTO mdf_veiculos (manifesto_id, placa, uf, rntrc, renavam)
VALUES (1, '1234567', 'AC', '12345678', '1234567');

-- 4. Inserir Condutor
INSERT INTO mdf_condutores (manifesto_id, nome, cpf)
VALUES (1, 'CRISTIANO PIRES', '000.000.000-00');

-- 5. Inserir Seguro
INSERT INTO mdf_seguros (manifesto_id, nome_seguradora, cnpj_seguradora, numero_apolice, numero_averbacao)
VALUES (1, 'teste seguro', '16.757.320/0001-20', '1234', '4567895');

-- 6. Inserir Documentos Fiscais Vinculados (NF-e)
INSERT INTO mdf_documentos_vinculados (manifesto_id, municipio, numero_documento, chave_nfe) VALUES 
(1, 'CAATIBA', '33240', '33240914460636000100550040000013611091622300'),
(1, 'SALINAS DA MARGARIDA', '13241', '1324111911778500010550010000860061105751950');
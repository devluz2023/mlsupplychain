-- 1. Inserir Destinatário
INSERT INTO destinatario (nome, cnpj, inscricao_estadual, endereco, bairro, cep, municipio, uf, telefone)
VALUES ('Dionísio de Baco', '111.111.111-11', '010/000000', 'Rua dos Vinhedos, 386', 'Vinhedos', '95.700-000', 'Bento Gonçalves', 'RS', '3454-6877');

-- 2. Inserir Transportador
INSERT INTO transportador (nome, frete_por_conta, placa_veiculo, uf_veiculo, cnpj_cpf)
VALUES ('Transportes Valdemar', 1, 'IHL-7746', 'RS', '00000000000000');

-- 3. Inserir Nota Fiscal (Cabeçalho)
INSERT INTO nota_fiscal (numero, serie, natureza_operacao, chave_acesso, data_emissao, data_saida, hora_saida, destinatario_id, transportador_id, base_calculo_icms, valor_icms, base_calculo_icms_st, valor_icms_st, valor_produtos, valor_frete, valor_seguro, desconto, outras_despesas, valor_ipi, valor_total_nota, quantidade_volumes, especie_volumes, peso_bruto, peso_liquido)
VALUES ('000175', '1', 'Venda de mercadorias', '43.0908.90.627.936/0001-30-55-001-000.000.175-000.896.536', '2009-08-07', '2009-08-07', '16:01:00', 1, 1, 230.00, 27.60, 0.00, 0.00, 230.00, 0.00, 0.00, 0.00, 0.00, 0.00, 230.00, 3, 'CAIXAS', 19.000, 19.000);

-- 4. Inserir Faturas
INSERT INTO faturas (nota_fiscal_id, numero_fatura, vencimento, valor) VALUES 
(1, '000175/1', '2009-09-06', 76.66),
(1, '000175/2', '2009-10-06', 76.67),
(1, '000175/3', '2009-11-05', 76.67);

-- 5. Inserir Itens da Nota
INSERT INTO itens_nota (nota_fiscal_id, codigo, descricao, ncm, cst, cfop, unidade, quantidade, preco_unitario, preco_total, base_calculo_icms, valor_icms, valor_ipi, aliquota_icms, aliquota_ipi) VALUES 
(1, 'DH69', 'Lâmpada dicróica', '10000000', '100', '5.102', 'Cx', 4.0000, 45.00, 180.00, 180.00, 21.60, 0.00, 12.00, 0.00),
(1, 'FL100', 'Lâmpada fluorescente', '20000000', '000', '5.102', 'Cx', 5.0000, 10.00, 50.00, 50.00, 6.00, 0.00, 12.00, 0.00);
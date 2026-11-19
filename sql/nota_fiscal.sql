-- Tabela de Destinatários
CREATE TABLE IF NOT EXISTS destinatario (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cnpj VARCHAR(20) NOT NULL,
    inscricao_estadual VARCHAR(20),
    endereco VARCHAR(150),
    bairro VARCHAR(50),
    cep VARCHAR(15),
    municipio VARCHAR(50),
    uf VARCHAR(2),
    telefone VARCHAR(20)
);

-- Tabela de Transportadores
CREATE TABLE IF NOT EXISTS transportador (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    frete_por_conta INT, -- 1-Emitente, 2-Destinatário
    placa_veiculo VARCHAR(10),
    uf_veiculo VARCHAR(2),
    cnpj_cpf VARCHAR(20)
);

-- Tabela de Cabeçalho da Nota Fiscal
CREATE TABLE IF NOT EXISTS nota_fiscal (
    id SERIAL PRIMARY KEY,
    numero VARCHAR(20) NOT NULL,
    serie VARCHAR(5) NOT NULL,
    natureza_operacao VARCHAR(50),
    chave_acesso VARCHAR(60) UNIQUE,
    data_emissao DATE,
    data_saida DATE,
    hora_saida TIME,
    destinatario_id INT,
    transportador_id INT,
    base_calculo_icms DECIMAL(10,2),
    valor_icms DECIMAL(10,2),
    base_calculo_icms_st DECIMAL(10,2),
    valor_icms_st DECIMAL(10,2),
    valor_produtos DECIMAL(10,2),
    valor_frete DECIMAL(10,2),
    valor_seguro DECIMAL(10,2),
    desconto DECIMAL(10,2),
    outras_despesas DECIMAL(10,2),
    valor_ipi DECIMAL(10,2),
    valor_total_nota DECIMAL(10,2),
    quantidade_volumes INT,
    especie_volumes VARCHAR(30),
    peso_bruto DECIMAL(10,3),
    peso_liquido DECIMAL(10,3),
    FOREIGN KEY (destinatario_id) REFERENCES destinatario(id),
    FOREIGN KEY (transportador_id) REFERENCES transportador(id)
);

-- Tabela de Faturas (Duplicatas)
CREATE TABLE IF NOT EXISTS faturas (
    id SERIAL PRIMARY KEY,
    nota_fiscal_id INT NOT NULL,
    numero_fatura VARCHAR(20),
    vencimento DATE,
    valor DECIMAL(10,2),
    FOREIGN KEY (nota_fiscal_id) REFERENCES nota_fiscal(id) ON DELETE CASCADE
);

-- Tabela de Itens da Nota Fiscal
CREATE TABLE IF NOT EXISTS itens_nota (
    id SERIAL PRIMARY KEY,
    nota_fiscal_id INT NOT NULL,
    codigo VARCHAR(20),
    descricao VARCHAR(150),
    ncm VARCHAR(20),
    cst VARCHAR(10),
    cfop VARCHAR(10),
    unidade VARCHAR(10),
    quantidade DECIMAL(10,4),
    preco_unitario DECIMAL(10,2),
    preco_total DECIMAL(10,2),
    base_calculo_icms DECIMAL(10,2),
    valor_icms DECIMAL(10,2),
    valor_ipi DECIMAL(10,2),
    aliquota_icms DECIMAL(5,2),
    aliquota_ipi DECIMAL(5,2),
    FOREIGN KEY (nota_fiscal_id) REFERENCES nota_fiscal(id) ON DELETE CASCADE
);
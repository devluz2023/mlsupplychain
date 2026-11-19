-- Tabela do Emitente do CT-e
CREATE TABLE IF NOT EXISTS cte_emitente (
    id SERIAL PRIMARY KEY,
    razao_social VARCHAR(100) NOT NULL,
    endereco VARCHAR(150),
    bairro VARCHAR(50),
    municipio_uf VARCHAR(50),
    cep VARCHAR(15),
    cnpj VARCHAR(20) NOT NULL,
    inscricao_estadual VARCHAR(20)
);

-- Tabela Principal do CT-e (Cabeçalho)
CREATE TABLE IF NOT EXISTS conhecimento_transporte (
    id SERIAL PRIMARY KEY,
    modelo VARCHAR(5),
    serie VARCHAR(5),
    numero VARCHAR(20) NOT NULL,
    chave_acesso VARCHAR(60) UNIQUE NOT NULL,
    data_emissao TIMESTAMP,
    tipo_cte VARCHAR(30),
    tipo_servico VARCHAR(30),
    tomador_servico VARCHAR(30),
    natureza_operacao VARCHAR(100),
    municipio_origem VARCHAR(100),
    municipio_destino VARCHAR(100),
    emitente_id INT,
    -- Remetente
    remetente_nome VARCHAR(100),
    remetente_cnpj VARCHAR(20),
    remetente_ie VARCHAR(20),
    remetente_endereco VARCHAR(150),
    -- Destinatário / Tomador
    destinatario_nome VARCHAR(100),
    destinatario_cnpj VARCHAR(20),
    destinatario_ie VARCHAR(20),
    destinatario_endereco VARCHAR(150),
    -- Carga
    produto_predominante VARCHAR(100),
    especie_carga VARCHAR(50),
    peso_bruto DECIMAL(10,2),
    -- Valores
    valor_total_servico DECIMAL(10,2),
    valor_a_receber DECIMAL(10,2),
    situacao_tributaria VARCHAR(50),
    FOREIGN KEY (emitente_id) REFERENCES cte_emitente(id)
);

-- Tabela de Componentes do Valor da Prestação de Serviço
CREATE TABLE IF NOT EXISTS cte_componentes_valor (
    id SERIAL PRIMARY KEY,
    cte_id INT NOT NULL,
    nome_componente VARCHAR(50),
    valor DECIMAL(10,2),
    FOREIGN KEY (cte_id) REFERENCES conhecimento_transporte(id) ON DELETE CASCADE
);

-- Tabela de Documentos Originários Vinculados
CREATE TABLE IF NOT EXISTS cte_documentos_originarios (
    id SERIAL PRIMARY KEY,
    cte_id INT NOT NULL,
    tipo_documento VARCHAR(30),
    cnpj_emitente VARCHAR(20),
    serie VARCHAR(10),
    numero_documento VARCHAR(30),
    FOREIGN KEY (cte_id) REFERENCES conhecimento_transporte(id) ON DELETE CASCADE
);
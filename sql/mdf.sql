-- Tabela do Emitente do MDF-e
CREATE TABLE IF NOT EXISTS mdf_emitente (
    id SERIAL PRIMARY KEY,
    razao_social VARCHAR(100) NOT NULL,
    endereco VARCHAR(150),
    municipio_uf VARCHAR(50),
    cep VARCHAR(15),
    cnpj VARCHAR(20) NOT NULL,
    inscricao_estadual VARCHAR(20),
    rntrc VARCHAR(20),
    telefone VARCHAR(20)
);

-- Tabela Principal do MDF-e (Cabeçalho do Manifesto)
CREATE TABLE IF NOT EXISTS manifesto_mdf (
    id SERIAL PRIMARY KEY,
    modelo VARCHAR(5),
    serie VARCHAR(5),
    numero VARCHAR(20) NOT NULL,
    chave_acesso VARCHAR(60) UNIQUE NOT NULL,
    data_emissao TIMESTAMP,
    uf_carregamento VARCHAR(2),
    uf_descarregamento VARCHAR(2),
    forma_emissao VARCHAR(30),
    tipo_emitente VARCHAR(50),
    tipo_ambiente VARCHAR(30),
    emitente_id INT,
    quantidade_nfe INT,
    peso_total DECIMAL(10,2),
    valor_total DECIMAL(15,2),
    responsavel VARCHAR(50),
    FOREIGN KEY (emitente_id) REFERENCES mdf_emitente(id)
);

-- Tabela de Veículos do Manifesto
CREATE TABLE IF NOT EXISTS mdf_veiculos (
    id SERIAL PRIMARY KEY,
    manifesto_id INT NOT NULL,
    placa VARCHAR(10),
    uf VARCHAR(2),
    rntrc VARCHAR(20),
    renavam VARCHAR(20),
    FOREIGN KEY (manifesto_id) REFERENCES manifesto_mdf(id) ON DELETE CASCADE
);

-- Tabela de Condutores
CREATE TABLE IF NOT EXISTS mdf_condutores (
    id SERIAL PRIMARY KEY,
    manifesto_id INT NOT NULL,
    nome VARCHAR(100),
    cpf VARCHAR(20),
    FOREIGN KEY (manifesto_id) REFERENCES manifesto_mdf(id) ON DELETE CASCADE
);

-- Tabela de Seguros
CREATE TABLE IF NOT EXISTS mdf_seguros (
    id SERIAL PRIMARY KEY,
    manifesto_id INT NOT NULL,
    nome_seguradora VARCHAR(100),
    cnpj_seguradora VARCHAR(20),
    numero_apolice VARCHAR(50),
    numero_averbacao VARCHAR(50),
    FOREIGN KEY (manifesto_id) REFERENCES manifesto_mdf(id) ON DELETE CASCADE
);

-- Tabela de Documentos Fiscais Vinculados (NF-e no Manifesto)
CREATE TABLE IF NOT EXISTS mdf_documentos_vinculados (
    id SERIAL PRIMARY KEY,
    manifesto_id INT NOT NULL,
    municipio VARCHAR(100),
    numero_documento VARCHAR(30),
    chave_nfe VARCHAR(60),
    FOREIGN KEY (manifesto_id) REFERENCES manifesto_mdf(id) ON DELETE CASCADE
);
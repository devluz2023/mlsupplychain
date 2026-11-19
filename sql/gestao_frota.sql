-- ==========================================
-- 1. MÓDULO DE VEÍCULOS E FROTA
-- ==========================================

CREATE TABLE IF NOT EXISTS veiculos (
    id SERIAL PRIMARY KEY,
    placa VARCHAR(10) UNIQUE NOT NULL,
    modelo VARCHAR(100) NOT NULL,
    marca VARCHAR(50) NOT NULL,
    ano INT,
    capacidade_peso_kg DECIMAL(10,2) NOT NULL, -- Ex: 4000.00 kg
    capacidade_volume_m3 DECIMAL(10,2), -- Ex: 25.5 m³
    status_veiculo VARCHAR(30) DEFAULT 'DISPONIVEL' -- DISPONIVEL, EM_MANUTENCAO, EM_ROTA
);

-- ==========================================
-- 2. MÓDULO DE MOTORISTAS
-- ==========================================

CREATE TABLE IF NOT EXISTS motoristas (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    cpf VARCHAR(20) UNIQUE NOT NULL,
    cnh VARCHAR(30) UNIQUE NOT NULL,
    categoria_cnh VARCHAR(5) NOT NULL, -- Ex: 'D', 'E'
    telefone VARCHAR(30),
    status_motorista VARCHAR(30) DEFAULT 'DISPONIVEL' -- DISPONIVEL, EM_ROTA, AFASTADO
);

-- ==========================================
-- 3. MÓDULO DE PEDIDOS DE TRANSPORTE
-- ==========================================

CREATE TABLE IF NOT EXISTS pedidos_transporte (
    id SERIAL PRIMARY KEY,
    codigo_pedido VARCHAR(30) UNIQUE NOT NULL,
    cliente_nome VARCHAR(150) NOT NULL,
    endereco_origem TEXT NOT NULL,
    endereco_destino TEXT NOT NULL,
    peso_carga_kg DECIMAL(10,2) NOT NULL,
    valor_frete DECIMAL(12,2) NOT NULL,
    status_pedido VARCHAR(30) DEFAULT 'PENDENTE' -- PENDENTE, Roteirizado, ENTREGUE, CANCELADO
);

-- ==========================================
-- 4. MÓDULO DE ROTEIRIZAÇÃO (Vincula Veículo, Motorista e Pedidos)
-- ==========================================

CREATE TABLE IF NOT EXISTS rotas_entrega (
    id SERIAL PRIMARY KEY,
    codigo_rota VARCHAR(30) UNIQUE NOT NULL,
    veiculo_id INT NOT NULL,
    motorista_id INT NOT NULL,
    data_saida TIMESTAMP,
    data_chegada_prevista TIMESTAMP,
    status_rota VARCHAR(30) DEFAULT 'PLANEJADA', -- PLANEJADA, EM_ANDAMENTO, CONCLUIDA
    FOREIGN KEY (veiculo_id) REFERENCES veiculos(id),
    FOREIGN KEY (motorista_id) REFERENCES motoristas(id)
);

-- Tabela de ligação entre Rota e os Pedidos que fazem parte dela
CREATE TABLE IF NOT EXISTS rota_pedidos (
    id SERIAL PRIMARY KEY,
    rota_id INT NOT NULL,
    pedido_id INT NOT NULL,
    ordem_parada INT NOT NULL, -- Sequência de entrega (1ª parada, 2ª parada...)
    FOREIGN KEY (rota_id) REFERENCES rotas_entrega(id) ON DELETE CASCADE,
    FOREIGN KEY (pedido_id) REFERENCES pedidos_transporte(id)
);

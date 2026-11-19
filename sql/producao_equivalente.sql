CREATE TABLE IF NOT EXISTS producao_equivalente_custos (
    id SERIAL PRIMARY KEY,
    periodo VARCHAR(50) NOT NULL, -- Ex: 'Março de 2025'
    custos_totais_producao DECIMAL(14,2) NOT NULL,
    unidades_iniciadas INT NOT NULL,
    unidades_inacabadas INT NOT NULL,
    percentual_conclusao DECIMAL(5,2) NOT NULL, -- Ex: 20.00 para 20%
    
    -- Colunas Calculadas Automaticamente
    unidades_acabadas INT GENERATED ALWAYS AS (unidades_iniciadas - unidades_inacabadas) STORED,
    producao_equivalente DECIMAL(12,2) GENERATED ALWAYS AS (
        (unidades_iniciadas - unidades_inacabadas) + (unidades_inacabadas * (percentual_conclusao / 100.0))
    ) STORED,
    custo_ unitario_equivalente DECIMAL(12,2) GENERATED ALWAYS AS (
        custos_totais_producao / 
        NULLIF((unidades_iniciadas - unidades_inacabadas) + (unidades_inacabadas * (percentual_conclusao / 100.0)), 0)
    ) STORED
);
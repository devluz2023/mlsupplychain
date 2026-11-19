INSERT INTO producao_equivalente_custos (
    periodo, custos_totais_producao, unidades_iniciadas, unidades_inacabadas, percentual_conclusao
) VALUES (
    'Março de 2025', 2400000.00, 20000, 5000, 20.00
);

-- Consulta para visualizar o resultado calculado
SELECT 
    periodo,
    custos_totais_producao,
    unidades_iniciadas,
    unidades_acabadas,
    producao_equivalente,
    custo_unitario_equivalente AS custo_unitario
FROM producao_equivalente_custos;
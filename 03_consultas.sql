USE eletrica_com;

-- 1. Todos os orçamentos com nome do cliente e valor total
SELECT 
    o.id_orcamento,
    c.nome AS cliente,
    o.data_emissao,
    o.status,
    o.valor_total
FROM Orcamento o
JOIN Cliente c ON o.id_cliente = c.id_cliente
ORDER BY o.data_emissao DESC;

-- 2. Detalhamento completo de um orçamento específico (ex: id 1)
SELECT 
    o.id_orcamento,
    c.nome AS cliente,
    i.tipo_item,
    COALESCE(s.descricao, m.descricao) AS descricao_item,
    i.quantidade,
    i.valor_unitario,
    i.subtotal
FROM Orcamento o
JOIN Cliente c ON o.id_cliente = c.id_cliente
JOIN Item_Orcamento i ON o.id_orcamento = i.id_orcamento
LEFT JOIN Servico s ON i.id_servico = s.id_servico
LEFT JOIN Material m ON i.id_material = m.id_material
WHERE o.id_orcamento = 1;

-- 3. Serviços mais utilizados nos orçamentos
SELECT 
    s.descricao,
    COUNT(*) AS vezes_utilizado,
    SUM(i.subtotal) AS faturamento_total
FROM Item_Orcamento i
JOIN Servico s ON i.id_servico = s.id_servico
GROUP BY s.id_servico, s.descricao
ORDER BY vezes_utilizado DESC;

-- 4. Orçamentos aprovados no mês atual
SELECT 
    o.id_orcamento,
    c.nome,
    o.valor_total,
    o.data_emissao
FROM Orcamento o
JOIN Cliente c ON o.id_cliente = c.id_cliente
WHERE o.status = 'Aprovado'
  AND MONTH(o.data_emissao) = MONTH(CURRENT_DATE)
  AND YEAR(o.data_emissao) = YEAR(CURRENT_DATE);

-- 5. Cliente com maior valor total em orçamentos
SELECT 
    c.nome,
    SUM(o.valor_total) AS total_gasto
FROM Cliente c
JOIN Orcamento o ON c.id_cliente = o.id_cliente
WHERE o.status = 'Aprovado'
GROUP BY c.id_cliente, c.nome
ORDER BY total_gasto DESC
LIMIT 1;
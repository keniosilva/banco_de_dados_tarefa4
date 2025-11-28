USE eletrica_com;

-- UPDATEs
UPDATE Cliente SET telefone = '(11)91111-2222' WHERE id_cliente = 1;

UPDATE Material SET valor_unitario = 4.20 WHERE id_material = 1;

UPDATE Orcamento SET status = 'Rejeitado', observacoes = 'Cliente optou por concorrente' 
WHERE id_orcamento = 2;

-- DELETEs (com cuidado por causa das FKs)
DELETE FROM Item_Orcamento WHERE id_item = 5;  -- remove um item específico

-- Apagar orçamento completo (CASCADE remove os itens automaticamente)
DELETE FROM Orcamento WHERE id_orcamento = 2;

-- Apagar cliente que nunca fez orçamento (não viola FK)
DELETE FROM Cliente WHERE id_cliente NOT IN (SELECT id_cliente FROM Orcamento) AND id_cliente = 3;
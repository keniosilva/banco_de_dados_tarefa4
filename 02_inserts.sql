USE eletrica_com;

-- Clientes
INSERT INTO Cliente (cpf_cnpj, nome, endereco, telefone, email) VALUES
('123.456.789-00', 'João Silva', 'Rua das Flores, 123 - São Paulo', '(11)98765-4321', 'joao@email.com'),
('12.345.678/0001-99', 'Construtora XYZ Ltda', 'Av. Paulista, 1000', '(11)3333-4444', 'contato@xyz.com.br'),
('987.654.321-00', 'Maria Oliveira', 'Rua do Sol, 45 - Campinas', '(19)99988-7766', 'maria.oli@outlook.com');

-- Serviços
INSERT INTO Servico (descricao, valor_mao_obra_hora, tempo_estimado_horas) VALUES
('Instalação de rede elétrica residencial', 85.00, 8.00),
('Troca de disjuntores e quadro', 120.00, 4.00),
('Manutenção preventiva', 90.00, 3.00),
('Instalação de tomadas e interruptores', 75.00, 6.00);

-- Materiais
INSERT INTO Material (codigo, descricao, unidade_medida, valor_unitario) VALUES
('CAB001', 'Cabo flexível 2,5mm²', 'metro', 3.80),
('CAB002', 'Cabo flexível 4mm²', 'metro', 5.90),
('DISJ01', 'Disjuntor bipolar 40A', 'unidade', 48.00),
('TOM001', 'Tomada 10A branca', 'unidade', 12.50);

-- Orçamento 1 - João Silva
INSERT INTO Orcamento (id_cliente, data_emissao, data_validade, status) VALUES
(1, '2025-11-10', '2025-11-25', 'Aprovado');

INSERT INTO Item_Orcamento (id_orcamento, tipo_item, id_servico, id_material, quantidade, valor_unitario) VALUES
(1, 'Serviço', 1, NULL, 1, 680.00),        -- 8h × R$85
(1, 'Material', NULL, 1, 80, 3.80),         -- 80m cabo 2,5mm
(1, 'Material', NULL, 4, 15, 12.50);        -- 15 tomadas

-- Atualiza valor total automaticamente (pode ser feito via trigger ou aplicação)
UPDATE Orcamento SET valor_total = (
    SELECT SUM(subtotal) FROM Item_Orcamento WHERE id_orcamento = 1
) WHERE id_orcamento = 1;

-- Orçamento 2 - Construtora XYZ
INSERT INTO Orcamento (id_cliente, data_emissao, status) VALUES
(2, '2025-11-15', 'Pendente');

INSERT INTO Item_Orcamento (id_orcamento, tipo_item, id_servico, id_material, quantidade, valor_unitario) VALUES
(2, 'Serviço', 2, NULL, 1, 480.00),
(2, 'Material', NULL, 2, 200, 5.90),
(2, 'Material', NULL, 3, 6, 48.00);

UPDATE Orcamento SET valor_total = (
    SELECT SUM(subtotal) FROM Item_Orcamento WHERE id_orcamento = 2
) WHERE id_orcamento = 2;
--USUARIO
CREATE TABLE usuario (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    papel VARCHAR(20) CHECK (papel IN ('admin', 'funcionario')) NOT NULL,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--CLIENTE
CREATE TABLE cliente (
    id SERIAL PRIMARY KEY,
    telefone VARCHAR(15) UNIQUE NOT NULL,
    nome VARCHAR(100) NOT NULL,
    logradouro VARCHAR(100),
    numero VARCHAR(10),
    complemento VARCHAR(50),
    bairro VARCHAR(50),
    cidade VARCHAR(50),
    estado CHAR(2),
    cep VARCHAR(10)
);

--TERAPEUTA
CREATE TABLE terapeuta (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

--CLIENTE_TERAPEUTA
CREATE TABLE cliente_terapeuta (
    cliente_id INT REFERENCES cliente(id) ON DELETE CASCADE,
    terapeuta_id INT REFERENCES terapeuta(id) ON DELETE CASCADE,
    data_associacao DATE,
    observacoes TEXT,
    PRIMARY KEY (cliente_id, terapeuta_id)
);

--UNIDADE
CREATE TABLE unidade (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    logradouro VARCHAR(100),
    numero VARCHAR(10),
    complemento VARCHAR(50),
    bairro VARCHAR(50),
    cidade VARCHAR(50),
    estado CHAR(2),
    cep VARCHAR(10)
);

--FUNCIONARIO
CREATE TABLE funcionario (
    usuario_id INT REFERENCES usuario(id) ON DELETE CASCADE,
    unidade_id INT REFERENCES unidade(id),
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20),
    salario DECIMAL(10,2),
    data_admissao DATE,
    observacoes TEXT
);

--COMANDA
CREATE TABLE comanda (
    id SERIAL PRIMARY KEY,
    cliente_id INT REFERENCES cliente(id),
    terapeuta_id INT REFERENCES terapeuta(id),
    unidade_id INT REFERENCES unidade(id),
    usuario_id INT REFERENCES usuario(id),    
    data TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL,
    forma_pagamento VARCHAR(20),
    tipo_venda VARCHAR(20) CHECK (tipo_venda IN ('balcao', 'entrega')),
    valor_total DECIMAL(10,2) NOT NULL
);

--VALIDADE
CREATE TABLE validade (
    id SERIAL PRIMARY KEY,
    tipo_produto VARCHAR(30),
    validade INT
);

--PRODUTO
CREATE TABLE produto (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    tipo VARCHAR(30) NOT NULL,
    origem VARCHAR(20) CHECK (origem IN ('manipulado', 'revenda')),
    preco DECIMAL(10,2),
    validade_id INT REFERENCES validade(id) ON DELETE SET NULL
);

--PRODUTO_COMANDA
CREATE TABLE produto_comanda (
    id SERIAL PRIMARY KEY,
    comanda_id INT REFERENCES comanda(id) ON DELETE CASCADE,
    produto_id INT REFERENCES produto(id),
    quantidade INT CHECK (quantidade > 0),
    preco_unitario DECIMAL(10,2),
    posologia TEXT
);

--ESTOQUE
CREATE TABLE estoque (
    id SERIAL PRIMARY KEY,
    produto_id INT REFERENCES produto(id),
    unidade_id INT REFERENCES unidade(id),
    quantidade INT CHECK (quantidade >= 0)
);

--GAVETA
CREATE TABLE gaveta (
    id SERIAL PRIMARY KEY,
    unidade_id INT REFERENCES unidade(id),
    gaveta_numero VARCHAR(10) NOT NULL
);

--PRODUTO_GAVETA
CREATE TABLE produto_gaveta (
    gaveta_id INT REFERENCES gaveta(id) ON DELETE CASCADE,
    produto_id INT REFERENCES produto(id) ON DELETE CASCADE,
    PRIMARY KEY (gaveta_id, produto_id)
);

--TAXA_ENTREGA
CREATE TABLE taxa_entrega (
    id SERIAL PRIMARY KEY,
    bairro VARCHAR(50),
    valor DECIMAL(10,2)
);

--ENTREGADOR
CREATE TABLE entregador (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20) UNIQUE NOT NULL,
    data_inicio DATE,
    observacoes TEXT
);

--ENTREGADOR_UNIDADE
CREATE TABLE entregador_unidade (
    entregador_id INT REFERENCES entregador(id) ON DELETE CASCADE,
    unidade_id INT REFERENCES unidade(id) ON DELETE CASCADE,
    PRIMARY KEY (entregador_id, unidade_id)
);

--ENTREGA
CREATE TABLE entrega (
    comanda_id INT PRIMARY KEY REFERENCES comanda(id) ON DELETE CASCADE,
    entregador_id INT REFERENCES entregador(id),
    logradouro VARCHAR(100),
    numero VARCHAR(10),
    complemento VARCHAR(50),
    bairro VARCHAR(50),
    cidade VARCHAR(50),
    estado CHAR(2),
    cep VARCHAR(10),
    taxa_entrega_id INT REFERENCES taxa_entrega(id),
    observacoes TEXT
);

--FORNECEDOR
CREATE TABLE fornecedor (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    contato VARCHAR(100)
);

--PRODUTO_FORNECEDOR
CREATE TABLE produto_fornecedor (
    produto_id INT REFERENCES produto(id) ON DELETE CASCADE,
    fornecedor_id INT REFERENCES fornecedor(id) ON DELETE CASCADE,
    PRIMARY KEY (produto_id, fornecedor_id)
);

-- SEED COMPLETO PARA TODAS AS ENTIDADES

-- USUARIOS
INSERT INTO usuario (nome, email, senha, papel) VALUES
('Alice Silva',    'alice.silva@vitaflora.com',    'senha123', 'admin'),
('Bruno Souza',    'bruno.souza@vitaflora.com',    'senha123', 'funcionario'),
('Carla Pereira',  'carla.pereira@vitaflora.com',  'senha123', 'funcionario'),
('Daniel Costa',   'daniel.costa@vitaflora.com',   'senha123', 'funcionario'),
('Eva Lima',       'eva.lima@vitaflora.com',       'senha123', 'admin');

-- CLIENTES
INSERT INTO cliente (telefone, nome, logradouro, numero, complemento, bairro, cidade, estado, cep) VALUES
('83990001001', 'Mariana Souza',   'Rua das Flores',      '123', '',        'Centro',      'João Pessoa', 'PB', '58000-001'),
('83990001002', 'Lucas Oliveira',  'Av. Brasil',          '456', 'Apto 12', 'Manaíra',     'João Pessoa', 'PB', '58000-002'),
('83990001003', 'Juliana Ramos',   'Rua da Paz',          '78',  '',        'Bessa',       'João Pessoa', 'PB', '58000-003'),
('83990001004', 'Rafael Almeida',  'Praça Central',       '10',  '',        'Centro',      'Campina Gde', 'PB', '58400-100'),
('83990001005', 'Bianca Santos',   'Av. Beira Mar',       '200', 'Loja 5',  'Tambaú',      'João Pessoa', 'PB', '58000-004'),
('83990001006', 'Carlos Pereira',  'Rua do Sol',          '34',  '',        'Altiplano',   'Campina Gde', 'PB', '58400-101'),
('83990001007', 'Fernanda Costa',  'Travessa das Árvores', '5',   '',        'Bancários',   'João Pessoa', 'PB', '58000-005'),
('83990001008', 'Pedro Lima',      'Rua do Limoeiro',     '89',  '',        'Tambauzinho', 'João Pessoa', 'PB', '58000-006'),
('83990001009', 'Larissa Rocha',   'Praça dos Pássaros',  '7',   'Casa',    'Mandacaru',   'Campina Gde', 'PB', '58400-102'),
('83990001010', 'Eduardo Gomes',   'Alameda das Rosas',   '50',  '',        'Jaguaribe',   'João Pessoa', 'PB', '58000-007');

-- TERAPEUTAS
INSERT INTO terapeuta (nome) VALUES
('Dra. Helena Bezerra'),
('Dr. Ricardo Farias'),
('Dra. Camila Alves');

-- CLIENTE_TERAPEUTA
INSERT INTO cliente_terapeuta (cliente_id, terapeuta_id, data_associacao, observacoes) VALUES
(1, 1, '2025-01-15', 'Consulta inicial'),
(2, 2, '2025-02-10', ''),
(3, 1, '2025-03-05', 'Acompanhamento mensal'),
(4, 3, '2025-04-20', ''),
(5, 2, '2025-05-12', 'Avaliação de progresso');

-- UNIDADES
INSERT INTO unidade (nome, logradouro, numero, complemento, bairro, cidade, estado, cep) VALUES
('Matriz', 'Rua Principal',  '100', '', 'Centro',      'João Pessoa', 'PB', '58000-000'),
('Bessa',  'Av. das Flores', '200', '', 'Bessa',       'João Pessoa', 'PB', '58000-100');

-- FUNCIONARIOS
INSERT INTO funcionario (usuario_id, unidade_id, nome, telefone, salario, data_admissao, observacoes) VALUES
(2, 1, 'Bruno Souza',   '83990002001', 2500.00, '2024-01-20', ''),
(3, 1, 'Carla Pereira', '83990002002', 2400.00, '2024-02-15', 'Meio período'),
(4, 2, 'Daniel Costa',  '83990002003', 2300.00, '2024-03-10', '');

-- COMANDAS
INSERT INTO comanda (cliente_id, terapeuta_id, unidade_id, usuario_id, data, status, forma_pagamento, tipo_venda, valor_total) VALUES
(1, 1, 1, 2, '2025-07-20 10:15:00', 'concluída', 'dinheiro', 'balcao', 120.00),
(2, 2, 1, 3, '2025-07-21 11:30:00', 'pendente', 'pix', 'entrega',  75.50),
(3, 1, 2, 2, '2025-07-22 14:45:00', 'concluída', 'cartao', 'balcao',  90.25),
(4, 3, 2, 4, '2025-07-23 09:05:00', 'concluída', 'pix', 'entrega', 150.80),
(5, 2, 1, 3, '2025-07-24 16:20:00', 'cancelada', 'dinheiro', 'balcao',  60.00);

-- VALIDADE
INSERT INTO validade (tipo_produto, validade) VALUES
('Floral', 180),
('Tintura', 365),
('Incenso', 730);

-- PRODUTOS
INSERT INTO produto (nome, tipo, origem, preco, validade_id) VALUES
('Floral Equilíbrio', 'Floral', 'manipulado',  35.00, 1),
('Xarope Tosse Forte', 'Xarope', 'revenda',      25.50, 2),
('Tintura Própolis',   'Tintura', 'revenda',     18.75, 2),
('Incenso Lavanda',    'Incenso', 'revenda',     12.00, 3),
('Floral Alegria',     'Floral', 'manipulado',   40.00, 1),
('Xarope Relaxante',   'Xarope', 'revenda',      22.00, 2),
('Tintura Erva Doce',  'Tintura', 'manipulado',   20.00, 2),
('Incenso Sálvia',     'Incenso', 'manipulado',   15.50, 3),
('Florais Vitalidade', 'Floral', 'manipulado',   45.00, 1),
('Xarope Infantil',    'Xarope', 'revenda',      30.00, 2);

-- PRODUTO_COMANDA
INSERT INTO produto_comanda (comanda_id, produto_id, quantidade, preco_unitario, posologia) VALUES
(1, 1, 2, 35.00, '5 gotas 3x ao dia'),
(1, 3, 1, 18.75, NULL),
(2, 2, 1, 25.50, NULL),
(2, 4, 2, 12.00, NULL),
(3, 5, 1, 40.00, '10 gotas ao acordar'),
(4, 6, 2, 22.00, NULL),
(4, 8, 1, 15.50, NULL),
(5, 9, 1, 45.00, NULL);

-- ESTOQUE
INSERT INTO estoque (produto_id, unidade_id, quantidade) VALUES
(1, 1,  20),
(2, 1,  30),
(3, 1,  25),
(4, 2,  40),
(5, 2,  15),
(6, 1,  10),
(7, 2,  12),
(8, 2,  35),
(9, 1,  18),
(10,1,  22);

-- GAVETA
INSERT INTO gaveta (unidade_id, gaveta_numero) VALUES
(1, 'A1'),
(1, 'A2'),
(2, 'B1'),
(2, 'B2');

-- PRODUTO_GAVETA
INSERT INTO produto_gaveta (gaveta_id, produto_id) VALUES
(1, 1),
(1, 2),
(2, 3),
(2, 5),
(3, 4),
(3, 6),
(4, 7),
(4, 8);

-- TAXA_ENTREGA
INSERT INTO taxa_entrega (bairro, valor) VALUES
('Centro', 5.00),
('Bessa', 7.00),
('Tambaú', 8.50);

-- ENTREGADOR
INSERT INTO entregador (nome, telefone, data_inicio, observacoes) VALUES
('Felipe Santos',   '83990003001', '2024-01-10', 'Entrega preferencial de manhã'),
('Gabriela Rocha',  '83990003002', '2024-02-20', '');

-- ENTREGADOR_UNIDADE
INSERT INTO entregador_unidade (entregador_id, unidade_id) VALUES
(1, 1),
(1, 2),
(2, 2);

-- ENTREGA
INSERT INTO entrega (comanda_id, entregador_id, logradouro, numero, complemento, bairro, cidade, estado, cep, taxa_entrega_id, observacoes) VALUES
(2, 1, 'Rua das Acácias', '321', 'Apto 101', 'Tambaú', 'João Pessoa', 'PB', '58000-010', 3, ''),
(4, 2, 'Av. Marítima',  '150', '',         'Bessa',  'João Pessoa', 'PB', '58000-020', 2, 'Entregar após as 14h');

-- FORNECEDORES
INSERT INTO fornecedor (nome, contato) VALUES
('Pharma Distribuidora', 'contato@pharma.com'),
('Flora Natural LTDA',   'vendas@floranatural.com'),
('Central Farma',        '0800-123-456');

-- PRODUTO_FORNECEDOR
INSERT INTO produto_fornecedor (produto_id, fornecedor_id) VALUES
(2, 1),
(3, 1),
(4, 2),
(6, 3),
(10,2);

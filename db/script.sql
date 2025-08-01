-- USUÁRIO
CREATE TABLE usuario (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    papel VARCHAR(20) CHECK (papel IN ('admin', 'funcionario')) NOT NULL,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- CLIENTE
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

-- TERAPEUTA
CREATE TABLE terapeuta (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

-- CLIENTE_TERAPEUTA (Relacionamento N:N)
CREATE TABLE cliente_terapeuta (
    cliente_id INT REFERENCES cliente(id) ON DELETE CASCADE,
    terapeuta_id INT REFERENCES terapeuta(id) ON DELETE CASCADE,
    data_associacao DATE,
    observacoes TEXT,
    PRIMARY KEY (cliente_id, terapeuta_id)
);

-- UNIDADE
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

-- COMANDA (VENDA)
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

-- VALIDADE
CREATE TABLE validade (
    id SERIAL PRIMARY KEY,
    tipo_produto VARCHAR(30),
    validade INT
);

-- PRODUTO
CREATE TABLE produto (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    tipo VARCHAR(30) NOT NULL,
    origem VARCHAR(20) CHECK (origem IN ('manipulado', 'revenda')),
    preco DECIMAL(10,2),
    validade_id INT REFERENCES validade(id) ON DELETE SET NULL
);

-- PRODUTO_COMANDA (Itens da Comanda)
CREATE TABLE produto_comanda (
    id SERIAL PRIMARY KEY,
    comanda_id INT REFERENCES comanda(id) ON DELETE CASCADE,
    produto_id INT REFERENCES produto(id),
    quantidade INT CHECK (quantidade > 0),
    preco_unitario DECIMAL(10,2),
    posologia TEXT
);

-- ESTOQUE
CREATE TABLE estoque (
    id SERIAL PRIMARY KEY,
    produto_id INT REFERENCES produto(id),
    unidade_id INT REFERENCES unidade(id),
    quantidade INT CHECK (quantidade >= 0)
);

-- GAVETA
CREATE TABLE gaveta (
    id SERIAL PRIMARY KEY,
    unidade_id INT REFERENCES unidade(id),
    gaveta_numero VARCHAR(10) NOT NULL
);

-- PRODUTO_GAVETA (Relacionamento N:N)
CREATE TABLE produto_gaveta (
    gaveta_id INT REFERENCES gaveta(id) ON DELETE CASCADE,
    produto_id INT REFERENCES produto(id) ON DELETE CASCADE,
    PRIMARY KEY (gaveta_id, produto_id)
);

-- TAXA_ENTREGA
CREATE TABLE taxa_entrega (
    id SERIAL PRIMARY KEY,
    bairro VARCHAR(50),
    valor DECIMAL(10,2)
);

-- ENTREGA
CREATE TABLE entrega (
    comanda_id INT PRIMARY KEY REFERENCES comanda(id) ON DELETE CASCADE,
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

-- FORNECEDOR
CREATE TABLE fornecedor (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    contato VARCHAR(100)
);

-- PRODUTO_FORNECEDOR (Relacionamento N:N)
CREATE TABLE produto_fornecedor (
    produto_id INT REFERENCES produto(id) ON DELETE CASCADE,
    fornecedor_id INT REFERENCES fornecedor(id) ON DELETE CASCADE,
    PRIMARY KEY (produto_id, fornecedor_id)
);

-- USUÁRIOS
INSERT INTO usuario (nome, email, senha, papel) VALUES
('Administrador', 'admin@vitaflora.com', 'admin123', 'admin'),
('Funcionário João', 'joao@vitaflora.com', 'senha123', 'funcionario');

-- CLIENTES
INSERT INTO cliente (telefone, nome, logradouro, numero, bairro, cidade, estado, cep) VALUES
('83999990001', 'Maria Souza', 'Rua das Flores', '123', 'Centro', 'João Pessoa', 'PB', '58000-000'),
('83999990002', 'Carlos Pereira', 'Av. Brasil', '456', 'Bessa', 'João Pessoa', 'PB', '58035-000');

-- TERAPEUTAS
INSERT INTO terapeuta (nome) VALUES
('Dra. Helena Costa'),
('Dr. João Mendes');

-- CLIENTE_TERAPEUTA
INSERT INTO cliente_terapeuta (cliente_id, terapeuta_id, data_associacao, observacoes) VALUES
(1, 1, '2024-01-15', 'Consulta inicial'),
(2, 2, '2024-03-10', 'Tratamento contínuo');

-- UNIDADES
INSERT INTO unidade (nome, logradouro, numero, bairro, cidade, estado, cep) VALUES
('Matriz', 'Rua Central', '100', 'Centro', 'João Pessoa', 'PB', '58000-000'),
('Filial', 'Av. Principal', '200', 'Bessa', 'João Pessoa', 'PB', '58035-000');

-- VALIDIDADES
INSERT INTO validade (tipo_produto, validade) VALUES
('Floral', 180),
('Tintura', 365),
('Incenso', 730);

-- PRODUTOS
INSERT INTO produto (nome, tipo, origem, preco, validade_id) VALUES
('Floral Calmante', 'Floral', 'manipulado', 25.00, 1),
('Tintura de Própolis', 'Tintura', 'revenda', 18.50, 2),
('Incenso Lavanda', 'Incenso', 'revenda', 12.00, 3),
('Floral Harmonia', 'Floral', 'manipulado', 30.00, 1);

-- ESTOQUE
INSERT INTO estoque (produto_id, unidade_id, quantidade) VALUES
(1, 1, 20),
(2, 1, 15),
(3, 2, 40),
(4, 2, 25);

-- GAVETAS
INSERT INTO gaveta (unidade_id, gaveta_numero) VALUES
(1, 'A1'),
(1, 'A2'),
(2, 'B1'),
(2, 'B2');

-- PRODUTO_GAVETA
INSERT INTO produto_gaveta (gaveta_id, produto_id) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4);

-- TAXAS DE ENTREGA
INSERT INTO taxa_entrega (bairro, valor) VALUES
('Centro', 5.00),
('Bessa', 7.50),
('Tambaú', 8.00);

-- FORNECEDORES
INSERT INTO fornecedor (nome, contato) VALUES
('Natural Produtos LTDA', 'contato@naturalprodutos.com'),
('Farmácia Central', 'farmcentral@email.com');

-- PRODUTO_FORNECEDOR
INSERT INTO produto_fornecedor (produto_id, fornecedor_id) VALUES
(2, 1),
(3, 1),
(4, 2);

-- COMANDAS
INSERT INTO comanda (cliente_id, terapeuta_id, unidade_id, usuario_id, data, status, forma_pagamento, tipo_venda, valor_total) VALUES
(1, 1, 1, 1, NOW(), 'concluída', 'cartao', 'balcao', 55.00),
(2, 2, 2, 2, NOW(), 'pendente', 'pix', 'entrega', 30.50);

-- ITENS DE COMANDA
INSERT INTO produto_comanda (comanda_id, produto_id, quantidade, preco_unitario, posologia) VALUES
(1, 1, 1, 25.00, '5 gotas 3x ao dia'),
(1, 2, 1, 18.50, '10 ml 2x ao dia'),
(2, 3, 2, 12.00, NULL);

-- ENTREGAS (apenas para comandas tipo entrega)
INSERT INTO entrega (comanda_id, logradouro, numero, complemento, bairro, cidade, estado, cep, taxa_entrega_id, observacoes) VALUES
(2, 'Rua das Acácias', '321', 'Apto 101', 'Tambaú', 'João Pessoa', 'PB', '58000-100', 3, 'Entregar pela manhã');

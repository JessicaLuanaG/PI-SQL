CREATE DATABASE MaJeDu_Motors;
USE MaJeDu_Motors;

DROP VIEW IF EXISTS Valor_total_do_emprestimo;
DROP VIEW IF EXISTS Multas_carros;
DROP VIEW IF EXISTS Carros_disponiveis;

DROP TABLE IF EXISTS Vistoria;
DROP TABLE IF EXISTS Emprestimos;
DROP TABLE IF EXISTS Clientes;
DROP TABLE IF EXISTS Carro;
DROP TABLE IF EXISTS Oficina;

CREATE TABLE Carro (
    Placa_carro VARCHAR(10) PRIMARY KEY,
    Modelo VARCHAR(50) NOT NULL,
    Cor VARCHAR(50) NOT NULL,
    Ano YEAR, -- Usando YEAR para o ano
    Marca VARCHAR(50) NOT NULL,
    Valor_diaria DECIMAL(10, 2) -- Usando DECIMAL para valor monetário
);

CREATE TABLE Oficina(
    Oficina_id INT PRIMARY KEY AUTO_INCREMENT,
    nome_oficina VARCHAR(50) NOT NULL,
    Rua VARCHAR(50),
    Numero_casa INT,
    Complemento VARCHAR(50),
    Cep INT,
    Telefone INT
);

CREATE TABLE Clientes(
    Cpf VARCHAR(50) PRIMARY KEY,
    Nome VARCHAR(50) NOT NULL,
    Cnh INT,
    Rua VARCHAR(50),
    Numero_casa INT,
    Complemento VARCHAR(50),
    Cep INT,
    Telefone INT,
    Email VARCHAR(50)
);

CREATE TABLE Vistoria(
    Vistoria_id INT PRIMARY KEY AUTO_INCREMENT,
    Placa_carro VARCHAR(10),
    Data_Vistoria DATE,
    Sinistro BOOLEAN,
    Oficina_id INT,
    Nome_responsavel VARCHAR(50),
    Valor_vistoria REAL,
    FOREIGN KEY (Placa_carro) REFERENCES Carro(Placa_carro),
    FOREIGN KEY (Oficina_id) REFERENCES Oficina(Oficina_id)
);

CREATE TABLE Emprestimos(
    Emprestimo_id INT PRIMARY KEY, 
    Cpf VARCHAR(50),
    Placa_carro VARCHAR(10),
    Data_emprestimo DATE,
    Data_devolucao DATE,
    FOREIGN KEY (Cpf) REFERENCES Clientes(Cpf),
    FOREIGN KEY (Placa_carro) REFERENCES Carro(Placa_carro)
);

CREATE VIEW Valor_total_do_emprestimo AS 
SELECT Emprestimos.Emprestimo_id, DATEDIFF(Emprestimos.Data_emprestimo, Emprestimos.Data_devolucao) * Carro.Valor_diaria AS Valor_total 
FROM Emprestimos, Carro WHERE Emprestimos.Placa_carro = Carro.Placa_carro;

CREATE VIEW Multas_carros AS 
SELECT DATEDIFF(Emprestimos.Data_devolucao, CURDATE()) * Carro.Valor_diaria * 2 
FROM Emprestimos, Carro WHERE Emprestimos.Placa_carro = Carro.Placa_carro;

CREATE VIEW Carros_disponiveis AS 
SELECT * FROM Carro WHERE Carro.Placa_carro NOT IN (SELECT Emprestimos.Placa_carro FROM Emprestimos WHERE Emprestimos.Data_devolucao IS NULL);

INSERT INTO Carro (Placa_carro, Modelo, Cor, Ano, Marca, Valor_diaria) VALUES
('ABC1234', 'Fusca', 'Azul', 1978, 'Volkswagen', 150.00),
('XYZ5678', 'Civic', 'Preto', 2020, 'Honda', 300.00),
('LMN9012', 'Mustang', 'Vermelho', 2022, 'Ford', 500.00),
('QRS3456', 'Corolla', 'Prata', 2018, 'Toyota', 250.00),
('TUV7890', 'i30', 'Branco', 2021, 'Hyundai', 275.00);

INSERT INTO Vistoria (Placa_carro, Data_Vistoria, Sinistro, Oficina_id, Nome_responsavel, Valor_vistoria) VALUES
('ABC1234', '2024-06-15', 0, 1, 'Carlos Silva', 200.00),
('XYZ5678', '2024-07-01', 1, 2, 'Ana Costa', 350.00),
('LMN9012', '2024-07-20', 0, 1, 'Marcos Pereira', 180.00),
('QRS3456', '2024-07-25', 1, 3, 'Lucia Santos', 300.00),
('TUV7890', '2024-07-30', 0, 2, 'João Oliveira', 275.00);

INSERT INTO clientes (Cpf, Nome, Cnh, Rua, Numero_casa, Complemento, Cep, Telefone, Email)
VALUES 
('12345678900', 'João Silva', 123456, 'Rua A', 123, 'Apto 101', 12345678, 912345678, 'joao.silva@email.com'),

('23456789012', 'Maria Oliveira', 234567, 'Rua B', 456, NULL, 23456789, 923456789, 'maria.oliveira@email.com'),

('34567890123', 'Carlos Santos', 345678, 'Rua C', 789, 'Casa 5', 34567890, 934567890, 'carlos.santos@email.com'),

('45678901234', 'Ana Costa', 456789, 'Rua D', 101, 'Casa 2', 45678901, 945678901, 'ana.costa@email.com'),

('56789012345', 'Roberto Lima', 567890, 'Rua E', 202, 'Apto 303', 56789012, 956789012, 'roberto.lima@email.com');

INSERT INTO oficina (Oficina_id, nome_oficina, Rua, Numero_casa, Complemento, Cep, Telefone)
VALUES 
(1, 'Oficina AutoMec', 'Avenida Principal', 100, 'Sala 201', 12345678, 111223344),

(2, 'Oficina Rápida', 'Rua das Flores', 45, NULL, 23456789, 122334455),

(3, 'Oficina Car Service', 'Rua da Paz', 789, 'Galpão 3', 34567890, 133445566),

(4, 'Oficina Master', 'Rua dos Trabalhadores', 10, 'Próximo ao Mercado', 45678901, 144556677),

(5, 'Oficina Premium', 'Avenida das Nações', 202, NULL, 56789012, 155667788);

INSERT INTO emprestimos (Emprestimo_id, Cpf, Placa_carro, Data_emprestimo, Data_devolucao)
VALUES 
(1, '12345678900', 'ABC1234', '2024-07-01', '2024-07-10'),

(2, '23456789012', 'XYZ5678', '2024-07-05', '2024-07-12'),

(3, '34567890123', 'LMN9012',  '2024-07-10', '2024-07-15'),

(4, '45678901234', 'QRS3456', '2024-07-15', '2024-07-20'),

(5, '56789012345', 'TUV7890', '2024-07-20', '2024-07-25');

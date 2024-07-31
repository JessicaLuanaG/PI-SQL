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
    Oficina_id INT PRIMARY KEY,
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
    Vistoria_id INT PRIMARY KEY,
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


CREATE TABLE Carro (
    Placa_carro VARCHAR(10) PRIMARY KEY,
    Modelo VARCHAR(50) NOT NULL,
    Cor VARCHAR(50) NOT NULL,
    Ano YEAR,
    Marca VARCHAR(50) NOT NULL,
    Valor_diaria REAL
);

CREATE TABLE Oficina(

Oficina_id VARCHAR(50) PRIMARY KEY,
endereço VARCHAR(50) NOT NULL
nome_oficina VARCHAR(50) NOT NULL
    Oficina_id INT PRIMARY KEY,
    Endereço VARCHAR(50) NOT NULL,
    Nome_oficina VARCHAR(50) NOT NULL
);

CREATE TABLE Clientes(

cpf INT PRIMARY KEY,
nome VARCHAR(50) NOT NULL

);

CREATE TABLE Vistoria(
    Vistoria_id INT PRIMARY KEY,
    Placa_carro VARCHAR(10),
    Data_Vistoria DATE,
    Sinistro BOOLEAN,
    Oficina_id INT,
    Nome_responsavel VARCHAR(50),
    Valor_vistoria REAL,
    FOREIGN KEY Placa_carro REFERENCES Carro(Placa_carro),
    FOREIGN KEY Oficina_id REFERENCES Oficina(Oficina_id)
)

CREATE VIEW Valor_total_do_emprestimo AS 
SELECT Emprestimos.emprestimo_id, DATEDIFF(Emprestimos.data_inicio,Emprestimos.data_fim) * Carro.Valor_diaria AS Valor_total 
FROM Emprestimos,Carro WHERE Emprestimos.Placa_carro = Carro.Placa_carro;

CREATE VIEW Multas_carros AS 
SELECT DATADIFF(Emprestimos.data_fim,CURDATE()) * Carro.Valor_diaria * 2 
FROM Emprestimos,Carro WHERE Emprestimos.Placa_carro = Carro.Placa_carro;

CREATE VIEW Carros_disponiveis AS 
SELECT * FROM Carro WHERE Carro.Placa_carro NOT IN (SELECT Emprestimos.Placa_carro FROM Emprestimos WHERE Emprestimos.data_fim IS NULL);

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

CREATE TABLE Emprestimos(
    Emprestimo_id INT PRIMARY KEY, 
    Cpf VARCHAR(50),
    Placa_carro VARCHAR(50),
    Data_emprestimo DATE,
    Data_devolucao DATE,
    FOREIGN KEY Cpf REFERENCES Clientes(Cpf),
    FOREIGN KEY Placa_carro REFERENCES Carro(Placa_carro)
);
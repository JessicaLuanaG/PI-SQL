CREATE TABLE Carro (
    Placa_carro VARCHAR(10) PRIMARY KEY,
    Modelo VARCHAR(50) NOT NULL,
    Cor VARCHAR(50) NOT NULL,
    Ano YEAR,
    Marca VARCHAR(50) NOT NULL,
    Valor_diaria REAL
);

CREATE TABLE Oficina(
    Oficina_id INT PRIMARY KEY,
    Endereço VARCHAR(50) NOT NULL,
    Nome_oficina VARCHAR(50) NOT NULL
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

CREATE TABLE Emprestimos(
    Emprestimo_id INT PRIMARY KEY, 
    Cpf VARCHAR(50),
    Placa_carro VARCHAR(50),
    Data_emprestimo DATE,
    Data_devolucao DATE,
    FOREIGN KEY Cpf REFERENCES Clientes(Cpf),
    FOREIGN KEY Placa_carro REFERENCES Carro(Placa_carro)
);
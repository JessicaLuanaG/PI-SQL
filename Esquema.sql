CREATE TABLE Carro (
    Placa_carro VARCHAR(10) PRIMARY KEY,
    Modelo VARCHAR(50) NOT NULL,
    Cor VARCHAR(50) NOT NULL,
    Ano YEAR,
    Marca VARCHAR(50) NOT NULL,
    Valor_diaria REAL
)
CREATE TABLE Oficina(

oficina_id VARCHAR(50) PRIMARY KEY,
endereço VARCHAR(50) NOT NULL
nome_oficina VARCHAR(50) NOT NULL
);


CREATE TABLE Clientes(

cpf INT PRIMARY KEY,
nome VARCHAR(50) NOT NULL



);
CREATE TABLE Carro (
    Placa_carro VARCHAR(10) PRIMARY KEY,
    Modelo VARCHAR(50) NOT NULL,
    Cor VARCHAR(50) NOT NULL,
    Ano YEAR,
    Marca VARCHAR(50) NOT NULL,
    Valor_diaria REAL
)
CREATE TABLE Oficina(

Oficina_id VARCHAR(50) PRIMARY KEY,
endereço VARCHAR(50) NOT NULL
nome_oficina VARCHAR(50) NOT NULL
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
    FOREIGN KEY Placa_carro REFERENCES Carro(Placa_carro),
    FOREIGN KEY Oficina_id REFERENCES Oficina(Oficina_id)
)

CREATE VIEW Valor_total_do_emprestimo AS 
SELECT Emprestimos.emprestimo_id, DATEDIFF(Emprestimos.data_inicio,Emprestimos.data_fim) * Carro.Valor_diaria AS Valor_total FROM Emprestimos,Carro WHERE Emprestimos.Placa_carro = Carro.Placa_carro;

CREATE TABLE Carro (
    Placa_carro VARCHAR(10) PRIMARY KEY,
    Modelo VARCHAR(50) NOT NULL,
    Cor VARCHAR(50) NOT NULL,
    Ano YEAR,
    Marca VARCHAR(50) NOT NULL,
    Valor_diaria REAL
)
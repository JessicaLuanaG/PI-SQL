CREATE TABLE Carros (
    id INT PRIMARY KEY,
    modelo VARCHAR(255) NOT NULL
);

CREATE TABLE Emprestimos (
    id INT PRIMARY KEY,
    carro_id INT,
    data_inicio DATE,
    data_fim DATE,
    FOREIGN KEY (carro_id) REFERENCES Carros(id)
);

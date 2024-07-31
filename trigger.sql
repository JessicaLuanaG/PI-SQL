

CREATE TRIGGER verificar_carro_emprestado
BEFORE INSERT ON Emprestimos
FOR EACH ROW
BEGIN
    DECLARE qtd INT;

    -- Verifica se há um empréstimo sobrepondo o período de início e fim
    SELECT COUNT(*)
    INTO qtd
    FROM Emprestimos
    WHERE carro_id = NEW.carro_id
    AND ((NEW.data_inicio BETWEEN data_inicio AND data_fim)
    OR (NEW.data_fim BETWEEN data_inicio AND data_fim)
    OR (data_inicio BETWEEN NEW.data_inicio AND NEW.data_fim)
    OR (data_fim BETWEEN NEW.data_inicio AND NEW.data_fim));

    -- Se houver um empréstimo sobrepondo, cancela a inserção
    IF qtd > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'O carro já está emprestado durante o período solicitado.';
    END IF;
END//



DROP TRIGGER verificar_carro_emprestado;
DROP TRIGGER check_return_date;
DROP TRIGGER check_car_inspection;

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

DELIMITER //

CREATE TRIGGER check_return_date
BEFORE INSERT ON emprestimos
FOR EACH ROW
BEGIN
    IF NEW.data_devolucao < NEW.data_emprestimo THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A data de devolução não pode ser anterior à data de empréstimo.';
    END IF;
END//

DELIMITER ;


DELIMITER //

CREATE TRIGGER check_car_inspection
BEFORE INSERT ON emprestimos
FOR EACH ROW
BEGIN
    DECLARE last_devolution DATE;
    DECLARE last_inspection DATE;

    -- Encontre a última data de devolução para o carro
    SELECT MAX(data_devolucao) INTO last_devolution
    FROM emprestimos
    WHERE Placa_carro = NEW.Placa_carro;

    -- Encontre a última vistoria após a última devolução
    SELECT MAX(data_vistoria) INTO last_inspection
    FROM vistorias
    WHERE Placa_carro = NEW.Placa_carro
      AND data_vistoria > last_devolution;

    -- Verifique se a última vistoria é depois da última devolução
    IF last_inspection IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'O carro precisa passar por uma vistoria antes de ser emprestado.';
    END IF;
END//

DELIMITER ;
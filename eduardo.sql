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
    WHERE id_carro = NEW.id_carro;

    -- Encontre a última vistoria após a última devolução
    SELECT MAX(data_vistoria) INTO last_inspection
    FROM vistorias
    WHERE id_carro = NEW.id_carro
      AND data_vistoria > last_devolution;

    -- Verifique se a última vistoria é depois da última devolução
    IF last_inspection IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'O carro precisa passar por uma vistoria antes de ser emprestado.';
    END IF;
END//

DELIMITER ;


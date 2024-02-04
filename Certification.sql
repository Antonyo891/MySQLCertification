CREATE DATABASE IF NOT EXISTS HomeWork6;
USE HomeWork6;
/* Создайте функцию, которая принимает кол-во сек и формат их
 в кол-во дней часов. Пример: 123456 ->
 '1 days 10 hours 17 minutes 36 seconds ' */

DROP TABLE IF EXISTS time_in_seconds;
CREATE TABLE IF NOT EXISTS time_in_seconds
(
Id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
time_interval_name VARCHAR(7) NOT NULL,
seconds_in_interval INT(5) NOT NULL,
numbers_of_intervals INT(8) DEFAULT NULL
);
INSERT INTO time_in_seconds ( time_interval_name, seconds_in_interval)
VALUES
('days', 86400),
('hours', 3600),
('minutes', 60),
('seconds', 1);  
drop FUNCTION if exists sec_to_min;
delimiter $$
 CREATE FUNCTION sec_to_min (sec INT)
 RETURNS VARCHAR(200)
 DETERMINISTIC
 BEGIN
	DECLARE seconds INT default sec;
    DECLARE temp INT default 1;
    DECLARE num_of_interval INT default 0;
    DECLARE sec_in_interval INT default 1;
    DECLARE res VARCHAR(200) default '';
	DROP TEMPORARY TABLE IF EXISTS table_function;
 CREATE TEMPORARY TABLE table_function 
    SELECT DISTINCT* FROM time_in_seconds;
    WHILE temp<5 DO
    SET sec_in_interval = (
		SELECT t.seconds_in_interval FROM time_in_seconds t
		WHERE t.id = temp);
    IF (seconds > sec_in_interval) THEN 
        SET num_of_interval = (seconds DIV sec_in_interval);
        SET seconds = (seconds - num_of_interval*sec_in_interval);
        SET SQL_SAFE_UPDATES = 0;
        UPDATE table_function tf 
        SET tf.numbers_of_intervals = (
			CASE 
				WHEN (tf.id = temp) THEN num_of_interval
				WHEN (tf.id > temp) THEN 0
                END)
		WHERE tf.id>=temp;
		SET SQL_SAFE_UPDATES = 1;
        SET res = CONCAT(res,' ',
    (SELECT CONCAT(tf.numbers_of_intervals,' ',tf.time_interval_name) 
    FROM table_function tf
	WHERE tf.id=temp));
		END IF;
	SET temp = temp+1;
	END WHILE;
    RETURN (res);                 
    end $$ 
    delimiter ; 
SELECT sec_to_min(100000);
 
 /* Выведите только четные числа от 1 до 10. Пример: 2,4,6,8,10  */ 
drop procedure if exists even_numbers;
DELIMITER $$
CREATE PROCEDURE even_numbers (last_number INT)
BEGIN
DECLARE temp INT default 2;
DROP TEMPORARY TABLE IF EXISTS numbers;
CREATE TEMPORARY TABLE IF NOT EXISTS numbers
 (id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 numbers INT(2));
WHILE (temp<=last_number) DO
INSERT INTO numbers (numbers)
VALUE (temp);
SET temp = temp + 2;
END WHILE;
SELECT numbers FROM numbers;
END$$
DELIMITER ;
CALL even_numbers(10);
 
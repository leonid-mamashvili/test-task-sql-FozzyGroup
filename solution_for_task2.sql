--В таблице находятся 8 чисел из диапазона от 1 до 10, в произвольном порядке. Каждое число встречается один раз. 
--Необходимо написать запрос, который из диапазона [min, max] вернёт числа отсутствующие в таблице. 
--Использовать спецфункции нельзя. Решение должно быть наиболее грамотным, понятным и универсальным. 
--Проверить решение на таблице, в которой максимальное число в диапазоне 1 000 000. 

IF Object_id('tempdb..#test_table') IS NOT NULL 
  DROP TABLE #test_table 

CREATE TABLE #test_table 
  ( 
     id INT 
  ) 

GO 

INSERT INTO #test_table 
VALUES (1), (2), (8), (4), (9), (7), (3), (10)  --<-- Отсутствуют числа 5 и 6
GO

--SELECT * 
--FROM   #test_table  

--GO

-- ====== Solution =========


DECLARE @min int = 2	
DECLARE @max int = 8


DECLARE @tableWithNumber TABLE (num int)
INSERT INTO @tableWithNumber (num) (SELECT * 
									FROM #test_table
									GROUP BY id)


DECLARE @missedNumbers TABLE (num INT)

WHILE (@min <= @max) 
	BEGIN
		DECLARE @num INT = (SELECT num FROM @tableWithNumber WHERE num = @min)
		IF (@num IS NULL)
			INSERT INTO @missedNumbers (num) VALUES (@min)
			
		SET @min = @min + 1
	END

SELECT * FROM @missedNumbers

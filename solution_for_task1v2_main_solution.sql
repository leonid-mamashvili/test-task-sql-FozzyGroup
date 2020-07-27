
--Найти все полностью оплаченные заказы. Заказы оплачиваются в порядке очередности по мере поступления заказа.

declare @customers table (id int, name varchar(20))
declare @orders table (id int, summa numeric(18,2), customerId int)
declare @payments table (customerId int, payment numeric(18,2))

insert @customers (id, name)
values 
	(1, 'Первый'), 
	(2, 'Второй'), 
	(3, 'Третий'),
	(4, 'Четвертый')
	
insert @orders (id, summa, customerId)
values 
	(1, 10, 1), 
	(2, 15, 1), 
	(3, 20, 1), 
	(4, 25, 1), 
	(5, 12, 2), 
	(6, 14, 2), 
	(7, 200, 2), 
	(8, 100, 3), 
	(9, 200, 3)
insert @payments (customerId, payment)
values 
	(1, 30), 
	(2, 500), 
	(3, 100), 
	(4, 20)


-- ====== Solution =======

DECLARE @ordersCount INT = (SELECT COUNT(*) FROM @orders)

DECLARE @payedOrders TABLE (orderId int)

DECLARE @customerBill TABLE (summa INT, customerId INT)
INSERT INTO @customerBill (summa, customerId) (SELECT SUM(payment), customerId FROM @payments GROUP BY customerId)




WHILE @ordersCount > 0
	BEGIN
		DECLARE @customerId INT = (SELECT TOP(1) customerId FROM @orders)
		DECLARE @price		INT = (SELECT TOP(1) summa		FROM @orders)
		DECLARE @orderId	INT = (SELECT TOP(1) id			FROM @orders)
		DELETE TOP(1) FROM @orders
		PRINT @orderId
		DECLARE @customerPayment INT = (SELECT summa FROM @customerBill WHERE customerId = @customerId)

		SET @customerPayment = @customerPayment - @price
		UPDATE @customerBill SET summa = @customerPayment WHERE customerId = @customerId


		IF (@customerPayment >= 0)
			BEGIN
				INSERT INTO @payedOrders (orderId) VALUES (@orderId)
				
				SELECT * FROM @customerBill
			END
		


		SET @ordersCount = @ordersCount - 1
	END

SELECT * FROM @payedOrders
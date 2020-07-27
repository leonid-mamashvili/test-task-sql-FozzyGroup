
--˜˜˜˜˜ ˜˜˜ ˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜. ˜˜˜˜˜˜ ˜˜˜˜˜˜˜˜˜˜˜˜ ˜ ˜˜˜˜˜˜˜ ˜˜˜˜˜˜˜˜˜˜˜ ˜˜ ˜˜˜˜ ˜˜˜˜˜˜˜˜˜˜˜ ˜˜˜˜˜˜.

declare @customers table (id int, name varchar(20))
declare @orders table (id int, summa numeric(18,2), customerId int)
declare @payments table (customerId int, payment numeric(18,2))

insert @customers (id, name)
values 
	(1, '˜˜˜˜˜˜'), 
	(2, '˜˜˜˜˜˜'), 
	(3, '˜˜˜˜˜˜'),
	(4, '˜˜˜˜˜˜˜˜˜')
	
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

-- payments from customers
DECLARE @paymentsCount INT = (SELECT COUNT(*) FROM @payments)

DECLARE @payedOrders TABLE (orderId int)

WHILE @paymentsCount > 0
	BEGIN
		DECLARE @customerPayment int = 0
		DECLARE @customerId int = 0

		SET @customerId		 = (SELECT TOP(1) customerId FROM @payments) 
		SET @customerPayment = (SELECT payment FROM @payments WHERE customerId = @customerId)
		DELETE TOP(1) FROM @payments

		DECLARE @customerOrders TABLE (orderId int, price NUMERIC(18,2))
		
		INSERT INTO @customerOrders (orderId, price) (SELECT id, summa FROM @orders WHERE customerId = @customerId)

		DECLARE @fullPrice int = (SELECT SUM(price) FROM @customerOrders)
		IF (@fullPrice <= @customerPayment)
			BEGIN 
				INSERT INTO @payedOrders (orderId) (SELECT orderId FROM @customerOrders)
				DELETE @customerOrders
				CONTINUE
			END

		DECLARE @countCustomerOrders INT = (SELECT COUNT(*) FROM @customerOrders)

		WHILE @countCustomerOrders > 0
			BEGIN
				DECLARE @orderPrice INT = (SELECT TOP(1) price FROM @customerOrders)
				DECLARE @orderId INT	= (SELECT TOP(1) orderId FROM @customerOrders)
				DELETE TOP(1) FROM @customerOrders

				SET @customerPayment = @customerPayment - @orderPrice
				IF @customerPayment >= 0 
					INSERT INTO @payedOrders (orderId) VALUES (@orderId)
				ELSE
					BEGIN
						DELETE @customerOrders
						BREAK 
					END
				SET @countCustomerOrders = @countCustomerOrders - 1
			END

		DELETE @customerOrders
		SET @customerPayment = 0
		SET @paymentsCount = @paymentsCount - 1
	END

SELECT orderId AS pyaidId FROM @payedOrders
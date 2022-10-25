USE master
GO
IF EXISTS (SELECT * FROM sys.databases WHERE Name='AzBank')
DROP DATABASE AzBank
GO
CREATE DATABASE AzBank
GO
USE AzBank
GO

--Tao bang luu tru thong tin khach hang:
CREATE TABLE Customer(
	CustomerID int PRIMARY KEY,
	Name nvarchar(50),
	City nvarchar(50),
	Country nvarchar(50),
	Phone nvarchar(15),
	Email nvarchar(50)
);

--Tao bang luu tru tai khoan cua khach hang:
CREATE TABLE CustomerAccount(
	AccountNumber char(9) PRIMARY KEY,
	CustomerID int,
	Balance money NOT NULL,
	MinAccount money
		CONSTRAINT FK_CA_CustomerID
		FOREIGN KEY (CustomerID)
		REFERENCES Customer(CustomerID)
		ON DELETE CASCADE

);

--Tao bang luu tru cac giao dich cua khach hang:
CREATE TABLE CustomerTransaction(
	TransactionID int PRIMARY KEY,
	AccountNumber char(9),
	TransationDate smalldatetime NOT NULL,
	Amount money,
	DepositorWithdraw bit
		CONSTRAINT FK_CT_AccountNumber
		FOREIGN KEY (AccountNumber)
		REFERENCES CustomerAccount(AccountNumber)
		ON DELETE CASCADE

);

--3. Insert into each table at least 3 records.


INSERT INTO Customer VALUES (9999,'TRANANHA','HANOI','VIETNAM','7564746591623','trananha@gmail.com')
INSERT INTO Customer VALUES (8888,'NGUYENYVAN','HAIPHONG','VIETNAM','7564746341623','nguyenyvan@gmail.com')
INSERT INTO Customer VALUES (7777,'TRANTHIB','HOCHIMINH','VIETNAM','7564616591623','tranthib@gmail.com')
INSERT INTO Customer VALUES (6666,'BUIVANC','TOKYO','NHATBAN','4164746591623','buivanc@gmail.com')
SELECT * FROM Customer

INSERT INTO CustomerAccount VALUES (123444444,9999,50000,10000)
INSERT INTO CustomerAccount VALUES (432111111,7777,80000,10000)
INSERT INTO CustomerAccount VALUES (678999999,8888,100000,10000)
INSERT INTO CustomerAccount VALUES (986777777,6666,20000,10000)
SELECT * FROM CustomerAccount

INSERT INTO CustomerTransaction VALUES (28491231,123444444,'1999-02-01',10000,9)
INSERT INTO CustomerTransaction VALUES (28411231,432111111,'2000-02-11',30000,1)
INSERT INTO CustomerTransaction VALUES (28401231,678999999,'2001-02-12',40000,3)
INSERT INTO CustomerTransaction VALUES (28111231,986777777,'2003-02-09',5000,12)
SELECT * FROM CustomerTransaction

--4.Write a query to get all customers from Customer table who live in ‘Hanoi’.

SELECT Name FROM Customer WHERE City ='HANOI'

--5.Write a query to get account information of the customers (Name, Phone, Email,
--AccountNumber, Balance).

SELECT Name,Phone,Email,AccountNumber,Balance FROM Customer
JOIN CustomerAccount ON Customer.CustomerId = CustomerAccount.CustomerId

--6.A-Z bank has a business rule that each transaction (withdrawal or deposit) won’t be
--over $1000000 (One million USDs). Create a CHECK constraint on Amount column
--of CustomerTransaction table to check that each transaction amount is greater than
--0 and less than or equal $1000000.

ALTER TABLE CustomerTransaction
ADD CONSTRAINT CK_Checkwithdraw CHECK (Amount > 0 and Amount <= 1000000)

--7.Create a view named vCustomerTransactions that display Name,
--AccountNumber, TransactionDate, Amount, and DepositorWithdraw from Customer,
--CustomerAccount and CustomerTransaction tables.

CREATE VIEW vCustomerTransaction
AS
SELECT [Name],CustomerAccount.AccountNumber,TransactionDate,Amount,DepositorWithdraw FROM Customer
JOIN CustomerAccount ON Customer.CustomerId = CustomerAccount.CustomerId
JOIN CustomerTransaction ONCustomerTransaction.AccountNumber = CustomerAccount.AccountNumber

SELECT * FROM vCustomerTransaction
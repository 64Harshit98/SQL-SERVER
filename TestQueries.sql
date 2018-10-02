--TEST QUERIES

--DEFINING CHAR LENGTH IMPORTANT
CREATE TABLE Test(
	Name char(10),
	LName Varchar(10),
);

INSERT INTO Test(Name, LName) VALUES('Harshit', 'Singh');

--TABLE STRUCTURES
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='Shipping';

SELECT * FROM Test;

DROP TABLE Test;

--Image STORAGE
CREATE TABLE Images(
	ID int IDENTITY(1,1) NOT NULL,
	ImageData varbinary(max) NOT NULL
);

INSERT INTO Images(Id, ImgeData) 
SELECT  BulkColumn 
FROM Openrowset( Bulk '‪C:\Users\Harshit\Pictures\1.png', Single_Blob) as EmployeePicture;

--UNICODE VALUES
CREATE TABLE Hindi(
	ID int IDENTITY(1,1) NOT NULL,
	Hindi nvarchar(40) NOT NULL
);

INSERT INTO Hindi(Hindi) VALUES('पोीेपगू');

SELECT * FROM Hindi;

--Data copying
CREATE TABLE BKP(
				Item VARCHAR(10),
				InQty decimal(14,2),
				OutQty decimal(14,2),
				InValue decimal(14,2),
				OutValue decimal(14,2)
);

INSERT INTO  BKP
SELECT * FROM Inventory;

SELECT * FROM BKP;

--Working Procedure

/*SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE FindSite
  @site_id INT

AS

BEGIN

   IF @site_id < 10
      PRINT 'TechOnTheNet.com';
   ELSE
      PRINT 'CheckYourMath.com';

END
GO



EXEC FindSite @site_id=14;

DROP PROCEDURE FindSite;*/

--Procedure with DML and Parameter
/*
CREATE PROCEDURE Find
  @item Varchar(10)

AS

SELECT * FROM Inventory WHERE Item LIKE @item;

GO



EXEC Find @item = "Pen";

DROP PROC Find;*/

--Order by
CREATE PROCEDURE Find
  @item Varchar(10)

AS

SELECT  FROM Inventory ORDER BY OutValue ;

GO



EXEC Find @item = "Pen";

DROP PROC Find;

--Update command in procedure with multiple parameter
/*CREATE PROCEDURE Find
  @item Varchar(10),
  @OutQty INT
AS

UPDATE Inventory
SET OutQty= @OutQty
WHERE Item LIKE @item;

GO



EXEC Find @OutQty = 10, @item = "Chalk" ;

DROP PROC Find;*/
--Table 2
CREATE TABLE Shipping 
(
	ProductId Int UNIQUE, 
	Qty  decimal(14,2), 
	CusId  Int UNIQUE,
	ShipID int IDENTITY(101,1) PRIMARY KEY
 );

 DROP Table Shipping;
ALTER TABLE Shipping
ALTER COLUMN ProductId Int FOREIGN KEY REFERENCES Inventory(ProductId);

 INSERT INTO Shipping (ProductId, Qty, CusId) VALUES (10, 2, 1001);




UPDATE [Product Shipped]
SET CusName = 'Harshit'
WHERE CusName = 'Harry';

ALTER VIEW [Product Shipped] AS
SELECT Customer.CusName, Inventory.Item 
FROM ((Customer JOIN Shipping ON  Customer.CusId = Shipping.CusId)
JOIN Inventory ON Inventory.ProductId=Shipping.ProductId);

DROP VIEW [Product Shipped]

CREATE INDEX idx_EName
ON Employee (Last_Name, First_Name);

BEGIN TRANSACTION 

UPDATE Employee
SET Last_Name = 'Michael'
WHERE First_Name = 'John';

SELECT * FROM Employee;

ROLLBACK

BEGIN TRANSACTION

UPDATE Employee
SET Last_Name = 'Jade'
WHERE First_Name = 'John';

COMMIT;





SELECT Customer.CusName, Shipping.Qty, Inventory.Item 
FROM ((Customer LEFT JOIN Shipping ON  Customer.CusId = Shipping.CusId)
LEFT JOIN Inventory ON Inventory.ProductId=Shipping.ProductId);

SELECT Customer.CusName, Shipping.Qty, Inventory.Item 
FROM ((Customer RIGHT JOIN Shipping ON  Customer.CusId = Shipping.CusId)
RIGHT JOIN Inventory ON Inventory.ProductId=Shipping.ProductId);


--------Save

DECLARE @Open int, @Closing int, @Icode nvarchar(50), @In int, @Out int

	--To Select Opening Qty
	SELECT @Open=SUM(InQty) FROM OINM 
	WHERE CreateDate < @fDate AND ItemCode LIKE @ItemCode;

	--To Select InQty
	SELECT @In=SUM(InQty)
	FROM OINM
	WHERE ItemCode LIKE @ItemCode AND CreateDate BETWEEN @fDate AND @tDate;
	-- To Select Total Out Qty
	SELECT @Out=SUM(OutQty)
	FROM OINM
	WHERE ItemCode LIKE @ItemCode AND CreateDate BETWEEN @fDate AND @tDate;

	SET @Closing = @Open + @In - @Out
	--------
	PRINT @ItemCode; 
    PRINT @Open;
	PRINT @In;
	PRINT @Out;
	PRINT @Closing;

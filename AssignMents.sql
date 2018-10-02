--ASSIGNMENT 1
CREATE TABLE Inventory 
(
Item VARCHAR(10), 
InQty  decimal(14,2),
 OutQty  decimal(14,2), 
InValue  decimal(14,2),
 OutValue  decimal(14,2)
 );
INSERT INTO Inventory (Item, InQty, OutQty, InValue, OutValue) VALUES ('Pen', 10, 5, 1000, 500);
INSERT INTO Inventory (Item, InQty, OutQty, InValue, OutValue) VALUES ('Pencil', 2, 20, 5000, 3000);
INSERT INTO Inventory (Item, InQty, OutQty, InValue, OutValue) VALUES ('Rubber', 60, 10, 60000, 1000);
INSERT INTO Inventory (Item, InQty, OutQty, InValue, OutValue) VALUES ('Notebook', 9, 10, 1000, 500);
INSERT INTO Inventory (Item, InQty, OutQty, InValue, OutValue) VALUES ('Sharpner', 15, 21, 100, 50);
INSERT INTO Inventory (Item, InQty, OutQty, InValue, OutValue) VALUES ('Chalk', 9, 10.5, 15, 17);
INSERT INTO Inventory (Item, InQty, OutQty, InValue, OutValue) VALUES ('Sharpner', 60, 10, 60000, 1000);
INSERT INTO Inventory (Item, InQty, OutQty, InValue, OutValue) VALUES ('Sharpner', 2, 20, 5000, 3000);
INSERT INTO Inventory (Item, InQty, OutQty, InValue, OutValue) VALUES ('Pen', 9, 10, 1000, 500);


DROP TABLE Inventory;
--ASSIGNMENT 2

SELECT * INTO BKP
FROM Inventory;

SELECT * FROM BKP;

--ASSIGNMENT 3
ALTER TABLE Inventory
ADD ProductId int IDENTITY(1,1) PRIMARY KEY ;

Select *,ROW_NUMBER() OVER(PARTITION by Item, Item ORDER BY Item) AS SerialNum from Inventory ORDER BY Item ;

--ASSIGNMENT 4
--1
CREATE TABLE Employee(
	Employee_Id int IDENTITY(1,1) PRIMARY KEY,
	First_Name Varchar(30),
	Last_Name Varchar(30),
	Salary int,
	Joining_Date Date,
	Department Varchar(30)
);

INSERT INTO  Employee( First_Name, Last_Name, Salary, Joining_Date,	Department) VALUES ('John', 'Abraham', 1000000, '2013-01-01', 'Banking');
INSERT INTO  Employee( First_Name, Last_Name, Salary, Joining_Date,	Department) VALUES ('Michael', 'Clarke', 800000, '2013-01-01', 'Insurance');
INSERT INTO  Employee( First_Name, Last_Name, Salary, Joining_Date,	Department) VALUES ('Roy', 'Thomas', 700000, '2013-02-01', 'Banking');
INSERT INTO  Employee( First_Name, Last_Name, Salary, Joining_Date,	Department) VALUES ('Tom', 'Jose', 600000, '2013-02-01', 'Insurance');
INSERT INTO  Employee( First_Name, Last_Name, Salary, Joining_Date,	Department) VALUES ('Jerry', 'Pinto', 650000, '2013-01-01', 'Insurance');
INSERT INTO  Employee( First_Name, Last_Name, Salary, Joining_Date,	Department) VALUES ('Philip', 'Mathow', 750000, '2013-01-01', 'Services');
INSERT INTO  Employee( First_Name, Last_Name, Salary, Joining_Date,	Department) VALUES ('TestName1', '123', 650000, '2013-01-01', 'Services');
INSERT INTO  Employee( First_Name, Last_Name, Salary, Joining_Date,	Department) VALUES ('TestName2', 'lname%', 750000, '2013-02-01', 'Insurance');

--2
SELECT First_Name as 'Employee Name' FROM Employee;

SELECT UPPER(First_Name) AS Fname, LOWER(Last_Name) AS Lname FROM Employee;

SELECT SUBSTRING(First_Name,1,3) AS FirstThree FROM Employee;

SELECT LEN(First_Name) AS 'FName Length' FROM Employee;

SELECT REPLACE(First_Name,'o','$') AS FName FROM Employee;

SELECT (First_Name + ' ' + Last_Name) AS 'Full Name' FROM Employee;

SELECT First_Name, MONTH(Joining_Date) AS 'Joining Month', YEAR(Joining_Date) AS 'Joining Year' FROM Employee;


SELECT Item FROM Inventory
UNION
SELECT Department FROM Employee;

SELECT *  FROM Employee WHERE Salary IN(800000 ,600000)  ;

SELECT *  FROM Employee WHERE Joining_Date BETWEEN '2013-01-01' AND '2013-01-11' ;

SELECT *  FROM Employee WHERE Salary BETWEEN 800000 AND 600000;

SELECT * FROM Employee;

--ASSIGNMENT 5

--JOINS
CREATE TABLE Customer
(
	CusId Int IDENTITY(40,1) PRIMARY KEY,
	CusName Varchar(30),
	Contact decimal(15,0)
);

INSERT INTO Customer( CusName, Contact) VALUES ('Harry', 9876543210);
INSERT INTO Customer( CusName, Contact) VALUES ('Ram', 9872373210);
INSERT INTO Customer( CusName, Contact) VALUES ('Sam', 9876543210);
INSERT INTO Customer( CusName, Contact) VALUES ('Rahul', 9870983210);
INSERT INTO Customer( CusName, Contact) VALUES ('Steve', 9876526010);
INSERT INTO Customer( CusName, Contact) VALUES ('qwerty', 9876517540);

CREATE TABLE Shipping 
(
	ProductId Int FOREIGN KEY REFERENCES Inventory(ProductId), 
	Qty  decimal(14,2), 
	CusId  Int FOREIGN KEY REFERENCES Customer(CusId),
	ShipID int IDENTITY(101,1) PRIMARY KEY
 );
INSERT INTO Shipping (ProductId, Qty, CusId) VALUES (1, 2, 40);
INSERT INTO Shipping (ProductId, Qty, CusId) VALUES (8, 2, 40);
INSERT INTO Shipping (ProductId, Qty, CusId) VALUES (1, 2, 43);
INSERT INTO Shipping (ProductId, Qty, CusId) VALUES (6, 2, 40);
INSERT INTO Shipping (ProductId, Qty, CusId) VALUES (1, 2, 44);

SELECT * FROM Inventory;
SELECT * FROM Customer;
SELECT * FROM Shipping;

--NORMAL JOIN
SELECT * FROM Customer, Shipping, Inventory;

--With Common Key
SELECT * FROM Customer, Shipping, Inventory
WHERE Customer.CusId = Shipping.CusId
AND Inventory.ProductId=Shipping.ProductId;

--INNER JOIN
SELECT Customer.CusName, Shipping.Qty, Inventory.Item 
FROM ((Customer INNER JOIN Shipping ON  Customer.CusId = Shipping.CusId)
INNER JOIN Inventory ON Inventory.ProductId=Shipping.ProductId);

CREATE VIEW [Product Shipped] AS
SELECT Customer.CusName, Shipping.Qty, Inventory.Item 
FROM ((Customer  JOIN Shipping ON  Customer.CusId = Shipping.CusId)
JOIN Inventory ON Inventory.ProductId=Shipping.ProductId);

SELECT * FROM [Product Shipped];

--OUTTER JOIN
SELECT * FROM Customer LEFT JOIN Shipping
ON Customer.CusId = Shipping.CusId;

SELECT * FROM Inventory RIGHT JOIN Shipping
ON Inventory.ProductId=Shipping.ProductId;

SELECT * FROM Shipping RIGHT JOIN Inventory
ON Inventory.ProductId=Shipping.ProductId;

--With Common Key
SELECT Customer.CusName, Shipping.Qty, Inventory.Item 
FROM ((Customer LEFT JOIN Shipping ON  Customer.CusId = Shipping.CusId)
LEFT JOIN Inventory ON Inventory.ProductId=Shipping.ProductId);

SELECT Customer.CusName, Shipping.Qty, Inventory.Item 
FROM ((Customer RIGHT JOIN Shipping ON  Customer.CusId = Shipping.CusId)
RIGHT JOIN Inventory ON Inventory.ProductId=Shipping.ProductId);

-- T1 and T2

CREATE TABLE T1(
	Id Int,
	Name Varchar(30)
);

CREATE TABLE T2(
	Id Int,
	Address Varchar(30)
);

INSERT INTO T1(Id, Name) VALUES (1 , 'A');
INSERT INTO T1(Id, Name) VALUES (2 , 'B');
INSERT INTO T1(Id, Name) VALUES (3 , 'C');
INSERT INTO T1(Id, Name) VALUES (1 , 'D');
INSERT INTO T1(Id, Name) VALUES (4 , 'E');

INSERT INTO T2(Id, Address) VALUES (1 , 'X');
INSERT INTO T2(Id, Address) VALUES (2 , 'Y');
INSERT INTO T2(Id, Address) VALUES (2 , 'Z');
INSERT INTO T2(Id, Address) VALUES (3 , 'P');
INSERT INTO T2(Id, Address) VALUES (5 , 'Q');
INSERT INTO T2(Id, Address) VALUES (6 , 'R');

SELECT T1.Id, T1.Name, T2.Address
FROM T1 INNER JOIN T2
ON T1.Id = T2.Id;

SELECT T1.Id, T1.Name, T2.Address
FROM T1 LEFT JOIN T2
ON T1.Id = T2.Id;


-- With Employee Table
CREATE TABLE Incentives(
	Employee_Ref_Id Int,
	Incentive_Date Date,
	Incentive_Amount decimal(12,2)
);

INSERT INTO Incentives(Employee_Ref_Id, Incentive_Date ,	Incentive_Amount ) VALUES (1, '2013-02-01', 5000);
INSERT INTO Incentives(Employee_Ref_Id, Incentive_Date ,	Incentive_Amount ) VALUES (2, '2013-02-01', 3000);
INSERT INTO Incentives(Employee_Ref_Id, Incentive_Date ,	Incentive_Amount ) VALUES (3, '2013-02-01', 4000);
INSERT INTO Incentives(Employee_Ref_Id, Incentive_Date ,	Incentive_Amount ) VALUES (1, '2013-01-01', 4500);
INSERT INTO Incentives(Employee_Ref_Id, Incentive_Date ,	Incentive_Amount ) VALUES (2, '2013-01-01', 3500);

SELECT * FROM Incentives;

SELECT * FROM Employee;

SELECT Department, SUM(Salary) FROM Employee
GROUP BY Department; 
--HAVING SUM(Salary) IN (SELECT SUM(Salary) FROM Employee GROUP BY Department);


SELECT First_Name FROM Employee
WHERE First_Name LIKE 'J%';

SELECT * FROM Employee
WHERE Salary > 700000;

SELECT * FROM Employee 
WHERE Salary = 
(SELECT MAX(Salary) FROM Employee);

SELECT * FROM Employee
WHERE Department = 'Insurance';

--JOIN
SELECT * FROM Incentives;

SELECT * FROM Employee;

SELECT Employee.First_Name, Incentives.Incentive_Amount FROM
Employee INNER JOIN Incentives ON
Employee.Employee_Id = Incentives.Employee_Ref_Id; 


SELECT Employee.First_Name, Incentives.Incentive_Amount FROM
Employee,Incentives WHERE 
Employee.Employee_Id = Incentives.Employee_Ref_Id AND
Incentives.Incentive_Amount > 3000 ; 


SELECT Employee.First_Name, Incentives.Incentive_Amount FROM
Employee LEFT JOIN Incentives ON
Employee.Employee_Id = Incentives.Employee_Ref_Id; 
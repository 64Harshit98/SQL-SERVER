SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='OINM';

--OINM
SELECT  TransType, SUM( TransValue )'TransValue', SUM(InQty)'InQty', SUM(OutQty)'OutQty'
FROM OINM
GROUP BY TransType;

--OITM
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='OITM';

SELECT ItemName, ItemCode,
ROW_NUMBER() OVER(PARTITION BY ItemName, ItemName ORDER BY ItemName)
FROM OITM;

SELECT *,
ROW_NUMBER() OVER(PARTITION BY ItemName, ItemName ORDER BY ItemName)
FROM OITM;

--OINV and INV1 Item Not returned
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='OINV';
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='INV1';

SELECT * FROM INV1;

SELECT DocEntry, DocDate, ItemCode,LineTotal, Quantity FROM INV1;

--DocEntry, DocDate

SELECT * FROM OINV;
SELECT DISTINCT(ObjType) FROM OINV;
SELECT CANCELED, DocEntry, DocDate FROM OINV;

--JOIN for Sales

SELECT T.DocEntry, T.DocDate, T.ItemCode, T.LineTotal, SUM(T.Quantity) 'SaleQty' 
FROM INV1 T
GROUP BY T.ItemCode, T.DocDate, T.DocEntry, T.LineTotal
HAVING T.DocDate BETWEEN '2018-04-24' AND '2018-05-28';

--ORIN and RIN1 Returned Items
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='ORIN';
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='RIN1';

SELECT * FROM RIN1;
SELECT DocEntry,ItemCode, Quantity, DocDate, LineTotal FROM RIN1;

SELECT * FROM ORIN;
SELECT DISTINCT(ObjType) FROM ORIN;
SELECT DocEntry, CANCELED, DocDate FROM ORIN;

--JOIN For Return

SELECT O.DocEntry, O.DocDate, O.ItemCode, O.LineTotal, SUM(O.Quantity)'ReturnQty' 
FROM RIN1 O
GROUP BY O.ItemCode, O.DocDate, O.DocEntry, O.LineTotal
HAVING O.DocDate BETWEEN '2018-04-24' AND '2018-05-28';


--JOIN for Return and Sales
SELECT  O.DocDate 'Return', T.DocDate 'Sales', T.ItemCode, O.LineTotal 'ReturnValue', T.LineTotal 'SalesValue', SUM(O.Quantity)'ReturnQty' ,
   SUM(T.Quantity) 'SaleQty' INTO #TEMP
FROM RIN1 O INNER JOIN INV1 T 
ON O.ItemCode = T.ItemCode AND  O.DocDate = T.DocDate 
GROUP BY O.ItemCode, O.DocDate, O.DocEntry, O.LineTotal,
T.ItemCode, T.DocDate, T.DocEntry, T.LineTotal
HAVING O.DocDate BETWEEN '2018-04-24' AND '2018-05-28'
AND T.DocDate BETWEEN '2018-04-24' AND '2018-05-28';

SELECT T.DocEntry, T.DocDate, T.ItemCode, T.LineTotal, SUM(T.Quantity) 'SaleQty' 
FROM INV1 T
GROUP BY T.ItemCode, T.DocDate, T.DocEntry, T.LineTotal
HAVING T.DocDate BETWEEN '2018-04-24' AND '2018-05-28';
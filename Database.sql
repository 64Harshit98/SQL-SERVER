SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='OINM';

SELECT ItemCode, SUM(OpenQty), SUM(InQty), SUM(OutQty),   ROW_NUMBER() OVER(PARTITION by ItemCode, ItemCode ORDER BY ItemCode) AS SerialNum 
FROM OINM
GROUP BY ItemCode
HAVING ItemCode LIKE 'ICP0001'; 



SELECT ItemCode, SUM(InQty), SUM(OutQty),ROW_NUMBER() OVER(PARTITION by ItemCode, ItemCode ORDER BY ItemCode) AS SerialNum, DocDate FROM OINM
GROUP BY ItemCode, DocDate
HAVING DocDate < '2018-04-28'; 

SELECT DISTINCT(ItemCode) FROM OINM;

SELECT ItemCode,  SUM(InQty), SUM(OutQty), DocDate ,
ROW_NUMBER() OVER(PARTITION by ItemCode, ItemCode ORDER BY ItemCode) AS SerialNum 
FROM OINM
GROUP BY ItemCode, DocDate
HAVING DocDate BETWEEN '2018-04-28' AND '2018-05-28' ; 

SELECT ItemCode,CreateDate, SUM(InQty) AS InQtya, SUM(OutQty) AS OutQtya ,
ROW_NUMBER() OVER(PARTITION by ItemCode, ItemCode ORDER BY CreateDate) AS SerialNum
FROM OINM GROUP BY ItemCode, CreateDate
HAVING ItemCode IN (SELECT ItemCode FROM OINM  WHERE CreateDate BETWEEN '2018-03-31' AND '2018-05-09')
AND  CreateDate BETWEEN '2018-03-31' AND '2018-05-09'

SELECT ItemCode,DocDate, (SUM(InQty) - SUM(OutQty)) AS Closing,
ROW_NUMBER() OVER(PARTITION by ItemCode, ItemCode ORDER BY ItemCode)
FROM OINM
GROUP BY ItemCode, DocDate
HAVING DocDate < '2018-04-28' ;

SELECT ItemCode, CreateDate, SUM(InQty),
ROW_NUMBER() OVER(PARTITION by ItemCode, ItemCode ORDER BY ItemCode)
FROM OINM
Group BY ItemCode, CreateDate
HAVING ItemCode IN (SELECT ItemCode FROM OINM GROUP BY ItemCode)
WHERE CreateDate < '2018-04-28'

--To Select Opening Qty
SELECT ItemCode, CreateDate, SUM(InQty) AS Opening
FROM OINM
GROUP BY ItemCode,CreateDate
HAVING CreateDate < '2018-04-28' 

--To Select InQty
SELECT ItemCode,  SUM(InQty), SUM(OutQty)
FROM OINM

HAVING CreateDate BETWEEN '2018-04-28' AND '2018-05-28'

-- To Select Total Out Qty
SELECT ItemCode, CreateDate,  SUM(OutQty)
FROM OINM
GROUP BY ItemCode,CreateDate
HAVING CreateDate BETWEEN '2018-04-28' AND '2018-05-28'


SELECT A.ItemCode, SUM(B.InQty) AS Opening, SUM(A.InQty) AS InQty, SUM(A.OutQty) AS OutQty, (SUM(B.InQty) + SUM(A.InQty)- SUM(A.OutQty)) AS Closing, A.CreateDate, B.CreateDate 
FROM OINM A INNER JOIN OINM B
ON A.ItemCode = B.ItemCode AND A.CreateDate = B.CreateDate
GROUP BY A.ItemCode, A.CreateDate, B.CreateDate, B.ItemCode
HAVING A.CreateDate BETWEEN '2018-04-28' AND '2018-05-28'
AND B.CreateDate < '2018-04-28' 
AND SUM(A.InQty) IN (SELECT SUM(A.InQty) FROM OINM A GROUP BY A.ItemCode)
AND SUM(A.OutQty) IN (SELECT SUM(A.OutQty) FROM OINM A GROUP BY A.ItemCode)





----

	
	SELECT ROW_NUMBER() OVER(PARTITION by ItemCode, ItemCode ORDER BY ItemCode) AS SerialNum,
	ItemCode, SUM(InQty) AS InQty, SUM(OutQty) AS OutQty ,DocDate INTO #OpenTemp FROM OINM
	GROUP BY ItemCode, DocDate 
	HAVING DocDate < '2018-04-28' 
	
	SELECT * FROM #OpenTemp
	SELECT ItemCode,(SUM(InQty)- SUM(OutQty)) AS Opening FROM #OpenTemp GROUP BY ItemCode
	DROP TABLE #OpenTemp

	--Updating the Closing Column
	UPDATE H
	SET H.Closing = A.Calc
	FROM #MainTemp H,
	(SELECT T.ItemCode, SUM(T.Opening + T.InQty - T.OutQty) 'Calc' 
	 FROM #MainTemp T) A 
	 WHERE H.ItemCode = A.ItemCode;
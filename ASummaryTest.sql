SELECT DISTINCT(TransId) FROM OJDT;

SELECT TransID FROM JDT1 GROUP BY TransId;

SELECT RefDate, TransId 
FROM OJDT
GROUP BY RefDate, TransId;

SELECT * FROM JDT1;

SELECT SUM(Debit)'Debit', SUM(Credit)'Credit', ShortName, RefDate, TransId 
FROM JDT1
GROUP BY ShortName, RefDate, TransId;

SELECT A.ShortName, A.TransId, SUM(A.Debit), SUM(A.Credit), B.RefDate 
FROM JDT1 A INNER JOIN OJDT B 
ON A.TransId = B.TransId 
GROUP BY A.ShortName, A.TransId, B.RefDate 
HAVING A.ShortName = '2CLDT0401';
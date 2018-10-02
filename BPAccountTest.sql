SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='JDT1';


SELECT * FROM OJDT;

SELECT RefDate, TransId 
FROM OJDT
GROUP BY RefDate, TransId;

SELECT * FROM JDT1;

SELECT SUM(Debit)'Debit', SUM(Credit)'Credit', ShortName, RefDate, TransId 
FROM JDT1
GROUP BY ShortName, RefDate, TransId;

SELECT O.RefDate, O.TransId ,SUM(J.Debit)'Debit', SUM(J.Credit)'Credit', J.ShortName, J.TransId 
FROM OJDT O INNER JOIN JDT1 J 
ON O.TransId = J.TransId
GROUP BY O.RefDate, O.TransId, J.ShortName, J.TransId
ORDER BY RefDate;


SELECT ShortName, SUM(Debit-Credit)'0-30', 0'31-60', 0'61-90', 0'91+' FROM #MAIN2 GROUP BY ShortName,Days HAVING Days <= 31
	UNION
	SELECT ShortName, 0, SUM(Debit-Credit), 0, 0 FROM #MAIN2 GROUP BY ShortName,Days HAVING Days > 30 AND Days<61
	UNION
	SELECT ShortName, 0, 0, SUM(Debit-Credit), 0 FROM #MAIN2 GROUP BY ShortName,Days HAVING Days > 61 AND Days<91
	UNION
	SELECT ShortName, 0, 0, 0, SUM(Debit-Credit) FROM #MAIN2 GROUP BY ShortName,Days HAVING Days >91;

	SELECT ShortName, SUM(Debit)'Debit', SUM(Credit)'Credit', ABS(DATEDIFF(DAY, @Date,RefDate))'Days' 
	INTO #MAIN2 FROM #MAIN 
	GROUP BY ShortName, RefDate;
	
	SELECT ShortName, Days, SUM(Debit)'Debit', SUM(Credit)'Credit'  
	INTO #MAIN3 FROM #MAIN2 
	GROUP BY ShortName, Days;

	SELECT ShortName, SUM(Credit-Debit)'0-30' INTO #T1 FROM #MAIN3  GROUP BY ShortName,Days HAVING Days < 31
	
	SELECT ShortName, SUM(Credit-Debit)'31-60' INTO #T2 FROM #MAIN3 GROUP BY ShortName,Days HAVING Days BETWEEN 31 AND 60
	
	SELECT ShortName, SUM(Credit-Debit)'61-90' INTO #T3 FROM #MAIN3 GROUP BY ShortName,Days HAVING Days BETWEEN 61 AND 90
	
	SELECT ShortName, SUM(Credit-Debit)'91' INTO #T4 FROM #MAIN3 GROUP BY ShortName,Days HAVING Days >91;
	
	SELECT X.* INTO #Final FROM( 
	SELECT Shortname, 0-30'0-30', 0'31-60', 0'61-90', 0'91' FROM #T1 GROUP BY ShortName 
	UNION
	SELECT Shortname, 0, 31-60, 0, 0 FROM #T2 GROUP BY ShortName
	UNION
	SELECT Shortname, 0, 0, 61-90, 0 FROM #T3 GROUP BY ShortName
	UNION
	SELECT Shortname, 0, 0, 0, 91 FROM #T4 GROUP BY ShortName) X;
	
	SELECT ShortName, SUM(0-30)'0-30', SUM(31-60)'31-60', SUM(61-90)'61-90',SUM(90)'90' FROM #Final GROUP BY ShortName;
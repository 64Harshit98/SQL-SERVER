SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE BPAccount
	-- Add the parameters for the stored procedure here
	@Date Date
AS
	DECLARE @day int

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT J.ShortName, (DATEDIFF(DAY,O.RefDate, @Date))'Days' ,SUM(J.Debit)-SUM(J.Credit)'Diff'
	INTO #MAIN 
	FROM OJDT O INNER JOIN JDT1 J 
	ON O.TransId = J.TransId
	GROUP BY O.RefDate, O.TransId, J.ShortName, J.TransId
	HAVING O.RefDate < @Date;
	
	SELECT ShortName,
	(CASE WHEN days between 0 and 30 THEN diff ELSE 0 END) '0-30',
	(CASE WHEN days between 31 and 60 THEN diff ELSE 0 END) '31-60',
	(CASE WHEN days between 61 and 90 THEN diff ELSE 0 END) '61-90',
	(CASE WHEN days>90 THEN diff ELSE 0 END) '90' 
	INTO #Final FROM #MAIN;


	SELECT ShortName,
	SUM([0-30])[0-30],
	SUM([31-60])[31-60],
	SUM([61-90])[61-90],
	SUM([90])[90] 
	FROM #Final 
	GROUP BY ShortName;

END
GO


EXEC BPAccount @Date='2018-06-17';

DROP PROC BPAccount;
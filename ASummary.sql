
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE ASummary
	-- Add the parameters for the stored procedure here
	@SName nVarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT A.ShortName, A.TransId, B.RefDate, SUM(A.Debit)'Debit', SUM(A.Credit)'Credit'
	INTO #Temp1 
	FROM JDT1 A INNER JOIN OJDT B 
	ON A.TransId = B.TransId 
	GROUP BY A.ShortName, A.TransId, B.RefDate 
	HAVING A.ShortName = @SName;

	SELECT A.ShortName, B.TransId , B.ShortName'Account', A.RefDate, 
	B.Debit'Debit', B.Credit'Credit', A.Credit'MainCredit'
	INTO #Main
	FROM #Temp1 A INNER JOIN JDT1 B
	ON A.TransId = B.TransId AND A.RefDate = B.RefDate
	WHERE B.ShortName != @SName
	ORDER BY A.RefDate;

	SELECT * FROM #Main ;

END
GO

EXEC  ASummary @SName ='2CLDT0401';

DROP PROC ASummary;

--2CLDT0401 , 5DE0202 
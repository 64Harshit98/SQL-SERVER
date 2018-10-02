
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE Sale
	-- Add the parameters for the stored procedure here
	@fDate Date,
	@tDate Date,
	@ICode nVarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--Sales
	SELECT O.DocDate, O.DocEntry, R.ItemCode, SUM(R.Quantity)'SalesQty', R.LineTotal
	INTO #Sales
	FROM OINV O INNER JOIN INV1 R
	ON O.DocEntry = R.DocEntry
	GROUP BY O.DocDate, O.DocEntry, R.ItemCode, R.LineTotal, R.DocDate
	HAVING O.DocDate BETWEEN @fDate AND @tDate;

	--Return
	SELECT O.DocDate, O.DocEntry, R.ItemCode, SUM(R.Quantity)'ReturnQty', R.LineTotal
	INTO #Return
	FROM ORIN O INNER JOIN RIN1 R
	ON O.DocEntry = R.DocEntry
	GROUP BY O.DocDate, O.DocEntry, R.ItemCode, R.LineTotal, R.DocDate
	HAVING O.DocDate BETWEEN @fDate AND @tDate;

	SELECT ItemCode,SUM(SalesQty)'SalesQty', SUM(LineTotal)'SalesValue',0 'ReturnQty', 0 'ReturnValue'  FROM #Sales GROUP BY ItemCode
	UNION 
	SELECT ItemCode,0,0,SUM(ReturnQty)'ReturnQty', SUM(LineTotal)'ReturnValue' FROM #Return GROUP BY ItemCode


END
GO

EXEC Sale @fDate='2018-04-28', @tDate='2018-05-28', @ICode= 'ICP0001';

DROP PROC Sale;






--SELECT T.ItemCode,SUM(T.SalesQTY)'SalesQTY', SUM(T.SalesVALUE)'SalesValue', SUM(T.ReturnQTY)'ReturnQTY', SUM(T.ReturnValue)'ReturnValue', O.ItemCode,SUM(O.SalesQTY)'SalesQTY', SUM(O.SalesVALUE)'SalesValue', SUM(O.ReturnQTY)'ReturnQTY', SUM(O.ReturnValue)'ReturnValue' FROM #MAIN1 T JOIN #MAIN2 O
	-- ON T.DocDate= O.DocDate AND T.ItemCode= O.ItemCode 
	-- GROUP BY T.ItemCode, O.ItemCode;
	
	
	
	--SELECT S.ItemCode,  SUM(S.SalesQty)'SalesQTY', SUM(S.LineTotal)'SalesValue', SUM(R.ReturnQty)'ReturnQTY', SUM(R.LineTotal)'ReturnValue' 
	--INTO #MAIN1
	--FROM #Sales S LEFT JOIN  #Return R
	--ON S.ItemCode = R.ItemCode 
	--GROUP BY S.ItemCode, S.DocDate;

	--SELECT R.ItemCode, SUM(S.SalesQty)'SalesQTY', SUM(S.LineTotal)'SalesValue', SUM(R.ReturnQty)'ReturnQTY', SUM(R.LineTotal)'ReturnValue'
	--INTO #MAIN2 
	--FROM #Sales S RIGHT JOIN  #Return R
	--ON S.ItemCode = R.ItemCode 
	--GROUP BY R.ItemCode,R.DocDate ;

	--SELECT ItemCode,
	--SUM(SalesQTY)'SalesQty', SUM(SalesValue)'SalesValue', SUM(ReturnQTY)'ReturnQTY', SUM(ReturnValue)'ReturnValue' 
	--FROM #MAIN1 GROUP BY ItemCode;

	--SELECT ItemCode,
	--SUM(SalesQTY)'SalesQty', SUM(SalesValue)'SalesValue', SUM(ReturnQTY)'ReturnQTY', SUM(ReturnValue)'ReturnValue' 
	--FROM #MAIN2 GROUP BY ItemCode;
	
	--SELECT S.ItemCode,SUM(S.SalesQty)'SalesQty', SUM(S.LineTotal)'SalesValue', SUM(R.ReturnQty)'ReturnQty', SUM(R.LineTotal)'ReturnValue'
	-- FROM #Sales S JOIN #Return R 
	-- ON S.ItemCode = R.ItemCode
	-- GROUP BY S.ItemCode, R.ItemCode;
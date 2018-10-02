
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE Calculate 
	-- Add the parameters for the stored procedure here
	@fDate DATE,
	@tDate DATE
AS

BEGIN

	SELECT ROW_NUMBER() OVER(PARTITION by ItemCode, ItemCode ORDER BY ItemCode) AS SerialNum,
	ItemCode, 
	Convert(numeric(19,6),0.0) 'Opening',
	SUM(InQty) AS InQty, SUM(OutQty) AS OutQty ,DocDate ,
	Convert(numeric(19,6),0.0) 'Closing'
	INTO #MainTemp FROM OINM
	GROUP BY ItemCode, DocDate 
	HAVING DocDate BETWEEN @fDate AND @tDate;
	

	UPDATE H
	SET H.Opening=A.Total
	FROM #MainTemp H,(SELECT T.ItemCode,SUM(T.InQty-T.OutQty) 'Total'
						 FROM OINM T WHERE DocDate < @fDate
						 GROUP BY t.ItemCode)A
	WHERE H.ItemCode = A.ItemCode

	UPDATE H
	SET H.Closing=A.Calc
	FROM #MainTemp H,(SELECT T.ItemCode, SUM(T.Opening + T.InQty - T.OutQty) 'Calc'
							FROM #MainTemp T GROUP BY ItemCode) A
	WHERE H.ItemCode = A.ItemCode;
	


	SELECT ItemCode, SUM(Opening) AS Opening, SUM(InQty) AS InQty, SUM(OutQty) AS OutQty, SUM(Closing)  AS Closing
	FROM #MainTemp 
	GROUP BY ItemCode;

END
GO

EXEC Calculate @fDate='2018-04-28', @tDate='2018-05-28';

DROP PROC Calculate;


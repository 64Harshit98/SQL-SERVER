-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE DataInsert 
	@Item Varchar(10), 
	@InQty decimal, 
	@OutQty decimal, 
	@InValue decimal, 
	@OutValue decimal
AS
	DECLARE @Sno Int
	SELECT @sno = MAX(SerialNum) FROM Inventory WHERE Item LIKE @item;
--INSERT INTO Inventory (Item, InQty, OutQty, InValue, OutValue) VALUES (@Item, @InQty, @OutQty, @InValue, @OutValue);

BEGIN
	IF @Sno = 1
		SET @sno = @sno + 1
   ELSE
      SET @sno = 1

INSERT INTO Inventory (Item, InQty, OutQty, InValue, OutValue, SerialNum) VALUES (@Item, @InQty, @OutQty, @InValue, @OutValue, @sno);
END
GO

EXEC DataInsert @Item = "Card", @InQty = 14.5, @OutQty = 50, @InValue = 210, @OutValue = 7000 ;

DROP PROCEDURE DataInsert;
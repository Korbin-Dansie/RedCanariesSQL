-- Assignment:	Project Phase 3
-- Authors:		Briella Rutherford, Korbin Dansie
-- Date:		11/16/2022

USE master
	IF EXISTS (SELECT * FROM sysdatabases WHERE name='RedCanaries_CS3550')
	DROP DATABASE RedCanaries_CS3550

	EXEC sp_dropserver 'FARMS', 'droplogins'

	EXEC sp_addlinkedserver
		@server = N'FARMS',
		@srvproduct = N'SQLSERVER', 
		@provider = N'SQLNCLI',
		@datasrc = N'LAPTOP-5AR7P28S\SQLEXPRESS', -- DESKTOP-EVA or LAPTOP-5AR7P28S
		@catalog = N'FARMS'

	EXEC sp_serveroption N'FARMS', 'data access', 'true'
	EXEC sp_serveroption N'FARMS', 'rpc', 'true'
	EXEC sp_serveroption N'FARMS', 'rpc out', 'true'
	EXEC sp_serveroption N'FARMS', 'collation compatible', 'true'

	EXEC sp_addlinkedsrvlogin 'FARMS', 'true'

	EXEC sp_configure 'show advanced options', 1
	reconfigure

	GO

	EXEC sp_configure 'Ad Hoc Distributed Queries', 1
	reconfigure

GO

CREATE DATABASE RedCanaries_CS3550
ON PRIMARY
(
	NAME = 'RedCanaries_CS3550', --.mdf
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\RedCanaries_CS3550.mdf',
	SIZE = 4MB,
	MAXSIZE = 4MB,
	FILEGROWTH = 500KB
)
GO

USE RedCanaries_CS3550

CREATE TABLE [Address] 
( 
	AddressID		smallint		NOT NULL	IDENTITY(1,1),
	AddrLine1		varchar(30)		NOT NULL,
	AddrLine2		varchar(10),
	AddrCity		varchar(20)		NOT NULL,
	AddrState		char(2),
	AddrPostalCode	char(10)		NOT NULL,
	AddrCountry		varchar(20)		NOT NULL
);
             
CREATE TABLE Restaurant
(
	RestaurantID		smallint	NOT NULL	IDENTITY(1,1),
	RestaurantName		varchar(20),
	AddressID			smallint	NOT NULL,
	RestaurantPhone		varchar(10)	NOT NULL,
	HotelID				smallint
);

CREATE TABLE Menu
(
	MenuID			int			NOT NULL	IDENTITY(1,1),
	RestaurantID	smallint	NOT NULL,
	MenuName		varchar(20)	NOT NULL,
	MenuStartTime	time		NOT NULL,
	MenuEndTime		time		NOT NULL
);

CREATE TABLE Menu_Item
(
	MenuItemID		int			NOT NULL	IDENTITY(1,1),
	FoodItemID		smallint	NOT NULL,
	MenuID			int			NOT NULL,
	MenuItemPrice	smallmoney
);

CREATE TABLE Food_Item
(
	FoodItemID			smallint	NOT NULL	IDENTITY(1,1),
	FoodName			varchar(30)	NOT NULL,
	FoodDescription		varchar(MAX),
	AgeRestricted		bit			NOT NULL,
	FoodCategoryID		tinyint		NOT NULL,
	FoodDefaultPrice	smallmoney	NOT NULL
)

CREATE TABLE Food_Category
(
	FoodCategoryID	tinyint			NOT NULL,
	CategoryName	varchar(20)		NOT NULL
)

CREATE TABLE Recipe
(
	RecipeID		int			NOT NULL	IDENTITY(1,1),
	FoodItemID		smallint	NOT NULL,
	IngredientID	smallint	NOT NULL
)

CREATE TABLE Ingredient
(
	IngredientID	smallint	NOT NULL	IDENTITY(1,1),
	IngredientName	varchar(30)	NOT NULL
)

CREATE TABLE Ordered_Item
(
	OrderedItemID		int			NOT NULL	IDENTITY(1,1),	
	FoodItemID			smallint	NOT NULL,
	ReceiptID			int			NOT NULL,
	OrderedAdjustments	varchar(MAX),
	OrderedPrice		smallmoney	NOT NULL,
	OrderedItemQty		tinyint
)


CREATE TABLE Receipt
(
	ReceiptID				int			NOT NULL IDENTITY(1,1),
	ReceiptCCType			varchar(5),
	ReceiptCCNumber			varchar(16),
	DiscountID				smallint,
	RestaurantID			smallint,
	ReceiptTip				smallmoney,
	ReceiptFolio			bit,
	ReceiptDate				datetime,
	ReceiptAgeVerified		bit
)

CREATE TABLE Discount
(
	DiscountID			smallint	NOT NULL	IDENTITY(1,1),
	DiscountDescription	varchar(50)	NOT NULL,
	DiscountExpiration	date		NOT NULL,
	DiscountRules		varchar(100),
	DiscountAmount		smallmoney,
	DiscountPercent		decimal(4,2)
)

CREATE TABLE Special
(
	SpecialID		int			NOT NULL	IDENTITY(1,1),
	FoodItemID		smallint	NOT NULL,
	RestaurantID	smallint	NOT NULL,
	SpecialWeekDay	tinyint
)


-- Temporarily add hotel table
CREATE TABLE Hotel
(
	HotelID				smallint	NOT NULL, --NOT an Identity
	HotelName			varchar(30)	NOT NULL,
	HotelAddress		varchar(30)	NOT NULL,
	HotelCity			varchar(20)	NOT NULL,
	HotelState			varchar(2),
	HotelCountry		varchar(20)	NOT NULL,
	HotelPostalCode		char(10)	NOT NULL,
	HotelStarRating		char(1),
	HotelPictureLink	varchar(100),
	TaxLocationID		smallint	NOT NULL
)
GO

/****************************************************************
*
*	Add constraints
*
****************************************************************/
/********************************
*	Set Primary Keys
********************************/
	ALTER TABLE [Address]
	ADD PRIMARY KEY (AddressID)

	ALTER TABLE Restaurant
	ADD PRIMARY KEY (RestaurantID)
	
	ALTER TABLE Menu
	ADD PRIMARY KEY (MenuID)
	
	ALTER TABLE Menu_Item
	ADD PRIMARY KEY (MenuItemID)

	ALTER TABLE Food_Item
	ADD PRIMARY KEY (FoodItemID)

	ALTER TABLE Food_Category
	ADD PRIMARY KEY (FoodCategoryID)

	ALTER TABLE Recipe
	ADD PRIMARY KEY (RecipeID)

	ALTER TABLE Ingredient
	ADD PRIMARY KEY (IngredientID)

	ALTER TABLE Ordered_Item
	ADD PRIMARY KEY (OrderedItemID)

	ALTER TABLE Receipt
	ADD PRIMARY KEY (ReceiptID)

	ALTER TABLE Discount
	ADD PRIMARY KEY (DiscountID)

	ALTER TABLE Special
	ADD PRIMARY KEY (SpecialID)

	-- Temporarily add hotel table
	ALTER TABLE Hotel
	ADD PRIMARY KEY (HotelID)
GO
/********************************
*	1 Address
********************************/

/********************************
*	2 Restaurant
********************************/
	-- Foreign Keys
	ALTER TABLE Restaurant
	ADD FOREIGN KEY (AddressID) REFERENCES [Address](AddressID)
	
	--ALTER TABLE Restaurant
	--ADD FOREIGN KEY (HotelID) REFERENCES Hotel(HotelID)

/********************************
*	3 Menu
********************************/
	-- Foreign Keys
	ALTER TABLE Menu
	ADD FOREIGN KEY (RestaurantID) REFERENCES Restaurant(RestaurantID)
	
/********************************
*	4 Menu_Item
********************************/
	ALTER TABLE Menu_Item
	ADD FOREIGN KEY (FoodItemID) REFERENCES Food_Item(FoodItemID)
	
	ALTER TABLE Menu_Item
	ADD FOREIGN KEY (MenuID) REFERENCES Menu(MenuID)

/********************************
*	5 Food_Item
********************************/
	ALTER TABLE Food_Item
	ADD FOREIGN KEY (FoodCategoryID) REFERENCES Food_Category(FoodCategoryID)

/********************************
*	6 Food_Category
********************************/

/********************************
*	7 Recipe
********************************/
	-- Foreign Keys
	ALTER TABLE Recipe
	ADD FOREIGN KEY (FoodItemID) REFERENCES Food_Item(FoodItemID)

	ALTER TABLE Recipe
	ADD FOREIGN KEY (IngredientID) REFERENCES Ingredient(IngredientID)

/********************************
*	8 Ingredient
********************************/
	
/********************************
*	9 Ordered_Item
********************************/
	-- Foreign Keys
	ALTER TABLE Ordered_Item
	ADD FOREIGN KEY (FoodItemID) REFERENCES Food_Item(FoodItemID)

	ALTER TABLE Ordered_Item
	ADD FOREIGN KEY (ReceiptID) REFERENCES Receipt(ReceiptID)

	-- Default Keys
	ALTER TABLE Ordered_Item
	ADD CONSTRAINT df_OrderedItemQty
	DEFAULT 1 FOR OrderedItemQty

/********************************
*	10 Receipt
********************************/
	-- Foreign Keys
	ALTER TABLE Receipt
	ADD FOREIGN KEY (DiscountID) REFERENCES Discount(DiscountID)

	ALTER TABLE Receipt
	ADD FOREIGN KEY (RestaurantID) REFERENCES Restaurant(RestaurantID)

	-- Default Keys
	ALTER TABLE Receipt
	ADD CONSTRAINT df_ReceiptFolio
	DEFAULT 0 FOR ReceiptFolio
	
	ALTER TABLE Receipt
	ADD CONSTRAINT df_ReceiptAgeVerified
	DEFAULT 0 FOR ReceiptAgeVerified

/********************************
*	11 Discount
********************************/

/********************************
*	12  Special
********************************/
	-- Foreign Keys
	ALTER TABLE Special
	ADD FOREIGN KEY (FoodItemID) REFERENCES Food_Item(FoodItemID)

	ALTER TABLE Special
	ADD FOREIGN KEY (RestaurantID) REFERENCES Restaurant(RestaurantID)

/****************************************************************
*
*	Bulk insert
*
****************************************************************/
PRINT('ADD Address')
BULK INSERT [Address]
FROM 'C:\Stage_RedCanaries\Address.csv'
WITH
(
	FIELDTERMINATOR =	'|',
	ROWTERMINATOR =		'\n',
	FIRSTROW = 2
)

PRINT('****************************************************************')
PRINT('ADD Restaurant')
BULK INSERT Restaurant
FROM 'C:\Stage_RedCanaries\Restaurant.csv'
WITH
(
	FIELDTERMINATOR =	'|',
	ROWTERMINATOR =		'\n',
	FIRSTROW = 2
)

PRINT('****************************************************************')
PRINT('ADD Menu')
BULK INSERT Menu
FROM 'C:\Stage_RedCanaries\Menu.csv'
WITH
(
	FIELDTERMINATOR =	'|',
	ROWTERMINATOR =		'\n',
	FIRSTROW = 2
)

PRINT('****************************************************************')
PRINT('ADD Menu_Item')
BULK INSERT Menu_Item
FROM 'C:\Stage_RedCanaries\Menu_Item.csv'
WITH
(
	FIELDTERMINATOR =	'|',
	ROWTERMINATOR =		'\n',
	FIRSTROW = 2
)

PRINT('****************************************************************')
PRINT('ADD Food_Item')
BULK INSERT Food_Item
FROM 'C:\Stage_RedCanaries\Food_Item.csv'
WITH
(
	FIELDTERMINATOR =	'|',
	ROWTERMINATOR =		'\n',
	FIRSTROW = 2
)

PRINT('****************************************************************')
PRINT('ADD Food_Category')
BULK INSERT Food_Category
FROM 'C:\Stage_RedCanaries\Food_Category.csv'
WITH
(
	FIELDTERMINATOR =	'|',
	ROWTERMINATOR =		'\n',
	FIRSTROW = 2
)

PRINT('****************************************************************')
PRINT('ADD Recipe')
BULK INSERT Recipe
FROM 'C:\Stage_RedCanaries\Recipe.csv'
WITH
(
	FIELDTERMINATOR =	'|',
	ROWTERMINATOR =		'\n',
	FIRSTROW = 2
)

PRINT('****************************************************************')
PRINT('ADD Ingredient')
BULK INSERT Ingredient
FROM 'C:\Stage_RedCanaries\Ingredient.csv'
WITH
(
	FIELDTERMINATOR =	'|',
	ROWTERMINATOR =		'\n',
	FIRSTROW = 2
)

PRINT('****************************************************************')
PRINT('ADD Ordered_Item')
BULK INSERT Ordered_Item
FROM 'C:\Stage_RedCanaries\Ordered_Item.csv'
WITH
(
	FIELDTERMINATOR =	'|',
	ROWTERMINATOR =		'\n',
	FIRSTROW = 2
)

PRINT('****************************************************************')
PRINT('ADD Receipt')
BULK INSERT Receipt
FROM 'C:\Stage_RedCanaries\Receipt.csv'
WITH
(
	FIELDTERMINATOR =	'|',
	ROWTERMINATOR =		'\n',
	FIRSTROW = 2
)

PRINT('****************************************************************')
PRINT('ADD Discount')
BULK INSERT Discount
FROM 'C:\Stage_RedCanaries\Discount.csv'
WITH
(
	FIELDTERMINATOR =	'|',
	ROWTERMINATOR =		'\n',
	FIRSTROW = 2
)

PRINT('****************************************************************')
PRINT('ADD Special')
BULK INSERT Special
FROM 'C:\Stage_RedCanaries\Special.csv'
WITH
(
	FIELDTERMINATOR =	'|',
	ROWTERMINATOR =		'\n',
	FIRSTROW = 2
)
PRINT('****************************************************************')

GO

-- =============================================
-- OUT OF ORDER SO THAT sp_SendBillToRoom CAN CALL IT
-- Author:		Korbin Dansie 
-- Create date: 2022-11-16
-- Description:	Given a ReceiptID, return only the total cost of all OrderedItems for that Receipt as a smallmoney.
-- =============================================
CREATE FUNCTION dbo.ReceiptTotalAmount(@ReceiptID int)
RETURNS @ReceiptAmounts table (SubTotal smallmoney, DiscountAmount smallmoney, TotalAmount smallmoney, ItemCount tinyint) 
AS
BEGIN
	DECLARE
		@SubTotal		smallmoney = 0,
		@DiscountAmount	smallmoney,
		@ItemCount		tinyint	   = 0

	-- Cursor through to find subtotal
	DECLARE 
		@SingleItemPrice smallmoney,
		@SingleItemQty	 tinyint

	DECLARE cursor_OrderedItems CURSOR

	FOR SELECT
		OI.OrderedPrice,
		OI.OrderedItemQty
	FROM Receipt AS RCPT
		INNER JOIN Ordered_Item AS OI
		ON RCPT.ReceiptID = OI.ReceiptID
	WHERE
		RCPT.ReceiptID = @ReceiptID

	OPEN cursor_OrderedItems

	FETCH NEXT FROM cursor_OrderedItems INTO
		@SingleItemPrice ,
		@SingleItemQty	 

	---- Subtotal = Price * amount, and count how many items were orderd
	WHILE @@FETCH_STATUS = 0
    BEGIN
		SET @SubTotal = @SubTotal + @SingleItemPrice * @SingleItemQty
		SET @ItemCount = @ItemCount + @SingleItemQty

		FETCH NEXT FROM cursor_OrderedItems INTO
			@SingleItemPrice ,
			@SingleItemQty	 
    END
	CLOSE cursor_OrderedItems
	DEALLOCATE cursor_OrderedItems


	-- Find discount percentage OR amount
	DECLARE
		@DiscountOffAmount	smallmoney,
		@DiscountOffPercent	decimal(4,2)

	SELECT @DiscountOffAmount = D.DiscountAmount, @DiscountOffPercent = D.DiscountPercent
	FROM Receipt AS RCPT
		INNER JOIN Discount AS D
		ON RCPT.DiscountID = D.DiscountID
	WHERE
		RCPT.ReceiptID = @ReceiptID

	---- Do math to find Discounted Rate. If its a percentage off find the amount. If its an fixed amount off just subtract it. If no discount set it to @QuotedRate
	IF @DiscountOffPercent > 0 
		SET @DiscountAmount = @SubTotal * (@DiscountOffPercent / 100)
	ELSE IF @DiscountOffAmount > 0 
		SET @DiscountAmount = @DiscountOffAmount
	ELSE -- Is default and has no discount
		SET @DiscountAmount = 0


	-- Add it all up for total
	INSERT INTO @ReceiptAmounts VALUES
	(	
		@SubTotal		,
		@DiscountAmount	,
		@SubTotal - @DiscountAmount	,
		@ItemCount
	)

	RETURN; -- returns @ReceiptAmounts
END
GO

-- =============================================
-- Author:		Korbin Dansie
-- Create date: 2022-11-16
-- Description:	Helper function to get sales tax rate from a FARMS hotel
-- Works but could not implment
-- =============================================
CREATE PROCEDURE sp_getSalesTaxRate 
	(@HotelID		smallint,
	@SalesTaxRate	decimal(6,4) OUTPUT)
AS
BEGIN
		DECLARE @Query	nvarchar(MAX)
		DECLARE @TQuery nvarchar(MAX)

		SELECT @TQuery = 
			CONCAT('''SELECT TOP 1 TR.SalesTaxRate 
			FROM Hotel AS H
				INNER JOIN Taxrate as TR
				ON H.TaxLocationID = TR.TaxLocationID
			WHERE
				H.HotelID = ', @HotelID, '''')

		CREATE TABLE #temptable (SalesTaxRate decimal(6,4))
		SELECT @Query = CONCAT('INSERT INTO #temptable SELECT * FROM OPENQUERY(FARMS, ', @TQuery, ')')

		EXEC (@Query)

		SELECT TOP 1 @SalesTaxRate = SalesTaxRate FROM #temptable
END
GO

/****************************************************************
*
*	SPROC
*
****************************************************************/
-- =============================================
-- Author:		Briella Rutherford
-- Create date: 2022-11-16
-- Description:	This SPROC will send a guest's bill to the folio for their reservation if they are checked in. 
-- =============================================
CREATE PROCEDURE sp_SendBillToRoom 
@GuestFirstName		varchar(20),
@GuestLastName		varchar(20),
@CreditCardNumber	varchar(16),
@HotelID			smallint,
@ReceiptID			int,
@RoomNumber			varchar(5)
AS
	-- Query CreditCard to get the record matching the given credit card, keep GuestID and CreditCardID

	
	DECLARE @OpenQuery Nvarchar(100) = N'SELECT * FROM OPENQUERY(FARMS, '''
	DECLARE @Command Nvarchar(MAX)
	SET @Command = N'SELECT GuestID, CreditCardID FROM CreditCard WHERE CCNumber = '+@CreditCardNumber

	DECLARE @GuestTable TABLE (GuestID smallint, CreditCardID smallint) 
	INSERT INTO @GuestTable EXEC (@OpenQuery + @Command + ''')') 

	-- IF there are too many elegible guests, throw an error

	IF((SELECT COUNT(*) FROM @GuestTable) > 1) 
	BEGIN
		DECLARE @GuestError varchar(50) = CONCAT('TooManyGuests: ',(SELECT COUNT(*) FROM @GuestTable))
		RAISERROR(@GuestError,16,10)
		RETURN -1
	END

	DECLARE @GuestID smallint = (SELECT GuestID FROM @GuestTable)
	DECLARE @CreditCardID smallint = (SELECT CreditCardID FROM @GuestTable)
	
	-- Use given GuestIDs to query FARMS GUEST and find guests whose name match what was given

	SET @Command = CONCAT(N'SELECT GuestID FROM GUEST WHERE GuestID = ', @GuestID, ' AND GuestFirst = ''''', @GuestFirstName, ''''' AND GuestLast = ''''',@GuestLastName,'''''')
	DECLARE @MatchesTable TABLE (GuestID smallint) 
	INSERT INTO @MatchesTable EXEC (@OpenQuery + @Command + ''')') 

	-- IF there is no match, throw an error that there is no matching guest and end the procedure
	
	IF(NOT EXISTS (SELECT 1 FROM @MatchesTable)) 
	BEGIN
		RAISERROR('NoMatchingGuests',16,10)
		RETURN -1
	END

	-- Use the CreditCardID to query the FARMS RESERVATION table to find reservations under that credit card which are active
	-- Store the potential ReservationID's.

	SET @Command = CONCAT(N'SELECT ReservationID FROM RESERVATION WHERE CreditCardID = ',@CreditCardID,' AND ReservationStatus = ''''A''''')
	DECLARE @ReservationsTable TABLE (ReservationID smallint) 
	INSERT INTO @ReservationsTable EXEC (@OpenQuery + @Command + ''')') 

	-- IF there is no match, throw an error that there is no active reservation and end the procedure.
	
	IF(NOT EXISTS (SELECT 1 FROM @ReservationsTable))
	BEGIN
		RAISERROR('NoElegibleReservations',16,10)
		RETURN -1
	END

	-- Use ReservationID to query FARMS Folio and JOIN with ROOM table to use Room's HotelId and find ones that match the hotel
	
	SET @Command = CONCAT(N'SELECT FolioID, ReservationID FROM Folio JOIN Room ON Folio.RoomID = Room.RoomID WHERE Room.HotelID = ',@HotelID)
	DECLARE @FolioTable TABLE (FolioID smallint, ReservationID smallint) 
	INSERT INTO @FolioTable EXEC (@OpenQuery + @Command + ''')') 

	-- Find Rooms that match the Folios we have
	
	DECLARE @MatchingFolios TABLE (FolioID smallint, ReservationID smallint) 
	INSERT INTO @MatchingFolios 
		SELECT FolioID, FolioTable.ReservationID FROM @FolioTable AS FolioTable 
			INNER JOIN @ReservationsTable AS ReservationsTable 
			ON FolioTable.ReservationID = ReservationsTable.ReservationID

	-- IF there is no match, throw an error that all reservations are at the wrong hotel and end the procedure
	
	IF(NOT EXISTS (SELECT 1 FROM @MatchingFolios)) 
	BEGIN
		RAISERROR('ReservationsAtWrongHotel',16,10)
		RETURN -1
	END

	-- IF there are multiple folios at this point throw an error that there are multiple qualifying reservations.

	IF((SELECT COUNT(*) FROM @MatchingFolios) > 1) 
	BEGIN
		DECLARE @ResError varchar(50) = CONCAT('TooManyReservations: ',(SELECT COUNT(FolioID) FROM @MatchingFolios))
		RAISERROR(@ResError,16,10)
		RETURN -1
	END
	
	-- There should only be one Folio left
	DECLARE @FolioID smallint = (SELECT FolioID FROM @MatchingFolios)

	-- Use the given ReceiptID to query the local RECEIPT to get the tip amount, and the ReceiptDate

	DECLARE @ReceiptTable TABLE (ReceiptTip smallmoney, ReceiptDate datetime);
	INSERT INTO @ReceiptTable SELECT ReceiptTip, ReceiptDate FROM Receipt WHERE ReceiptID = @ReceiptID
	DECLARE @ReceiptTip smallmoney = (SELECT ReceiptTip FROM @ReceiptTable)
	DECLARE @ReceiptDate datetime = (SELECT ReceiptDate FROM @ReceiptTable)
	
	-- Use the ReceiptID to call the dbo.ReceiptTotalAmount and get the total cost of that receipt.
	-- FIX THIS LATER

	DECLARE @ReceiptTotal smallmoney = 18.00 --SELECT dbo.ReceiptTotalAmount (@ReceiptID)
	DECLARE @TotalCost smallmoney = @ReceiptTotal + @ReceiptTip

	/*
	Insert into the FARMS BILLING table an entry with the FolioID, 
	the appropriate BillingCategoryID for a restaurant purchase (hard-coded), 
	a BillingDescription of “Restaurant Purchase” concatenated with the receipt ID, 
	add the tip and total cost retrieved earlier to insert for the BillingCost, 
	BillingItemQuantity will be 1, and use the ReceiptDate from earlier as the BillingItemDate.
	*/

	
	SET @Command = CONCAT(N'INSERT OPENQUERY (FARMS, ''SELECT FolioID, BillingCategoryID, BillingDescription, BillingAmount, BillingItemQty, BillingItemDate FROM Billing WHERE 1=0'') VALUES (',@FolioID,', 5, ''Resturaunt Purchase: ',@ReceiptID,''', ',@ReceiptTotal,', 1, ''',@ReceiptDate , ''')')
	EXEC (@Command) 


	

	RETURN
GO

-- =============================================
-- Author:		
-- Create date: 2022-11-16
-- Description:	Create a new FOOD_ITEM with many possible ingredients and add it to a variety of restaurant menus. Use comma-separated values.
-- =============================================
CREATE PROCEDURE sp_AddFoodItem 
@FoodName			varchar(30),
@FoodDescription	varchar(MAX) = NULL,
@AgeRestricted		bit,
@FoodCategoryID		tinyint,	
@FoodDefaultPrice	smallmoney,

@IngredientsList	varchar(MAX),
@MenuList			varchar(MAX) = NULL,

@FoodID				smallint OUTPUT
AS
	DECLARE @ErrorMessage nvarchar(MAX)

	-- Simple test first to make sure @FoodCategoryID entered exits
	IF NOT EXISTS (SELECT * FROM Food_Category AS FC WHERE FC.FoodCategoryID = @FoodCategoryID)
	BEGIN
		SET @ErrorMessage = 'The food category number you entered does not exits';
		RAISERROR(@ErrorMessage, 1, 1)
		RETURN
	END

	-- Test if each ingredient exists
	----- Cursor through each food item
	----- if it does not exit add it to the error message
	
	---- If null throw error
	IF @IngredientsList IS NULL OR @IngredientsList = ''
	BEGIN
		SET @ErrorMessage = 'Ingredients list is empty'
		RAISERROR(@ErrorMessage, 1,2)
		RETURN
	END

	---- Seperate the csvs into a temp table	
	CREATE TABLE #IngredientsList 
	(
		Ingredient varchar(30)
	)

	INSERT INTO #IngredientsList SELECT value  
	FROM STRING_SPLIT(@IngredientsList, ',')  
	WHERE RTRIM(value) <> '';

	---- Cursor through the ingrediants that dont belong
	DECLARE @IngredientName varchar(30)
	
	DECLARE cursor_ingredient CURSOR
	
	------ Find which ingredants dont belong
	FOR SELECT IL.Ingredient
	FROM Ingredient AS INGR
		RIGHT JOIN #IngredientsList AS IL
		ON INGR.IngredientName = IL.Ingredient
	WHERE
		INGR.IngredientName IS NULL

	OPEN cursor_ingredient;

	FETCH NEXT FROM cursor_ingredient INTO 
		@IngredientName

	WHILE @@FETCH_STATUS = 0
	    BEGIN
		-- (Ingrediantname, )
		SET @ErrorMessage = concat(@ErrorMessage, @IngredientName,', ')
			
	        FETCH NEXT FROM cursor_ingredient INTO 
	            @IngredientName 
	    END;
	
	CLOSE cursor_ingredient;
	
	DEALLOCATE cursor_ingredient;

	---- Then we know which ingediants do not work
	IF @ErrorMessage IS NOT NULL
	BEGIN
		-- trim off last comma
		SET @ErrorMessage = SUBSTRING(@ErrorMessage, 1, LEN(@ErrorMessage) - 2)
		SET @ErrorMessage = CONCAT('Some ingrediants you enterd were incorrect. Please check near ', @ErrorMessage)
		RAISERROR(@ErrorMessage, 1, 3)
		RETURN
	END

	-- Create the new Food item
	INSERT INTO Food_Item VALUES
	(
		@FoodName			,
		@FoodDescription	,
		@AgeRestricted		,
		@FoodCategoryID		,	
		@FoodDefaultPrice	
	)

	SELECT @FoodID = @@IDENTITY

	-- Add the ingrediants to the new food recipe
	---- Join the Ingrediant table because we have the Names but need the IDs
	INSERT INTO Recipe (FoodItemID, IngredientID)
	SELECT 
		@FoodID, INGE.IngredientID 
	FROM #IngredientsList AS IL
		INNER JOIN Ingredient AS INGE
		ON IL.Ingredient = INGE.IngredientName

	-- Add the new food item to mutiple menus
	---- dont throw erros if menus dont exits. The food item can be manual added latter
	---- Seperate the csvs into a temp table
	IF @MenuList IS NULL OR @MenuList = ''
	BEGIN
		RETURN -- Just end the procedure because we are done
	END

	CREATE TABLE #MenuList 
	(
		Menu	int
	)

	INSERT INTO #MenuList SELECT value  
	FROM STRING_SPLIT(@MenuList, ',')  
	WHERE RTRIM(value) <> '';

	INSERT INTO Menu_Item (FoodItemID, MenuID, MenuItemPrice /*Price is default price*/)
	SELECT 
		@FoodID, ML.MENU, 0 /* 0 triggers to set default price. For some reason @FoodDefaultPrice does not work*/
	FROM #MenuList AS ML
		INNER JOIN Menu AS M -- make sure the menu at the very least exists
		ON ML.Menu = M.MenuID	
GO

-- =============================================
-- Author:		Briella Rutherford
-- Create date: 2022-11-16
-- Description:	Given a FoodItemID, ReceiptID, and MenuID and optional Amount and OrderedAdjustments, add an entry to the ORDERED_ITEM table for this receipt.
-- =============================================
CREATE PROCEDURE sp_AddItem 
@FoodItemID			smallint,
@ReceiptID			int,
@MenuID				int = NULL,
@Amount				smallmoney = NULL,
@OrderedAdjustments	varchar(MAX) = NULL
AS
	-- IF Amount is not entered, set it to 1

	IF (@Amount IS NULL) SET @Amount = 1

	-- Query the ORDERED_ITEM table to find if there is already an entry matching the ReceiptID. 
	
	DECLARE @ItemTable TABLE (OrderedItemID int, OrderedItemQty tinyint, OrderedAdjustments varchar(MAX))
	INSERT INTO @ItemTable SELECT OrderedItemID, OrderedItemQty, OrderedAdjustments FROM Ordered_Item WHERE FoodItemID = @FoodItemID AND ReceiptID = @ReceiptID

	-- IF there is, add our Amount variable to OrderedItemQty for that entry, and concatenate the given OrderedAdjustments.
	
	IF((SELECT COUNT(*) FROM @ItemTable) > 0) 
	BEGIN
		DECLARE @ID int = (SELECT TOP 1 OrderedItemID FROM @ItemTable)
		DECLARE @OldQty tinyint = (SELECT TOP 1 OrderedItemQty FROM @ItemTable)
		DECLARE @OldAdj varchar(MAX) = (SELECT TOP 1 OrderedAdjustments FROM @ItemTable)
		IF (@OrderedAdjustments IS NOT NULL) UPDATE Ordered_Item SET OrderedAdjustments = CONCAT(@OldAdj, ' ', @OrderedAdjustments) WHERE OrderedItemID = @ID
		UPDATE Ordered_Item SET OrderedItemQty = (@OldQty + @Amount) WHERE OrderedItemID = @ID
		RETURN
	END
	
	-- ELSE IF MenuID is null, throw an error that the menu could not be found, and end the procedure. 
	
	IF (@MenuID IS NULL)
	BEGIN
		RAISERROR('Menu could not be found',16,10)
		RETURN -1
	END
		
	-- Query the MENU_ITEM table with the given FoodItemID  and MenuID to find the appropriate MenuItemPrice
		
	DECLARE @OrderedPrice smallmoney = (SELECT MenuItemPrice FROM Menu_Item WHERE FoodItemID = @FoodItemID AND MenuID = @MenuID)

	-- Create a new entry for the ORDERED_ITEM table, using the given FoodItemID, ReceiptID, Amount, OrderedAdjustments (leave null if not given), 
	-- the MenuItemPrice obtained above for the OrderedPrice, and the Amount given as the OrderedItemQty.
	INSERT INTO Ordered_Item VALUES (@FoodItemID, @ReceiptID, @OrderedAdjustments, @OrderedPrice, @Amount)

GO

/****************************************************************
*
*	USDF
*
****************************************************************/
-- =============================================
-- Author:		Korbin Dansie
-- Create date: 2022-11-16
-- Description:	Use the RestaurantID and the time of day to print the menu for that time.
-- =============================================
CREATE FUNCTION dbo.DisplayMenu(@RestaurantID smallint, @Time time = NULL)
RETURNS @ProduceMenu TABLE ( MenuInformation nvarchar(MAX)) 
AS
BEGIN
	-- See if time is supplied
	IF (@Time is NULL)
	BEGIN
		SET @Time = CONVERT(TIME, GETDATE())
	END

	-- Display Restaurant info, RestaurantName, Address, and Phone number

	---- Check if Restaurant exits, If not return error
	IF NOT EXISTS (SELECT * FROM Restaurant WHERE Restaurant.RestaurantID = @RestaurantID)
	BEGIN
		DECLARE @ErrorMessage nvarchar(MAX)
		SET @ErrorMessage = CONCAT('A Restaurant with an id of ''', @RestaurantID, ''' does not exist')
		
		DELETE FROM @ProduceMenu
		INSERT INTO @ProduceMenu VALUES (@ErrorMessage)
		RETURN
	END

	DECLARE 
			@RestaurantPhone	varchar(10),
			@AddrLine1			varchar(30),
			@AddrLine2			varchar(10),
			@AddrCity			varchar(20),
			@AddrState			char(2) = NULL,
			@AddrPostalCode		char(10)

	SELECT @RestaurantPhone = R.RestaurantPhone, @AddrLine1 = A.AddrLine1, @AddrLine2 = A.AddrLine2, @AddrCity = A.AddrCity, @AddrState = A.AddrState, @AddrPostalCode = A.AddrPostalCode FROM Restaurant AS R
	INNER JOIN Address AS A
	ON R.AddressID = A.AddressID



	INSERT INTO @ProduceMenu VALUES
	('Red Canaries'),(''),
	(CONCAT(@AddrLine1,' ',@AddrLine2)),
	(CONCAT(@AddrCity,', ', 
	CASE 
		WHEN @AddrState IS NOT NULL THEN CONCAT(@AddrState,' ')
		ELSE ''
	END,
	@AddrPostalCode
	))
	,('')

	-- Display the Menu info, name, time its avaiable
	DECLARE
		@MenuID			int, -- Used latter to loop thought the menu
		@MenuName		varchar(20),
		@MenuStartTime	time,
		@MenuEndTime	time
	
	SELECT TOP 1 @MenuID = M.MenuID, @MenuName = M.MenuName, @MenuStartTime = M.MenuStartTime, @MenuEndTime = M.MenuEndTime FROM Menu AS M
	WHERE
	M.RestaurantID = @RestaurantID AND
	@Time between m.MenuStartTime and m.MenuEndTime

	INSERT INTO @ProduceMenu VALUES
	(@MenuName),
	
	(CONCAT(CONVERT(varchar(15), @MenuStartTime, 100),' - ', CONVERT(varchar(15), @MenuEndTime, 100) ))

	-- Cursor through the menu items orginzed by Food Category
	DECLARE 
		@FoodCategoryName			varchar(20),
		@FoodName					varchar(30),
		@FoodPrice					smallmoney,
		@FoodDescription			varchar(MAX),
		@PreviousFoodCategoryName	varchar(20) = '' -- Used to see when Food category changes in the cursor

	---- Get the longest character length of each item used for spacing in cursor
	DECLARE 
		@MaxLengthFoodName	tinyint,
		@MaxLengthFoodPrice	tinyint

	SELECT	@MaxLengthFoodName	= MAX(LEN(FI.FoodName)),
			@MaxLengthFoodPrice	= MAX(LEN(FORMAT(MI.MenuItemPrice, 'C')))	
	FROM Menu AS M
	INNER JOIN Menu_Item AS MI
	ON M.MenuID = MI.MenuID
	INNER JOIN Food_Item AS FI
	ON MI.FoodItemID = FI.FoodItemID
	WHERE
		M.MenuID = @MenuID

	---- Declare Cursor
	DECLARE cursor_MenuItems CURSOR

	FOR SELECT
		FC.CategoryName, FI.FoodName, MI.MenuItemPrice, FI.FoodDescription
	FROM Menu AS M
		INNER JOIN Menu_Item AS MI
		ON M.MenuID = MI.MenuID
		INNER JOIN Food_Item AS FI
		ON MI.FoodItemID = FI.FoodItemID
		INNER JOIN Food_Category AS FC
		ON FI.FoodCategoryID = FC.FoodCategoryID
	WHERE
		M.MenuID = @MenuID
	ORDER BY 
		FC.FoodCategoryID, FI.FoodItemID

	OPEN cursor_MenuItems

	FETCH NEXT FROM cursor_MenuItems INTO
		@FoodCategoryName,
		@FoodName,
		@FoodPrice,
		@FoodDescription

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (@FoodCategoryName != @PreviousFoodCategoryName)
		BEGIN
			SET @PreviousFoodCategoryName = @FoodCategoryName -- Set PreviousFoodCategoryName so we know we started on a new category
			
			DECLARE @longestFoodNameAndPrice tinyint;
			SET @longestFoodNameAndPrice = @MaxLengthFoodName + 5 + @MaxLengthFoodPrice

			INSERT INTO @ProduceMenu VALUES
			(''),
			(
				CONCAT
				(
				REPLICATE('-', (@longestFoodNameAndPrice - LEN(@FoodCategoryName)) / 2),
				@FoodCategoryName,
				REPLICATE('-', (@longestFoodNameAndPrice - LEN(@FoodCategoryName)) / 2),
				(
					CASE
					WHEN ((@longestFoodNameAndPrice - LEN(@FoodCategoryName) / 2) % 2) = 0 THEN '-'
					ELSE ''
					END
				) 
				)
			),
			('')
		END

		INSERT INTO @ProduceMenu VALUES 
		(
			-- FoodName...$price
			CONCAT
			(
			@FoodName,
			' ',
			REPLICATE('.', @MaxLengthFoodName + 3 /* for a min of ... on the longet name */ - LEN(@FoodName)),
			REPLICATE(' ', @MaxLengthFoodPrice - LEN(FORMAT(@FoodPrice, 'C'))/*Formated Food price length*/),
			' ',
			FORMAT(@FoodPrice, 'C')
			)
		),
		(@FoodDescription),
		('')

		FETCH NEXT FROM cursor_MenuItems INTO
			@FoodCategoryName,
			@FoodName,
			@FoodPrice,
			@FoodDescription
	END
	
	CLOSE cursor_MenuItems
	DEALLOCATE cursor_MenuItems

	RETURN -- returns @ProduceMenu
END
GO


-- =============================================
-- Author:		Korbin Dansie
-- Create date: 2022-11-16
-- Description:	Given a specific restaurant, return a table of the specials for that restaurant, and what times each dish is available. Order it by the day of the week it applies and includes the 10% discounted price. The start date starts on Monday = 0.
-- =============================================
CREATE FUNCTION dbo.DisplaySpecials(@RestaurantID smallint)
RETURNS @ProduceSpecialsMenu TABLE ( MenuInformation nvarchar(MAX)) 
AS
BEGIN

	DECLARE @ErrorMessage nvarchar(MAX)

	-- Test to see if Restaurant exits
	IF NOT EXISTS (SELECT * FROM Restaurant WHERE Restaurant.RestaurantID = @RestaurantID)
	BEGIN
		SET @ErrorMessage = CONCAT('A Restaurant with an id of ''', @RestaurantID, ''' does not exist')
		
		DELETE FROM @ProduceSpecialsMenu
		INSERT INTO @ProduceSpecialsMenu VALUES (@ErrorMessage)
		RETURN
	END

	-- Test to see if Restaurant has specails
	IF NOT EXISTS (SELECT * FROM Special WHERE Special.RestaurantID = @RestaurantID)
	BEGIN
		SET @ErrorMessage = ('No Specials')
		
		DELETE FROM @ProduceSpecialsMenu
		INSERT INTO @ProduceSpecialsMenu VALUES (@ErrorMessage)
		RETURN
	END

	-- For each special see if it appers on one or more menus
	---- DayOfWeek, MenuStartTime, MenuEndTime, FoodName, FoodPrice, 
	DECLARE
		@DayOFWeek		tinyint,
		@MenuStartTime	time,
		@MenuEndTime	time,
		@FoodName		varchar(30),
		@FoodPrice		smallmoney

	---- Get the longest character length of each item used for spacing in cursor
	DECLARE 
		@MaxLengthFoodName	tinyint,
		@MaxLengthFoodPrice	tinyint

	SELECT	@MaxLengthFoodName	= MAX(LEN(FI.FoodName)),
			@MaxLengthFoodPrice	= MAX(LEN(FORMAT(MI.MenuItemPrice * 0.90, 'C')))	
	FROM Restaurant AS R
		INNER JOIN Special AS S
		ON R.RestaurantID = S.RestaurantID
		INNER JOIN Menu AS M
		ON R.RestaurantID = M.RestaurantID
		INNER JOIN Menu_Item AS MI
		ON M.MenuID = MI.MenuID
		INNER JOIN Food_Item AS FI
		ON MI.FoodItemID = FI.FoodItemID
	WHERE
		R.RestaurantID = @RestaurantID AND
		S.FoodItemID IN (MI.FoodItemID)

	-- Start the cursor
	DECLARE cursor_SpecailMenu	CURSOR
	FOR SELECT
		S.SpecialWeekDay, M.MenuStartTime, M.MenuEndTime, FI.FoodName, MI.MenuItemPrice
	FROM Restaurant AS R
		INNER JOIN Special AS S
		ON R.RestaurantID = S.RestaurantID
		INNER JOIN Menu AS M
		ON R.RestaurantID = M.RestaurantID
		INNER JOIN Menu_Item AS MI
		ON M.MenuID = MI.MenuID
		INNER JOIN Food_Item AS FI
		ON MI.FoodItemID = FI.FoodItemID
	WHERE
		R.RestaurantID = @RestaurantID AND
		S.FoodItemID IN (MI.FoodItemID)
	ORDER BY
		S.SpecialWeekDay, M.MenuStartTime

	OPEN cursor_SpecailMenu

	FETCH NEXT FROM cursor_SpecailMenu INTO
		@DayOFWeek		,
		@MenuStartTime	,
		@MenuEndTime	,
		@FoodName		,
		@FoodPrice		

	WHILE @@FETCH_STATUS = 0
	BEGIN
		--INSERT INTO @ProduceSpecialsMenu VALUES
		--(
		--	CONCAT
		--	(
		--	@DayOFWeek, ' ', @MenuStartTime, ' ', @MenuEndTime, ' ', @FoodName, ' ',@FoodPrice
		--	)
		--)

		INSERT INTO @ProduceSpecialsMenu VALUES
		(
		CONCAT
		(
			DATENAME(WEEKDAY, @DayOFWeek),
			' ',
			CONVERT(varchar(15), @MenuStartTime, 100),
			' - ',
			CONVERT(varchar(15), @MenuEndTime, 100)
		)
		),
		(
		CONCAT
			(
			@FoodName,
			' ',
			REPLICATE('.', @MaxLengthFoodName + 3/* for a min of ... on the longet name */ - LEN(@FoodName)),
			REPLICATE(' ', @MaxLengthFoodPrice - LEN(FORMAT(@FoodPrice * 0.90, 'C'))/*Formated Food price length*/),
			' ',
			FORMAT(@FoodPrice * 0.90, 'C')
			)
		),
		('')

		FETCH NEXT FROM cursor_SpecailMenu INTO
		@DayOFWeek		,
		@MenuStartTime	,
		@MenuEndTime	,
		@FoodName		,
		@FoodPrice		
	END

	RETURN -- returns @ProduceSpecialsMenu
END
GO

-- =============================================
-- Author:		Korbin Dansie
-- Create date: 2022-11-16
-- Description:	UseCreate a receipt to hand to the customer giving them a variety of information about their purchase.
-- =============================================
CREATE FUNCTION dbo.CreateReceipt(@ReceiptID int)
RETURNS @ProduceReceipt TABLE ( ReceiptInformation nvarchar(MAX)) 
AS
BEGIN
	DECLARE @ErrorMessage nvarchar(MAX)

	-- Test to see if Restaurant exits
	IF NOT EXISTS (SELECT TOP 1 RCPT.RestaurantID FROM Receipt AS RCPT WHERE RCPT.ReceiptID = @ReceiptID)
	BEGIN
		SET @ErrorMessage = CONCAT('A Restaurant with an id of ''', @ReceiptID, ''' does not exist')
		
		DELETE FROM @ProduceReceipt
		INSERT INTO @ProduceReceipt VALUES (@ErrorMessage)
		RETURN
	END

	-- Display the restaurant information
	---- Get the restaurant ID
	DECLARE @RestaurantID		smallint,
			@RestaurantPhone	varchar(10),
			@AddrLine1			varchar(30),
			@AddrLine2			varchar(10),
			@AddrCity			varchar(20),
			@AddrState			char(2) = NULL,
			@AddrPostalCode		char(10),
			@ReceiptDate		datetime

	SELECT @RestaurantID = R.RestaurantID, @RestaurantPhone = R.RestaurantPhone, @AddrLine1 = A.AddrLine1, @AddrLine2 = A.AddrLine2, @AddrCity = A.AddrCity, @AddrState = A.AddrState, @AddrPostalCode = A.AddrPostalCode, @ReceiptDate = RCPT.ReceiptDate
	FROM Receipt AS RCPT
		INNER JOIN Restaurant AS R
		ON RCPT.RestaurantID = R.RestaurantID
		INNER JOIN Address AS A
		ON R.AddressID = A.AddressID
	WHERE
		RCPT.ReceiptID = @ReceiptID

	---- Display the info
	INSERT INTO @ProduceReceipt VALUES
	(
	'----Red Canaries----'
	),
	(
	CONCAT('Red Canaries # ', RIGHT('0000' + CONVERT(VARCHAR(4),@ReceiptID), 4))
	)
	,(''),
	(CONCAT(@AddrLine1,' ',@AddrLine2)),
	(CONCAT
		(
		@AddrCity,', ', 
		CASE 
			WHEN @AddrState IS NOT NULL THEN CONCAT(@AddrState,' ')
			ELSE ''
		END,
		@AddrPostalCode
		)
	)
	,
	(
	CONCAT
		(
		'Phone: ',SUBSTRING(@RestaurantPhone, 1,3), '-', SUBSTRING(@RestaurantPhone, 4,3), '-', SUBSTRING(@RestaurantPhone,7,4)
		)
	),
	(
	CONCAT
		(
		'Date: ', format(@ReceiptDate, 'g')
		)
	),
	('--------------------')

	-- Display the Ordered items info
	---- Get the max values to format latter
	DECLARE
		@MaxFoodQty		int,
		@MaxFoodName	int,
		@MaxFoodPrice	int

	SELECT @MaxFoodQty = MAX(LEN(OI.OrderedItemQty)), @MaxFoodName = MAX(LEN(FI.FoodName)), @MaxFoodPrice = MAX(LEN(FORMAT(OI.OrderedPrice, 'C' )))
	FROM Receipt AS RCPT
		INNER JOIN Ordered_Item AS OI
		ON RCPT.ReceiptID = OI.ReceiptID
		INNER JOIN Food_Item AS FI
		ON OI.FoodItemID = FI.FoodItemID
	WHERE
		RCPT.ReceiptID = @ReceiptID


	---- Declare a cursor to loop through the items
	DECLARE 
		@FoodQty			tinyint,
		@FoodName			varchar(30),
		@FoodPrice			smallmoney,
		@FoodAdjustments	varchar(MAX)


	DECLARE cursor_orderedItem CURSOR

	FOR SELECT
		OI.OrderedItemQty, FI.FoodName, OI.OrderedPrice, OI.OrderedAdjustments
	FROM Receipt AS RCPT
		INNER JOIN Ordered_Item AS OI
		ON RCPT.ReceiptID = OI.ReceiptID
		INNER JOIN Food_Item AS FI
		ON OI.FoodItemID = FI.FoodItemID
	WHERE
		RCPT.ReceiptID = @ReceiptID

	OPEN cursor_orderedItem

	FETCH NEXT FROM cursor_orderedItem INTO
		@FoodQty			,
		@FoodName			,
		@FoodPrice			,
		@FoodAdjustments

	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO @ProduceReceipt VALUES
		(
			CONCAT
			(
				REPLICATE(' ', @MaxFoodQty - LEN(@FoodQty)),
				@FoodQty,
				' ',
				@FoodName,
				' ',
				REPLICATE(' ', @MaxFoodName - LEN(@FoodName)),
				REPLICATE(' ', @MaxFoodPrice - LEN(FORMAT(@FoodPrice, 'C'))),
				FORMAT(@FoodPrice, 'C'),
				' '
			)
		)

		------ If no food adjustments add a blank line, else dispaly the food adjustments and a blank line
		IF @FoodAdjustments IS NULL
		BEGIN
			INSERT INTO @ProduceReceipt VALUES ('')
		END
		ELSE
		BEGIN
			INSERT INTO @ProduceReceipt VALUES 
			(
			@FoodAdjustments
			),
			('')
		END			

		FETCH NEXT FROM cursor_orderedItem INTO
			@FoodQty			,
			@FoodName			,
			@FoodPrice			,
			@FoodAdjustments
	END

	CLOSE cursor_orderedItem
	DEALLOCATE cursor_orderedItem

	-- Display the total amounts
	DECLARE 
		@SubTotalAmount smallmoney = 0,
		@DiscountAmount	smallmoney = 0,
		@TotalAmount	smallmoney = 0,
		@ItemCount		tinyint
	---- Run dbo.ReceiptTotalAmount(@ReceiptID int) to find values
	SELECT 
		@SubTotalAmount = RTA.SubTotal,
		@DiscountAmount = RTA.DiscountAmount,
		@TotalAmount = RTA.TotalAmount,
		@ItemCount = RTA.ItemCount 
	FROM dbo.ReceiptTotalAmount(@ReceiptID) AS RTA

	---- If subtotal is NULL then no items ordered
	IF @ItemCount = 0
	BEGIN
		INSERT INTO @ProduceReceipt VALUES ('No items ordered '), (FORMAT(@SubTotalAmount, 'C'))
		RETURN
	END

	INSERT INTO @ProduceReceipt VALUES 
	(
	CONCAT
	(
		'Items: ',
		/*Longest length of ordered item plus spaces minus character for Items: (7) and subtoal price*/
		REPLICATE(' ',@MaxFoodQty + 1 + @MaxFoodName + 1 + @MaxFoodPrice - 7 - LEN(@ItemCount) ),
		@ItemCount
		)
	)

	
	INSERT INTO @ProduceReceipt VALUES 
	(
	CONCAT
	(
		'Subtotal: ',
		/*Longest length of ordered item plus spaces minus character for Subtotal: (10) and subtoal price*/
		REPLICATE(' ',@MaxFoodQty + 1 + @MaxFoodName + 1 + @MaxFoodPrice - 10 - LEN(FORMAT(@SubTotalAmount, 'C'))),
		FORMAT(@SubTotalAmount, 'C')
		)
	)
	
	IF @DiscountAmount != 0
	BEGIN
		INSERT INTO @ProduceReceipt VALUES 
		(
		CONCAT
			(
			'Discount: ',
			/*Longest length of ordered item plus spaces minus character for Discount: (10) and  - (1) subtoal price*/
			REPLICATE(' ',@MaxFoodQty + 1 + @MaxFoodName + 1 + @MaxFoodPrice - 11 - LEN(FORMAT(@DiscountAmount, 'C'))),
			'-',
			FORMAT(@DiscountAmount, 'C')
			)
		)
	END
	
	-- Display total
	INSERT INTO @ProduceReceipt VALUES 
	(
	CONCAT
		(
		'Total: ',
		/*Longest length of ordered item plus spaces minus character for Total: (7) and subtoal price*/
		REPLICATE(' ',@MaxFoodQty + 1 + @MaxFoodName + 1 + @MaxFoodPrice - 7 - LEN(FORMAT(@TotalAmount, 'C'))),
		FORMAT(@TotalAmount, 'C')
		)
	)
	-- Add the footer of the receipt

	RETURN -- returns @ProduceReceipt
END
GO




/****************************************************************
*
*	TRIGGER
*
****************************************************************/
-- =============================================
-- Author:		Briella Rutherford
-- Create date: 2022-11-16
-- Description:	Works like a check constraint. If the value is anything but 0 it will check with the Farms database to see if it's a valid ID. If not roll back and throw an error.
-- =============================================
CREATE TRIGGER tr_RestaurantHotelID
ON Restaurant
AFTER UPDATE, INSERT
AS
	DECLARE @HotelID smallint
	SELECT TOP 1 @HotelID = HotelID FROM inserted
	IF (NOT @HotelID = 0)

	BEGIN
		DECLARE @OpenQuery Nvarchar(100) = N'SELECT * FROM OPENQUERY(FARMS, '''
		DECLARE @Command Nvarchar(MAX) = CONCAT(@OpenQuery, N'SELECT HotelID FROM Hotel WHERE HotelID = ', @HotelID, ''')')

		DECLARE @IDsTable TABLE (HotelID smallint) 
		INSERT INTO @IDsTable EXEC (@Command )

		IF (NOT EXISTS (SELECT * FROM @IDsTable))
		BEGIN
			ROLLBACK TRAN
			RAISERROR ('InvalidHotelID', 16, 1)
		END

	END
GO

-- =============================================
-- Author:		
-- Create date: 2022-11-16
-- Description:	When an Ordered_Item is created it checks with the Food_Item table if its age is restricted. If it is then it checks to see if the Receipt.AgeVerifed is 0. If is 0 then the age has not been verified yet so it throws an error and rolls back to prevent the food from being ordered.
-- =============================================
CREATE TRIGGER tr_AgeVerified 
ON Ordered_Item
AFTER INSERT
AS
	DECLARE @FoodItemID smallint
	DECLARE @ReceiptID int

	SELECT @FoodItemID = FoodItemID, @ReceiptID = ReceiptID FROM inserted

	DECLARE @AgeRestricted bit
	
	SELECT @AgeRestricted = Food_Item.AgeRestricted 
	FROM Food_Item 
	WHERE Food_Item.FoodItemID = @FoodItemID

	DECLARE @AgeVerified bit 
	SELECT @AgeVerified=ReceiptAgeVerified FROM RECEIPT WHERE ReceiptID = @ReceiptID
	
	IF (@AgeRestricted = 'true' AND @AgeVerified = 'false') 
	BEGIN
		RAISERROR ('Check Customer Age. No changes were made. ', 16, 1)
		ROLLBACK TRAN
	END

GO

-- =============================================
-- Author:		Korbin Dansie
-- Create date: 2022-11-16
-- Description:	When the user updates the credit card number and the credit card type. If both are filled then add the current date and time to the ReceiptDate. If one is missing roll back the info and throw an error stating that it's missing a field.
-- =============================================
CREATE TRIGGER tr_ReceiptPaid
ON dbo.Receipt
AFTER UPDATE AS
BEGIN
	--No sense in continuing to check if no rows were updated.
	IF @@ROWCOUNT = 0 RETURN;

	-- If colums 2 and 3 not updated return
	IF NOT SUBSTRING(COLUMNS_UPDATED(), 1, 1) & 6 = 6 
	BEGIN
	RAISERROR('Missing Credit card type or number', 1, 1)
	ROLLBACK
	RETURN
	END

	UPDATE Receipt
	SET ReceiptDate = GETDATE()
	WHERE Receipt.ReceiptID IN (SELECT DISTINCT ReceiptID FROM Inserted)
END
GO

-- =============================================
-- Author:		Korbin Dansie
-- Create date: 2022-11-16
-- Description:	When the user adds a new Ordered_Item it checks to see if the item is the special of the day at that restaurant. Then it replaces the current Ordered_Item price with a 10% discount. It also adds ï¿½Special of the dayï¿½ to the Ordered_Item.OrderedAdjustments row.
-- =============================================
CREATE TRIGGER tr_SpecialOfTheDay
ON Ordered_Item
INSTEAD OF INSERT
AS
	DECLARE @FoodItemID		smallint,
			@RestaurantID	smallint,
			@DayOfWeek		tinyint,
			@isSpecial		bit

	SELECT TOP 1 @FoodItemID = inserted.FoodItemID, @RestaurantID = Receipt.RestaurantID, @DayOfWeek = DATEPART(WEEKDAY, Receipt.ReceiptDate)
	FROM inserted
	INNER JOIN Receipt
	ON inserted.ReceiptID = Receipt.ReceiptID

	-- DATEPART(WEEKDAY, DATETIME) assumes Sunday = 1, Saturday = 7.  When we need Monday = 0, Sunday = 6
	SET @DayOfWeek = CASE
		WHEN @DayOfWeek = 1 THEN 6
		ELSE @DayOfWeek - 2
	END	

	-- See if food item is the special of the day
	IF EXISTS 
	(
		SELECT * FROM Special
		WHERE
		Special.FoodItemID = @FoodItemID AND
		Special.RestaurantID = @RestaurantID AND
		Special.SpecialWeekDay = @DayOfWeek
	)
	BEGIN
		INSERT INTO Ordered_Item 
		([FoodItemID],[ReceiptID],[OrderedAdjustments],[OrderedPrice],[OrderedItemQty])
		SELECT [FoodItemID],[ReceiptID],CONCAT([OrderedAdjustments], 'Special of the day.  '),[OrderedPrice] * (0.90),[OrderedItemQty] 
		FROM
		inserted
	END
	ELSE
	BEGIN
		INSERT INTO Ordered_Item ([FoodItemID],[ReceiptID],[OrderedAdjustments],[OrderedPrice],[OrderedItemQty])
		SELECT [FoodItemID],[ReceiptID],[OrderedAdjustments],[OrderedPrice],[OrderedItemQty] FROM inserted
	END

GO

-- =============================================
-- Author:		Korbin Dansie
-- Create date: 2022-11-16
-- Description:	When the user attempts to add a new Menu_Item but inputs a price of zero then we insert the price from Food_Item.FoodDefaultPrice.
-- =============================================
CREATE TRIGGER tr_MenuItemDefaultPrice
ON Menu_Item
INSTEAD OF INSERT
AS
	-- Find the FoodItemID and inserted price
	DECLARE @InsertedPrice	smallmoney,
			@FoodItemID		smallint
	Select top 1 @InsertedPrice = MenuItemPrice, @FoodItemID = FoodItemID from inserted;

	-- If inserted price is 0. Then find the default price
	IF (@InsertedPrice = 0)
	BEGIN
		-- Find the default price from Food_Item
		DECLARE @DefaultPrice smallmoney
		SELECT TOP 1 @DefaultPrice = FoodDefaultPrice FROM Food_Item
		WHERE
		Food_Item.FoodItemID = @FoodItemID

		-- Inserted instead of
		INSERT INTO Menu_Item ([FoodItemID],[MenuID],[MenuItemPrice])
		SELECT [FoodItemID],[MenuID],@DefaultPrice
		FROM inserted
	END
GO

/****************************************************************
*
*	Problems
*
****************************************************************/
PRINT('')
PRINT('Problem 1 - Add a new food item to a menu - To test trigger sp_SendBillToRoom')
PRINT('adding pancakes (1) to the breakfast menu (1)')

INSERT INTO Menu_Item ([FoodItemID],[MenuID],[MenuItemPrice])
VALUES (8,1,0)

SELECT Food_Item.FoodName, Menu_Item.MenuItemPrice FROM Menu_Item
INNER JOIN Food_Item
ON Menu_Item.FoodItemID = Food_Item.FoodItemID
WHERE 
Menu_Item.MenuID = 1


PRINT('****************************************************************')
GO

PRINT('')
PRINT('Problem 2 - Add the special of the day - To test trigger MenuItemDefaultPrice')
PRINT('adding water (8) to the receipt (5)')

INSERT INTO Ordered_Item ([FoodItemID],[ReceiptID],[OrderedPrice])
VALUES (1,5,10.00)
PRINT('')
GO

-- SELECT * FROM Ordered_Item
SELECT Food_Item.FoodName, Ordered_Item.OrderedPrice, Ordered_Item.OrderedAdjustments FROM Receipt
INNER JOIN Ordered_Item
ON Receipt.ReceiptID = Ordered_Item.ReceiptID
INNER JOIN Food_Item
ON Ordered_Item.FoodItemID = Food_Item.FoodItemID
WHERE Receipt.ReceiptID = 5

PRINT('****************************************************************')
GO

PRINT('')
PRINT('Problem 3 - Send a bill to a reservation - To test SPROC sp_SendBillToRoom')

PRINT('Current Billing Table from FARMS:')

DECLARE @OpenQuery Nvarchar(50) = N'SELECT * FROM OPENQUERY(FARMS, '''
DECLARE @Command varchar (200)= N'SELECT * FROM Billing WHERE FolioID = 7'
DECLARE @BillingTable TABLE (BillingID smallint, FolioID smallint, BillingCategoryID smallint, BillingDescription char(30), BillingAmount smallmoney, BillintItemQty tinyint, BillingItemDate date) 
INSERT INTO @BillingTable EXEC (@OpenQuery + @Command + ''')') 
SELECT * FROM @BillingTable

PRINT('')

GO

PRINT('Running the SPROC...')

EXEC sp_SendBillToRoom 
	@GuestFirstName	= 'Anita',
	@GuestLastName = 'Proul',
	@CreditCardNumber = '8887776665551110',
	@HotelID = 2100,
	@ReceiptID = 4,
	@RoomNumber = '202'

GO 

PRINT('New Billing Table from FARMS:')
PRINT('There should be a row for Anita Proul''s most recent meal at hotel 2100 for 12.34')

DECLARE @OpenQuery Nvarchar(50) = N'SELECT * FROM OPENQUERY(FARMS, '''
DECLARE @Command varchar (200)= N'SELECT * FROM Billing WHERE FolioID = 7'
DECLARE @BillingTable TABLE (BillingID smallint, FolioID smallint, BillingCategoryID smallint, BillingDescription char(30), BillingAmount smallmoney, BillintItemQty tinyint, BillingItemDate date) 
INSERT INTO @BillingTable EXEC (@OpenQuery + @Command + ''')') 
SELECT * FROM @BillingTable


PRINT('****************************************************************')
GO

PRINT('')
PRINT('Problem 4 - Display the breakfast menu - To test USDF DisplayMenu')
PRINT('')


SELECT * FROM dbo.DisplayMenu(1, '7:00:00')

PRINT('****************************************************************')
GO

PRINT('')
PRINT('Problem 5 - Display the specail menu - To test USDF DisplaySpecials')
PRINT('Restaurant (1) has a specail everday')
PRINT('')


SELECT * FROM dbo.DisplaySpecials(1)

PRINT('********************************')
PRINT('')
PRINT('Problem 5B - Display the specail menu or Restaurant 3 with split menus')
PRINT('')

SELECT * FROM dbo.DisplaySpecials(3)

PRINT('****************************************************************')
GO

PRINT('')
PRINT('Problem 6 - Display the receipt - To test USDF CreateReceipt')
PRINT('Receipt (1) 4 Items -- Subtotal 43.99 -- Total 43.99')
PRINT('')

SELECT * FROM dbo.CreateReceipt(1)

PRINT('****************************************************************')
GO
PRINT('')
PRINT('Problem 7 - Total up the receipt - To test USDF ReceiptTotalAmount')
PRINT('Recipt 1, 2, 4 to test types of discount none, fixed, percentage')

PRINT('')
SELECT * FROM dbo.ReceiptTotalAmount(1)
SELECT * FROM dbo.ReceiptTotalAmount(2)
SELECT * FROM dbo.ReceiptTotalAmount(4)
GO

---- Did not work. Cannot run distributed query in usdf without a lot of work
--DECLARE @Temp decimal(6,4) = 0.0
--DECLARE @HotelID smallint = 2100

--EXEC sp_getSalesTaxRate @HotelID,  @Temp OUTPUT;
--print(@Temp)

PRINT('****************************************************************')
GO

PRINT('')
PRINT('Problem 8 - Insert an Ordered Item - To test SPROC sp_AddItem')
PRINT('')

EXEC sp_AddItem 
	@FoodItemID = 2,
	@ReceiptID = 3,
	@MenuID = 1,
	@Amount = 3,
	@OrderedAdjustments = 'Melt my face off'

SELECT * FROM Ordered_Item WHERE ReceiptID = 3
GO

PRINT('****************************************************************')

PRINT('')
PRINT('Problem 9 - Insert an Food item - To test SPROC sp_AddFoodItem')
PRINT('')

DECLARE @FoodID smallint = 0 -- used to query the new food item

EXEC sp_AddFoodItem 
@FoodName			= 'Waffles',
@FoodDescription	= 'We can stay up late, swapping manly stories, and in the morning, I''m making waffles!',
@AgeRestricted		= 0,
@FoodCategoryID		= 1,	
@FoodDefaultPrice	= 50.10,

@IngredientsList	= 'Baking powder,Butter,Egg,Flour,Milk,Salt,Sugar,Water',
@MenuList			= '1,5,200',

@FoodID				= @FoodID OUTPUT


PRINT('********************************')
PRINT('')
PRINT('Display the new food item')
PRINT('')

SELECT * FROM Food_Item AS FI WHERE FI.FoodItemID = @FoodID

PRINT('********************************')
PRINT('')
PRINT('Display the ingredients needed for the new food item')
PRINT('')
SELECT 
	FI.FoodItemID, FI.FoodName, INGR.IngredientName
FROM Food_Item AS FI
	INNER JOIN Recipe AS RECI
	ON FI.FoodItemID = RECI.FoodItemID
	INNER JOIN Ingredient AS INGR
	ON RECI.IngredientID = INGR.IngredientID
WHERE
	FI.FoodItemID = @FoodID

select * from dbo.DisplayMenu(1, '7:00');


GO
PRINT('****************************************************************')

PRINT('')
PRINT('Problem 10 - Insert a new Hotel - To test Trigger tr_RestaurantHotelID')
PRINT('')


PRINT('Insert a resturaunt with a valid HotelID')
INSERT into Restaurant VALUES ('The Second', 1, '5554446666', 2100)
PRINT('Now insert a resturaunt with an invalid HotelID. It should return an error.')
INSERT into Restaurant VALUES ('The Third', 1, '6665554444', 13)

SELECT * FROM Ordered_Item WHERE ReceiptID = 3

GO

PRINT('****************************************************************')

GO
PRINT('')
PRINT('Problem 11 - To test TRIGGER tr_ReceiptPaid')
PRINT('')

select RCPT.ReceiptID, RCPT.ReceiptCCType, RCPT.ReceiptCCNumber, RCPT.ReceiptDate
from Receipt AS RCPT
WHERE
	RCPT.ReceiptID = 5

UPDATE dbo.Receipt
SET 
	ReceiptCCType = 'MAST' ,
	ReceiptCCNumber = '5113868647762072'
WHERE
	Receipt.ReceiptID = 5

select RCPT.ReceiptID, RCPT.ReceiptCCType, RCPT.ReceiptCCNumber, RCPT.ReceiptDate
from Receipt AS RCPT
WHERE
	RCPT.ReceiptID = 5

GO

PRINT('****************************************************************')

GO
PRINT('')
PRINT('Problem 12 - To test TRIGGER tr_AgeVerified')
PRINT('')

PRINT('Insert an ordered item ordering an age restricted item where the receipt is AgeVerified')
INSERT INTO Ordered_Item VALUES (7, 4, NULL, 1.99, 100)
PRINT('Now insert an ordered item ordering an age restricted item where the receipt is NOT AgeVerified')
PRINT('This should produce an error.')
INSERT INTO Ordered_Item VALUES (7, 2, NULL, 1.99, 1)

select * from dbo.CreateReceipt(4)

select * from Receipt as RCPT where RCPT.ReceiptID in (2,4)
GO

----Used to determine order of colums
--select *
--from sys.columns
--where object_id = object_id('dbo.Receipt')
--order by column_id

/****************************************************************
*
*	Delete Tables when done
*
****************************************************************/
-- TODO: Drop table when done
--USE master
--GO
--DROP DATABASE RedCanaries_CS3550
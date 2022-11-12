-- Assignment:	Project Phase 3
-- Authors:		Briella Rutherford, Korbin Dansie
-- Date:		11/16/2022

USE master
	IF EXISTS (SELECT * FROM sysdatabases WHERE name='RedCanaries_CS3550')
	DROP DATABASE RedCanaries_CS3550
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
	AgeRestriced		bit			NOT NULL,
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
	
	ALTER TABLE Restaurant
	ADD FOREIGN KEY (HotelID) REFERENCES Hotel(HotelID)

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
FROM 'C:\Stage_RedCannaries\Address.csv'
WITH
(
	FIELDTERMINATOR =	'|',
	ROWTERMINATOR =		'\n',
	FIRSTROW = 2
)

PRINT('****************************************************************')
PRINT('ADD Restaurant')
BULK INSERT Restaurant
FROM 'C:\Stage_RedCannaries\Restaurant.csv'
WITH
(
	FIELDTERMINATOR =	'|',
	ROWTERMINATOR =		'\n',
	FIRSTROW = 2
)

PRINT('****************************************************************')
PRINT('ADD Menu')
BULK INSERT Menu
FROM 'C:\Stage_RedCannaries\Menu.csv'
WITH
(
	FIELDTERMINATOR =	'|',
	ROWTERMINATOR =		'\n',
	FIRSTROW = 2
)

PRINT('****************************************************************')
PRINT('ADD Menu_Item')
BULK INSERT Menu_Item
FROM 'C:\Stage_RedCannaries\Menu_Item.csv'
WITH
(
	FIELDTERMINATOR =	'|',
	ROWTERMINATOR =		'\n',
	FIRSTROW = 2
)

PRINT('****************************************************************')
PRINT('ADD Food_Item')
BULK INSERT Food_Item
FROM 'C:\Stage_RedCannaries\Food_Item.csv'
WITH
(
	FIELDTERMINATOR =	'|',
	ROWTERMINATOR =		'\n',
	FIRSTROW = 2
)

PRINT('****************************************************************')
PRINT('ADD Food_Category')
BULK INSERT Food_Category
FROM 'C:\Stage_RedCannaries\Food_Category.csv'
WITH
(
	FIELDTERMINATOR =	'|',
	ROWTERMINATOR =		'\n',
	FIRSTROW = 2
)

PRINT('****************************************************************')
PRINT('ADD Recipe')
BULK INSERT Recipe
FROM 'C:\Stage_RedCannaries\Recipe.csv'
WITH
(
	FIELDTERMINATOR =	'|',
	ROWTERMINATOR =		'\n',
	FIRSTROW = 2
)

PRINT('****************************************************************')
PRINT('ADD Ingredient')
BULK INSERT Ingredient
FROM 'C:\Stage_RedCannaries\Ingredient.csv'
WITH
(
	FIELDTERMINATOR =	'|',
	ROWTERMINATOR =		'\n',
	FIRSTROW = 2
)

PRINT('****************************************************************')
PRINT('ADD Ordered_Item')
BULK INSERT Ordered_Item
FROM 'C:\Stage_RedCannaries\Ordered_Item.csv'
WITH
(
	FIELDTERMINATOR =	'|',
	ROWTERMINATOR =		'\n',
	FIRSTROW = 2
)

PRINT('****************************************************************')
PRINT('ADD Receipt')
BULK INSERT Receipt
FROM 'C:\Stage_RedCannaries\Receipt.csv'
WITH
(
	FIELDTERMINATOR =	'|',
	ROWTERMINATOR =		'\n',
	FIRSTROW = 2
)

PRINT('****************************************************************')
PRINT('ADD Discount')
BULK INSERT Discount
FROM 'C:\Stage_RedCannaries\Discount.csv'
WITH
(
	FIELDTERMINATOR =	'|',
	ROWTERMINATOR =		'\n',
	FIRSTROW = 2
)

PRINT('****************************************************************')
PRINT('ADD Special')
BULK INSERT Special
FROM 'C:\Stage_RedCannaries\Special.csv'
WITH
(
	FIELDTERMINATOR =	'|',
	ROWTERMINATOR =		'\n',
	FIRSTROW = 2
)
PRINT('****************************************************************')

GO

/****************************************************************
*
*	SPROC
*
****************************************************************/
-- =============================================
-- Author:		
-- Create date: 2022-11-16
-- Description:	This SPROC will send a guest’s bill to the folio for their reservation if they are checked in. 
-- =============================================
CREATE PROCEDURE sp_SendBillToRoom 
@GuestFirstName		varchar(20),
@GuestLastName		varchar(20),
@CreditCardNumber	varchar(16),
@HotelID			smallint,
@ReceiptID			int,
@RoomNumber			varchar(5)
AS
	DECLARE @NOTHING int
GO

-- =============================================
-- Author:		
-- Create date: 2022-11-16
-- Description:	Create a new FOOD_ITEM with many possible ingredients and add it to a variety of restaurant menus. Use comma-separated values.
-- =============================================
CREATE PROCEDURE sp_AddFoodItem 
@IngredientsList	varchar(MAX),
@MenuList			varchar(MAX) = NULL
AS
	DECLARE @NOTHING int
GO

-- =============================================
-- Author:		
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
	DECLARE @NOTHING int
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

	INSERT INTO @ProduceMenu VALUES (@TIME)

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
		@MenuName		varchar(20),
		@MenuStartTime	time,
		@MenuEndTime	time
	
	SELECT TOP 1 @MenuName = M.MenuName, @MenuStartTime = M.MenuStartTime, @MenuEndTime = M.MenuEndTime FROM Menu AS M
	WHERE
	M.RestaurantID = @RestaurantID AND
	@Time between m.MenuStartTime and m.MenuEndTime

	INSERT INTO @ProduceMenu VALUES
	(@MenuName),(''),
	(CONCAT(@MenuStartTime,' - ', @MenuEndTime))

	-- Cursor through the menu items orginzed by Food Category


	
	RETURN -- returns @ProduceMenu
END
GO

-- =============================================
-- Author:		
-- Create date: 2022-11-16
-- Description:	Given a specific restaurant, return a table of the specials for that restaurant, and what times each dish is available. Order it by the day of the week it applies and includes the 10% discounted price. The start date starts on Monday = 0.
-- =============================================
CREATE FUNCTION dbo.DisplaySpecials(@RestaurantID smallint)
RETURNS @ProduceSpecialsMenu TABLE ( MenuInformation nvarchar(MAX)) 
AS
BEGIN
	RETURN -- returns @ProduceSpecialsMenu
END
GO

-- =============================================
-- Author:		
-- Create date: 2022-11-16
-- Description:	UseCreate a receipt to hand to the customer giving them a variety of information about their purchase.
-- =============================================
CREATE FUNCTION dbo.CreateReceipt(@ReceiptID int)
RETURNS @ProduceReceipt TABLE ( MenuInformation nvarchar(MAX)) 
AS
BEGIN
	RETURN -- returns @ProduceReceipt
END
GO

-- =============================================
-- Author:		
-- Create date: 2022-11-16
-- Description:	Given a ReceiptID, return only the total cost of all OrderedItems for that Receipt as a smallmoney.
-- =============================================
CREATE FUNCTION dbo.ReceiptTotalAmount(@ReceiptID int)
RETURNS smallmoney 
AS
BEGIN
	DECLARE @TotalAmount smallmoney = 0

	RETURN  @TotalAmount
END
GO

/****************************************************************
*
*	TRIGGER
*
****************************************************************/
-- =============================================
-- Author:		
-- Create date: 2022-11-16
-- Description:	Works like a check constraint. If the value is anything but 0 it will check with the Farms database to see if it's a valid ID. If not roll back and throw an error.
-- =============================================
CREATE TRIGGER tr_RestaurantHotelID
ON Restaurant
AFTER UPDATE, INSERT
AS
	DECLARE @NOTHING int
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
	DECLARE @NOTHING int
GO

-- =============================================
-- Author:		
-- Create date: 2022-11-16
-- Description:	When the user updates the credit card number and the credit card type. If both are filled then add the current date and time to the ReceiptDate. If one is missing roll back the info and throw an error stating that it's missing a field.
-- =============================================
CREATE TRIGGER tr_ReceiptPaid
ON Receipt
AFTER UPDATE
AS
	DECLARE @NOTHING int
GO

-- =============================================
-- Author:		Korbin Dansie
-- Create date: 2022-11-16
-- Description:	When the user adds a new Ordered_Item it checks to see if the item is the special of the day at that restaurant. Then it replaces the current Ordered_Item price with a 10% discount. It also adds “Special of the day” to the Ordered_Item.OrderedAdjustments row.
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
PRINT('Problem 1 - Add a new food item to a menu - To test trigger SpecialOfTheDay')
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
PRINT('Problem 3 - Display the breakfast menu - To test USDF DisplayMenu')

SELECT * FROM dbo.DisplayMenu(1, '7:00:00')


/****************************************************************
*
*	Delete Tables when done
*
****************************************************************/
-- TODO: Drop table when done
--USE master
--GO
--DROP DATABASE RedCanaries_CS3550
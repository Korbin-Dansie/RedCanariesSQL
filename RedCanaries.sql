-- Assignment:	Project Phase 1
-- Authors:		Briella Rutherford, Korbin Dansie
-- Date:		11/9/2022

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
*	Delete Tables when done
*
****************************************************************/
-- TODO: Drop table when done
USE master
GO
DROP DATABASE RedCanaries_CS3550
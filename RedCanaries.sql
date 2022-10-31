-- Assignment:	Project Phase 1
-- Authors:		Briella Rutherford, Korbin Dansie
-- Date:		10/31/2022

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
	AddressID		int				NOT NULL	IDENTITY(1,1),
	AddressLine1	varchar(30)		NOT NULL,
	AddressLine2	varchar(10),
	City			varchar(20)		NOT NULL,
	[State]			char(2),
	PostalCode		char(10)		NOT NULL,
	Country			varchar(20)		NOT NULL
);

CREATE TABLE [Location]
(
	LocationID		int		NOT NULL	IDENTITY(1,1),
	LocationAddress	int,
	LocationName	varchar(MAX)
);

CREATE TABLE Menu
(
	MenuID			int		NOT NULL	IDENTITY(1,1),
	LocationID		int		NOT NULL,
	FoodItemID		int		NOT NULL,
);

CREATE TABLE Food_Item
(
	FoodItemID			int			NOT NULL	IDENTITY(1,1),
	FoodName			varchar(30)	NOT NULL,
	FoodDescription		varchar(MAX),
	FoodPrice			smallmoney	NOT NULL
)

CREATE TABLE Recipe
(
	RecipeID		int		NOT NULL	IDENTITY(1,1),
	FoodItemID		int		NOT NULL,
	IngredientID	int		NOT NULL
)

CREATE TABLE Ingredient
(
	IngredientID	int			NOT NULL	IDENTITY(1,1),
	IngredientName	varchar(30)	NOT NULL
)

CREATE TABLE Inventory
(
	InventoryID		int		NOT NULL	IDENTITY(1,1),
	LocationID		int		NOT NULL,
	IngredientID	int		NOT NULL,
)

CREATE TABLE Ordered_Item
(
	OrderedItemID	int		NOT NULL	IDENTITY(1,1),	
	FoodItemID		int		NOT NULL,
	ReceiptID		int		NOT NULL,
	Adjustments		varchar(MAX)
)


CREATE TABLE Receipt
(
	ReceiptID				int			NOT NULL IDENTITY(1,1),
	RedeiptCreditCardNum	varchar(16),
	DiscountID				int,
	ReceiptAmountPaid		smallmoney,
	LocationID				int,
	ReceiptTip				smallmoney
)

CREATE TABLE Discount
(
	DiscountID			int	NOT NULL	IDENTITY(1,1),
	DiscountName		varchar(20),
	DiscountDescription	varchar(50),
	DiscountAmount		smallmoney,
	DiscountPercent		decimal(4,2),
	DiscountExpiration	date
)

CREATE TABLE Special
(
	SpecailID		int	NOT NULL	IDENTITY(1,1),
	FoodItemID		int	NOT NULL,
	LocationID		int	NOT NULL,
	SpecialWeekDay	tinyint
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

	ALTER TABLE [Location]
	ADD PRIMARY KEY (LocationID)
	
	ALTER TABLE Menu
	ADD PRIMARY KEY (MenuID)

	ALTER TABLE FoodItem
	ADD PRIMARY KEY (FoodItemID)

	ALTER TABLE Recipe
	ADD PRIMARY KEY (RecipeID)

	ALTER TABLE Ingredient
	ADD PRIMARY KEY (IngredientID)

	ALTER TABLE Inventory
	ADD PRIMARY KEY (InventoryID)

	ALTER TABLE Ordered_Item
	ADD PRIMARY KEY (OrderedItemID)

	ALTER TABLE Receipt
	ADD PRIMARY KEY (ReceiptID)

	ALTER TABLE Discount
	ADD PRIMARY KEY (DiscountID)

	ALTER TABLE Special
	ADD PRIMARY KEY (SpecialID)
GO

/****************************************************************
*
*	Delete Tables when done
*
****************************************************************/
-- TODO: Drop table when done
--USE master
--GO
--DROP DATABASE RedCanaries_CS3550
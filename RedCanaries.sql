-- Assignment:	Project Phase 1
-- Authors:		Briella Rutherford, Korbin Dansie
-- Date:		10/31/2022


USE master
	IF EXISTS (SELECT * FROM sysdatabases WHERE name='Dansie_FARMS')
	DROP DATABASE Dansie_FARMS
GO

CREATE DATABASE Dansie_FARMS
ON PRIMARY
(
	NAME = 'Dansie_FARMS', --.mdf
	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\Dansie_FARMS.mdf',
	SIZE = 4MB,
	MAXSIZE = 4MB,
	FILEGROWTH = 500KB
)
GO

USE Dansie_FARMS

CREATE TABLE Guest
(
	GuestID			smallint	NOT NULL	IDENTITY(1500,1),
	GuestFirst		varchar(20)	NOT NULL,
	GuestLast		varchar(20)	NOT NULL,
	GuestAddress1	varchar(30)	NOT NULL,
	GuestAddress2	varchar(30),
	GuestCity		varchar(20)	NOT NULL,
	GuestState		char(2),
	GuestPostalCode	char(10)	NOT NULL,
	GuestCountry	varchar(20)	NOT NULL,
	GuestPhone		varchar(20)	NOT NULL,
	GuestEmail		varchar(30),
	GuestComments	varchar(200)
);

CREATE TABLE CreditCard
(
	CreditCardID	smallint		NOT NULL	IDENTITY(1,1),
	GuestID			smallint		NOT NULL,
	CCType			varchar(5)		NOT NULL,
	CCNumber		varchar(16)		NOT NULL,
	CCCompany		varchar(40),
	CCCardHolder	varchar(40)		NOT NULL,
	CCExpiration	smalldatetime	NOT NULL
);

CREATE TABLE Reservation
(
	ReservationID		smallint	NOT NULL	IDENTITY(5000,1),
	ReservationDate		date		NOT NULL,
	ReservationStatus	char(1)		NOT NULL,
	ReservationComments varchar(200),
	CreditCardID		smallint	NOT NULL
)

CREATE TABLE Folio
(
	FolioID			smallint		NOT NULL	IDENTITY(1,1),
	ReservationID	smallint		NOT NULL,
	GuestID			smallint		NOT NULL,
	RoomID			smallint		NOT NULL,
	QuotedRate		smallmoney		NOT NULL,
	CheckinDate		smalldatetime	NOT NULL,
	Nights			tinyint			NOT NULL,
	Status			char(1)			NOT NULL,
	Comments		varchar(200),
	DiscountID		smallint		NOT NULL
)

CREATE TABLE Discount
(
	DiscountID			smallint	NOT NULL	IDENTITY(1,1),
	DiscountDescription	varchar(50)	NOT NULL,
	DiscountExpiration	date		NOT NULL,
	DiscountRules		varchar(200),
	DiscountPercent		decimal(4,2),
	DiscountAmount		smallmoney
)

CREATE TABLE Billing
(
	FolioBillingID		smallint	NOT NULL	IDENTITY(1,1),
	FolioID				smallint	NOT NULL,
	BillingCategoryID	smallint	NOT NULL,
	BillingDescription	char(30)	NOT NULL,
	BillingAmount		smallmoney	NOT NULL,
	BillingItemQty		tinyint		NOT NULL,
	BillingItemDate		date		NOT NULL
)

CREATE TABLE BillingCategory
(
	BillingCategoryID		smallint	NOT NULL	IDENTITY(1,1),
	BillingCatDescription	varchar(30)	NOT NULL,
	BillingCatTaxable		bit			NOT NULL
)

CREATE TABLE Payment
(
	PaymentID		smallint	NOT NULL	IDENTITY(8000,1),
	FolioID			smallint	NOT NULL,
	PaymentDate		date		NOT NULL,
	PaymentAmount	smallmoney	NOT NULL,
	PaymentComments	varchar(200)
)

CREATE TABLE Room
(
	RoomID					smallint		NOT NULL	IDENTITY(1,1),
	RoomNumber				varchar(5)		NOT NULL,
	RoomDescription			varchar(200)	NOT NULL,
	RoomSmoking				bit				NOT NULL,
	RoomBedConfiguration	char(2)			NOT NULL,
	HotelID					smallint		NOT NULL,
	RoomTypeID				smallint		NOT NULL
)

CREATE TABLE RoomType
(
	RoomTypeID		smallint		NOT NULL	IDENTITY(1,1),
	RTDescription	varchar(200)	NOT NULL
)

CREATE TABLE RackRate
(
	RackRateID			smallint		NOT NULL	IDENTITY(1,1),
	RoomTypeID			smallint		NOT NULL,
	HotelID				smallint		NOT NULL,
	RackRate			smallmoney		NOT NULL,
	RackRateBegin		date			NOT NULL,
	RackRateEnd			date			NOT NULL,
	RackRateDescription	varchar(200)	NOT NULL
)

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

CREATE TABLE TaxRate
(
	TaxLocationID	smallint		NOT NULL	IDENTITY(1,1),
	TaxDescription	varchar(30)		NOT NULL,
	RoomTaxRate		decimal(6,4)	NOT NULL,
	SalesTaxRate	decimal(6,4)	NOT NULL
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
	ALTER TABLE Guest
	ADD PRIMARY KEY (GuestID)

	ALTER TABLE CreditCard
	ADD PRIMARY KEY (CreditCardID)

	ALTER TABLE Reservation
	ADD PRIMARY KEY (ReservationID)

	ALTER TABLE Folio
	ADD PRIMARY KEY (FolioID)

	ALTER TABLE Discount
	ADD PRIMARY KEY (DiscountID)

	ALTER TABLE Billing
	ADD PRIMARY KEY (FolioBillingID)

	ALTER TABLE Payment
	ADD PRIMARY KEY (PaymentID)

	ALTER TABLE BillingCategory
	ADD PRIMARY KEY (BillingCategoryID)

	ALTER TABLE Room
	ADD PRIMARY KEY (RoomID)

	ALTER TABLE RoomType
	ADD PRIMARY KEY (RoomTypeID)

	ALTER TABLE RackRate
	ADD PRIMARY KEY (RackRateID)

	ALTER TABLE Hotel
	ADD PRIMARY KEY (HotelID)

	ALTER TABLE TaxRate
	ADD PRIMARY KEY (TaxLocationID)
GO
/********************************
*	1 Guest
********************************/

/********************************
*	2 CreditCard
********************************/
	
	-- Foreign Keys
	ALTER TABLE CreditCard
	ADD FOREIGN KEY (GuestID) REFERENCES Guest(GuestID)

/********************************
*	3 Reservation
********************************/

	-- Foreign Keys
	ALTER TABLE Reservation
	ADD FOREIGN KEY (CreditCardID) REFERENCES CreditCard(CreditCardID)

	-- Check Constraints
	ALTER TABLE Reservation
	ADD CONSTRAINT CK_ReservationStatus
	CHECK (ReservationStatus IN ('R','A','C','X'))

	ALTER TABLE Reservation
	ADD CONSTRAINT DF_ReservationStatus
	DEFAULT 'R' FOR ReservationStatus 


/********************************
*	4 Folio
********************************/

	-- Foreign Keys
	ALTER TABLE Folio
	ADD FOREIGN KEY (ReservationID) REFERENCES Reservation(ReservationID)

	ALTER TABLE Folio
	ADD FOREIGN KEY (RoomID) REFERENCES Room(RoomID)

	ALTER TABLE Folio
	ADD FOREIGN KEY (DiscountID) REFERENCES Discount(DiscountID)

	-- Check Constraints
	ALTER TABLE Folio
	ADD CONSTRAINT CK_FolioStatus
	CHECK (Status IN ('R','A','C','X'))

	-- Defualt Constraints
	ALTER TABLE Folio
	ADD CONSTRAINT DF_FolioDiscount
	DEFAULT 1 FOR DiscountID 

	ALTER TABLE Folio
	ADD CONSTRAINT DF_FolioStatus
	DEFAULT 'R' FOR Status 

/********************************
*	5 Discount
********************************/

/********************************
*	6 Billing
********************************/

	-- Foreign Keys
	ALTER TABLE Billing
	ADD FOREIGN KEY (FolioID) REFERENCES Folio(FolioID)

	ALTER TABLE Billing
	ADD FOREIGN KEY (BillingCategoryID) REFERENCES BillingCategory(BillingCategoryID)

/********************************
*	7 BillingCategory
********************************/

/********************************
*	8 Payment
********************************/

	-- Foreign Keys
	ALTER TABLE Payment
	ADD FOREIGN KEY (FolioID) REFERENCES Folio(FolioID)

/********************************
*	9 Room
********************************/

	-- Foreign Keys
	ALTER TABLE Room
	ADD FOREIGN KEY (HotelID) REFERENCES Hotel(HotelID)

	ALTER TABLE Room
	ADD FOREIGN KEY (RoomTypeID) REFERENCES RoomType(RoomTypeID)

	-- Check Constraints
	ALTER TABLE Room
	ADD CONSTRAINT CK_RoomBedConfiguration
	CHECK (RoomBedConfiguration IN ('K','Q','F','2K','2Q','2F'))

/********************************
*	10 RoomType
********************************/

/********************************
*	11 RackRate
********************************/

	-- Foreign Keys
	ALTER TABLE RackRate
	ADD FOREIGN KEY (RoomTypeID) REFERENCES RoomType(RoomTypeID)

	ALTER TABLE RackRate
	ADD FOREIGN KEY (HotelID) REFERENCES Hotel(HotelID)

/********************************
*	12 Hotel
********************************/

	-- Foreign Keys
	ALTER TABLE Hotel
	ADD FOREIGN KEY (TaxLocationID) REFERENCES TaxRate(TaxLocationID)

/********************************
*	13 TaxRate
********************************/

/****************************************************************
*
*	Bulk insert
*
****************************************************************/
BULK INSERT Guest
FROM 'C:\Stage\Guest.txt'
WITH
(
	FIELDTERMINATOR =	'|',
	ROWTERMINATOR =		'\n'
)

BULK INSERT CreditCard
FROM 'C:\Stage\CreditCard.txt'
WITH
(
	FIELDTERMINATOR =	'|',
	ROWTERMINATOR =		'\n'
)

BULK INSERT Reservation
FROM 'C:\Stage\Reservation.txt'
WITH
(
	FIELDTERMINATOR =	'|',
	ROWTERMINATOR =		'\n'
)

BULK INSERT Folio
FROM 'C:\Stage\Folio.txt'
WITH
(
	FIELDTERMINATOR =	'|',
	ROWTERMINATOR =		'\n'
)

BULK INSERT Discount
FROM 'C:\Stage\Discount.txt'
WITH
(
	FIELDTERMINATOR =	'|',
	ROWTERMINATOR =		'\n'
)

BULK INSERT Billing
FROM 'C:\Stage\Billing.txt'
WITH
(
	FIELDTERMINATOR =	'|',
	ROWTERMINATOR =		'\n'
)

BULK INSERT BillingCategory
FROM 'C:\Stage\BillingCategory.txt'
WITH
(
	FIELDTERMINATOR =	'|',
	ROWTERMINATOR =		'\n'
)

BULK INSERT Payment
FROM 'C:\Stage\Payment.txt'
WITH
(
	FIELDTERMINATOR =	'|',
	ROWTERMINATOR =		'\n'
)

BULK INSERT Room
FROM 'C:\Stage\Room.txt'
WITH
(
	FIELDTERMINATOR =	'|',
	ROWTERMINATOR =		'\n'
)

BULK INSERT RoomType
FROM 'C:\Stage\RoomType.txt'
WITH
(
	FIELDTERMINATOR =	'|',
	ROWTERMINATOR =		'\n'
)

BULK INSERT RackRate
FROM 'C:\Stage\RackRate.txt'
WITH
(
	FIELDTERMINATOR =	'|',
	ROWTERMINATOR =		'\n'
)

BULK INSERT Hotel
FROM 'C:\Stage\Hotel.txt'
WITH
(
	FIELDTERMINATOR =	'|',
	ROWTERMINATOR =		'\n'
)

BULK INSERT TaxRate
FROM 'C:\Stage\TaxRate.txt'
WITH
(
	FIELDTERMINATOR =	'|',
	ROWTERMINATOR =		'\n'
)
GO

/****************************************************************
*
*	Delete Tables when done
*
****************************************************************/
-- TODO: Drop table when done
USE master
GO
DROP DATABASE Dansie_FARMS
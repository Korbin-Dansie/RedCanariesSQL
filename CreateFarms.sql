-- Create FARMS database for use with RedCanaries


/*
====================================================================================================
	CREATE DATABASE
====================================================================================================
*/

-- Drop if exists
USE Master

IF EXISTS (SELECT * FROM sysdatabases WHERE name='FARMS')
DROP DATABASE FARMS

GO

-- Make new one
CREATE DATABASE FARMS

ON PRIMARY

(
NAME = 'FARMS',
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\FARMS.mdf',
-- FILENAME LOCAL
SIZE = 4MB,
MAXSIZE = 4MB,
FILEGROWTH = 500KB
)

LOG ON

(
NAME = 'FARMS_Log',
FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\FARMS.ldf',
-- FILENAME LOCAL
SIZE = 4MB,
MAXSIZE = 4MB,
FILEGROWTH = 500KB
)

GO 


/*
--------------------------------------------------
	With DB created, switch to it, make tables
--------------------------------------------------
*/
USE FARMS


--- Guest
CREATE TABLE Guest
(
GuestID					smallint		NOT NULL	IDENTITY(1500,1),
GuestFirst				varchar(20)		NOT NULL,
GuestLast				varchar(20)		NOT NULL, 
GuestAddress1			varchar(30)		NOT NULL, 
GuestAddress2			varchar(10)		NULL,
GuestCity				varchar(20)		NOT NULL,
GuestState				char(2)			NULL,
GuestPostalCode			char(10)		NOT NULL,
GuestCountry			varchar(20)		NOT NULL,
GuestPhone				varchar(20)		NOT NULL,
GuestEmail				varchar(30)		NULL,
GuestComments			varchar(200)	NULL
)

--- RoomType
CREATE TABLE RoomType
(
RoomTypeID				smallint		NOT NULL	IDENTITY,
RTDescription			varchar(200)	NOT NULL
)

--- Discount
CREATE TABLE Discount
(
DiscountID				smallint		NOT NULL	IDENTITY,
DiscountDescription		varchar(50)		NOT NULL,
DiscountExpiration		date			NOT NULL,
DiscountRules			varchar(100)	NULL,
DiscountPercent			decimal(4,2)	NULL,
DiscountAmount			smallmoney		NULL
)

--- BillingCategory
CREATE TABLE BillingCategory
(
BillingCategoryID		smallint		NOT NULL	IDENTITY,
BillingCatDescription	varchar(30)		NOT NULL,
BillingCatTaxable		bit				NOT NULL
)

--- TaxRate
CREATE TABLE TaxRate
(
TaxLocationID			smallint		NOT NULL	IDENTITY,
TaxDescription			varchar(30)		NOT NULL,
RoomTaxRate				decimal(6,4)	NOT NULL,
SalesTaxRate			decimal(6,4)	NOT NULL
)

--- CreditCard
CREATE TABLE CreditCard
(
CreditCardID			smallint		NOT NULL	IDENTITY,
GuestID					smallint		NOT NULL, --- Foreign Key
CCType					varchar(5)		NOT NULL,
CCNumber				varchar(16)		NOT NULL,
CCCompany				varchar(40)		NULL,
CCCardHolder			varchar(40)		NOT NULL,
CCExpiration			smalldatetime	NOT NULL
)

--- Hotel
CREATE TABLE Hotel
(
HotelID					smallint		NOT NULL, --- NOT an Identity
HotelName				varchar(30)		NOT NULL,
HotelAddress			varchar(30)		NOT NULL,
HotelCity				varchar(20)		NOT NULL,
HotelState				char(2)			NULL,
HotelCountry			varchar(20)		NOT NULL,
HotelPostalCode			char(10)		NOT NULL,
HotelStarRating			char(1)			NULL,
HotelPictureLink		varchar(100)	NULL,
TaxLocationID			smallint		NOT NULL
)

--- Reservation
CREATE TABLE Reservation
(
ReservationID			smallint		NOT NULL	IDENTITY(5000,1),
ReservationDate			date			NOT NULL,
ReservationStatus		char(1)			NOT NULL, --- CHECK R,A,C,X
ReservationComments		varchar(200)	NULL,
CreditCardID			smallint		NOT NULL  --- Foreign Key
)

--- Room
CREATE TABLE Room
(
RoomID					smallint		NOT NULL	IDENTITY,
RoomNumber				varchar(5)		NOT NULL,
RoomDescription			varchar(200)	NOT NULL,
RoomSmoking				bit				NOT NULL,
RoomBedConfiguration	char(2)			NOT NULL, --- CHECK K,Q,F,2Q,2K,2F
HotelID					smallint		NOT NULL, --- Foreign Key
RoomTypeID				smallint		NOT NULL  --- Foreign Key
)

--- RackRate
CREATE TABLE RackRate
(
RackRateID				smallint		NOT NULL	IDENTITY,
RoomTypeID				smallint		NOT NULL, --- Foreign Key
HotelID					smallint		NOT NULL, --- Foreign Key
RackRate				smallmoney		NOT NULL,
RackRateBegin			date			NOT NULL,
RackRateEnd				date			NOT NULL,
RackRateDescription		varchar(200)	NOT NULL
)

--- Folio
CREATE TABLE Folio
(
FolioID					smallint		NOT NULL IDENTITY,
ReservationID			smallint		NOT NULL, --- Foreign Key
GuestID					smallint		NOT NULL, --- TRIGGER
RoomID					smallint		NOT NULL, --- Foreign Key
FolioQuotedRate			smallmoney		NOT NULL,
FolioCheckinDate		smalldatetime	NOT NULL,
FolioNights				tinyint			NOT NULL,
FolioStatus				char(1)			NOT NULL, --- CHECK R,A,C,X
FolioComments			varchar(200)	NULL,
DiscountID				smallint		NOT NULL  --- Foreign Key, default 1
)

--- Billing
CREATE TABLE Billing
(
BillingID				smallint		NOT NULL IDENTITY,
FolioID					smallint		NOT NULL, --- Foreign Key
BillingCategoryID		smallint		NOT NULL, --- Foreign Key
BillingDescription		char(30)		NOT NULL,
BillingAmount			smallmoney		NOT NULL,
BillingItemQty			tinyint			NOT NULL,
BillingItemDate			date			NOT NULL
)

--- Payment
CREATE TABLE Payment
(
PaymentID				smallint		NOT NULL IDENTITY(8000,1),
FolioID					smallint		NOT NULL, --- Foreign Key
PaymentDate				date			NOT NULL,
PaymentAmount			smallmoney		NOT NULL,
PaymentComments			varchar(200)	NULL
)

GO

/*
--------------------------------------------------
	Make Alterations and Constraints
--------------------------------------------------
*/

--- Add Primary Keys
ALTER TABLE Guest
	ADD CONSTRAINT PK_GuestID
	PRIMARY KEY (GuestID)

ALTER TABLE RoomType
	ADD CONSTRAINT PK_RoomTypeID
	PRIMARY KEY (RoomTypeID)

ALTER TABLE Discount
	ADD CONSTRAINT PK_DiscountID
	PRIMARY KEY (DiscountID)

ALTER TABLE BillingCategory
	ADD CONSTRAINT PK_BillingCategoryID
	PRIMARY KEY (BillingCategoryID)

ALTER TABLE TaxRate
	ADD CONSTRAINT PK_TaxRateID
	PRIMARY KEY (TaxLocationID)

ALTER TABLE CreditCard
	ADD CONSTRAINT PK_CreditCardID
	PRIMARY KEY (CreditCardID)

ALTER TABLE Hotel
	ADD CONSTRAINT PK_HotelID
	PRIMARY KEY (HotelID)

ALTER TABLE Reservation
	ADD CONSTRAINT PK_ReservationID
	PRIMARY KEY (ReservationID)

ALTER TABLE Room
	ADD CONSTRAINT PK_RoomID
	PRIMARY KEY (RoomID)

ALTER TABLE RackRate
	ADD CONSTRAINT PK_RackRateID
	PRIMARY KEY (RackRateID)

ALTER TABLE Folio
	ADD CONSTRAINT PK_FolioID
	PRIMARY KEY (FolioID)

ALTER TABLE Billing
	ADD CONSTRAINT PK_BillingID
	PRIMARY KEY (BillingID)

ALTER TABLE Payment
	ADD CONSTRAINT PK_PaymentID
	PRIMARY KEY (PaymentID)

GO

--- Add Foreign Key Constraints

ALTER TABLE CreditCard
	ADD CONSTRAINT FK_CreditCardtoGuestID
	FOREIGN KEY (GuestID) REFERENCES Guest (GuestID)
	ON UPDATE CASCADE
	ON DELETE CASCADE

ALTER TABLE Hotel
	ADD CONSTRAINT FK_HoteltoTaxLocationID
	FOREIGN KEY (TaxLocationID) REFERENCES TaxRate (TaxLocationID)
	ON UPDATE CASCADE
	ON DELETE CASCADE

ALTER TABLE Reservation
	ADD CONSTRAINT FK_ReservationtoCreditCardID
	FOREIGN KEY (CreditCardID) REFERENCES CreditCard (CreditCardID)
	ON UPDATE CASCADE
	ON DELETE CASCADE

ALTER TABLE Room
	ADD 
	
	CONSTRAINT FK_RoomtoRoomTypeID
	FOREIGN KEY (RoomTypeID) REFERENCES RoomType (RoomTypeID)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	
	CONSTRAINT FK_RoomtoHotelID
	FOREIGN KEY (HotelID) REFERENCES Hotel (HotelID)
	ON UPDATE CASCADE
	ON DELETE CASCADE

ALTER TABLE RackRate
	ADD 
	
	CONSTRAINT FK_RackRatetoRoomTypeID
	FOREIGN KEY (RoomTypeID) REFERENCES RoomType (RoomTypeID)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	
	CONSTRAINT FK_RackRatetoHotelID
	FOREIGN KEY (HotelID) REFERENCES Hotel (HotelID)
	ON UPDATE CASCADE
	ON DELETE CASCADE

ALTER TABLE Folio
	ADD 
	
	CONSTRAINT FK_FoliotoReservationID
	FOREIGN KEY (ReservationID) REFERENCES Reservation (ReservationID)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	
	CONSTRAINT FK_FoliotoRoomID
	FOREIGN KEY (RoomID) REFERENCES Room (RoomID)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	
	CONSTRAINT FK_DiscountID
	FOREIGN KEY (DiscountID) REFERENCES Discount (DiscountID)
	ON UPDATE CASCADE
	ON DELETE CASCADE

ALTER TABLE Billing
	ADD 
	
	CONSTRAINT FK_BillingtoFolioID
	FOREIGN KEY (FolioID) REFERENCES Folio (FolioID)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	
	CONSTRAINT FK_BillingtoBillingCategoryID
	FOREIGN KEY (BillingCategoryID) REFERENCES BillingCategory (BillingCategoryID)
	ON UPDATE CASCADE
	ON DELETE CASCADE

ALTER TABLE Payment
	ADD CONSTRAINT FK_PaymenttoFolioID
	FOREIGN KEY (FolioID) REFERENCES Folio (FolioID)
	ON UPDATE CASCADE
	ON DELETE CASCADE

GO

--- Add Check Constraints

ALTER TABLE Reservation
	ADD CONSTRAINT CK_ReservationStatusMustBeRACorX
	CHECK (ReservationStatus IN ('R','A','C','X'))

ALTER TABLE Room
	ADD CONSTRAINT CK_BedConfigurationMustBeValid
	CHECK (RoomBedConfiguration IN ('K','Q','F','2Q','2K','2F'))

ALTER TABLE Folio
	ADD CONSTRAINT CK_FolioStatusMustBeRACorX
	CHECK (FolioStatus IN ('R','A','C','X'))

GO

--- Add Default Constraints

ALTER TABLE Folio
	ADD CONSTRAINT DK_DiscountIDis1
	DEFAULT 1 FOR DiscountID

GO

/*
==================================================
	BULK INSERT
==================================================
*/


BULK INSERT Guest from 'C:\Users\Briel\Desktop\School\Database\Farms1-1\Guest.txt' WITH (FIELDTERMINATOR='|')
BULK INSERT RoomType from 'C:\Users\Briel\Desktop\School\Database\Farms1-1\RoomType.txt' WITH (FIELDTERMINATOR='|')
BULK INSERT Discount from 'C:\Users\Briel\Desktop\School\Database\Farms1-1\Discount.txt' WITH (FIELDTERMINATOR='|')
BULK INSERT BillingCategory from 'C:\Users\Briel\Desktop\School\Database\Farms1-1\BillingCategory.txt' WITH (FIELDTERMINATOR='|')
BULK INSERT TaxRate from 'C:\Users\Briel\Desktop\School\Database\Farms1-1\TaxRate.txt' WITH (FIELDTERMINATOR='|')
BULK INSERT CreditCard from 'C:\Users\Briel\Desktop\School\Database\Farms1-1\CreditCard.txt' WITH (FIELDTERMINATOR='|')
BULK INSERT Hotel from 'C:\Users\Briel\Desktop\School\Database\Farms1-1\Hotel.txt' WITH (FIELDTERMINATOR='|')
BULK INSERT Reservation from 'C:\Users\Briel\Desktop\School\Database\Farms1-1\Reservation.txt' WITH (FIELDTERMINATOR='|')
BULK INSERT Room from 'C:\Users\Briel\Desktop\School\Database\Farms1-1\Room.txt' WITH (FIELDTERMINATOR='|')
BULK INSERT RackRate from 'C:\Users\Briel\Desktop\School\Database\Farms1-1\RackRate.txt' WITH (FIELDTERMINATOR='|')
BULK INSERT Folio from 'C:\Users\Briel\Desktop\School\Database\Farms1-1\Folio.txt' WITH (FIELDTERMINATOR='|')
BULK INSERT Billing from 'C:\Users\Briel\Desktop\School\Database\Farms1-1\Billing.txt' WITH (FIELDTERMINATOR='|')
BULK INSERT Payment from 'C:\Users\Briel\Desktop\School\Database\Farms1-1\Payment.txt' WITH (FIELDTERMINATOR='|')

/*
BULK INSERT Guest from 'C:\Stage\Guest.txt' WITH (FIELDTERMINATOR='|')
BULK INSERT RoomType from 'C:\Stage\RoomType.txt' WITH (FIELDTERMINATOR='|')
BULK INSERT Discount from 'C:\Stage\Discount.txt' WITH (FIELDTERMINATOR='|')
BULK INSERT BillingCategory from 'C:\Stage\BillingCategory.txt' WITH (FIELDTERMINATOR='|')
BULK INSERT TaxRate from 'C:\Stage\TaxRate.txt' WITH (FIELDTERMINATOR='|')
BULK INSERT CreditCard from 'C:\Stage\CreditCard.txt' WITH (FIELDTERMINATOR='|')
BULK INSERT Hotel from 'C:\Stage\Hotel.txt' WITH (FIELDTERMINATOR='|')
BULK INSERT Reservation from 'C:\Stage\Reservation.txt' WITH (FIELDTERMINATOR='|')
BULK INSERT Room from 'C:\Stage\Room.txt' WITH (FIELDTERMINATOR='|')
BULK INSERT RackRate from 'C:\Stage\RackRate.txt' WITH (FIELDTERMINATOR='|')
BULK INSERT Folio from 'C:\Stage\Folio.txt' WITH (FIELDTERMINATOR='|')
BULK INSERT Billing from 'C:\Stage\Billing.txt' WITH (FIELDTERMINATOR='|')
BULK INSERT Payment from 'C:\Stage\Payment.txt' WITH (FIELDTERMINATOR='|')
*/

GO

UPDATE Reservation SET ReservationStatus = 'A' WHERE ReservationID = 5005

UPDATE Folio SET FolioStatus = 'A' WHERE ReservationID = 5005

GO




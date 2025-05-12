/* START */
/*
Implemnting Design Elements on quote compilation db 
*/

--Create a proc to make contact connected to customer table.
GO
	CREATE PROCEDURE createCustomer
	@ContactName NVARCHAR(100),
	@ContactPhone VARCHAR(20),
	@ContactFax VARCHAR(20) = NULL,
	@ContactMobilePhone VARCHAR(20) = NULL,
	@ContactEmail VARCHAR(100) = NULL,
	@ContactWWW VARCHAR(100) = NULL,
	@ContactPostalAddress NVARCHAR(255) = NULL,
	@NewCustomerID INT OUTPUT
	AS
	BEGIN
	SET NOCOUNT ON;

	INSERT INTO Contact(ContactName, ContactPhone, ContactFax, ContactMobilePhone, ContactEmail, ContactWWW, ContactPostalAddress)
	VALUES (@ContactName, @ContactPhone, @ContactFax, @ContactMobilePhone, @ContactEmail, @ContactWWW, @ContactPostalAddress);

	SET @NewCustomerID = SCOPE_IDENTITY();

	INSERT INTO Customer(CustomerID) VALUES (@NewCustomerID);
	END;
GO

--Create a proc for creating a quote
GO
	CREATE PROCEDURE createQuote
	@QuoteDescription NVARCHAR(255),
	@QuoteDate DATETIME = NULL,
    @QuoteCompiler NVARCHAR(100),
    @CustomerID INT,
    @QuoteID INT OUTPUT
	AS
	BEGIN
	SET NOCOUNT ON;

	--Makes QuoteDate optional and if null sets it to current date
	IF @QuoteDate IS NULL SET @QuoteDate = GETDATE();

	INSERT INTO Quote (QuoteDescription, QuoteDate, QuoteCompiler, CustomerID)
    VALUES (@QuoteDescription, @QuoteDate, @QuoteCompiler, @CustomerID);

	SET @QuoteID = SCOPE_IDENTITY();
	END
GO

--Create proc for adding a quote component
Go
	CREATE PROCEDURE addQuoteComponent 
	@QuoteID INT,
	@ComponentID INT,
	@Quantity DECIMAL(10,2)
	AS
	BEGIN
	SET NOCOUNT ON;

	DECLARE @TradePrice DECIMAL(10,2);
    DECLARE @ListPrice DECIMAL(10,2);
    DECLARE @TimeToFit DECIMAL(5,2);


	SELECT 
        @TradePrice = TradePrice,
        @ListPrice = ListPrice,
        @TimeToFit = TimeToFit
    FROM Component
    WHERE ComponentID = @ComponentID;

	INSERT INTO QuoteComponent (QuoteID, ComponentID, Quantity, TradePrice, ListPrice, TimeToFit)
    VALUES (@QuoteID, @ComponentID, @Quantity, @TradePrice, @ListPrice, @TimeToFit);
	END;
GO

--Script for new customers and quotes
DECLARE @BHID INT;
EXEC createCustomer
    @ContactName = 'Bimble & Hat',
    @ContactPhone = '444 5555',
    @ContactPostalAddress = '123 Digit Street, Dunedin',
    @ContactEmail = 'guy.little@bh.biz.nz',
    @NewCustomerID = @BHID OUTPUT;

DECLARE @BHQuoteID1 INT;
DECLARE @BHQuoteID2 INT;

DECLARE @HMID INT;
EXEC createCustomer
    @ContactName = 'Hyperfont Modulator (International) Ltd.',
    @ContactPhone = '(4) 213 4359',
    @ContactPostalAddress = '3 Lambton Quay, Wellington',
    @ContactEmail = 'sue@nz.hfm.com',
    @NewCustomerID = @HMID OUTPUT;

DECLARE @HMQuoteID INT;

/*
SELECT * FROM Contact

SELECT * FROM Customer
*/

--Quote for Bimble & Hat Craypot frame
EXEC createQuote 
    @QuoteDescription = 'Craypot frame',
    @QuoteCompiler = 'Bimble & Hat',
    @CustomerID = @BHID, 
    @QuoteID = @BHQuoteID1 OUTPUT;

EXEC addQuoteComponent @QuoteID = @BHQuoteID1, @ComponentID = 30935, @Quantity = 3.0;   --3 of 15mm square strap
EXEC addQuoteComponent @QuoteID = @BHQuoteID1, @ComponentID = 30912, @Quantity = 8.0;   --8 of 1250mm BMS.5.15 ms bar
EXEC addQuoteComponent @QuoteID = @BHQuoteID1, @ComponentID = 30901, @Quantity = 24.0;  --24 of BMS10 bolt
EXEC addQuoteComponent @QuoteID = @BHQuoteID1, @ComponentID = 30904, @Quantity = 24.0;  --24 of NMS10 nut
EXEC addQuoteComponent @QuoteID = @BHQuoteID1, @ComponentID = 30933, @Quantity = 0.2;   --200ml of anti-rust paint, blue
EXEC addQuoteComponent @QuoteID = @BHQuoteID1, @ComponentID = 30921, @Quantity = 2.5;   --150 minutes of artisan labour
EXEC addQuoteComponent @QuoteID = @BHQuoteID1, @ComponentID = 30923, @Quantity = 2.0;   --120 minutes of apprentice labour
EXEC addQuoteComponent @QuoteID = @BHQuoteID1, @ComponentID = 30922, @Quantity = 0.75;  --45 minutes of designer labour

--Second Quote for Bimble & Hat Craypot stand
EXEC createQuote 
    @QuoteDescription = 'Craypot stand',
    @QuoteCompiler = 'Bimble & Hat',
    @CustomerID = @BHID, 
    @QuoteID = @BHQuoteID2 OUTPUT;

EXEC addQuoteComponent @QuoteID = @BHQuoteID2, @ComponentID = 30914, @Quantity = 2.0;   --2 of 2565mm length BMS.15.40 ms
EXEC addQuoteComponent @QuoteID = @BHQuoteID2, @ComponentID = 30903, @Quantity = 4.0;   --bar 4 of BMS15 bolt
EXEC addQuoteComponent @QuoteID = @BHQuoteID2, @ComponentID = 30906, @Quantity = 4.0;   --4 of NMS15 nut
EXEC addQuoteComponent @QuoteID = @BHQuoteID2, @ComponentID = 30933, @Quantity = 0.1;   --100ml of anti-rust paint, blue
EXEC addQuoteComponent @QuoteID = @BHQuoteID2, @ComponentID = 30923, @Quantity = 1.5;   --90 minutes of apprentice labour
EXEC addQuoteComponent @QuoteID = @BHQuoteID2, @ComponentID = 30922, @Quantity = 0.25;	--15 minutes of designer labour

--Quote for Hyperfront Modulator
EXEC createQuote 
    @QuoteDescription = 'Phasing restitution fulcrum',
    @QuoteCompiler = 'Hyperfont Modulator (International) Ltd.',
    @CustomerID = @HMID, 
    @QuoteID = @HMQuoteID OUTPUT;

EXEC addQuoteComponent @QuoteID = @HMQuoteID, @ComponentID = 30936, @Quantity = 3.0;   --3 of 15mm corner brace
EXEC addQuoteComponent @QuoteID = @HMQuoteID, @ComponentID = 30934, @Quantity = 1.0;   --assembly 1 of 15mm small corner
EXEC addQuoteComponent @QuoteID = @HMQuoteID, @ComponentID = 30921, @Quantity = 5.33;  --320 minutes of artisan labour 105
EXEC addQuoteComponent @QuoteID = @HMQuoteID, @ComponentID = 30922, @Quantity = 0.5;  --minutes of designer labour 0.5
EXEC addQuoteComponent @QuoteID = @HMQuoteID, @ComponentID = 30932, @Quantity = 1;   --litre of anti-rust paint, red

/*
SELECT * FROM Quote

SELECT * FROM QuoteComponent
*/

/* END */
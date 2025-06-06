/*  START  */

/*
Create data on QuoteCompilation database to support
ID705 Databases 3 assignment.

****************************WARNING******************************************************
Object names used in this script require that
you must have implemented the database as specified on the assignment ERD


*/

--support functions, views and sp
--create function dbo.getCategoryID
GO
	CREATE FUNCTION dbo.getCategoryID(@CategoryName NVARCHAR(100))
	RETURNS INT 
	AS 
	BEGIN
		DECLARE @CategoryID INT;
		SELECT @CategoryID = CategoryID
		FROM Category
		WHERE CategoryName = @CategoryName
		RETURN @CategoryID
	END;
GO

--create function dbo.getAssemblySupplierID()
GO
	CREATE FUNCTION dbo.getAssemblySupplierID()
	RETURNS INT
	AS
	BEGIN
		DECLARE @SupplierID INT;
		SELECT @SupplierID = SupplierID
		FROM Supplier
		WHERE SupplierID IN (
			SELECT ContactID
			FROM Contact
			WHERE ContactName = 'BIT Manufacturing Ltd.'
		);

		RETURN @SupplierID;
	END;
GO

--create proc createAssembly
GO 
	CREATE PROCEDURE createAssembly
	@componentName NVARCHAR(100),
	@componentDescription NVARCHAR(255)
	AS
	BEGIN
	DECLARE @supplierID INT;
	DECLARE @categoryID INT;
	DECLARE @newComponentID INT;

	--Setting supplierID and categoryIDs
	SET @supplierID = dbo.getAssemblySupplierID();
	SET @categoryID = dbo.getCategoryID('Assembly');

	--Generate a ComponentID
	SELECT @newComponentID = ISNULL(MAX(ComponentID), 0) + 1 FROM Component;

	INSERT INTO Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
	VALUES (@newComponentID, @componentName, @componentDescription, @supplierID, 0, 0, 0, @categoryID);
	END;
GO

--create proc addSubComponent
GO
	CREATE PROCEDURE addSubComponent
	@assemblyName NVARCHAR(100),
	@subComponentName NVARCHAR(100),
	@quantity DECIMAL(10,2)
	AS
	BEGIN
	DECLARE @assemblyID INT;
	DECLARE @subComponentID INT;

	--Grabs the assemblyID where the component names id is
    SELECT @assemblyID = ComponentID
    FROM Component
    WHERE ComponentName = @assemblyName;

	--Grabs the subComponentID from the subComponentName
    SELECT @subComponentID = ComponentID
    FROM Component
    WHERE ComponentName = @subComponentName;

    INSERT INTO AssemblySubcomponent (AssemblyID, SubcomponentID, Quantity)
    VALUES (@assemblyID, @subComponentID, @quantity);
END;
GO

-- Using variables : @ABC int, @XYZ int, @CDBD int, @BITManf int- capture the ContactID
--create categories
insert Category (CategoryName) values ('Black Steel')
insert Category (CategoryName) values ('Assembly')
insert Category (CategoryName) values ('Fixings')
insert Category (CategoryName) values ('Paint')
insert Category (CategoryName) values ('Labour')

/*
SELECT * FROM Category
*/

--create contacts
--Using variables : @ABC int, @XYZ int, @CDBD int, @BITManf int- capture the ContactID
-- This will mean you don't have to hard code these later.
DECLARE @ABC INT, @XYZ INT, @CDBD INT, @BITManf INT;

insert Contact (ContactName, ContactPostalAddress, ContactWWW, ContactEmail, ContactPhone, ContactFax)
values ('ABC Ltd.', '17 George Street, Dunedin', 'www.abc.co.nz', 'info@abc.co.nz', '	471 2345', null)
SET @ABC = @@IDENTITY;

insert Contact (ContactName, ContactPostalAddress, ContactWWW, ContactEmail, ContactPhone, ContactFax)
values ('XYZ Ltd.', '23 Princes Street, Dunedin', null, 'xyz@paradise.net.nz', '4798765', '4798760')
SET @XYZ = @@IDENTITY;

insert Contact (ContactName, ContactPostalAddress, ContactWWW, ContactEmail, ContactPhone, ContactFax)
values ('CDBD Pty Ltd.',	'Lot 27, Kangaroo Estate, Bondi, NSW, Australia 2026', '	www.cdbd.com.au', 'support@cdbd.com.au', '+61 (2) 9130 1234', null)
SET @CDBD = @@IDENTITY;

insert Contact (ContactName, ContactPostalAddress, ContactWWW, ContactEmail, ContactPhone, ContactFax)
values ('BIT Manufacturing Ltd.', 'Forth Street, Dunedin', 'bitmanf.tekotago.ac.nz', 'bitmanf@tekotago.ac.nz', '0800 SMARTMOVE', null)
SET @BITManf = @@IDENTITY;

/*
SELECT * FROM Contact
*/

-- Insert Suppliers using ContactIDs
INSERT Supplier (SupplierID, SupplierGST) VALUES (@ABC, 'ABC-GST')
INSERT Supplier (SupplierID, SupplierGST) VALUES (@XYZ, 'XYZ-GST')
INSERT Supplier (SupplierID, SupplierGST) VALUES (@CDBD, 'CDBD-GST')
INSERT Supplier (SupplierID, SupplierGST) VALUES (@BITManf, 'BIT-GST')

/*
SELECT * FROM Supplier
*/

-- create components
-- Note this script relies on you having captured the ContactID to insert into SupplierID

insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
values (30901, 'BMS10', '10mm M6 ms bolt', @ABC, 0.20, 0.17, 0.5, dbo.getCategoryID('Fixings'))
insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
values (30902, 'BMS12', '12mm M6 ms bolt', @ABC, 0.25, 0.2125,	0.5, dbo.getCategoryID('Fixings'))
insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
values (30903, 'BMS15', '15mm M6 ms bolt', @ABC, 0.32, 0.2720, 0.5, dbo.getCategoryID('Fixings'))
insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
values (30904, 'NMS10', '10mm M6 ms nut', @ABC, 0.05, 0.04, 0.5, dbo.getCategoryID('Fixings'))
insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
values (30905, 'NMS12', '12mm M6 ms nut', @ABC, 0.052, 0.0416, 0.5, dbo.getCategoryID('Fixings'))
insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
values (30906, 'NMS15', '15mm M6 ms nut', @ABC, 0.052, 0.0416, 0.5, dbo.getCategoryID('Fixings'))
insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
values (30911, 'BMS.3.12', '3mm x 12mm flat ms bar', @XYZ, 1.20, 1.15, 	0.75, dbo.getCategoryID('Black Steel'))
insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
values (30912, 'BMS.5.15', '5mm x 15mm flat ms bar', @XYZ, 2.50, 2.45, 	0.75, dbo.getCategoryID('Black Steel'))
insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
values (30913, 'BMS.10.25', '10mm x 25mm flat ms bar', @XYZ, 8.33, 8.27, 0.75, dbo.getCategoryID('Black Steel'))
insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
values (30914, 'BMS.15.40', '15mm x 40mm flat ms bar', @XYZ, 20.00, 19.85, 0.75, dbo.getCategoryID('Black Steel'))
insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
values (30931, '27', 'Anti-rust paint, silver', @CDBD, 74.58, 63.85, 0, dbo.getCategoryID('Paint'))
insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
values (30932, '43', 'Anti-rust paint, red', @CDBD, 74.58, 63.85, 0, dbo.getCategoryID('Paint'))
insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
values (30933, '154', 'Anti-rust paint, blue', @CDBD, 74.58, 63.85, 0, dbo.getCategoryID('Paint'))
insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
values (30921, 'ARTLAB', 'Artisan labour', @BITManf, 42.00, 42.00, 0	, dbo.getCategoryID('Labour'))
insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
values (30922, 'DESLAB', 'Designer labour', @BITManf, 54.00, 54.00, 0, dbo.getCategoryID('Labour'))
insert Component (ComponentID, ComponentName, ComponentDescription, SupplierID, ListPrice, TradePrice, TimeToFit, CategoryID)
values (30923, 'APPLAB', 'Apprentice labour', @BITManf, 23.50, 23.50, 0, dbo.getCategoryID('Labour'))

--create assemblies
exec createAssembly  'SmallCorner.15', '15mm small corner'
exec dbo.addSubComponent 'SmallCorner.15', 'BMS.5.15', 0.120
exec dbo.addSubComponent 'SmallCorner.15', 'APPLAB', 0.33333
exec dbo.addSubComponent 'SmallCorner.15', '43', 0.0833333

exec dbo.createAssembly 'SquareStrap.1000.15', '1000mm x 15mm square strap'
exec dbo.addSubComponent 'SquareStrap.1000.15', 'BMS.5.15', 4
exec dbo.addSubComponent 'SquareStrap.1000.15', 'SmallCorner.15', 4
exec dbo.addSubComponent 'SquareStrap.1000.15', 'APPLAB', 25
exec dbo.addSubComponent 'SquareStrap.1000.15', 'ARTLAB', 10
exec dbo.addSubComponent 'SquareStrap.1000.15', '43', 0.185
exec dbo.addSubComponent 'SquareStrap.1000.15', 'BMS10', 8

exec dbo.createAssembly 'CornerBrace.15', '15mm corner brace'
exec dbo.addSubComponent 'CornerBrace.15', 'BMS.5.15', 0.090
exec dbo.addSubComponent 'CornerBrace.15', 'BMS10', 2

/*
Select * FROM Component

Select * FROM AssemblySubcomponent
*/

/*
--drop functions, views and sp
IF OBJECT_ID('dbo.createAssembly', 'P') IS NOT NULL
    DROP PROCEDURE dbo.createAssembly;

IF OBJECT_ID('dbo.addSubComponent', 'P') IS NOT NULL
    DROP PROCEDURE dbo.addSubComponent;

IF OBJECT_ID('dbo.createCustomer', 'P') IS NOT NULL
    DROP PROCEDURE dbo.createCustomer;

IF OBJECT_ID('dbo.createQuote', 'P') IS NOT NULL
    DROP PROCEDURE dbo.createQuote;

IF OBJECT_ID('dbo.addQuoteComponent', 'P') IS NOT NULL
    DROP PROCEDURE dbo.addQuoteComponent;

-- Drop functions
IF OBJECT_ID('dbo.getCategoryID', 'FN') IS NOT NULL
    DROP FUNCTION dbo.getCategoryID;

IF OBJECT_ID('dbo.getAssemblySupplierID', 'FN') IS NOT NULL
    DROP FUNCTION dbo.getAssemblySupplierID;
IF OBJECT_ID('dbo.QuoteComponent', 'U') IS NOT NULL DROP TABLE dbo.QuoteComponent;
IF OBJECT_ID('dbo.AssemblySubcomponent', 'U') IS NOT NULL DROP TABLE dbo.AssemblySubcomponent;
IF OBJECT_ID('dbo.Quote', 'U') IS NOT NULL DROP TABLE dbo.Quote;
IF OBJECT_ID('dbo.Component', 'U') IS NOT NULL DROP TABLE dbo.Component;
IF OBJECT_ID('dbo.Customer', 'U') IS NOT NULL DROP TABLE dbo.Customer;
IF OBJECT_ID('dbo.Supplier', 'U') IS NOT NULL DROP TABLE dbo.Supplier;
IF OBJECT_ID('dbo.Contact', 'U') IS NOT NULL DROP TABLE dbo.Contact;
IF OBJECT_ID('dbo.Category', 'U') IS NOT NULL DROP TABLE dbo.Category;
*/

/* END  */



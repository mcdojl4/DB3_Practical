/* START */
/*
Create Database Design for Assignment
*/

CREATE TABLE Category (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL
);

CREATE TABLE Contact (
    ContactID INT IDENTITY(1,1) PRIMARY KEY,
    ContactName NVARCHAR(100) NOT NULL,
    ContactPhone VARCHAR(20) NOT NULL,
    ContactFax VARCHAR(20) NULL,
    ContactMobilePhone VARCHAR(20) NULL,
    ContactEmail VARCHAR(100) NULL,
    ContactWWW VARCHAR(100) NULL,
    ContactPostalAddress NVARCHAR(255) NOT NULL
);

CREATE TABLE Supplier (
    SupplierID INT PRIMARY KEY,
    SupplierGST VARCHAR(20) NOT NULL,
    CONSTRAINT FK_Supplier_Contact FOREIGN KEY (SupplierID)
        REFERENCES Contact(ContactID)
        ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    CONSTRAINT FK_Customer_Contact FOREIGN KEY (CustomerID)
        REFERENCES Contact(ContactID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Component (
    ComponentID INT PRIMARY KEY,
    ComponentName NVARCHAR(100) NOT NULL,
    ComponentDescription NVARCHAR(255) NOT NULL,
    TradePrice DECIMAL(10,2) NOT NULL CHECK (TradePrice >= 0),
    ListPrice DECIMAL(10,2) NOT NULL CHECK (ListPrice >= 0),
    TimeToFit DECIMAL(5,2) NOT NULL CHECK (TimeToFit >= 0),
    CategoryID INT NOT NULL,
    SupplierID INT NOT NULL,
    CONSTRAINT FK_Component_Category FOREIGN KEY (CategoryID)
        REFERENCES Category(CategoryID)
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    CONSTRAINT FK_Component_Supplier FOREIGN KEY (SupplierID)
        REFERENCES Supplier(SupplierID)
        ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE Quote (
    QuoteID INT IDENTITY(1,1) PRIMARY KEY,
    QuoteDescription NVARCHAR(255) NOT NULL,
    QuoteDate DATETIME DEFAULT GETDATE(),
    QuotePrice DECIMAL(10,2) NULL CHECK (QuotePrice IS NULL OR QuotePrice >= 0),
    QuoteCompiler NVARCHAR(100) NOT NULL,
    CustomerID INT NOT NULL,
    CONSTRAINT FK_Quote_Customer FOREIGN KEY (CustomerID)
        REFERENCES Customer(CustomerID)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE QuoteComponent (
    QuoteID INT NOT NULL,
    ComponentID INT NOT NULL,
    Quantity DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK (Quantity >= 0),
    TradePrice DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK (TradePrice >= 0),
    ListPrice DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK (ListPrice >= 0),
    TimeToFit DECIMAL(5,2) NOT NULL DEFAULT 0 CHECK (TimeToFit >= 0),
    PRIMARY KEY (QuoteID, ComponentID),
    CONSTRAINT FK_QuoteComponent_Quote FOREIGN KEY (QuoteID)
        REFERENCES Quote(QuoteID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT FK_QuoteComponent_Component FOREIGN KEY (ComponentID)
        REFERENCES Component(ComponentID)
        ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE AssemblySubcomponent (
    AssemblyID INT NOT NULL,
    SubcomponentID INT NOT NULL,
    Quantity DECIMAL(10,2) NOT NULL CHECK (Quantity >= 0),
    PRIMARY KEY (AssemblyID, SubcomponentID),
    CONSTRAINT FK_Assembly_Component FOREIGN KEY (AssemblyID)
        REFERENCES Component(ComponentID)
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    CONSTRAINT FK_Subcomponent_Component FOREIGN KEY (SubcomponentID)
        REFERENCES Component(ComponentID)
        ON UPDATE NO ACTION ON DELETE NO ACTION
);
/* END */
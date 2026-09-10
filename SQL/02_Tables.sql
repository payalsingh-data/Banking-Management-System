USE BankingSystem;
GO

-- STEP 2: Branches
CREATE TABLE Branches
(
    BranchID INT IDENTITY(1,1) PRIMARY KEY,
    BranchName VARCHAR(100) NOT NULL,
    City VARCHAR(50) NOT NULL,
    State VARCHAR(50) NOT NULL,
    IFSCCode VARCHAR(20) UNIQUE NOT NULL,
    ContactNumber VARCHAR(15),
    CreatedDate DATE DEFAULT GETDATE()
);
GO

-- STEP 4: Customers
CREATE TABLE Customers
(
    CustomerID INT IDENTITY(1001,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50),
    DateOfBirth DATE,
    Gender VARCHAR(10),
    Phone VARCHAR(15) UNIQUE,
    Email VARCHAR(100) UNIQUE,
    Address VARCHAR(250),
    City VARCHAR(50),
    State VARCHAR(50),
    PANNumber VARCHAR(10) UNIQUE,
    AadhaarNumber VARCHAR(12) UNIQUE,
    CreatedDate DATETIME DEFAULT GETDATE()
);
GO

-- STEP 6: Employees
CREATE TABLE Employees
(
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    BranchID INT NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50),
    JobTitle VARCHAR(50),
    Phone VARCHAR(15),
    Email VARCHAR(100) UNIQUE,
    Salary DECIMAL(12,2),
    JoiningDate DATE,
    CONSTRAINT FK_Employees_Branches
        FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
);
GO

-- STEP 8: Accounts
CREATE TABLE Accounts
(
    AccountID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    BranchID INT NOT NULL,
    AccountNumber VARCHAR(20) UNIQUE NOT NULL,
    AccountType VARCHAR(20) NOT NULL,
    Balance DECIMAL(15,2) DEFAULT 0,
    OpenDate DATE DEFAULT GETDATE(),
    Status VARCHAR(20) DEFAULT 'Active',
    CONSTRAINT FK_Accounts_Customers
        FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT FK_Accounts_Branches
        FOREIGN KEY (BranchID) REFERENCES Branches(BranchID),
    CONSTRAINT CK_Accounts_Balance CHECK (Balance >= 0),
    CONSTRAINT CK_Accounts_Type
        CHECK (AccountType IN ('Savings', 'Current', 'Salary'))
);
GO

-- STEP 10: Transactions
CREATE TABLE Transactions
(
    TransactionID BIGINT IDENTITY(1,1) PRIMARY KEY,
    AccountID INT NOT NULL,
    TransactionType VARCHAR(20) NOT NULL,
    Amount DECIMAL(15,2) NOT NULL,
    TransactionDate DATETIME DEFAULT GETDATE(),
    Description VARCHAR(250),
    ReferenceNumber VARCHAR(50) UNIQUE,
    CONSTRAINT FK_Transactions_Accounts
        FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID),
    CONSTRAINT CK_Transactions_Amount CHECK (Amount > 0),
    CONSTRAINT CK_Transactions_Type
        CHECK (TransactionType IN
            ('Deposit', 'Withdrawal', 'Transfer In', 'Transfer Out'))
);
GO

-- STEP 12: Loans
CREATE TABLE Loans
(
    LoanID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    BranchID INT NOT NULL,
    LoanType VARCHAR(30) NOT NULL,
    LoanAmount DECIMAL(15,2) NOT NULL,
    InterestRate DECIMAL(5,2) NOT NULL,
    TenureMonths INT NOT NULL,
    StartDate DATE,
    LoanStatus VARCHAR(20) DEFAULT 'Active',
    CONSTRAINT FK_Loans_Customers
        FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT FK_Loans_Branches
        FOREIGN KEY (BranchID) REFERENCES Branches(BranchID),
    CONSTRAINT CK_Loans_Amount CHECK (LoanAmount > 0),
    CONSTRAINT CK_Loans_Interest CHECK (InterestRate >= 0),
    CONSTRAINT CK_Loans_Tenure CHECK (TenureMonths > 0)
);
GO

-- STEP 14: LoanPayments
CREATE TABLE LoanPayments
(
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    LoanID INT NOT NULL,
    PaymentDate DATE DEFAULT GETDATE(),
    PaymentAmount DECIMAL(15,2) NOT NULL,
    PaymentMethod VARCHAR(30),
    ReferenceNumber VARCHAR(50) UNIQUE,
    CONSTRAINT FK_LoanPayments_Loans
        FOREIGN KEY (LoanID) REFERENCES Loans(LoanID),
    CONSTRAINT CK_LoanPayments_Amount CHECK (PaymentAmount > 0)
);
GO

-- STEP 16: Beneficiaries
CREATE TABLE Beneficiaries
(
    BeneficiaryID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    BeneficiaryName VARCHAR(100) NOT NULL,
    BeneficiaryAccountNumber VARCHAR(20) NOT NULL,
    BankName VARCHAR(100),
    IFSCCode VARCHAR(20),
    AddedDate DATE DEFAULT GETDATE(),
    Status VARCHAR(20) DEFAULT 'Active',
    CONSTRAINT FK_Beneficiaries_Customers
        FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT CK_Beneficiaries_Status
        CHECK (Status IN ('Active', 'Inactive'))
);
GO

-- STEP 53: Transaction audit table
CREATE TABLE TransactionAudit
(
    AuditID BIGINT IDENTITY(1,1) PRIMARY KEY,
    TransactionID BIGINT NOT NULL,
    AccountID INT NOT NULL,
    TransactionType VARCHAR(20),
    Amount DECIMAL(15,2),
    AuditDate DATETIME DEFAULT GETDATE(),
    AuditAction VARCHAR(50)
);
GO

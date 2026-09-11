CREATE DATABASE BankingSystem
GO

USE BankingSystem
GO

SELECT DB_NAME() AS CurrentDatabase



CREATE TABLE Branches
(
    BranchID INT IDENTITY(1, 1) PRIMARY KEY,
	BranchName VARCHAR(100) NOT NULL,
	City VARCHAR(50) NOT NULL,
	State VARCHAR(50) NOT NULL,
	IFSCCode VARCHAR(20) UNIQUE NOT NULL,
	ContactNumber VARCHAR(15),
	CurrentDate DATE DEFAULT GETDATE()
)


select * from Branches

--- Isse tumhe columns, data types, constraints etc. dikh jayenge. ---
EXEC sp_help 'Branches'


INSERT INTO Branches
(
   BranchName,
   City,
   State,
   IFSCCode,
   ContactNumber
)
VALUES
('Canought Place Branch', 'Delhi', 'Delhi', 'BANK0001001', '9876543210'),
('Sector 18 Branch', 'Noida', 'Uttar Pradesh', 'BANK0001002', '9876543211'),
('Cyber City Branch', 'Gurugram', 'Haryana', 'BANK0001003', '9876543212'),
('South Extension Branch', 'Delhi', 'Delhi', 'BANK0001004', '9876543213'),
('Indirapuram Branch', 'Ghaziabad', 'Uttar Pradesh', 'BANK0001005','9876543214')    

SELECT * from Branches

select * from Branches where city = 'Delhi'

select * from Branches order by city asc



CREATE TABLE Customers
(
    CustomerID INT IDENTITY(1001,1) PRIMARY KEY,
	FirstName VARCHAR(50) NOT NUll,
	LastName VARCHAR(50),
	DateOfBirth DATE,
	Gender VARCHAR(10),
	Phone VARCHAR(15),
	Email VARCHAR(100),
	Address VARCHAR(250),
	City VARCHAR(50),
	State VARCHAR(50),
	PANNumber VARCHAR(50) UNIQUE,
	AadhaarNumber VARCHAR(12) UNIQUE,
	CreateDate DATETIME DEFAULT GETDATE()
)

select * from Customers

EXEC sp_help 'Customers'

INSERT INTO Customers
(
    FirstName,
    LastName,
    DateOfBirth,
    Gender,
    Phone,
    Email,
    Address,
    City,
    State,
    PANNumber,
    AadhaarNumber
)
VALUES
('Rahul', 'Sharma', '1998-05-12', 'Male',
 '9000000001', 'rahul@gmail.com',
 'Rohini', 'Delhi', 'Delhi',
 'ABCDE1234F', '111122223333'),

('Priya', 'Verma', '1997-08-20', 'Female',
 '9000000002', 'priya@gmail.com',
 'Sector 62', 'Noida', 'Uttar Pradesh',
 'BCDEF2345G', '222233334444'),

('Amit', 'Kumar', '1995-03-15', 'Male',
 '9000000003', 'amit@gmail.com',
 'Dwarka', 'Delhi', 'Delhi',
 'CDEFG3456H', '333344445555'),

('Neha', 'Singh', '1999-11-10', 'Female',
 '9000000004', 'neha@gmail.com',
 'Gurugram', 'Haryana', 'Haryana',
 'DEFGH4567I', '444455556666'),

('Rohit', 'Mehta', '1996-01-25', 'Male',
 '9000000005', 'rohit@gmail.com',
 'Noida Extension', 'Noida', 'Uttar Pradesh',
 'EFGHI5678J', '555566667777')

 select * from Customers

 CREATE TABLE Employees
(
   EmployeeID INT IDENTITY(1, 1) PRIMARY KEY,
   BranchID INT NOT NULL,
   FirstName VARCHAR(50) NOT NULL,
   LastName VARCHAR(50),
   JobTitle VARCHAR(50),
   Phone VARCHAR(15),
   Email VARCHAR(100) UNIQUE,
   Salary DECIMAL(12,2),
   JoiningDate DATE,

    CONSTRAINT FK_Employees_Branches
        FOREIGN KEY (BranchID)
        REFERENCES Branches(BranchID)
)

select * from Employees

EXEC sp_help 'Employees';

INSERT INTO Employees
(
   BranchID,
   FirstName,
   LastName,
   JobTitle,
   Phone,
   Email,
   Salary,
   JoiningDate
)
VALUES
(1, 'Ankit', 'Sharma', 'Branch Manager',
'9100000001', 'ankit@bank.com', 65000, '2023-04-10'),

(1, 'Pooja', 'Verma', 'Bank Officer',
 '9100000002', 'pooja@bank.com', 45000, '2024-01-15'),

(2, 'Ravi', 'Kumar', 'Branch Manager',
 '9100000003', 'ravi@bank.com', 68000, '2022-07-20'),

(2, 'Simran', 'Kaur', 'Cashier',
 '9100000004', 'simran@bank.com', 35000, '2024-03-12'),

(3, 'Vikas', 'Mehta', 'Bank Officer',
 '9100000005', 'vikas@bank.com', 47000, '2023-11-05')

 select * from Employees

CREATE TABLE Accounts
(
    AccountID INT IDENTITY(1,1) PRIMARY KEY,

	CustomerID INT NOT NULL,
	BranchID INT NOT NULL,

	AccountNumber VARCHAR(20) UNIQUE NOT NULL,
	AccountType VARCHAR(20) NOT NULL,

	Balance DECIMAL(15, 2) DEFAULT 0,

	OpenDate DATE DEFAULt GETDATE(),

	Status VARCHAR(20) DEFAULT 'Active',

	CONSTRAINT FK_Accounts_Customers
	    FOREIGN KEY (CustomerID)
		REFERENCES Customers(CustomerID),

	CONSTRAINT FK_Accounts_Branches
	    FOREIGN KEY (BranchID)
		REFERENCES Branches(BranchID),

	CONSTRAINT CK_Accounts_Balance
	    CHECK (Balance >= 0),

	CONSTRAINT CK_Accounts_Type
	    CHECk (AccountType IN ('Savings', 'Current', 'Salary'))
)

SELECT * FROM Accounts

EXEC sp_help 'Accounts';

INSERT INTO Accounts
(
    CustomerID,
	BranchID,
	AccountNumber,
	AccountType,
	Balance,
	Status
)
VALUES
(1001, 1, '1000000001', 'Savings', 50000, 'Active'),

(1002, 2, '1000000002', 'Savings', 75000, 'Active'),

(1003, 1, '1000000003', 'Current', 120000, 'Active'),

(1004, 3, '1000000004', 'Salary', 65000, 'Active'),

(1005, 2, '1000000005', 'Savings', 30000, 'Active') 

select * from Accounts


CREATE TABLE Transactions
(
    TransactionID BIGINT IDENTITY(1, 1) PRIMARY KEY,
	AccountID INT NOT NULL,
	TransactionType VARCHAR(20) NOT NULL,
	Amount DECIMAL(15,2) NOT NULL,
	TransactionDate DATETIME DEFAULT GETDATE(),
	Description VARCHAR(250),
	ReferenceNumber VARCHAR(50) UNIQUE,

	CONSTRAINT FK_Transaction_Accounts
	    FOREIGN KEY (AccountID)
		REFERENCES Accounts(AccountID),

	CONSTRAINT CK_Transactions_Amount
	    CHECK (Amount > 0),

	CONSTRAINT CK_Transactions_Type
	    CHECK
		(
		      TransactionType IN
			  ('Deposit', 'Withdrawal', 'Transfer In', 'Transfer Out')
          )
	)

select * from Transactions

EXEC sp_help 'Transactions'

INSERT INTO Transactions
(
    AccountID,
	TransactionType,
	Amount,
	Description,
	ReferenceNumber
)
VALUES
(1, 'Deposit', 10000, 'Cash Deposit', 'TXN10001'),
(1, 'Withdrawal', 5000, 'ATM Withdrawal', 'TXN10002'),
(2, 'Deposit', 20000, 'Salary Credit', 'TXN10003'),
(3, 'Withdrawal', 15000, 'Business Expense', 'TXN10004'),
(4, 'Deposit', 25000, 'Salary Credit', 'TXN10005'),
(5, 'Withdrawal', 3000, 'ATM Withdrawal', 'TXN10006')

select * from Transactions

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

   CONSTRAINT FK_Loan_Customers
       FOREIGN KEY (CustomerID)
	   REFERENCES Customers(CustomerID),

   CONSTRAINT FK_Loans_Branches
       FOREIGN KEY (BranchID)
	   REFERENCES Branches(BranchID),

	CONSTRAINT CK_Loans_Amount
	    CHECK (LoanAmount > 0),

	 CONSTRAINT CK_Loans_Interest
        CHECK (InterestRate >= 0),

    CONSTRAINT CK_Loans_Tenure
        CHECK (TenureMonths > 0)
)

select * from Loans

EXEC sp_help 'Loans'

INSERT INTO Loans
(
    CustomerID,
    BranchID,
    LoanType,
    LoanAmount,
    InterestRate,
    TenureMonths,
    StartDate,
    LoanStatus
)
VALUES
(1001, 1, 'Home Loan', 2500000, 8.50, 240, '2025-01-15', 'Active'),
(1002, 2, 'Personal Loan', 500000, 11.50, 60, '2025-03-10', 'Active'),
(1003, 1, 'Business Loan', 1500000, 10.25, 120, '2024-08-20', 'Active'),
(1004, 3, 'Education Loan', 800000, 7.50, 84, '2025-06-01', 'Active'),
(1005, 2, 'Personal Loan', 300000, 12.00, 36, '2025-02-25', 'Active')

select * from Loans


Create Table LoanPayments
(
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
	LoanID INT NOT NULL,
	PaymentDate DATE DEFAULT GETDATE(),
	PaymentAmount DECIMAL(15,2) NOT NULL,
	PaymentMethod VARCHAR(30),
	ReferenceNumber VARCHAR(50) UNIQUE,

	CONSTRAINT FK_LoanPayments_Loans
	   FOREIGN KEY (LoanID)
	   REFERENCES Loans(LoanID),

	CONSTRAINT CK_LoanPayments_Amount
	     CHECK (PaymentAmount > 0)
)

select * from LoanPayments

INSERT INTO LoanPayments
(
    LoanID,
    PaymentDate,
    PaymentAmount,
    PaymentMethod,
    ReferenceNumber
)
VALUES
(1, '2025-02-15', 25000, 'NEFT', 'LP10001'),
(1, '2025-03-15', 25000, 'UPI', 'LP10002'),
(2, '2025-04-10', 12000, 'NEFT', 'LP10003'),
(3, '2025-04-20', 30000, 'Cheque', 'LP10004'),
(4, '2025-07-01', 15000, 'UPI', 'LP10005'),
(5, '2025-03-25', 10000, 'NEFT', 'LP10006')

select * from LoanPayments

SELECT
    lp.PaymentID,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    l.LoanType,
    l.LoanAmount,
    lp.PaymentAmount,
    lp.PaymentDate,
    lp.PaymentMethod,
    lp.ReferenceNumber
FROM LoanPayments lp
INNER JOIN Loans l
    ON lp.LoanID = l.LoanID
INNER JOIN Customers c
    ON l.CustomerID = c.CustomerID
ORDER BY lp.PaymentDate

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
        FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID),

    CONSTRAINT CK_Beneficiaries_Status
        CHECK (Status IN ('Active', 'Inactive'))
)

INSERT INTO Beneficiaries
(
    CustomerID,
    BeneficiaryName,
    BeneficiaryAccountNumber,
    BankName,
    IFSCCode,
    AddedDate,
    Status
)
VALUES
(1001, 'Priya Verma', '1000000002', 'Banking System Bank', 'BANK0001002', '2025-01-20', 'Active'),
(1001, 'Amit Kumar', '1000000003', 'Banking System Bank', 'BANK0001001', '2025-01-22', 'Active'),
(1002, 'Rahul Sharma', '1000000001', 'Banking System Bank', 'BANK0001001', '2025-02-15', 'Active'),
(1003, 'Neha Singh', '1000000004', 'Banking System Bank', 'BANK0001003', '2025-03-10', 'Active'),
(1005, 'Rahul Sharma', '1000000001', 'Banking System Bank', 'BANK0001001', '2025-04-05', 'Inactive')

select * from Beneficiaries

SELECT
    c.CustomerID,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    b.BeneficiaryName,
    b.BeneficiaryAccountNumber,
    b.BankName,
    b.IFSCCode,
    b.Status
FROM Customers c
INNER JOIN Beneficiaries b
    ON c.CustomerID = b.CustomerID


SELECT
    c.CustomerID,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    a.AccountNumber,
    a.AccountType,
    a.Balance,
    a.Status
FROM Customers c
INNER JOIN Accounts a
    ON c.CustomerID = a.CustomerID
ORDER BY a.Balance DESC

--- Branch-wise Account Analysis ---
SELECT
    b.BranchID,
    b.BranchName,
    b.City,
    COUNT(a.AccountID) AS TotalAccounts
FROM Branches b
LEFT JOIN Accounts a
    ON b.BranchID = a.BranchID
GROUP BY
    b.BranchID,
    b.BranchName,
    b.City
ORDER BY TotalAccounts DESC

--- Total Bank Balance ---
SELECT
    SUM(Balance) AS TotalBankBalance
FROM Accounts
WHERE Status = 'Active'

--- Find the Account with Highest Balance ---
select TOP 1
    AccountNumber,
	AccountType,
	Balance
from Accounts
order by Balance desc

--- Customer Transaction History ---
SELECT
    c.CustomerID,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    a.AccountNumber,
    a.AccountType,
    t.TransactionType,
    t.Amount,
    t.TransactionDate,
    t.Description
FROM Customers c
INNER JOIN Accounts a
    ON c.CustomerID = a.CustomerID
INNER JOIN Transactions t
    ON a.AccountID = t.AccountID
ORDER BY t.TransactionDate DESC

---  Deposits vs Withdrawals Analysis ---
SELECT
    TransactionType,
    COUNT(*) AS NumberOfTransactions,
    SUM(Amount) AS TotalAmount
FROM Transactions
GROUP BY TransactionType
ORDER BY TotalAmount DESC

--- Branch-wise Total Account Balance ---
SELECT
    b.BranchID,
    b.BranchName,
    b.City,
    COUNT(a.AccountID) AS TotalAccounts,
    COALESCE(SUM(a.Balance), 0) AS TotalBalance
FROM Branches b
LEFT JOIN Accounts a
    ON b.BranchID = a.BranchID
GROUP BY
    b.BranchID,
    b.BranchName,
    b.City
ORDER BY TotalBalance DESC

--- Customer-wise Total Transaction Amount ---
SELECT
    c.CustomerID,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    COUNT(t.TransactionID) AS TotalTransactions,
    COALESCE(SUM(t.Amount), 0) AS TotalTransactionAmount
FROM Customers c
LEFT JOIN Accounts a
    ON c.CustomerID = a.CustomerID
LEFT JOIN Transactions t
    ON a.AccountID = t.AccountID
GROUP BY
    c.CustomerID,
    c.FirstName,
    c.LastName
ORDER BY TotalTransactionAmount DESC

--- Find Customers With No Transactions ---
SELECT
    c.CustomerID,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    a.AccountNumber,
    a.AccountType,
    a.Balance
FROM Customers c
INNER JOIN Accounts a
    ON c.CustomerID = a.CustomerID
LEFT JOIN Transactions t
    ON a.AccountID = t.AccountID
WHERE t.TransactionID IS NULL

--- Customer-wise Loan Summary ---
SELECT
    c.CustomerID,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    COUNT(l.LoanID) AS TotalLoans,
    SUM(l.LoanAmount) AS TotalLoanAmount,
    AVG(l.InterestRate) AS AverageInterestRate
FROM Customers c
LEFT JOIN Loans l
    ON c.CustomerID = l.CustomerID
GROUP BY
    c.CustomerID,
    c.FirstName,
    c.LastName
ORDER BY TotalLoanAmount DESC

--- Loan Payment Analysis ---
SELECT
    c.CustomerID,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    l.LoanID,
    l.LoanType,
    l.LoanAmount,
    COUNT(lp.PaymentID) AS TotalPayments,
    COALESCE(SUM(lp.PaymentAmount), 0) AS TotalPaid,
    l.LoanAmount - COALESCE(SUM(lp.PaymentAmount), 0) AS RemainingAmount
FROM Customers c
INNER JOIN Loans l
    ON c.CustomerID = l.CustomerID
LEFT JOIN LoanPayments lp
    ON l.LoanID = lp.LoanID
GROUP BY
    c.CustomerID,
    c.FirstName,
    c.LastName,
    l.LoanID,
    l.LoanType,
    l.LoanAmount
ORDER BY RemainingAmount DESC

--- Top 3 Customers by Account Balance ---
WITH CustomerBalances AS
(
    SELECT
        c.CustomerID,
        c.FirstName + ' ' + c.LastName AS CustomerName,
        a.AccountNumber,
        a.Balance
    FROM Customers c
    INNER JOIN Accounts a
        ON c.CustomerID = a.CustomerID
)
SELECT TOP 3
    CustomerID,
    CustomerName,
    AccountNumber,
    Balance
FROM CustomerBalances
ORDER BY Balance DESC

--- Rank Customers by Account Balance ---
SELECT
    c.CustomerID,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    a.AccountNumber,
    a.Balance,

    RANK() OVER (
        ORDER BY a.Balance DESC
    ) AS BalanceRank

FROM Customers c
INNER JOIN Accounts a
    ON c.CustomerID = a.CustomerID

--- Top 3 customers based on balance ---
SELECT
    c.CustomerID,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    a.AccountNumber,
    a.Balance,

    ROW_NUMBER() OVER (
        ORDER BY a.Balance DESC
    ) AS RowNumber,

    RANK() OVER (
        ORDER BY a.Balance DESC
    ) AS BalanceRank

FROM Customers c
INNER JOIN Accounts a
    ON c.CustomerID = a.CustomerID

--- Running Transaction Total ---
SELECT
    t.TransactionID,
    a.AccountNumber,
    t.TransactionType,
    t.Amount,
    t.TransactionDate,

    SUM(t.Amount) OVER
    (
        PARTITION BY t.AccountID
        ORDER BY t.TransactionDate, t.TransactionID
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS RunningTotal

FROM Transactions t
INNER JOIN Accounts a
    ON t.AccountID = a.AccountID

ORDER BY
    a.AccountNumber,
    t.TransactionDate,
    t.TransactionID

--- Monthly Transaction Analysis ---
SELECT
    YEAR(TransactionDate) AS TransactionYear,
    MONTH(TransactionDate) AS TransactionMonth,
    COUNT(*) AS TotalTransactions,
    SUM(Amount) AS TotalTransactionAmount
FROM Transactions
GROUP BY
    YEAR(TransactionDate),
    MONTH(TransactionDate)
ORDER BY
    TransactionYear,
    TransactionMonth

--- Branches with High Total Balance ---
SELECT
    b.BranchID,
    b.BranchName,
    b.City,
    COUNT(a.AccountID) AS TotalAccounts,
    SUM(a.Balance) AS TotalBalance
FROM Branches b
INNER JOIN Accounts a
    ON b.BranchID = a.BranchID
GROUP BY
    b.BranchID,
    b.BranchName,
    b.City
HAVING
    SUM(a.Balance) > 50000
ORDER BY
    TotalBalance DESC

--- Customers Above Average Balance ---
SELECT
    c.CustomerID,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    a.AccountNumber,
    a.Balance
FROM Customers c
INNER JOIN Accounts a
    ON c.CustomerID = a.CustomerID
WHERE a.Balance >
(
    SELECT AVG(Balance)
    FROM Accounts
)

--- Customers with the Highest Account Balance ---
SELECT
    c.CustomerID,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    a.AccountNumber,
    a.AccountType,
    a.Balance
FROM Customers c
INNER JOIN Accounts a
    ON c.CustomerID = a.CustomerID
WHERE a.Balance =
(
    SELECT MAX(Balance)
    FROM Accounts
)

--- Customer Balance Category ---
SELECT
    c.CustomerID,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    a.AccountNumber,
    a.Balance,

    CASE
        WHEN a.Balance >= 100000 THEN 'High Balance'
        WHEN a.Balance >= 50000 THEN 'Medium Balance'
        ELSE 'Low Balance'
    END AS BalanceCategory

FROM Customers c
INNER JOIN Accounts a
    ON c.CustomerID = a.CustomerID

ORDER BY a.Balance DESC

--- Customers With No Loan ---
SELECT
    c.CustomerID,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    COUNT(l.LoanID) AS TotalLoans,
    COALESCE(SUM(l.LoanAmount), 0) AS TotalLoanAmount
FROM Customers c
LEFT JOIN Loans l
    ON c.CustomerID = l.CustomerID
GROUP BY
    c.CustomerID,
    c.FirstName,
    c.LastName
HAVING
    COUNT(l.LoanID) = 0

--- Customers Who Have Loans Using EXISTS ---
SELECT
    c.CustomerID,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    c.City,
    c.State
FROM Customers c
WHERE EXISTS
(
    SELECT 1
    FROM Loans l
    WHERE l.CustomerID = c.CustomerID
)

--- Customers With More Than One Loan ---
SELECT
    c.CustomerID,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    COUNT(l.LoanID) AS TotalLoans,
    SUM(l.LoanAmount) AS TotalLoanAmount
FROM Customers c
INNER JOIN Loans l
    ON c.CustomerID = l.CustomerID
GROUP BY
    c.CustomerID,
    c.FirstName,
    c.LastName
HAVING
    COUNT(l.LoanID) > 1

--- Customers With High Loan Exposure ---
WITH CustomerLoanSummary AS
(
    SELECT
        c.CustomerID,
        c.FirstName + ' ' + c.LastName AS CustomerName,
        COUNT(l.LoanID) AS TotalLoans,
        SUM(l.LoanAmount) AS TotalLoanAmount
    FROM Customers c
    INNER JOIN Loans l
        ON c.CustomerID = l.CustomerID
    GROUP BY
        c.CustomerID,
        c.FirstName,
        c.LastName
)

SELECT
    CustomerID,
    CustomerName,
    TotalLoans,
    TotalLoanAmount
FROM CustomerLoanSummary
WHERE TotalLoanAmount > 1000000
ORDER BY TotalLoanAmount DESC

--- Latest Transaction of Each Account ---
WITH RankedTransactions AS
(
    SELECT
        t.TransactionID,
        t.AccountID,
        a.AccountNumber,
        t.TransactionType,
        t.Amount,
        t.TransactionDate,
        t.Description,

        ROW_NUMBER() OVER
        (
            PARTITION BY t.AccountID
            ORDER BY t.TransactionDate DESC, t.TransactionID DESC
        ) AS RowNum

    FROM Transactions t
    INNER JOIN Accounts a
        ON t.AccountID = a.AccountID
)

SELECT
    TransactionID,
    AccountID,
    AccountNumber,
    TransactionType,
    Amount,
    TransactionDate,
    Description
FROM RankedTransactions
WHERE RowNum = 1
ORDER BY AccountNumber

--- True Calculated Balance from Transactions ---
SELECT
    t.TransactionID,
    a.AccountNumber,
    t.TransactionType,
    t.Amount,
    t.TransactionDate,

    SUM(
        CASE
            WHEN t.TransactionType IN ('Deposit', 'Transfer In')
                THEN t.Amount

            WHEN t.TransactionType IN ('Withdrawal', 'Transfer Out')
                THEN -t.Amount

            ELSE 0
        END
    ) OVER
    (
        PARTITION BY t.AccountID
        ORDER BY t.TransactionDate, t.TransactionID
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS CalculatedBalance

FROM Transactions t

INNER JOIN Accounts a
    ON t.AccountID = a.AccountID

ORDER BY
    a.AccountNumber,
    t.TransactionDate,
    t.TransactionID

--- Customer 360° Banking Report ---
SELECT
    c.CustomerID,
    c.FirstName + ' ' + c.LastName AS CustomerName,

    a.AccountNumber,
    a.AccountType,
    a.Balance,

    COUNT(DISTINCT t.TransactionID) AS TotalTransactions,
    COALESCE(SUM(DISTINCT t.Amount), 0) AS TotalTransactionAmount,

    COUNT(DISTINCT l.LoanID) AS TotalLoans,
    COALESCE(SUM(DISTINCT l.LoanAmount), 0) AS TotalLoanAmount,

    COALESCE(SUM(lp.PaymentAmount), 0) AS TotalLoanPayments

FROM Customers c

LEFT JOIN Accounts a
    ON c.CustomerID = a.CustomerID

LEFT JOIN Transactions t
    ON a.AccountID = t.AccountID

LEFT JOIN Loans l
    ON c.CustomerID = l.CustomerID

LEFT JOIN LoanPayments lp
    ON l.LoanID = lp.LoanID

GROUP BY
    c.CustomerID,
    c.FirstName,
    c.LastName,
    a.AccountNumber,
    a.AccountType,
    a.Balance

ORDER BY
    a.Balance DESC

--- Deposit Money Stored Procedure ---
CREATE PROCEDURE DepositMoney
    @AccountID INT,
    @Amount DECIMAL(15,2),
    @Description VARCHAR(250)
AS
BEGIN

    SET NOCOUNT ON;

    BEGIN TRY

        BEGIN TRANSACTION;

        -- Check account exists and is active
        IF NOT EXISTS
        (
            SELECT 1
            FROM Accounts
            WHERE AccountID = @AccountID
              AND Status = 'Active'
        )
        BEGIN
            THROW 50001, 'Account does not exist or is inactive.', 1;
        END;

        -- Check deposit amount
        IF @Amount <= 0
        BEGIN
            THROW 50002, 'Deposit amount must be greater than zero.', 1;
        END;

        -- Update account balance
        UPDATE Accounts
        SET Balance = Balance + @Amount
        WHERE AccountID = @AccountID;

        -- Insert transaction record
        INSERT INTO Transactions
        (
            AccountID,
            TransactionType,
            Amount,
            Description,
            ReferenceNumber
        )
        VALUES
        (
            @AccountID,
            'Deposit',
            @Amount,
            @Description,
            'DEP' + CAST(ABS(CHECKSUM(NEWID())) AS VARCHAR(20))
        );

        COMMIT TRANSACTION;

        PRINT 'Deposit successful.';

    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH;

END

--- Execute procedure 
EXEC DepositMoney
    @AccountID = 1,
    @Amount = 10000,
    @Description = 'Cash Deposit'

--- Check balance ---
SELECT
    AccountID,
    AccountNumber,
    Balance
FROM Accounts
WHERE AccountID = 1


SELECT TOP 1 *
FROM Transactions
WHERE AccountID = 1
ORDER BY TransactionID DESC

--- Withdrawal Money Stored Procedure ---
CREATE PROCEDURE WithdrawMoney
    @AccountID INT,
    @Amount DECIMAL(15,2),
    @Description VARCHAR(250)
AS
BEGIN

    SET NOCOUNT ON;

    BEGIN TRY

        BEGIN TRANSACTION;

        -- Check account exists and is active
        IF NOT EXISTS
        (
            SELECT 1
            FROM Accounts
            WHERE AccountID = @AccountID
              AND Status = 'Active'
        )
        BEGIN
            THROW 50003, 'Account does not exist or is inactive.', 1;
        END;

        -- Check withdrawal amount
        IF @Amount <= 0
        BEGIN
            THROW 50004, 'Withdrawal amount must be greater than zero.', 1;
        END;

        -- Check sufficient balance
        IF NOT EXISTS
        (
            SELECT 1
            FROM Accounts
            WHERE AccountID = @AccountID
              AND Balance >= @Amount
        )
        BEGIN
            THROW 50005, 'Insufficient balance.', 1;
        END;

        -- Deduct amount from account
        UPDATE Accounts
        SET Balance = Balance - @Amount
        WHERE AccountID = @AccountID;

        -- Insert transaction record
        INSERT INTO Transactions
        (
            AccountID,
            TransactionType,
            Amount,
            Description,
            ReferenceNumber
        )
        VALUES
        (
            @AccountID,
            'Withdrawal',
            @Amount,
            @Description,
            'WDR' + CAST(ABS(CHECKSUM(NEWID())) AS VARCHAR(20))
        );

        COMMIT TRANSACTION;

        PRINT 'Withdrawal successful.';

    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH;

END

--- Test procedure ---
EXEC WithdrawMoney
    @AccountID = 1,
    @Amount = 5000,
    @Description = 'ATM Withdrawal'

--- Verify balance ---
SELECT
    AccountID,
    AccountNumber,
    Balance
FROM Accounts
WHERE AccountID = 1


SELECT TOP 1
    TransactionID,
    AccountID,
    TransactionType,
    Amount,
    Description,
    TransactionDate
FROM Transactions
WHERE AccountID = 1
ORDER BY TransactionID DESC


--- Test Insufficient Balance ---
EXEC WithdrawMoney
    @AccountID = 1,
    @Amount = 100000,
    @Description = 'Large ATM Withdrawal'

--- Verify Balance ---
SELECT
    AccountID,
    AccountNumber,
    Balance
FROM Accounts
WHERE AccountID = 1


SELECT TOP 5
    TransactionID,
    AccountID,
    TransactionType,
    Amount,
    Description
FROM Transactions
WHERE AccountID = 1
ORDER BY TransactionID DESC


--- Money Transfer Between Two Accounts ---
CREATE PROCEDURE TransferMoney
    @FromAccountID INT,
    @ToAccountID INT,
    @Amount DECIMAL(15,2)
AS
BEGIN

    SET NOCOUNT ON;

    BEGIN TRY

        BEGIN TRANSACTION;

        -- Check that accounts are different
        IF @FromAccountID = @ToAccountID
        BEGIN
            THROW 50006, 'Source and destination accounts must be different.', 1;
        END;

        -- Check transfer amount
        IF @Amount <= 0
        BEGIN
            THROW 50007, 'Transfer amount must be greater than zero.', 1;
        END;

        -- Check source account
        IF NOT EXISTS
        (
            SELECT 1
            FROM Accounts
            WHERE AccountID = @FromAccountID
              AND Status = 'Active'
        )
        BEGIN
            THROW 50008, 'Source account does not exist or is inactive.', 1;
        END;

        -- Check destination account
        IF NOT EXISTS
        (
            SELECT 1
            FROM Accounts
            WHERE AccountID = @ToAccountID
              AND Status = 'Active'
        )
        BEGIN
            THROW 50009, 'Destination account does not exist or is inactive.', 1;
        END;

        -- Check sufficient balance
        IF NOT EXISTS
        (
            SELECT 1
            FROM Accounts
            WHERE AccountID = @FromAccountID
              AND Balance >= @Amount
        )
        BEGIN
            THROW 50010, 'Insufficient balance in source account.', 1;
        END;

        -- Debit source account
        UPDATE Accounts
        SET Balance = Balance - @Amount
        WHERE AccountID = @FromAccountID;

        -- Credit destination account
        UPDATE Accounts
        SET Balance = Balance + @Amount
        WHERE AccountID = @ToAccountID;

        -- Record Transfer Out
        INSERT INTO Transactions
        (
            AccountID,
            TransactionType,
            Amount,
            Description,
            ReferenceNumber
        )
        VALUES
        (
            @FromAccountID,
            'Transfer Out',
            @Amount,
            'Money transferred to Account ' + CAST(@ToAccountID AS VARCHAR(20)),
            'TRFOUT' + CAST(ABS(CHECKSUM(NEWID())) AS VARCHAR(20))
        );

        -- Record Transfer In
        INSERT INTO Transactions
        (
            AccountID,
            TransactionType,
            Amount,
            Description,
            ReferenceNumber
        )
        VALUES
        (
            @ToAccountID,
            'Transfer In',
            @Amount,
            'Money received from Account ' + CAST(@FromAccountID AS VARCHAR(20)),
            'TRFIN' + CAST(ABS(CHECKSUM(NEWID())) AS VARCHAR(20))
        );

        COMMIT TRANSACTION;

        PRINT 'Transfer successful.';

    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;

    END CATCH;

END

--- Test the Transfer ---
EXEC TransferMoney
    @FromAccountID = 1,
    @ToAccountID = 2,
    @Amount = 10000

--- Verify both balances ---
SELECT
    AccountID,
    AccountNumber,
    Balance
FROM Accounts
WHERE AccountID IN (1, 2)

--- Verify transactions ---
SELECT TOP 5
    TransactionID,
    AccountID,
    TransactionType,
    Amount,
    Description,
    TransactionDate
FROM Transactions
WHERE AccountID IN (1, 2)
ORDER BY TransactionID DESC

--- Transaction Control: COMMIT & ROLLBACK ---
BEGIN TRANSACTION;

UPDATE Accounts
SET Balance = Balance + 5000
WHERE AccountID = 1;

SELECT
    AccountID,
    AccountNumber,
    Balance
FROM Accounts
WHERE AccountID = 1;

ROLLBACK TRANSACTION;

SELECT
    AccountID,
    AccountNumber,
    Balance
FROM Accounts
WHERE AccountID = 1

--- TRY...CATCH + ROLLBACK Error Handling ---
BEGIN TRY

    BEGIN TRANSACTION;

    -- Account balance mein temporary change
    UPDATE Accounts
    SET Balance = Balance + 10000
    WHERE AccountID = 1;

    -- Intentionally error create kar rahe hain
    THROW 50020, 'Testing transaction rollback.', 1;

    COMMIT TRANSACTION;

END TRY

BEGIN CATCH

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    PRINT 'Transaction rolled back successfully.';
    PRINT ERROR_MESSAGE();

END CATCH


SELECT
    AccountID,
    AccountNumber,
    Balance
FROM Accounts
WHERE AccountID = 1

--- Create a Customer Account View ---
CREATE VIEW CustomerAccountView
AS
SELECT
    c.CustomerID,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    c.City,
    c.State,
    a.AccountID,
    a.AccountNumber,
    a.AccountType,
    a.Balance,
    a.Status AS AccountStatus,
    a.OpenDate
FROM Customers c
INNER JOIN Accounts a
    ON c.CustomerID = a.CustomerID

--- check view ---
SELECT *
FROM CustomerAccountView

--- only high balance customer ---
SELECT
    CustomerID,
    CustomerName,
    AccountNumber,
    AccountType,
    Balance
FROM CustomerAccountView
WHERE Balance >= 50000
ORDER BY Balance DESC

--- Create Indexes - 1. AccountID index on Transactions table --
CREATE INDEX IX_Transactions_AccountID
ON Transactions(AccountID)

---2. CustomerID index on Accounts table ---
CREATE INDEX IX_Accounts_CustomerID
ON Accounts(CustomerID)

---3. CustomerID index on Loans table ---
CREATE INDEX IX_Loans_CustomerID
ON Loans(CustomerID)

--- verify indexes ---
SELECT
    OBJECT_NAME(object_id) AS TableName,
    name AS IndexName,
    type_desc AS IndexType
FROM sys.indexes
WHERE OBJECT_NAME(object_id) IN
(
    'Accounts',
    'Transactions',
    'Loans'
)
ORDER BY TableName, IndexName

--- Transaction Audit Trigger ---
-- 1. Create Audit Table ---
CREATE TABLE TransactionAudit
(
    AuditID BIGINT IDENTITY(1,1) PRIMARY KEY,

    TransactionID BIGINT NOT NULL,

    AccountID INT NOT NULL,

    TransactionType VARCHAR(20),

    Amount DECIMAL(15,2),

    AuditDate DATETIME DEFAULT GETDATE(),

    AuditAction VARCHAR(50)
)

-- 2. Create Trigger --
CREATE TRIGGER trg_TransactionAudit
ON Transactions
AFTER INSERT
AS
BEGIN

    SET NOCOUNT ON;

    INSERT INTO TransactionAudit
    (
        TransactionID,
        AccountID,
        TransactionType,
        Amount,
        AuditAction
    )
    SELECT
        TransactionID,
        AccountID,
        TransactionType,
        Amount,
        'Transaction Created'
    FROM inserted;

END

-- 3. Test Trigger --
EXEC DepositMoney
    @AccountID = 1,
    @Amount = 2000,
    @Description = 'Trigger Test Deposit'

-- 4. check audit record --
SELECT *
FROM TransactionAudit
ORDER BY AuditID DESC


--- Final Banking Dashboard Queries ---
-- 1. Overall Banking KPI --
SELECT
    (SELECT COUNT(*) FROM Customers) AS TotalCustomers,
    (SELECT COUNT(*) FROM Accounts WHERE Status = 'Active') AS ActiveAccounts,
    (SELECT COALESCE(SUM(Balance), 0)
     FROM Accounts
     WHERE Status = 'Active') AS TotalBankBalance,
    (SELECT COUNT(*) FROM Loans WHERE LoanStatus = 'Active') AS ActiveLoans,
    (SELECT COALESCE(SUM(LoanAmount), 0)
     FROM Loans
     WHERE LoanStatus = 'Active') AS TotalLoanAmount

-- 2. Branch Performance --
SELECT
    b.BranchName,
    b.City,
    COUNT(DISTINCT a.AccountID) AS TotalAccounts,
    COALESCE(SUM(a.Balance), 0) AS TotalBalance,
    COUNT(DISTINCT l.LoanID) AS TotalLoans,
    COALESCE(SUM(l.LoanAmount), 0) AS TotalLoanAmount
FROM Branches b
LEFT JOIN Accounts a
    ON b.BranchID = a.BranchID
LEFT JOIN Loans l
    ON b.BranchID = l.BranchID
GROUP BY
    b.BranchID,
    b.BranchName,
    b.City
ORDER BY TotalBalance DESC

-- 3. Customer Segmentation --
SELECT
    c.CustomerID,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    a.Balance,

    CASE
        WHEN a.Balance >= 100000 THEN 'Premium Customer'
        WHEN a.Balance >= 50000 THEN 'Standard Customer'
        ELSE 'Basic Customer'
    END AS CustomerSegment

FROM Customers c
INNER JOIN Accounts a
    ON c.CustomerID = a.CustomerID

ORDER BY a.Balance DESC

--- Final Project Testing & Database Check ---
-- 1. check all tables --
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME

-- 2. check stored procedure --
SELECT
    name AS ProcedureName
FROM sys.procedures
WHERE name IN
(
    'DepositMoney',
    'WithdrawMoney',
    'TransferMoney'
)
ORDER BY name

-- 3. check view --
SELECT
    name AS ViewName
FROM sys.views
WHERE name = 'CustomerAccountView'

-- 4. check trigger --
SELECT
    name AS TriggerName,
    OBJECT_NAME(parent_id) AS TableName
FROM sys.triggers
WHERE name = 'trg_TransactionAudit'

-- 5. check final account balance --
SELECT
    AccountID,
    AccountNumber,
    AccountType,
    Balance,
    Status
FROM Accounts
ORDER BY AccountID

--6. verify audit trigger --
SELECT TOP 10
    AuditID,
    TransactionID,
    AccountID,
    TransactionType,
    Amount,
    AuditDate,
    AuditAction
FROM TransactionAudit
ORDER BY AuditID DESC
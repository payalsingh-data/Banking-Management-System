USE BankingSystem;
GO

-- STEP 49: Transaction rollback test
BEGIN TRANSACTION;

UPDATE Accounts
SET Balance = Balance + 5000
WHERE AccountID = 1;

SELECT AccountID, AccountNumber, Balance
FROM Accounts
WHERE AccountID = 1;

ROLLBACK TRANSACTION;

SELECT AccountID, AccountNumber, Balance
FROM Accounts
WHERE AccountID = 1;
GO

-- STEP 50: TRY/CATCH rollback test
BEGIN TRY
    BEGIN TRANSACTION;

    UPDATE Accounts
    SET Balance = Balance + 10000
    WHERE AccountID = 1;

    THROW 50020, 'Testing transaction rollback.', 1;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    PRINT 'Transaction rolled back successfully.';
    PRINT ERROR_MESSAGE();
END CATCH;
GO

-- STEP 47: Insufficient balance test
EXEC WithdrawMoney
    @AccountID = 1,
    @Amount = 100000,
    @Description = 'Large ATM Withdrawal';
GO

-- STEP 45: Deposit test
EXEC DepositMoney
    @AccountID = 1,
    @Amount = 10000,
    @Description = 'Cash Deposit';
GO

-- STEP 46: Withdrawal test
EXEC WithdrawMoney
    @AccountID = 1,
    @Amount = 5000,
    @Description = 'ATM Withdrawal';
GO

-- STEP 48: Transfer test
EXEC TransferMoney
    @FromAccountID = 1,
    @ToAccountID = 2,
    @Amount = 10000;
GO

-- STEP 53: Trigger test
EXEC DepositMoney
    @AccountID = 1,
    @Amount = 2000,
    @Description = 'Trigger Test Deposit';
GO

-- STEP 54: Banking KPI
SELECT
    (SELECT COUNT(*) FROM Customers) AS TotalCustomers,
    (SELECT COUNT(*) FROM Accounts WHERE Status = 'Active') AS ActiveAccounts,
    (SELECT COALESCE(SUM(Balance), 0) FROM Accounts WHERE Status = 'Active') AS TotalBankBalance,
    (SELECT COUNT(*) FROM Loans WHERE LoanStatus = 'Active') AS ActiveLoans,
    (SELECT COALESCE(SUM(LoanAmount), 0) FROM Loans WHERE LoanStatus = 'Active') AS TotalLoanAmount;
GO

-- STEP 54: Branch performance
SELECT
    b.BranchName,
    b.City,
    COUNT(DISTINCT a.AccountID) AS TotalAccounts,
    COALESCE(SUM(a.Balance), 0) AS TotalBalance,
    COUNT(DISTINCT l.LoanID) AS TotalLoans,
    COALESCE(SUM(l.LoanAmount), 0) AS TotalLoanAmount
FROM Branches b
LEFT JOIN Accounts a ON b.BranchID = a.BranchID
LEFT JOIN Loans l ON b.BranchID = l.BranchID
GROUP BY b.BranchID, b.BranchName, b.City
ORDER BY TotalBalance DESC;
GO

-- STEP 54: Customer segmentation
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
INNER JOIN Accounts a ON c.CustomerID = a.CustomerID
ORDER BY a.Balance DESC;
GO

-- STEP 55: Tables
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
GO

-- STEP 55: Stored procedures
SELECT name AS ProcedureName
FROM sys.procedures
WHERE name IN ('DepositMoney', 'WithdrawMoney', 'TransferMoney')
ORDER BY name;
GO

-- STEP 55: View
SELECT name AS ViewName
FROM sys.views
WHERE name = 'CustomerAccountView';
GO

-- STEP 55: Trigger
SELECT name AS TriggerName,
       OBJECT_NAME(parent_id) AS TableName
FROM sys.triggers
WHERE name = 'trg_TransactionAudit';
GO

-- STEP 55: Final account balances
SELECT AccountID, AccountNumber, AccountType, Balance, Status
FROM Accounts
ORDER BY AccountID;
GO

-- STEP 55: Audit verification
SELECT TOP 10
    AuditID, TransactionID, AccountID,
    TransactionType, Amount, AuditDate, AuditAction
FROM TransactionAudit
ORDER BY AuditID DESC;
GO

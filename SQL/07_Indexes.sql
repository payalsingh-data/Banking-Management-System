USE BankingSystem;
GO

-- STEP 52: Performance indexes
CREATE INDEX IX_Transactions_AccountID
ON Transactions(AccountID);
GO

CREATE INDEX IX_Accounts_CustomerID
ON Accounts(CustomerID);
GO

CREATE INDEX IX_Loans_CustomerID
ON Loans(CustomerID);
GO

SELECT
    OBJECT_NAME(object_id) AS TableName,
    name AS IndexName,
    type_desc AS IndexType
FROM sys.indexes
WHERE OBJECT_NAME(object_id) IN ('Accounts', 'Transactions', 'Loans')
ORDER BY TableName, IndexName;
GO

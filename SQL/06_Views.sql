USE BankingSystem;
GO

-- STEP 51: Customer Account View
CREATE OR ALTER VIEW CustomerAccountView
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
    ON c.CustomerID = a.CustomerID;
GO

SELECT * FROM CustomerAccountView;
GO

SELECT CustomerID, CustomerName, AccountNumber, AccountType, Balance
FROM CustomerAccountView
WHERE Balance >= 50000
ORDER BY Balance DESC;
GO

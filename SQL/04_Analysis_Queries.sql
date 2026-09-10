USE BankingSystem;
GO

-- STEP 18: Customer + Account Summary
SELECT c.CustomerID,
       c.FirstName + ' ' + c.LastName AS CustomerName,
       a.AccountNumber, a.AccountType, a.Balance, a.Status
FROM Customers c
INNER JOIN Accounts a ON c.CustomerID = a.CustomerID
ORDER BY a.Balance DESC;
GO

-- STEP 19: Branch-wise Account Analysis
SELECT b.BranchID, b.BranchName, b.City,
       COUNT(a.AccountID) AS TotalAccounts
FROM Branches b
LEFT JOIN Accounts a ON b.BranchID = a.BranchID
GROUP BY b.BranchID, b.BranchName, b.City
ORDER BY TotalAccounts DESC;
GO

-- STEP 20: Total Bank Balance
SELECT SUM(Balance) AS TotalBankBalance
FROM Accounts
WHERE Status = 'Active';
GO

-- STEP 21: Highest balance
SELECT TOP 1 AccountNumber, AccountType, Balance
FROM Accounts
ORDER BY Balance DESC;
GO

-- STEP 22: Customer Transaction History
SELECT c.CustomerID,
       c.FirstName + ' ' + c.LastName AS CustomerName,
       a.AccountNumber, a.AccountType,
       t.TransactionType, t.Amount, t.TransactionDate, t.Description
FROM Customers c
INNER JOIN Accounts a ON c.CustomerID = a.CustomerID
INNER JOIN Transactions t ON a.AccountID = t.AccountID
ORDER BY t.TransactionDate DESC;
GO

-- STEP 23: Deposits vs Withdrawals
SELECT TransactionType,
       COUNT(*) AS NumberOfTransactions,
       SUM(Amount) AS TotalAmount
FROM Transactions
GROUP BY TransactionType
ORDER BY TotalAmount DESC;
GO

-- STEP 24: Branch-wise Total Account Balance
SELECT b.BranchID, b.BranchName, b.City,
       COUNT(a.AccountID) AS TotalAccounts,
       COALESCE(SUM(a.Balance), 0) AS TotalBalance
FROM Branches b
LEFT JOIN Accounts a ON b.BranchID = a.BranchID
GROUP BY b.BranchID, b.BranchName, b.City
ORDER BY TotalBalance DESC;
GO

-- STEP 25: Customer-wise Total Transaction Amount
SELECT c.CustomerID,
       c.FirstName + ' ' + c.LastName AS CustomerName,
       COUNT(t.TransactionID) AS TotalTransactions,
       COALESCE(SUM(t.Amount), 0) AS TotalTransactionAmount
FROM Customers c
LEFT JOIN Accounts a ON c.CustomerID = a.CustomerID
LEFT JOIN Transactions t ON a.AccountID = t.AccountID
GROUP BY c.CustomerID, c.FirstName, c.LastName
ORDER BY TotalTransactionAmount DESC;
GO

-- STEP 26: Customers With No Transactions
SELECT c.CustomerID,
       c.FirstName + ' ' + c.LastName AS CustomerName,
       a.AccountNumber, a.AccountType, a.Balance
FROM Customers c
INNER JOIN Accounts a ON c.CustomerID = a.CustomerID
LEFT JOIN Transactions t ON a.AccountID = t.AccountID
WHERE t.TransactionID IS NULL;
GO

-- STEP 27: Customer-wise Loan Summary
SELECT c.CustomerID,
       c.FirstName + ' ' + c.LastName AS CustomerName,
       COUNT(l.LoanID) AS TotalLoans,
       SUM(l.LoanAmount) AS TotalLoanAmount,
       AVG(l.InterestRate) AS AverageInterestRate
FROM Customers c
LEFT JOIN Loans l ON c.CustomerID = l.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
ORDER BY TotalLoanAmount DESC;
GO

-- STEP 28: Loan Payment Analysis
SELECT c.CustomerID,
       c.FirstName + ' ' + c.LastName AS CustomerName,
       l.LoanID, l.LoanType, l.LoanAmount,
       COUNT(lp.PaymentID) AS TotalPayments,
       COALESCE(SUM(lp.PaymentAmount), 0) AS TotalPaid,
       l.LoanAmount - COALESCE(SUM(lp.PaymentAmount), 0) AS RemainingAmount
FROM Customers c
INNER JOIN Loans l ON c.CustomerID = l.CustomerID
LEFT JOIN LoanPayments lp ON l.LoanID = lp.LoanID
GROUP BY c.CustomerID, c.FirstName, c.LastName,
         l.LoanID, l.LoanType, l.LoanAmount
ORDER BY RemainingAmount DESC;
GO

-- STEP 29: Top 3 Customers by Balance
WITH CustomerBalances AS
(
    SELECT c.CustomerID,
           c.FirstName + ' ' + c.LastName AS CustomerName,
           a.AccountNumber, a.Balance
    FROM Customers c
    INNER JOIN Accounts a ON c.CustomerID = a.CustomerID
)
SELECT TOP 3 CustomerID, CustomerName, AccountNumber, Balance
FROM CustomerBalances
ORDER BY Balance DESC;
GO

-- STEP 30: Rank Customers by Balance
SELECT c.CustomerID,
       c.FirstName + ' ' + c.LastName AS CustomerName,
       a.AccountNumber, a.Balance,
       RANK() OVER (ORDER BY a.Balance DESC) AS BalanceRank
FROM Customers c
INNER JOIN Accounts a ON c.CustomerID = a.CustomerID;
GO

-- STEP 31: ROW_NUMBER vs RANK
SELECT c.CustomerID,
       c.FirstName + ' ' + c.LastName AS CustomerName,
       a.AccountNumber, a.Balance,
       ROW_NUMBER() OVER (ORDER BY a.Balance DESC) AS RowNumber,
       RANK() OVER (ORDER BY a.Balance DESC) AS BalanceRank
FROM Customers c
INNER JOIN Accounts a ON c.CustomerID = a.CustomerID;
GO

-- STEP 32: Running Transaction Total
SELECT t.TransactionID, a.AccountNumber,
       t.TransactionType, t.Amount, t.TransactionDate,
       SUM(t.Amount) OVER
       (
           PARTITION BY t.AccountID
           ORDER BY t.TransactionDate, t.TransactionID
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS RunningTotal
FROM Transactions t
INNER JOIN Accounts a ON t.AccountID = a.AccountID
ORDER BY a.AccountNumber, t.TransactionDate, t.TransactionID;
GO

-- STEP 33: Monthly Transaction Analysis
SELECT YEAR(TransactionDate) AS TransactionYear,
       MONTH(TransactionDate) AS TransactionMonth,
       COUNT(*) AS TotalTransactions,
       SUM(Amount) AS TotalTransactionAmount
FROM Transactions
GROUP BY YEAR(TransactionDate), MONTH(TransactionDate)
ORDER BY TransactionYear, TransactionMonth;
GO

-- STEP 34: Branches with High Total Balance
SELECT b.BranchID, b.BranchName, b.City,
       COUNT(a.AccountID) AS TotalAccounts,
       SUM(a.Balance) AS TotalBalance
FROM Branches b
INNER JOIN Accounts a ON b.BranchID = a.BranchID
GROUP BY b.BranchID, b.BranchName, b.City
HAVING SUM(a.Balance) > 50000
ORDER BY TotalBalance DESC;
GO

-- STEP 35: Customers Above Average Balance
SELECT c.CustomerID,
       c.FirstName + ' ' + c.LastName AS CustomerName,
       a.AccountNumber, a.Balance
FROM Customers c
INNER JOIN Accounts a ON c.CustomerID = a.CustomerID
WHERE a.Balance > (SELECT AVG(Balance) FROM Accounts);
GO

-- STEP 36: Customers with Highest Account Balance
SELECT c.CustomerID,
       c.FirstName + ' ' + c.LastName AS CustomerName,
       a.AccountNumber, a.AccountType, a.Balance
FROM Customers c
INNER JOIN Accounts a ON c.CustomerID = a.CustomerID
WHERE a.Balance = (SELECT MAX(Balance) FROM Accounts);
GO

-- STEP 37: Customer Balance Category
SELECT c.CustomerID,
       c.FirstName + ' ' + c.LastName AS CustomerName,
       a.AccountNumber, a.Balance,
       CASE
           WHEN a.Balance >= 100000 THEN 'High Balance'
           WHEN a.Balance >= 50000 THEN 'Medium Balance'
           ELSE 'Low Balance'
       END AS BalanceCategory
FROM Customers c
INNER JOIN Accounts a ON c.CustomerID = a.CustomerID
ORDER BY a.Balance DESC;
GO

-- STEP 38: Customers With No Loan
SELECT c.CustomerID,
       c.FirstName + ' ' + c.LastName AS CustomerName,
       COUNT(l.LoanID) AS TotalLoans,
       COALESCE(SUM(l.LoanAmount), 0) AS TotalLoanAmount
FROM Customers c
LEFT JOIN Loans l ON c.CustomerID = l.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
HAVING COUNT(l.LoanID) = 0;
GO

-- STEP 39: Customers Who Have Loans using EXISTS
SELECT c.CustomerID,
       c.FirstName + ' ' + c.LastName AS CustomerName,
       c.City, c.State
FROM Customers c
WHERE EXISTS
(
    SELECT 1 FROM Loans l
    WHERE l.CustomerID = c.CustomerID
);
GO

-- STEP 40: Customers With More Than One Loan
SELECT c.CustomerID,
       c.FirstName + ' ' + c.LastName AS CustomerName,
       COUNT(l.LoanID) AS TotalLoans,
       SUM(l.LoanAmount) AS TotalLoanAmount
FROM Customers c
INNER JOIN Loans l ON c.CustomerID = l.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
HAVING COUNT(l.LoanID) > 1;
GO

-- STEP 41: Customers With High Loan Exposure
WITH CustomerLoanSummary AS
(
    SELECT c.CustomerID,
           c.FirstName + ' ' + c.LastName AS CustomerName,
           COUNT(l.LoanID) AS TotalLoans,
           SUM(l.LoanAmount) AS TotalLoanAmount
    FROM Customers c
    INNER JOIN Loans l ON c.CustomerID = l.CustomerID
    GROUP BY c.CustomerID, c.FirstName, c.LastName
)
SELECT CustomerID, CustomerName, TotalLoans, TotalLoanAmount
FROM CustomerLoanSummary
WHERE TotalLoanAmount > 1000000
ORDER BY TotalLoanAmount DESC;
GO

-- STEP 42: Latest Transaction of Each Account
WITH RankedTransactions AS
(
    SELECT t.TransactionID, t.AccountID, a.AccountNumber,
           t.TransactionType, t.Amount, t.TransactionDate, t.Description,
           ROW_NUMBER() OVER
           (
               PARTITION BY t.AccountID
               ORDER BY t.TransactionDate DESC, t.TransactionID DESC
           ) AS RowNum
    FROM Transactions t
    INNER JOIN Accounts a ON t.AccountID = a.AccountID
)
SELECT TransactionID, AccountID, AccountNumber,
       TransactionType, Amount, TransactionDate, Description
FROM RankedTransactions
WHERE RowNum = 1
ORDER BY AccountNumber;
GO

-- STEP 43: True Calculated Balance from Transactions
SELECT t.TransactionID, a.AccountNumber,
       t.TransactionType, t.Amount, t.TransactionDate,
       SUM(
           CASE
               WHEN t.TransactionType IN ('Deposit', 'Transfer In') THEN t.Amount
               WHEN t.TransactionType IN ('Withdrawal', 'Transfer Out') THEN -t.Amount
               ELSE 0
           END
       ) OVER
       (
           PARTITION BY t.AccountID
           ORDER BY t.TransactionDate, t.TransactionID
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS CalculatedBalance
FROM Transactions t
INNER JOIN Accounts a ON t.AccountID = a.AccountID
ORDER BY a.AccountNumber, t.TransactionDate, t.TransactionID;
GO

-- STEP 44: Customer 360 Banking Report
SELECT c.CustomerID,
       c.FirstName + ' ' + c.LastName AS CustomerName,
       a.AccountNumber, a.AccountType, a.Balance,
       COUNT(DISTINCT t.TransactionID) AS TotalTransactions,
       COALESCE(SUM(DISTINCT t.Amount), 0) AS TotalTransactionAmount,
       COUNT(DISTINCT l.LoanID) AS TotalLoans,
       COALESCE(SUM(DISTINCT l.LoanAmount), 0) AS TotalLoanAmount,
       COALESCE(SUM(lp.PaymentAmount), 0) AS TotalLoanPayments
FROM Customers c
LEFT JOIN Accounts a ON c.CustomerID = a.CustomerID
LEFT JOIN Transactions t ON a.AccountID = t.AccountID
LEFT JOIN Loans l ON c.CustomerID = l.CustomerID
LEFT JOIN LoanPayments lp ON l.LoanID = lp.LoanID
GROUP BY c.CustomerID, c.FirstName, c.LastName,
         a.AccountNumber, a.AccountType, a.Balance
ORDER BY a.Balance DESC;
GO

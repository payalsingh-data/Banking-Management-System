USE BankingSystem;
GO

-- STEP 53: Transaction audit trigger
CREATE OR ALTER TRIGGER trg_TransactionAudit
ON Transactions
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO TransactionAudit
    (TransactionID, AccountID, TransactionType, Amount, AuditAction)
    SELECT
        TransactionID,
        AccountID,
        TransactionType,
        Amount,
        'Transaction Created'
    FROM inserted;
END;
GO

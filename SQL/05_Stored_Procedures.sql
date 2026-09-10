USE BankingSystem;
GO

-- STEP 45: Deposit
CREATE OR ALTER PROCEDURE DepositMoney
    @AccountID INT,
    @Amount DECIMAL(15,2),
    @Description VARCHAR(250)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS
        (
            SELECT 1 FROM Accounts
            WHERE AccountID = @AccountID AND Status = 'Active'
        )
            THROW 50001, 'Account does not exist or is inactive.', 1;

        IF @Amount <= 0
            THROW 50002, 'Deposit amount must be greater than zero.', 1;

        UPDATE Accounts
        SET Balance = Balance + @Amount
        WHERE AccountID = @AccountID;

        INSERT INTO Transactions
        (AccountID, TransactionType, Amount, Description, ReferenceNumber)
        VALUES
        (@AccountID, 'Deposit', @Amount, @Description,
         'DEP' + CAST(ABS(CHECKSUM(NEWID())) AS VARCHAR(20)));

        COMMIT TRANSACTION;
        PRINT 'Deposit successful.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO

-- STEP 46: Withdrawal
CREATE OR ALTER PROCEDURE WithdrawMoney
    @AccountID INT,
    @Amount DECIMAL(15,2),
    @Description VARCHAR(250)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS
        (
            SELECT 1 FROM Accounts
            WHERE AccountID = @AccountID AND Status = 'Active'
        )
            THROW 50003, 'Account does not exist or is inactive.', 1;

        IF @Amount <= 0
            THROW 50004, 'Withdrawal amount must be greater than zero.', 1;

        IF NOT EXISTS
        (
            SELECT 1 FROM Accounts
            WHERE AccountID = @AccountID AND Balance >= @Amount
        )
            THROW 50005, 'Insufficient balance.', 1;

        UPDATE Accounts
        SET Balance = Balance - @Amount
        WHERE AccountID = @AccountID;

        INSERT INTO Transactions
        (AccountID, TransactionType, Amount, Description, ReferenceNumber)
        VALUES
        (@AccountID, 'Withdrawal', @Amount, @Description,
         'WDR' + CAST(ABS(CHECKSUM(NEWID())) AS VARCHAR(20)));

        COMMIT TRANSACTION;
        PRINT 'Withdrawal successful.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO

-- STEP 48: Transfer
CREATE OR ALTER PROCEDURE TransferMoney
    @FromAccountID INT,
    @ToAccountID INT,
    @Amount DECIMAL(15,2)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF @FromAccountID = @ToAccountID
            THROW 50006, 'Source and destination accounts must be different.', 1;

        IF @Amount <= 0
            THROW 50007, 'Transfer amount must be greater than zero.', 1;

        IF NOT EXISTS
        (
            SELECT 1 FROM Accounts
            WHERE AccountID = @FromAccountID AND Status = 'Active'
        )
            THROW 50008, 'Source account does not exist or is inactive.', 1;

        IF NOT EXISTS
        (
            SELECT 1 FROM Accounts
            WHERE AccountID = @ToAccountID AND Status = 'Active'
        )
            THROW 50009, 'Destination account does not exist or is inactive.', 1;

        IF NOT EXISTS
        (
            SELECT 1 FROM Accounts
            WHERE AccountID = @FromAccountID AND Balance >= @Amount
        )
            THROW 50010, 'Insufficient balance in source account.', 1;

        UPDATE Accounts
        SET Balance = Balance - @Amount
        WHERE AccountID = @FromAccountID;

        UPDATE Accounts
        SET Balance = Balance + @Amount
        WHERE AccountID = @ToAccountID;

        INSERT INTO Transactions
        (AccountID, TransactionType, Amount, Description, ReferenceNumber)
        VALUES
        (@FromAccountID, 'Transfer Out', @Amount,
         'Money transferred to Account ' + CAST(@ToAccountID AS VARCHAR(20)),
         'TRFOUT' + CAST(ABS(CHECKSUM(NEWID())) AS VARCHAR(20)));

        INSERT INTO Transactions
        (AccountID, TransactionType, Amount, Description, ReferenceNumber)
        VALUES
        (@ToAccountID, 'Transfer In', @Amount,
         'Money received from Account ' + CAST(@FromAccountID AS VARCHAR(20)),
         'TRFIN' + CAST(ABS(CHECKSUM(NEWID())) AS VARCHAR(20)));

        COMMIT TRANSACTION;
        PRINT 'Transfer successful.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO

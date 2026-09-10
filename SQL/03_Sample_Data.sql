USE BankingSystem;
GO

-- STEP 3: Branch data
INSERT INTO Branches
(BranchName, City, State, IFSCCode, ContactNumber)
VALUES
('Connaught Place Branch', 'Delhi', 'Delhi', 'BANK0001001', '9876543210'),
('Sector 18 Branch', 'Noida', 'Uttar Pradesh', 'BANK0001002', '9876543211'),
('Cyber City Branch', 'Gurugram', 'Haryana', 'BANK0001003', '9876543212'),
('South Extension Branch', 'Delhi', 'Delhi', 'BANK0001004', '9876543213'),
('Indirapuram Branch', 'Ghaziabad', 'Uttar Pradesh', 'BANK0001005', '9876543214');
GO

-- STEP 5: Customer data
INSERT INTO Customers
(FirstName, LastName, DateOfBirth, Gender, Phone, Email, Address, City, State, PANNumber, AadhaarNumber)
VALUES
('Rahul', 'Sharma', '1998-05-12', 'Male', '9000000001', 'rahul@gmail.com',
 'Rohini', 'Delhi', 'Delhi', 'ABCDE1234F', '111122223333'),
('Priya', 'Verma', '1997-08-20', 'Female', '9000000002', 'priya@gmail.com',
 'Sector 62', 'Noida', 'Uttar Pradesh', 'BCDEF2345G', '222233334444'),
('Amit', 'Kumar', '1995-03-15', 'Male', '9000000003', 'amit@gmail.com',
 'Dwarka', 'Delhi', 'Delhi', 'CDEFG3456H', '333344445555'),
('Neha', 'Singh', '1999-11-10', 'Female', '9000000004', 'neha@gmail.com',
 'Gurugram', 'Haryana', 'Haryana', 'DEFGH4567I', '444455556666'),
('Rohit', 'Mehta', '1996-01-25', 'Male', '9000000005', 'rohit@gmail.com',
 'Noida Extension', 'Noida', 'Uttar Pradesh', 'EFGHI5678J', '555566667777');
GO

-- STEP 7: Employee data
INSERT INTO Employees
(BranchID, FirstName, LastName, JobTitle, Phone, Email, Salary, JoiningDate)
VALUES
(1, 'Ankit', 'Sharma', 'Branch Manager', '9100000001', 'ankit@bank.com', 65000, '2023-04-10'),
(1, 'Pooja', 'Verma', 'Bank Officer', '9100000002', 'pooja@bank.com', 45000, '2024-01-15'),
(2, 'Ravi', 'Kumar', 'Branch Manager', '9100000003', 'ravi@bank.com', 68000, '2022-07-20'),
(2, 'Simran', 'Kaur', 'Cashier', '9100000004', 'simran@bank.com', 35000, '2024-03-12'),
(3, 'Vikas', 'Mehta', 'Bank Officer', '9100000005', 'vikas@bank.com', 47000, '2023-11-05');
GO

-- STEP 9: Account data
INSERT INTO Accounts
(CustomerID, BranchID, AccountNumber, AccountType, Balance, Status)
VALUES
(1001, 1, '1000000001', 'Savings', 50000, 'Active'),
(1002, 2, '1000000002', 'Savings', 75000, 'Active'),
(1003, 1, '1000000003', 'Current', 120000, 'Active'),
(1004, 3, '1000000004', 'Salary', 65000, 'Active'),
(1005, 2, '1000000005', 'Savings', 30000, 'Active');
GO

-- STEP 11: Initial transaction data
INSERT INTO Transactions
(AccountID, TransactionType, Amount, Description, ReferenceNumber)
VALUES
(1, 'Deposit', 10000, 'Cash Deposit', 'TXN10001'),
(1, 'Withdrawal', 5000, 'ATM Withdrawal', 'TXN10002'),
(2, 'Deposit', 20000, 'Salary Credit', 'TXN10003'),
(3, 'Withdrawal', 15000, 'Business Expense', 'TXN10004'),
(4, 'Deposit', 25000, 'Salary Credit', 'TXN10005'),
(5, 'Withdrawal', 3000, 'ATM Withdrawal', 'TXN10006');
GO

-- STEP 13: Loan data
INSERT INTO Loans
(CustomerID, BranchID, LoanType, LoanAmount, InterestRate, TenureMonths, StartDate, LoanStatus)
VALUES
(1001, 1, 'Home Loan', 2500000, 8.50, 240, '2025-01-15', 'Active'),
(1002, 2, 'Personal Loan', 500000, 11.50, 60, '2025-03-10', 'Active'),
(1003, 1, 'Business Loan', 1500000, 10.25, 120, '2024-08-20', 'Active'),
(1004, 3, 'Education Loan', 800000, 7.50, 84, '2025-06-01', 'Active'),
(1005, 2, 'Personal Loan', 300000, 12.00, 36, '2025-02-25', 'Active');
GO

-- STEP 15: Loan payment data
INSERT INTO LoanPayments
(LoanID, PaymentDate, PaymentAmount, PaymentMethod, ReferenceNumber)
VALUES
(1, '2025-02-15', 25000, 'NEFT', 'LP10001'),
(1, '2025-03-15', 25000, 'UPI', 'LP10002'),
(2, '2025-04-10', 12000, 'NEFT', 'LP10003'),
(3, '2025-04-20', 30000, 'Cheque', 'LP10004'),
(4, '2025-07-01', 15000, 'UPI', 'LP10005'),
(5, '2025-03-25', 10000, 'NEFT', 'LP10006');
GO

-- STEP 17: Beneficiary data
INSERT INTO Beneficiaries
(CustomerID, BeneficiaryName, BeneficiaryAccountNumber, BankName, IFSCCode, AddedDate, Status)
VALUES
(1001, 'Priya Verma', '1000000002', 'Banking System Bank', 'BANK0001002', '2025-01-20', 'Active'),
(1001, 'Amit Kumar', '1000000003', 'Banking System Bank', 'BANK0001001', '2025-01-22', 'Active'),
(1002, 'Rahul Sharma', '1000000001', 'Banking System Bank', 'BANK0001001', '2025-02-15', 'Active'),
(1003, 'Neha Singh', '1000000004', 'Banking System Bank', 'BANK0001003', '2025-03-10', 'Active'),
(1005, 'Rahul Sharma', '1000000001', 'Banking System Bank', 'BANK0001001', '2025-04-05', 'Inactive');
GO

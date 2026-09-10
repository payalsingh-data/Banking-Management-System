# Banking Management System | MS SQL Server

An end-to-end relational **Banking Management System** built using **Microsoft SQL Server and T-SQL**. The project covers database design, banking transactions, loans, reporting, stored procedures, transaction control, auditing, indexing, and analytical SQL.

## Project Objective

The goal of this project is to simulate core banking operations while demonstrating practical SQL skills used in data analysis and database development.

## Tech Stack

- Microsoft SQL Server
- T-SQL
- Stored Procedures
- Views
- Triggers
- Transactions / TRY...CATCH / ROLLBACK
- CTEs
- Window Functions
- Joins
- Subqueries
- Aggregations
- CASE expressions
- Indexing

## Database Modules

| Module | Description |
|---|---|
| Branches | Bank branch information |
| Customers | Customer master data |
| Employees | Employees mapped to branches |
| Accounts | Customer bank accounts and balances |
| Transactions | Deposits, withdrawals and transfers |
| Loans | Customer loan records |
| LoanPayments | Loan repayment history |
| Beneficiaries | Customer beneficiary records |
| TransactionAudit | Automatic transaction audit records |

## Key Features

- Customer and account management
- Branch and employee management
- Deposit and withdrawal processing
- Account-to-account money transfer
- Insufficient-balance validation
- Transaction commit and rollback
- TRY...CATCH error handling
- Loan and loan-payment tracking
- Customer 360° banking analysis
- Branch-level performance analysis
- Customer balance segmentation
- Transaction history and monthly analysis
- Ranking using `RANK()` and `ROW_NUMBER()`
- CTE-based analytical queries
- `EXISTS`, `HAVING`, `CASE` and subqueries
- Reusable customer-account view
- Indexes for common lookup columns
- Automatic transaction audit using a trigger

## Repository Structure

```text
Banking-Management-System/
│
├── README.md
│
├── SQL/
│   ├── 01_Database.sql
│   ├── 02_Tables.sql
│   ├── 03_Sample_Data.sql
│   ├── 04_Analysis_Queries.sql
│   ├── 05_Stored_Procedures.sql
│   ├── 06_Views.sql
│   ├── 07_Indexes.sql
│   ├── 08_Triggers.sql
│   └── 09_Final_Testing.sql
│
└── Screenshots/
```

## How to Run

Run the scripts in this order in SQL Server Management Studio (SSMS):

1. `01_Database.sql`
2. `02_Tables.sql`
3. `03_Sample_Data.sql`
4. `04_Analysis_Queries.sql`
5. `05_Stored_Procedures.sql`
6. `06_Views.sql`
7. `07_Indexes.sql`
8. `08_Triggers.sql`
9. `09_Final_Testing.sql`

> If the database/tables already exist, do not recreate them blindly. Run the relevant verification query first.

## Important Design Note

The initial sample transaction records are demonstration/history data and were inserted independently of the starting `Accounts.Balance` values. Therefore, the initial transaction history is **not intended to reconstruct the seeded account balances exactly**.

From the stored-procedure stage onward, deposits, withdrawals and transfers update the account balance and transaction record within the same SQL transaction. This keeps new operational activity atomic and consistent.

## Example Banking Operations

### Deposit

```sql
EXEC DepositMoney
    @AccountID = 1,
    @Amount = 10000,
    @Description = 'Cash Deposit';
```

### Withdrawal

```sql
EXEC WithdrawMoney
    @AccountID = 1,
    @Amount = 5000,
    @Description = 'ATM Withdrawal';
```

### Transfer

```sql
EXEC TransferMoney
    @FromAccountID = 1,
    @ToAccountID = 2,
    @Amount = 10000;
```

## Example Analytical Questions

The project answers questions such as:

- What is the total active bank balance?
- Which customers have the highest balances?
- Which branches have the highest account balances?
- Which customers have loans above a given exposure threshold?
- What are the monthly transaction totals?
- What is the latest transaction for each account?
- How can customers be segmented by account balance?
- Which transactions should be recorded in the audit trail?

## Interview Highlights

This project demonstrates practical knowledge of:

- Relational database design
- Primary and foreign keys
- Constraints
- Data integrity
- Complex joins
- Aggregation and grouping
- CTEs
- Window functions
- Stored procedures
- Transactions and rollback
- Error handling
- Views
- Indexing
- Triggers
- Business-oriented SQL analytics

## Future Enhancements

- Power BI banking dashboard
- More realistic transaction/balance reconciliation
- EMI calculation and loan amortization
- Role-based access control
- Fraud/anomaly detection
- Monthly account statements
- More advanced audit and compliance reporting

## Author

**Payal Singh**

Data Analyst | SQL | Excel | Power BI | Python

LinkedIn: linkedin.com/in/payalsingh259  
GitHub: github.com/payalku47-eng

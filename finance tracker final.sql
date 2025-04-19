CREATE DATABASE finance_tracker;
USE finance_tracker;

-- 1. Users Table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP
);

-- 2. Accounts Table
CREATE TABLE accounts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL, -- References users(id)
    name VARCHAR(100) NOT NULL,
    type ENUM('Checking', 'Savings', 'Credit Card', 'Cash', 'Investment', 'Loan') NOT NULL,
    balance DECIMAL(15,2) DEFAULT 0.00,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Categories Table
CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT, -- References users(id)
    name VARCHAR(50) NOT NULL,
    type ENUM('Income', 'Expense', 'Transfer') NOT NULL,
    color VARCHAR(7) DEFAULT '#4CAF50',
    is_system BOOLEAN DEFAULT FALSE
);

-- 4. Transactions Table
CREATE TABLE transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL, -- References users(id)
    account_id INT NOT NULL, -- References accounts(id)
    category_id INT, -- References categories(id)
    amount DECIMAL(15,2) NOT NULL,
    description VARCHAR(255),
    date DATE NOT NULL,
    type ENUM('Income', 'Expense', 'Transfer') NOT NULL,
    is_cleared BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. Recurring Transactions Table
CREATE TABLE recurring_transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL, -- References users(id)
    account_id INT NOT NULL, -- References accounts(id)
    category_id INT, -- References categories(id)
    amount DECIMAL(15,2) NOT NULL,
    description VARCHAR(255),
    frequency ENUM('Daily', 'Weekly', 'Monthly', 'Yearly') NOT NULL,
    next_date DATE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
);

-- 6. Budgets Table
CREATE TABLE budgets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL, -- References users(id)
    category_id INT NOT NULL, -- References categories(id)
    amount DECIMAL(15,2) NOT NULL,
    month CHAR(7) NOT NULL -- Format: 'YYYY-MM'
);

-- 7. Goals Table
CREATE TABLE goals (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL, -- References users(id)
    name VARCHAR(100) NOT NULL,
    target_amount DECIMAL(15,2) NOT NULL,
    current_amount DECIMAL(15,2) DEFAULT 0.00,
    target_date DATE,
    is_completed BOOLEAN DEFAULT FALSE
);

-- 8. Bills Table
CREATE TABLE bills (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL, -- References users(id)
    account_id INT, -- References accounts(id)
    payee VARCHAR(100) NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    due_day TINYINT NOT NULL, -- Day of month (1-31)
    is_active BOOLEAN DEFAULT TRUE
);

-- 9. Income Sources Table
CREATE TABLE income_sources (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL, -- References users(id)
    account_id INT NOT NULL, -- References accounts(id)
    name VARCHAR(100) NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    pay_day TINYINT NOT NULL, -- Day of month (1-31)
    is_active BOOLEAN DEFAULT TRUE
);

-- 10. Transfers Table
CREATE TABLE transfers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL, -- References users(id)
    from_account_id INT NOT NULL, -- References accounts(id)
    to_account_id INT NOT NULL, -- References accounts(id)
    amount DECIMAL(15,2) NOT NULL,
    date DATE NOT NULL,
    description VARCHAR(255)
);

-- Indexes for better performance
CREATE INDEX idx_transactions_user_date ON transactions(user_id, date);
CREATE INDEX idx_recurring_next_date ON recurring_transactions(user_id, next_date);
CREATE INDEX idx_budgets_user_month ON budgets(user_id, month);

-- Done creating tables
USE finance_tracker;
SHOW TABLES;

-- 1.Users
INSERT INTO users (id, username, email, password_hash, currency, created_at, last_login) VALUES
(1, 'rahulm', 'rahulm@example.com', 'hashed_pw1', 'INR', '2024-01-01', '2024-04-01'),
(2, 'anitas', 'anita@example.com', 'hashed_pw2', 'INR', '2024-02-10', '2024-04-10'),
(3, 'vijayk', 'vijayk@example.com', 'hashed_pw3', 'INR', '2024-03-05', '2024-04-15');

-- 2.Accounts
INSERT INTO accounts (id, user_id, name, type, balance, is_active, created_at) VALUES
(1, 1, 'HDFC Savings', 'Savings', 75000, TRUE, '2024-01-01'),
(2, 1, 'Paytm Wallet', 'Cash', 1500, TRUE, '2024-01-05'),
(3, 2, 'ICICI Credit Card', 'Credit Card', -5000, TRUE, '2024-02-10'),
(4, 2, 'SBI Checking', 'Checking', 32000, TRUE, '2024-02-11'),
(5, 3, 'Axis Investment', 'Investment', 250000, TRUE, '2024-03-05');

-- 3.Categories
INSERT INTO categories (id, user_id, name, type, color, is_system) VALUES
(1, 1, 'Salary', 'Income', '#2ECC71', FALSE),
(2, 1, 'Groceries', 'Expense', '#E74C3C', FALSE),
(3, 1, 'Rent', 'Expense', '#3498DB', FALSE),
(4, 2, 'Freelancing', 'Income', '#2ECC71', FALSE),
(5, 2, 'Utilities', 'Expense', '#E67E22', FALSE),
(6, 3, 'Stock Return', 'Income', '#9B59B6', FALSE),
(7, 3, 'Travel', 'Expense', '#1ABC9C', FALSE);

-- 4.Transactions
INSERT INTO transactions (id, user_id, account_id, category_id, amount, description, date, type, is_cleared, created_at) VALUES
(1, 1, 1, 1, 50000, 'Jan Salary', '2024-01-31', 'Income', TRUE, '2024-01-31'),
(2, 1, 2, 2, 2000, 'D-Mart groceries', '2024-02-05', 'Expense', TRUE, '2024-02-05'),
(3, 1, 1, 3, 12000, 'February Rent', '2024-02-01', 'Expense', TRUE, '2024-02-01'),
(4, 2, 4, 4, 15000, 'Freelance Project', '2024-02-28', 'Income', TRUE, '2024-02-28'),
(5, 2, 3, 5, 3000, 'Electricity Bill', '2024-03-05', 'Expense', FALSE, '2024-03-05'),
(6, 3, 5, 6, 18000, 'Stock sale profit', '2024-03-10', 'Income', TRUE, '2024-03-10'),
(7, 3, 5, 7, 8000, 'Trip to Goa', '2024-04-01', 'Expense', TRUE, '2024-04-01');

-- 5.Recurring Transactions
INSERT INTO recurring_transactions (id, user_id, account_id, category_id, amount, description, frequency, next_date, is_active) VALUES
(1, 1, 1, 3, 12000, 'Monthly Rent', 'Monthly', '2024-05-01', TRUE),
(2, 2, 4, 5, 3000, 'Utility Bills', 'Monthly', '2024-05-05', TRUE),
(3, 3, 5, 6, 5000, 'Quarterly Dividends', 'Yearly', '2025-03-10', TRUE);

-- 6.Budgets
INSERT INTO budgets (id, user_id, category_id, amount, month) VALUES
(1, 1, 2, 5000, '2024-02'),
(2, 1, 3, 13000, '2024-03'),
(3, 2, 5, 3500, '2024-03'),
(4, 3, 7, 10000, '2024-04');

-- 7.Goals
INSERT INTO goals (id, user_id, name, target_amount, current_amount, target_date, is_completed) VALUES
(1, 1, 'Buy Laptop', 80000, 30000, '2024-12-01', FALSE),
(2, 2, 'Trip to Manali', 20000, 12000, '2024-06-15', FALSE),
(3, 3, 'Emergency Fund', 100000, 50000, '2025-01-01', FALSE);

-- 8.Bills
INSERT INTO bills (id, user_id, account_id, payee, amount, due_day, is_active) VALUES
(1, 1, 1, 'Reliance Jio', 999, 10, TRUE),
(2, 2, 4, 'BESCOM', 2800, 5, TRUE),
(3, 3, 5, 'Netflix', 499, 15, TRUE);

-- 9.Income Sources
INSERT INTO income_sources (id, user_id, account_id, name, amount, pay_day, is_active) VALUES
(1, 1, 1, 'Monthly Salary', 50000, 31, TRUE),
(2, 2, 4, 'Freelance Payments', 15000, 28, TRUE),
(3, 3, 5, 'Dividends', 6000, 10, TRUE);

-- 10.Transfers
INSERT INTO transfers (id, user_id, from_account_id, to_account_id, amount, date, description) VALUES
(1, 1, 1, 2, 2000, '2024-02-06', 'Moved to Paytm for UPI'),
(2, 2, 4, 3, 1000, '2024-03-01', 'Pay credit card bill'),
(3, 3, 5, 5, 5000, '2024-04-05', 'Reinvestment');

-- 1. List all users
SELECT * FROM Users;

-- 2. List all accounts and their balances
SELECT * FROM Accounts;

-- 3. Get all income transactions
SELECT * FROM Transactions WHERE transaction_type = 'income';

-- 4. Get all expense transactions
SELECT * FROM Transactions WHERE transaction_type = 'expense';

-- 5. Find total balance in all accounts
SELECT SUM(balance) AS total_balance FROM Accounts;

-- 6. Find the total amount of income transactions
SELECT SUM(amount) AS total_income FROM Transactions WHERE transaction_type = 'income';

-- 7. Find the total amount of expenses per category
SELECT c.name AS category, SUM(t.amount) AS total_expense
FROM Transactions t
JOIN Categories c ON t.category_id = c.category_id
WHERE t.transaction_type = 'expense'
GROUP BY c.name;

-- 8. Get the most recent 5 transactions
SELECT * FROM Transactions ORDER BY transaction_date DESC LIMIT 5;

-- 9. Count the number of users
SELECT COUNT(*) AS total_users FROM Users;

-- 10. List all budgets and their amounts
SELECT * FROM Budgets;

-- 11. Find budget usage (spent amount vs limit)
SELECT b.budget_id, b.limit_amount, SUM(t.amount) AS spent
FROM Budgets b
JOIN Transactions t ON b.user_id = t.user_id AND b.category_id = t.category_id
GROUP BY b.budget_id;

-- 12. List transactions by user ‘Priya’
SELECT * FROM Transactions WHERE user_id = (SELECT user_id FROM Users WHERE name = 'Priya');

-- 13. Get savings goals and how much is remaining
SELECT goal_name, target_amount - saved_amount AS remaining FROM SavingsGoals;

-- 14. View all reminders set by users
SELECT * FROM Reminders;

-- 15. Find accounts with balance less than ₹1000
SELECT * FROM Accounts WHERE balance < 1000;

-- 16. Show top 3 categories with highest spending
SELECT c.name, SUM(t.amount) AS total
FROM Transactions t
JOIN Categories c ON t.category_id = c.category_id
WHERE t.transaction_type = 'expense'
GROUP BY c.name
ORDER BY total DESC
LIMIT 3;

-- 17. List all feedbacks with rating >= 4
SELECT * FROM Feedbacks WHERE rating >= 4;

-- 18. Show all recurring transactions
SELECT * FROM Transactions WHERE is_recurring = TRUE;

-- 19. Average rating of the app
SELECT AVG(rating) AS average_rating FROM Feedbacks;

-- 20. Find total transactions per user
SELECT u.name, COUNT(t.transaction_id) AS total_transactions
FROM Users u
JOIN Transactions t ON u.user_id = t.user_id
GROUP BY u.name;

-- 21. Display transactions with category names
SELECT t.transaction_id, t.amount, t.transaction_type, c.name AS category
FROM Transactions t
JOIN Categories c ON t.category_id = c.category_id;

-- 22. Show total savings progress per user
SELECT u.name, SUM(s.saved_amount) AS total_saved, SUM(s.target_amount) AS total_target
FROM SavingsGoals s
JOIN Users u ON s.user_id = u.user_id
GROUP BY u.name;

-- 23. List reminders for the next 7 days
SELECT * FROM Reminders
WHERE reminder_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 7 DAY);

-- 24. Check if any user has overspent their budget
SELECT b.budget_id, u.name, b.limit_amount, SUM(t.amount) AS spent
FROM Budgets b
JOIN Transactions t ON b.user_id = t.user_id AND b.category_id = t.category_id
JOIN Users u ON b.user_id = u.user_id
GROUP BY b.budget_id, u.name
HAVING spent > b.limit_amount;

-- 25. Find the highest transaction amount
SELECT MAX(amount) AS highest_transaction FROM Transactions;

-- 26. Count number of recurring transactions per user
SELECT u.name, COUNT(*) AS recurring_count
FROM Transactions t
JOIN Users u ON t.user_id = u.user_id
WHERE t.is_recurring = TRUE
GROUP BY u.name;

-- 27. View total income and expenses per user
SELECT u.name,
       SUM(CASE WHEN t.transaction_type = 'income' THEN t.amount ELSE 0 END) AS total_income,
       SUM(CASE WHEN t.transaction_type = 'expense' THEN t.amount ELSE 0 END) AS total_expense
FROM Users u
JOIN Transactions t ON u.user_id = t.user_id
GROUP BY u.name;

-- 28. List all savings goals that are completed
SELECT * FROM SavingsGoals WHERE saved_amount >= target_amount;

-- 29. Show feedback with the longest comment
SELECT * FROM Feedbacks ORDER BY LENGTH(comment) DESC LIMIT 1;

-- 30. Find users who haven’t set a savings goal
SELECT * FROM Users
WHERE user_id NOT IN (SELECT DISTINCT user_id FROM SavingsGoals);

-- 31. Create a view for budget summary
CREATE VIEW BudgetSummary AS
SELECT u.name, c.name AS category, b.limit_amount, SUM(t.amount) AS spent
FROM Budgets b
JOIN Users u ON b.user_id = u.user_id
JOIN Categories c ON b.category_id = c.category_id
LEFT JOIN Transactions t ON b.user_id = t.user_id AND b.category_id = t.category_id
GROUP BY u.name, c.name, b.limit_amount;

-- 32. Query the view: BudgetSummary
SELECT * FROM BudgetSummary;

-- 33. List all accounts with user names
SELECT a.account_id, u.name, a.account_type, a.balance
FROM Accounts a
JOIN Users u ON a.user_id = u.user_id;

-- 34. List all transactions of type 'expense' for the current month
SELECT * FROM Transactions
WHERE transaction_type = 'expense'
  AND MONTH(transaction_date) = MONTH(CURDATE())
  AND YEAR(transaction_date) = YEAR(CURDATE());

-- 35. Show the categories for which no budget is set
SELECT * FROM Categories
WHERE category_id NOT IN (SELECT DISTINCT category_id FROM Budgets);

-- 36. Total number of reminders per user
SELECT u.name, COUNT(r.reminder_id) AS reminder_count
FROM Users u
LEFT JOIN Reminders r ON u.user_id = r.user_id
GROUP BY u.name;

-- 37. Show all accounts with zero balance
SELECT * FROM Accounts WHERE balance = 0;

-- 38. Display income vs expense per account
SELECT a.account_id, a.account_type,
       SUM(CASE WHEN t.transaction_type = 'income' THEN t.amount ELSE 0 END) AS total_income,
       SUM(CASE WHEN t.transaction_type = 'expense' THEN t.amount ELSE 0 END) AS total_expense
FROM Accounts a
JOIN Transactions t ON a.account_id = t.account_id
GROUP BY a.account_id, a.account_type;

-- 39. Transactions made in 2024
SELECT * FROM Transactions
WHERE YEAR(transaction_date) = 2024;

-- 40. List users with feedback ratings and comments
SELECT u.name, f.rating, f.comment
FROM Users u
JOIN Feedbacks f ON u.user_id = f.user_id;

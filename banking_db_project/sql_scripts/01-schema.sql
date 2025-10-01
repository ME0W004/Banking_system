
CREATE DATABASE IF NOT EXISTS banking_system;
USE banking_system;

-- =============================================
--  branches 
-- =============================================
CREATE TABLE branches (
    branch_id INT PRIMARY KEY AUTO_INCREMENT,
    branch_name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    phone_number VARCHAR(15)
);

-- =============================================
--  customers
-- =============================================
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(100) UNIQUE,
    address VARCHAR(255),
    birth_date DATE,
    national_id VARCHAR(10) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
--  accounts
-- =============================================
CREATE TABLE accounts (
    account_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    branch_id INT,
    account_number VARCHAR(20) UNIQUE NOT NULL,
    account_type ENUM('checking', 'saving', 'loan') NOT NULL,
    balance DECIMAL(15, 2) DEFAULT 0.00,
    status ENUM('active', 'inactive', 'closed') DEFAULT 'active',
    open_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT, 

    FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL 
);

-- =============================================
--  transactions
-- =============================================
CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT NOT NULL,
    amount DECIMAL(15, 2) NOT NULL,
    transaction_type ENUM('Deposit', 'Withdraw', 'Transfer') NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    description VARCHAR(255),
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE INDEX idx_customer_lastname ON customers(last_name);
CREATE INDEX idx_account_number ON accounts(account_number);
CREATE INDEX idx_transaction_date ON transactions(transaction_date);


-- =============================================
-- (Employees)
-- =============================================
CREATE TABLE IF NOT EXISTS employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(15),
    hire_date DATE NOT NULL,
    job_title VARCHAR(50),
    branch_id INT,
    FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
);


-- =============================================
--  Customers (enhancements)
-- =============================================
ALTER TABLE customers
    ADD COLUMN customer_type ENUM('personal', 'business', 'premium') NOT NULL DEFAULT 'personal' AFTER last_name,
    ADD COLUMN risk_level TINYINT DEFAULT 1 COMMENT '1=Low, 2=Medium, 3=High' AFTER birth_date,
    ADD COLUMN relationship_manager_id INT NULL AFTER risk_level,
    ADD CONSTRAINT fk_customer_manager
        FOREIGN KEY (relationship_manager_id) REFERENCES employees(employee_id)
        ON DELETE SET NULL; 


-- =============================================
-- Accounts(enhancements)
-- =============================================
ALTER TABLE accounts
    ADD COLUMN iban VARCHAR(34) UNIQUE NULL AFTER account_number,
    ADD COLUMN swift_code VARCHAR(11) NULL AFTER iban,
    ADD COLUMN interest_rate DECIMAL(5, 2) DEFAULT 0.00 AFTER balance;


-- =============================================
-- Transactions(enhancements)
-- =============================================
ALTER TABLE transactions
    ADD COLUMN status ENUM('pending', 'completed', 'failed', 'reverted') NOT NULL DEFAULT 'completed' AFTER amount,
    ADD COLUMN reference_code VARCHAR(50) UNIQUE NULL AFTER status,
    ADD COLUMN channel ENUM('online', 'atm', 'teller', 'mobile') NULL AFTER reference_code,
    ADD COLUMN related_transaction_id INT NULL AFTER channel,
    ADD CONSTRAINT fk_related_transaction
        FOREIGN KEY (related_transaction_id) REFERENCES transactions(transaction_id)
        ON DELETE SET NULL;
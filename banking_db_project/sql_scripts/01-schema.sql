
CREATE DATABASE IF NOT EXISTS banking_system;
USE banking_system;

-- =============================================
--  branches (شعب)
-- =============================================
CREATE TABLE branches (
    branch_id INT PRIMARY KEY AUTO_INCREMENT,
    branch_name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    phone_number VARCHAR(15)
);

-- =============================================
--  customers (مشتریان)
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
-- جدول: accounts (حساب‌ها)
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
--  transactions (تراکنش‌ها)
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
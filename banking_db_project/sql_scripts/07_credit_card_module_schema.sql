
USE banking_system;

-- =============================================
-- Credit Cards

-- =============================================
CREATE TABLE IF NOT EXISTS credit_cards (
    card_id INT PRIMARY KEY AUTO_INCREMENT,
    main_account_id INT NOT NULL,
    card_number_hash VARCHAR(256) NOT NULL UNIQUE COMMENT 'Hashed card number using SHA2-256',
    expiry_date DATE NOT NULL,
    cvv_hash VARCHAR(256) NOT NULL COMMENT 'Hashed CVV using SHA2-256',
    cardholder_name VARCHAR(100) NOT NULL,
    credit_limit DECIMAL(15, 2) NOT NULL,
    available_credit DECIMAL(15, 2) NOT NULL,
    status ENUM('active', 'blocked', 'expired', 'lost') NOT NULL DEFAULT 'active',
    issue_date DATE NOT NULL,

    FOREIGN KEY (main_account_id) REFERENCES accounts(account_id)
);


-- =============================================
-- Card Transactions

-- =============================================
CREATE TABLE IF NOT EXISTS card_transactions (
    card_transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    card_id INT NOT NULL,
    merchant_name VARCHAR(100) NOT NULL,
    amount DECIMAL(15, 2) NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('approved', 'declined', 'reverted') NOT NULL DEFAULT 'approved',

    FOREIGN KEY (card_id) REFERENCES credit_cards(card_id)
);
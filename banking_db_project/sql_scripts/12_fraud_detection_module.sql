
USE banking_system;


-- =============================================
CREATE TABLE IF NOT EXISTS fraud_rules (
    rule_id INT PRIMARY KEY AUTO_INCREMENT,
    rule_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    threshold_amount DECIMAL(15, 2) NULL,
    threshold_count INT NULL,
    time_window_minutes INT NULL,
    is_active BOOLEAN DEFAULT TRUE
);


-- =============================================
CREATE TABLE IF NOT EXISTS suspicious_activity_log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT NOT NULL,
    transaction_id INT NOT NULL,
    triggered_rule_id INT NOT NULL,
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    details VARCHAR(255),

    FOREIGN KEY (account_id) REFERENCES accounts(account_id),
    FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id),
    FOREIGN KEY (triggered_rule_id) REFERENCES fraud_rules(rule_id)
);


DELIMITER $$


-- =============================================
CREATE TRIGGER trg_check_for_suspicious_activity
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
    DECLARE v_large_tx_rule_id INT;
    DECLARE v_high_freq_rule_id INT;
    DECLARE v_threshold_amount DECIMAL(15, 2);
    DECLARE v_threshold_count INT;
    DECLARE v_time_window INT;
    DECLARE v_transaction_count INT;

    SELECT rule_id, threshold_amount INTO v_large_tx_rule_id, v_threshold_amount
    FROM fraud_rules WHERE rule_name = 'LARGE_TRANSACTION_AMOUNT' AND is_active = TRUE;
    
    IF ABS(NEW.amount) > v_threshold_amount THEN
        INSERT INTO suspicious_activity_log (account_id, transaction_id, triggered_rule_id, details)
        VALUES (NEW.account_id, NEW.transaction_id, v_large_tx_rule_id, CONCAT('Transaction amount ', ABS(NEW.amount), ' exceeded threshold of ', v_threshold_amount));
        
        UPDATE accounts SET status = 'inactive' WHERE account_id = NEW.account_id;
    END IF;

    SELECT rule_id, threshold_count, time_window_minutes INTO v_high_freq_rule_id, v_threshold_count, v_time_window
    FROM fraud_rules WHERE rule_name = 'HIGH_FREQUENCY_TRANSACTIONS' AND is_active = TRUE;

    SELECT COUNT(*) INTO v_transaction_count
    FROM transactions
    WHERE account_id = NEW.account_id
      AND transaction_date >= NOW() - INTERVAL v_time_window MINUTE;

    IF v_transaction_count > v_threshold_count THEN
        INSERT INTO suspicious_activity_log (account_id, transaction_id, triggered_rule_id, details)
        VALUES (NEW.account_id, NEW.transaction_id, v_high_freq_rule_id, CONCAT(v_transaction_count, ' transactions in the last ', v_time_window, ' minutes.'));
        
        UPDATE accounts SET status = 'inactive' WHERE account_id = NEW.account_id;
    END IF;

END$$

DELIMITER ;



-- =============================================
INSERT INTO fraud_rules (rule_name, description, threshold_amount, threshold_count, time_window_minutes) VALUES
('LARGE_TRANSACTION_AMOUNT', 'Flags any single transaction (deposit or withdrawal) over a specific amount.', 10000.00, NULL, NULL),
('HIGH_FREQUENCY_TRANSACTIONS', 'Flags an account if it performs too many transactions in a short period.', NULL, 5, 10);
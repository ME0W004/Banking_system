
USE banking_system;

CREATE TABLE IF NOT EXISTS audit_log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    table_name VARCHAR(50),
    record_id INT,
    action_type VARCHAR(10),
    old_value TEXT,
    new_value TEXT,
    changed_by VARCHAR(100),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$

-- =============================================
CREATE TRIGGER trg_after_transaction_update_balance
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
    UPDATE accounts
    SET balance = balance + NEW.amount
    WHERE account_id = NEW.account_id;

    IF (SELECT balance FROM accounts WHERE account_id = NEW.account_id) < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaction failed: Insufficient funds.';
    END IF;
END$$


-- =============================================
CREATE TRIGGER trg_audit_customer_changes
AFTER UPDATE ON customers
FOR EACH ROW
BEGIN
    IF OLD.email <> NEW.email OR OLD.address <> NEW.address THEN
        INSERT INTO audit_log (table_name, record_id, action_type, old_value, new_value, changed_by)
        VALUES (
            'customers',
            OLD.customer_id,
            'UPDATE',
            CONCAT('Old Email: ', OLD.email, ', Old Address: ', OLD.address),
            CONCAT('New Email: ', NEW.email, ', New Address: ', NEW.address),
            USER() 
        );
    END IF;
END$$

DELIMITER ;
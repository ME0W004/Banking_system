
USE banking_system;


-- =============================================
CREATE TABLE IF NOT EXISTS monthly_statements (
    statement_id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT NOT NULL,
    statement_month INT NOT NULL,
    statement_year INT NOT NULL,
    opening_balance DECIMAL(15, 2) NOT NULL,
    closing_balance DECIMAL(15, 2) NOT NULL,
    total_deposits DECIMAL(15, 2) NOT NULL,
    total_withdrawals DECIMAL(15, 2) NOT NULL,
    interest_earned DECIMAL(15, 2) DEFAULT 0.00,
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    UNIQUE KEY (account_id, statement_month, statement_year),
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);


DELIMITER $$


-- =============================================
CREATE PROCEDURE sp_calculate_and_apply_interest()
BEGIN

    DECLARE done INT DEFAULT FALSE;
    DECLARE current_account_id INT;
    DECLARE current_balance DECIMAL(15, 2);
    DECLARE annual_rate DECIMAL(5, 2);
    DECLARE monthly_interest DECIMAL(15, 2);


    DECLARE saving_accounts_cursor CURSOR FOR
        SELECT account_id, balance, interest_rate
        FROM accounts
        WHERE account_type = 'saving' AND status = 'active';


    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN saving_accounts_cursor;


    account_loop: LOOP

        FETCH saving_accounts_cursor INTO current_account_id, current_balance, annual_rate;

        IF done THEN
            LEAVE account_loop;
        END IF;

        SET monthly_interest = (current_balance * (annual_rate / 100)) / 12;

        IF monthly_interest > 0 THEN

            START TRANSACTION;

            INSERT INTO transactions (account_id, amount, transaction_type, status, description)
            VALUES (current_account_id, monthly_interest, 'Deposit', 'completed', 'Monthly Interest Earned');

            UPDATE accounts
            SET balance = balance + monthly_interest
            WHERE account_id = current_account_id;
            
            COMMIT;
        END IF;

    END LOOP;

    CLOSE saving_accounts_cursor;

END$$

DELIMITER ;

-- =============================================


DELIMITER $$

-- =============================================
CREATE PROCEDURE sp_generate_monthly_statements(
    IN p_year INT,
    IN p_month INT
)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE current_account_id INT;
    DECLARE current_closing_balance DECIMAL(15, 2);

    DECLARE v_total_deposits DECIMAL(15, 2);
    DECLARE v_total_withdrawals DECIMAL(15, 2);
    DECLARE v_interest_earned DECIMAL(15, 2);
    DECLARE v_opening_balance DECIMAL(15, 2);

    DECLARE accounts_cursor CURSOR FOR
        SELECT account_id, balance FROM accounts WHERE status = 'active';

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN accounts_cursor;

    account_statement_loop: LOOP
        FETCH accounts_cursor INTO current_account_id, current_closing_balance;

        IF done THEN
            LEAVE account_statement_loop;
        END IF;

        SELECT IFNULL(SUM(amount), 0)
        INTO v_total_deposits
        FROM transactions
        WHERE account_id = current_account_id
          AND YEAR(transaction_date) = p_year
          AND MONTH(transaction_date) = p_month
          AND amount > 0;

        SELECT IFNULL(SUM(amount), 0)
        INTO v_total_withdrawals
        FROM transactions
        WHERE account_id = current_account_id
          AND YEAR(transaction_date) = p_year
          AND MONTH(transaction_date) = p_month
          AND amount < 0;
          
        SELECT IFNULL(SUM(amount), 0)
        INTO v_interest_earned
        FROM transactions
        WHERE account_id = current_account_id
          AND YEAR(transaction_date) = p_year
          AND MONTH(transaction_date) = p_month
          AND transaction_type = 'Deposit' AND description LIKE 'Monthly Interest%';

       
        SET v_opening_balance = current_closing_balance - (v_total_deposits + v_total_withdrawals);
        
        
        INSERT INTO monthly_statements (
            account_id, statement_year, statement_month,
            opening_balance, closing_balance, total_deposits, total_withdrawals, interest_earned
        )
        VALUES (
            current_account_id, p_year, p_month,
            v_opening_balance, current_closing_balance, v_total_deposits, ABS(v_total_withdrawals), v_interest_earned
        )
        ON DUPLICATE KEY UPDATE
            opening_balance = v_opening_balance,
            closing_balance = current_closing_balance,
            total_deposits = v_total_deposits,
            total_withdrawals = ABS(v_total_withdrawals),
            interest_earned = v_interest_earned,
            generated_at = NOW();

    END LOOP;

    CLOSE accounts_cursor;

END$$

DELIMITER ;
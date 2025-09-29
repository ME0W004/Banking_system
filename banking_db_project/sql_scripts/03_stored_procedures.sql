
USE banking_system;

DELIMITER $$

CREATE PROCEDURE sp_transfer_money(
    IN from_account_id INT,
    IN to_account_id INT,
    IN transfer_amount DECIMAL(15, 2)
)
BEGIN
    DECLARE from_balance DECIMAL(15, 2);

    START TRANSACTION;

    IF transfer_amount <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transfer amount must be positive.';
        ROLLBACK;
    ELSE
        SELECT balance INTO from_balance FROM accounts WHERE account_id = from_account_id FOR UPDATE;

        IF from_balance >= transfer_amount THEN
            UPDATE accounts
            SET balance = balance - transfer_amount
            WHERE account_id = from_account_id;

            UPDATE accounts
            SET balance = balance + transfer_amount
            WHERE account_id = to_account_id;

            INSERT INTO transactions (account_id, amount, transaction_type, description)
            VALUES (from_account_id, -transfer_amount, 'Transfer', CONCAT('Transfer to account ', to_account_id));

            INSERT INTO transactions (account_id, amount, transaction_type, description)
            VALUES (to_account_id, transfer_amount, 'Transfer', CONCAT('Transfer from account ', from_account_id));

            COMMIT;
        ELSE
            ROLLBACK;
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient balance.';
        END IF;
    END IF;
END$$

DELIMITER ;
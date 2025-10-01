
USE banking_system;

DELIMITER $$


-- =============================================
CREATE PROCEDURE sp_issue_new_credit_card(
    IN p_main_account_id INT,
    IN p_card_number VARCHAR(19), 
    IN p_cvv VARCHAR(4),          
    IN p_expiry_date DATE,
    IN p_cardholder_name VARCHAR(100),
    IN p_credit_limit DECIMAL(15, 2)
)
BEGIN
    INSERT INTO credit_cards (
        main_account_id,
        card_number_hash,
        cvv_hash,
        expiry_date,
        cardholder_name,
        credit_limit,
        available_credit, 
        issue_date
    )
    VALUES (
        p_main_account_id,
        SHA2(p_card_number, 256), -- hashing with SHA2-256 algorithm
        SHA2(p_cvv, 256),         
        p_expiry_date,
        p_cardholder_name,
        p_credit_limit,
        p_credit_limit,
        CURDATE()
    );
END$$



-- =============================================
CREATE PROCEDURE sp_process_card_transaction(
    IN p_card_id INT,
    IN p_merchant_name VARCHAR(100),
    IN p_amount DECIMAL(15, 2)
)
BEGIN
    DECLARE v_available_credit DECIMAL(15, 2);
    DECLARE v_card_status ENUM('active', 'blocked', 'expired', 'lost');


    START TRANSACTION;

    SELECT available_credit, status
    INTO v_available_credit, v_card_status
    FROM credit_cards
    WHERE card_id = p_card_id FOR UPDATE;

    IF v_card_status = 'active' AND v_available_credit >= p_amount THEN
        UPDATE credit_cards
        SET available_credit = available_credit - p_amount
        WHERE card_id = p_card_id;

        INSERT INTO card_transactions (card_id, merchant_name, amount, status)
        VALUES (p_card_id, p_merchant_name, p_amount, 'approved');

        COMMIT;
    ELSE
        INSERT INTO card_transactions (card_id, merchant_name, amount, status)
        VALUES (p_card_id, p_merchant_name, p_amount, 'declined');

        ROLLBACK;

        IF v_card_status <> 'active' THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaction declined: Card is not active.';
        ELSE
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaction declined: Insufficient credit.';
        END IF;
    END IF;
END$$



-- =============================================
CREATE PROCEDURE sp_block_card(
    IN p_card_id INT
)
BEGIN
    UPDATE credit_cards
    SET status = 'blocked'
    WHERE card_id = p_card_id;
END$$

DELIMITER ;
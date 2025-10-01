
USE banking_system;

DELIMITER $$


-- =============================================
CREATE PROCEDURE sp_apply_for_loan(
    IN p_customer_id INT,
    IN p_loan_type_id INT,
    IN p_amount_requested DECIMAL(15, 2)
)
BEGIN
    INSERT INTO loan_applications (customer_id, loan_type_id, amount_requested)
    VALUES (p_customer_id, p_loan_type_id, p_amount_requested);
END$$



-- =============================================
CREATE FUNCTION fn_calculate_monthly_installment(
    p_principal DECIMAL(15, 2), 
    p_annual_rate DECIMAL(5, 4), 
    p_term_months INT 
)
RETURNS DECIMAL(15, 2)
DETERMINISTIC
BEGIN
    DECLARE monthly_rate DECIMAL(10, 6);
    DECLARE monthly_installment DECIMAL(15, 2);

    IF p_annual_rate = 0 THEN
        RETURN p_principal / p_term_months;
    END IF;

    SET monthly_rate = p_annual_rate / 12;
    SET monthly_installment = p_principal * (monthly_rate * POW(1 + monthly_rate, p_term_months)) / (POW(1 + monthly_rate, p_term_months) - 1);

    RETURN monthly_installment;
END$$



-- =============================================
CREATE PROCEDURE sp_approve_loan(
    IN p_application_id INT,
    IN p_employee_id INT,
    IN p_customer_checking_account_id INT
)
BEGIN
    DECLARE v_customer_id INT;
    DECLARE v_amount DECIMAL(15, 2);
    DECLARE v_loan_account_id INT;

    START TRANSACTION;

    SELECT customer_id, amount_requested
    INTO v_customer_id, v_amount
    FROM loan_applications
    WHERE application_id = p_application_id AND status = 'under_review';

    IF v_customer_id IS NOT NULL THEN
        UPDATE loan_applications
        SET
            status = 'approved',
            reviewed_by_employee_id = p_employee_id,
            decision_date = NOW()
        WHERE application_id = p_application_id;

     INSERT INTO accounts (customer_id, account_number, account_type, balance, status)
        VALUES (v_customer_id, CONCAT('LOAN-', LPAD(p_application_id, 8, '0')), 'loan', -v_amount, 'active');

        SET v_loan_account_id = LAST_INSERT_ID();

        UPDATE accounts
        SET balance = balance + v_amount
        WHERE account_id = p_customer_checking_account_id;

        INSERT INTO transactions (account_id, amount, transaction_type, status, description, reference_code)
        VALUES (p_customer_checking_account_id, v_amount, 'Deposit', 'completed', CONCAT('Loan disbursement from loan account ', v_loan_account_id), UUID());

        COMMIT;
    ELSE
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Loan application not found or not in a reviewable state.';
    END IF;
END$$

DELIMITER ;
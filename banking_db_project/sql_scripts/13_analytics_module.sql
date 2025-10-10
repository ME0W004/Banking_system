

USE banking_system;


CREATE TABLE IF NOT EXISTS daily_branch_summary (
    summary_id INT PRIMARY KEY AUTO_INCREMENT,
    summary_date DATE NOT NULL,
    branch_id INT NOT NULL,
    total_deposits DECIMAL(20, 2) DEFAULT 0.00,
    total_withdrawals DECIMAL(20, 2) DEFAULT 0.00,
    transaction_count INT DEFAULT 0,
    net_flow DECIMAL(20, 2) DEFAULT 0.00,

    UNIQUE KEY (summary_date, branch_id),
    FOREIGN KEY (branch_id) REFERENCES branches(branch_id)
);


DELIMITER $$


CREATE PROCEDURE sp_generate_daily_summary(
    IN p_date DATE
)
BEGIN

    DELETE FROM daily_branch_summary WHERE summary_date = p_date;


    INSERT INTO daily_branch_summary (
        summary_date,
        branch_id,
        total_deposits,
        total_withdrawals,
        transaction_count,
        net_flow
    )
    SELECT
        p_date,
        b.branch_id,

        IFNULL(SUM(CASE WHEN t.amount > 0 THEN t.amount ELSE 0 END), 0) AS total_deposits,

        ABS(IFNULL(SUM(CASE WHEN t.amount < 0 THEN t.amount ELSE 0 END), 0)) AS total_withdrawals,

        COUNT(t.transaction_id) AS transaction_count,

        IFNULL(SUM(t.amount), 0) AS net_flow
    FROM
        transactions t
    JOIN
        accounts a ON t.account_id = a.account_id
    JOIN
        branches b ON a.branch_id = b.branch_id
    WHERE
        DATE(t.transaction_date) = p_date
    GROUP BY
        b.branch_id;

END$$

DELIMITER ;
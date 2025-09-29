
USE banking_system;

-- =============================================
CREATE OR REPLACE VIEW CustomerTotalBalance AS
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(a.balance) AS total_balance
FROM
    customers c
JOIN
    accounts a ON c.customer_id = a.customer_id
GROUP BY
    c.customer_id, c.first_name, c.last_name;
-- =============================================

CREATE OR REPLACE VIEW TopActiveCustomers AS
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(t.transaction_id) AS transaction_count
FROM
    customers c
JOIN
    accounts a ON c.customer_id = a.customer_id
JOIN
    transactions t ON a.account_id = t.account_id
GROUP BY
    c.customer_id, c.first_name, c.last_name
ORDER BY
    transaction_count DESC;
    -- =============================================
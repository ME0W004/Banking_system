
USE banking_system;


INSERT INTO branches (branch_name, address, phone_number) VALUES
('Central Branch', '123 Finance St, Metropolis', '555-0101'),
('Northside Branch', '456 Oak Ave, Gotham', '555-0102'),
('Westend Branch', '789 Pine Ln, Star City', '555-0103');

INSERT INTO loan_types (type_name, base_interest_rate, max_term_months, description) VALUES
('Personal Loan', 18.50, 60, 'Unsecured personal loan for various purposes.'),
('Mortgage Loan', 7.20, 360, 'Loan for purchasing real estate.'),
('Auto Loan', 9.75, 72, 'Loan for purchasing new or used vehicles.');

INSERT INTO security_roles (role_name) VALUES
('Teller'), ('Loan Officer'), ('Branch Manager'), ('System Admin');

--  Permissions
INSERT INTO role_permissions (role_id, permission_key) VALUES
(1, 'CAN_VIEW_CUSTOMER_INFO'), (1, 'CAN_PROCESS_DEPOSIT'), (1, 'CAN_PROCESS_WITHDRAWAL');
-- Loan Officer Permissions
INSERT INTO role_permissions (role_id, permission_key) VALUES
(2, 'CAN_VIEW_CUSTOMER_INFO'), (2, 'CAN_REVIEW_LOAN_APPLICATIONS');

-- Branch Manager Permissions
INSERT INTO role_permissions (role_id, permission_key) VALUES
(3, 'CAN_VIEW_CUSTOMER_INFO'), (3, 'CAN_PROCESS_DEPOSIT'), (3, 'CAN_PROCESS_WITHDRAWAL'),
(3, 'CAN_REVIEW_LOAN_APPLICATIONS'), (3, 'CAN_APPROVE_LOAN'), (3, 'CAN_MANAGE_EMPLOYEES');

-- System Admin Permissions
INSERT INTO role_permissions (role_id, permission_key) VALUES
(4, 'FULL_SYSTEM_ACCESS');




INSERT INTO employees (first_name, last_name, email, hire_date, job_title, branch_id, role_id, manager_id, password_hash) VALUES
('Alice', 'Wonder', 'alice.w@bank.com', '2022-01-15', 'Branch Manager', 1, 3, NULL, SHA2('adminpass123', 256)),
('Bob', 'Builder', 'bob.b@bank.com', '2023-03-20', 'Loan Officer', 1, 2, 1, SHA2('loanpass123', 256)),
('Charlie', 'Chaplin', 'charlie.c@bank.com', '2023-05-10', 'Teller', 1, 1, 1, SHA2('tellerpass123', 256)),
('Diana', 'Prince', 'diana.p@bank.com', '2022-06-01', 'Branch Manager', 2, 3, NULL, SHA2('adminpass456', 256)),
('Eve', 'Online', 'eve.o@bank.com', '2024-01-01', 'Teller', 2, 1, 4, SHA2('tellerpass456', 256));



INSERT INTO customers (first_name, last_name, customer_type, phone, email, address, birth_date, risk_level, relationship_manager_id, national_id) VALUES
('John', 'Doe', 'personal', '555-1111', 'john.doe@email.com', '1 Apple Park', '1990-05-20', 1, 3, '1111111111'),
('Jane', 'Smith', 'premium', '555-2222', 'jane.smith@email.com', '2 Microsoft Way', '1985-11-15', 1, 1, '2222222222'),
('Peter', 'Jones', 'business', '555-3333', 'peter.jones.biz@email.com', '3 Amazon Blvd', '1978-02-10', 2, 1, '3333333333'),
('Bruce', 'Wayne', 'premium', '555-4444', 'bruce@wayne.enterprises', 'Wayne Manor, Gotham', '1972-04-17', 1, 4, '4444444444'),
('Clark', 'Kent', 'personal', '555-5555', 'clark.kent@dailyplanet.com', 'Kent Farm, Smallville', '1980-06-18', 1, NULL, '5555555555');



INSERT INTO accounts (customer_id, branch_id, account_number, account_type, balance, iban, swift_code, interest_rate) VALUES
(1, 1, 'CHK-001', 'checking', 2500.00, 'US001001', 'BANKUSM1', 0.00),
(1, 1, 'SAV-001', 'saving', 15000.00, 'US001002', 'BANKUSM1', 2.50),
(2, 1, 'CHK-002', 'checking', 125000.00, 'US002001', 'BANKUSM1', 0.00),
(3, 2, 'CHK-003', 'checking', 750000.00, 'US003001', 'BANKUSM1', 0.00),
(4, 2, 'CHK-004', 'checking', 10000000.00, 'US004001', 'BANKUSM1', 0.00),
(4, 2, 'SAV-004', 'saving', 50000000.00, 'US004002', 'BANKUSM1', 3.10),
(5, 1, 'CHK-005', 'checking', 850.75, 'US005001', 'BANKUSM1', 0.00);

INSERT INTO online_users (customer_id, username, password_hash, status) VALUES
(1, 'johndoe', SHA2('pass1', 256), 'active'),
(2, 'janesmith', SHA2('pass2', 256), 'active'),
(3, 'peterjones', SHA2('pass3', 256), 'active'),
(4, 'batman', SHA2('iambatman', 256), 'active');

-- CALL sp_issue_new_credit_card(main_account_id, card_number, cvv, expiry_date, cardholder_name, credit_limit)
CALL sp_issue_new_credit_card(1, '4111-1111-1111-1111', '123', '2028-12-31', 'John Doe', 5000.00);
CALL sp_issue_new_credit_card(3, '4222-2222-2222-2222', '456', '2027-10-31', 'Jane Smith', 25000.00);
CALL sp_issue_new_credit_card(5, '4333-3333-3333-3333', '789', '2029-08-31', 'Bruce Wayne', 1000000.00);

UPDATE credit_cards SET status = 'blocked' WHERE card_id = 3;



INSERT INTO loan_applications (customer_id, loan_type_id, amount_requested, status, reviewed_by_employee_id) VALUES
(1, 3, 20000.00, 'approved', 2), -- Approved
(2, 2, 750000.00, 'under_review', 2), -- Under Review
(5, 1, 5000.00, 'pending', NULL), -- Pending
(1, 1, 10000.00, 'rejected', 2); -- Rejected

INSERT INTO accounts (customer_id, branch_id, account_number, account_type, balance) VALUES
(1, 1, 'LOAN-001', 'loan', -20000.00);

UPDATE accounts SET balance = balance + 20000 WHERE account_id = 1;



CALL sp_transfer_money(1, 3, 500.00);


INSERT INTO transactions (account_id, amount, transaction_type, status, reference_code, channel, description) VALUES
(1, 1000.00, 'Deposit', 'completed', UUID(), 'teller', 'Cash Deposit'),
(3, -25000.00, 'Withdraw', 'completed', UUID(), 'atm', 'ATM Withdrawal'),
(5, -50.00, 'Withdraw', 'completed', UUID(), 'atm', 'ATM Withdrawal');


CALL sp_process_card_transaction(1, 'Amazon.com', 75.50);
CALL sp_process_card_transaction(2, 'Wayne Enterprises Gala', 5000.00); 
CALL sp_process_card_transaction(3, 'Ace Chemicals', 100.00);  -- Will be declined because card is not active.


INSERT INTO loan_payments (loan_account_id, amount_paid, principal_amount, interest_amount) VALUES
(8, 600.00, 500.00, 100.00);
UPDATE accounts SET balance = balance + 600.00 WHERE account_id = 8;
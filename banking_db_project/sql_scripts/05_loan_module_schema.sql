
USE banking_system;

-- ==============
CREATE TABLE IF NOT EXISTS loan_types (
    loan_type_id INT PRIMARY KEY AUTO_INCREMENT,
    type_name VARCHAR(50) NOT NULL UNIQUE, 
    base_interest_rate DECIMAL(5, 2) NOT NULL,
    max_term_months INT NOT NULL,
    description TEXT
);



-- =============================================
CREATE TABLE IF NOT EXISTS loan_applications (
    application_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    loan_type_id INT NOT NULL,
    amount_requested DECIMAL(15, 2) NOT NULL,
    status ENUM('pending', 'under_review', 'approved', 'rejected') NOT NULL DEFAULT 'pending',
    application_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reviewed_by_employee_id INT NULL,
    decision_date TIMESTAMP NULL,

    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (loan_type_id) REFERENCES loan_types(loan_type_id),
    FOREIGN KEY (reviewed_by_employee_id) REFERENCES employees(employee_id)
);



-- =============================================
CREATE TABLE IF NOT EXISTS loan_payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    -- توجه: وام تایید شده یک نوع حساب در جدول accounts است
    loan_account_id INT NOT NULL,
    amount_paid DECIMAL(15, 2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    principal_amount DECIMAL(15, 2) NOT NULL,
    interest_amount DECIMAL(15, 2) NOT NULL,
    notes TEXT,

    FOREIGN KEY (loan_account_id) REFERENCES accounts(account_id)
);
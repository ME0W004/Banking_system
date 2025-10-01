
USE banking_system;

-- =============================================
--  (Security Roles)
-- =============================================
CREATE TABLE IF NOT EXISTS security_roles (
    role_id INT PRIMARY KEY AUTO_INCREMENT,
    role_name VARCHAR(50) NOT NULL UNIQUE COMMENT 'e.g., Teller, Branch Manager, Loan Officer, Admin'
);


-- =============================================
--  (Permissions)
-- =============================================
CREATE TABLE IF NOT EXISTS role_permissions (
    permission_id INT PRIMARY KEY AUTO_INCREMENT,
    role_id INT NOT NULL,
    permission_key VARCHAR(100) NOT NULL COMMENT 'e.g., CAN_APPROVE_LOAN, CAN_CREATE_CUSTOMER',
    
    UNIQUE KEY (role_id, permission_key),
    FOREIGN KEY (role_id) REFERENCES security_roles(role_id) ON DELETE CASCADE
);


-- =============================================
--  update Employees
-- =============================================
ALTER TABLE employees
    ADD COLUMN role_id INT NULL AFTER job_title,
    ADD COLUMN manager_id INT NULL COMMENT 'Self-referencing key to the same table',
    ADD COLUMN password_hash VARCHAR(256) NOT NULL COMMENT 'Hashed password for internal system login',
    ADD CONSTRAINT fk_employee_role FOREIGN KEY (role_id) REFERENCES security_roles(role_id),
    ADD CONSTRAINT fk_employee_manager FOREIGN KEY (manager_id) REFERENCES employees(employee_id);


-- =============================================
--  (Online Users)
-- =============================================
CREATE TABLE IF NOT EXISTS online_users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(256) NOT NULL,
    last_login TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('active', 'locked', 'pending_verification') NOT NULL DEFAULT 'pending_verification',

    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
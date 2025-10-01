# Banking Management System Database

A comprehensive and professional database project for a **Banking Management System (BMS)**, designed and implemented using **MySQL**. This project emphasizes a scalable data structure, complex transactional business logic directly within the database, and strong security practices.

## Table of Contents

* [Key Features](#key-features)
* [Technologies Used](#technologies-used)
* [Project Structure](#project-structure)
* [Setup and Execution](#setup-and-execution)
* [Security Measures](#security-measures)

---

## Key Features

This database is built to handle the core operations of a modern bank, featuring:

| Feature | Description |
| :--- | :--- |
| **Modular Design** | Separation into core banking, **Loan Management**, and **Credit Card Management** modules. |
| **Transactional Logic** | Sensitive operations (e.g., **fund transfers**, loan disbursements) are handled via **Stored Procedures** to ensure Atomicity (ACID). |
| **Business Rule Automation** | **Triggers** automatically enforce business rules, such as checking for minimum balance before a withdrawal. |
| **Data Security** | Implementation of **hashing** (simulated) for sensitive customer data like passwords and credit card numbers. |
| **Access Control (RBAC)** | A **Role-Based Access Control** model defines permissions for bank employees and managers. |
| **Performance Optimization** | Effective use of **Indexing** to optimize query performance on frequently accessed columns (e.g., account numbers, customer IDs). |

---

## Technologies Used

* **Database:** MySQL
* **Core Features:**
    * **Stored Procedures** (for business logic)
    * **Triggers** (for rule enforcement)
    * **Functions** (for complex calculations)
    * **Transactions** (for data integrity)
    * **Role-Based Access Control (RBAC)** modeling
    * **Advanced Indexing**

---

## Project Structure

The repository is structured as follows:

banking-management-system/
├── sql_scripts/
│   ├── 01_schema.sql                # Table definitions and initial database creation
│   ├── 02_views.sql                 # Definition of reporting and complex views
│   ├── 03_stored_procedures.sql     # Core procedures (e.g., TransferFunds)
│   ├── 04_triggers.sql              # Logic for automatic rule checks
│   ├── 06_loan_module_schema.sql    # Tables for loan management
│   ├── 07_loan_module_logic.sql     # Procedures for loan approval/payment
│   ├── 10_internal_security_schema.sql # RBAC tables for employees
│   └── 11_sample_data.sql           # Populates the database with test data
├── documentation/
│   └── banking_system_erd.png       # Complete Entity-Relationship Diagram
└── README.md


---

## Setup and Execution

To deploy the complete database structure, logic, and sample data on your local MySQL server, execute the scripts in the **`sql_scripts`** directory in the **exact order** listed below.

### Execution Order

Run these files sequentially using your MySQL client (e.g., MySQL Workbench, `mysql` CLI):

```bash
# Order of execution:

1. 01_schema.sql
2. 02_views.sql
3. 03_stored_procedures.sql
4. 04_triggers.sql
5. 05_core_system_enhancements.sql 
6. 06_loan_module_schema.sql
7. 07_loan_module_logic.sql
8. 08_credit_card_module_schema.sql
9. 09_credit_card_module_logic.sql
10. 10_internal_security_schema.sql
11. 11_sample_data.sql
After execution, the database named banking_system will be fully operational, ready for testing and integration.

Security Measures
Security is paramount in banking systems. This database implements the following security features:

Password Hashing: Passwords and sensitive PII are not stored in plain text. (The scripts use a placeholder function for demonstration).

Transaction Management: Critical operations are wrapped in explicit transactions to prevent partial updates and data corruption.

Principle of Least Privilege: The RBAC model ensures employees can only access the data and execute the procedures necessary for their specific role.

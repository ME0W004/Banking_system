# Banking Management System Database

A comprehensive and professional database project for a **Banking Management System (BMS)**, designed and implemented using **MySQL**. This project emphasizes a scalable data structure, complex transactional business logic directly within the database, and strong security practices.

## Table of Contents

* [Key Features](#key-features)
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
5. 05_loan_module_schema.sql
6. 06_loan_module_logic.sql
7. 07_credit_card_module_schema.sql
8. 08_credit_card_module_logic.sql
9. 09_internal_security_schema.sql
10. 10_sample_data.sql
```
After execution, the database named banking_system will be fully operational, ready for testing and integration.

## Security Measures
Security is paramount in banking systems. This database implements the following security features:

Password Hashing: Passwords and sensitive PII are not stored in plain text. (The scripts use a placeholder function for demonstration).

Transaction Management: Critical operations are wrapped in explicit transactions to prevent partial updates and data corruption.

Principle of Least Privilege: The RBAC model ensures employees can only access the data and execute the procedures necessary for their specific role.



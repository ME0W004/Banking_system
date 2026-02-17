#  Core Banking Database Infrastructure

![MySQL](https://img.shields.io/badge/Database-MySQL-005C84?style=for-the-badge&logo=mysql&logoColor=white)

##  Project Overview

This repository hosts a comprehensive SQL-based infrastructure designed to simulate a Core Banking System. Unlike simple CRUD applications, this project focuses on the complex backend challenges of the financial sector: Data Integrity, Concurrency Control, Security, and Scalability.

I designed this system to demonstrate advanced RDBMS concepts, proving that critical business logic—such as money transfers, loan amortization, and fraud detection—can be safely encapsulated within the database layer to ensure strict ACID compliance and high performance.

---

##  Engineering & Technical Highlights

I engineered this system with a focus on real-world constraints. Key technical features include:

### 1. ACID Compliance & Transaction Management
* Problem: In banking, partial updates (e.g., money deducted but not credited) are unacceptable.
* My Solution: Implemented robust Stored Procedures (e.g., sp_transfer_money) utilizing Transaction Control Language (TCL).
* Mechanism: Uses START TRANSACTION, COMMIT, and ROLLBACK to ensure Atomicity. If any step fails, the entire operation is reverted to prevent data inconsistency.

### 2. Security-First Architecture (Defense in Depth)
* Cryptography: Implemented SHA-256 Hashing logic within the database to store credit card details (PAN, CVV), adhering to PCI-DSS principles (no plain-text storage of sensitive data).
* RBAC (Role-Based Access Control): Designed a granular permission system. Database users are restricted via Views and Stored Procedures, preventing direct table access based on their role (e.g., Tellers vs. Managers).

### 3. Advanced Business Logic Encapsulation
* Loan Engine: Instead of relying on application-level math, I implemented User-Defined Functions (UDFs) to calculate monthly installments using the Amortization Formula:

  $$M = P \frac{r(1+r)^n}{(1+r)^n - 1}$$

* Automation: Utilized Triggers to automatically update account balances after transactions and log audit trails, ensuring the derived data is always consistent with the raw transaction history.

### 4. Real-Time Fraud Detection (Event-Driven)
* Implemented an intelligent monitoring system using Triggers.
* The system analyzes transaction velocity and amounts in real-time. If an anomaly is detected (e.g., exceeding thresholds), the account is effectively blocked instantly before the transaction commits.

### 5. Performance Optimization (OLTP vs. OLAP)
* OLTP (Online Transaction Processing): The core schema is normalized to 3NF to optimize write speeds for daily operations.
* OLAP (Online Analytical Processing): To prevent reporting queries from locking active tables, I implemented a Data Warehousing strategy using scheduled Events to populate denormalized Summary Tables for fast analytics.

### 6. Data Lifecycle Management
* Archiving Strategy: Designed automated procedures to migrate "Cold Data" (historical transactions) to archive tables, keeping the active indices small and maintaining high insertion throughput.

---

##  Database Schema & Architecture

The database is designed with strict Referential Integrity.
* Foreign Keys: Configured with ON DELETE RESTRICT to prevent orphan records.
* Constraints: Extensive use of UNIQUE and CHECK constraints to validate data at the lowest level (e.g., non-negative balances).

---

##  Repository Structure

The SQL scripts are numbered to represent the logical order of execution for setting up the environment:
| File Name | Description |
| :--- | :--- |
| 01_schema.sql | Core table definitions (Branches, Customers, Accounts, Transactions). |
| 02_views.sql | Reporting views for quick data access (e.g., CustomerTotalBalance). |
| 03_stored_procedures.sql | Main transaction logic enforcing ACID properties (Transfer Money). |
| 04_triggers.sql | Automated balance updates and audit logging mechanism. |
| 05_loan_module_schema.sql | Schema definitions for Loans and Payments. |
| 06_loan_module_logic.sql | Loan application logic and mathematical amortization functions. |
| 07_credit_card_schema.sql | Schema definitions for Credit Cards. |
| 08_credit_card_logic.sql | Credit card issuance and management with SHA-256 hashing. |
| 09_internal_security_rbac.sql | Internal security roles and permission mapping (RBAC). |
| 10_sample_data.sql | Comprehensive mock data for testing all modules. |
| 11_batch_jobs_module.sql | Scheduled events for monthly interest calculations. |
| 12_fraud_detection_module.sql | Real-time anomaly detection triggers. |
| 13_analytics_module.sql | Summary tables for OLAP reporting. |
| 14_archiving_module.sql | Automated data migration for performance optimization. |
| 15_backup_logs.sql | Backup strategy logging and monitoring tables. |

---

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

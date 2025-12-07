# 🌾 AgroTech
## Smart Agriculture Management System Capstone Project

This repository contains the complete SQL and PL/SQL code, documentation, and testing results for the AgroTech Management System.

## Project Summary
AgroTech is a database solution designed to automate critical inventory and scheduling processes for modern farming operations. The system uses advanced PL/SQL programming to ensure data integrity, enforce business rules, and provide actionable Business Intelligence (BI) data.

## Key Features Implemented:
1.  **Automated Transaction Management:** Handled by the `PRC_COMPLETE_TASK` procedure, which updates schedules and deducts inventory in one atomic transaction.
2.  **Explicit Cursor Alerting:** Handled by `PRC_GENERATE_DEADLINE_ALERTS` which uses an explicit cursor to identify tasks due tomorrow.
3.  **Critical Security Enforcement (Phase VII):** A **Compound Trigger** blocks DML transactions on the **INVENTORY** table during restricted periods (Weekdays/Holidays).
4.  **Advanced Analytics (Phase VIII):** Implementation of **Window Functions** (`LAG`, `DENSE_RANK`) to generate key performance indicators (KPIs).

---

## 🛠️ Setup and Execution Steps

To deploy and test the system, run the following files sequentially in your Oracle environment:

1.  **Schema Setup (DDL):** `database/01_DDL_Schema_Sequences.sql`
2.  **Data Insertion (DML):** `database/02_DML_Data_Insertion.sql`
3.  **Logic & Security:** `database/03_PLSQL_Package_Body.sql` and `database/04_Triggers_Security.sql`

## Testing and Proof
The folder `testing_validation/` contains the necessary scripts and screenshots to prove all security and business rules are correctly implemented.

***

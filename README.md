# 🌾 AgroTech
## Smart Agriculture Management System Capstone Project

---

#### *Student Name:* MUGISHA Emmanuel
#### *Student ID:* 27811
#### *Course:* Database Development with PL/SQL (INSY 8311)
#### *Lecturer:* Eric MANIRAGUHA

---

## Project Summary
AgroTech is a database solution designed to automate critical inventory and scheduling processes for modern farming operations. The system uses advanced PL/SQL programming to ensure data integrity, enforce business rules, and provide actionable Business Intelligence (BI) data.

This repository contains the complete SQL and PL/SQL code, documentation, and testing results for the AgroTech Management System.

---

## Problem Statement

This project targets to creating a Smart Agriculture Management System, 
“AgroTech” that combines farming schedules, weather monitoring, and inventory 
management into a single database-driven platform using PL/SQL. The system 
focuses to support farmers in making data decisions, ensuring optimal crop 
growth and resource utilization.

---

## The main Objective

My project targets to creating a system that will help farmers manage their 
farming activities. It will be keeping records of crops, weather, schedules and farm 
resources like seeds and fertilizers. The system will be using PL/SQL in order to 
handle things like automatic alerts, schedules and updates in order to make farm 
work easier and very organized.

---

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

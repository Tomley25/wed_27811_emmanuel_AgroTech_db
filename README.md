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

## Creating a Pluggable Database
This is the standard way to create a new, empty PDB. The new PDB is copied from the PDB Seed (PDB$SEED), which acts as an Oracle template.
<img src="Screenshots/database_objects/create pdb.png">
<img src="Screenshots/database_objects/show pdbs.png">
---
## Checking if we are ready to go in the OEM
<img src="Screenshots/oem_monitoring/Login to Oracle Enterprise Oracle.png">

### What Sequences mean
A sequence in Oracle SQL is a database object used to automatically generate unique numbers in ascending or descending order. They are primarily used to populate Primary Key (PK) columns, ensuring that every new record gets a unique identifier without manual management or relying on complicated application logic.

Sequences are particularly useful because they:

Guarantee Uniqueness: Each time you call the sequence, it provides the next number in the series, ensuring no two rows receive the same ID.

Are Independent of Transactions: A number consumed from a sequence is gone forever, even if the transaction that requested it is rolled back. This ensures concurrency and high performance, as the database doesn't need to lock tables to determine the next available ID.

Are Simple to Use: You use the pseudocolumns NEXTVAL and CURRVAL to interact with them.

<img src="Screenshots/database_objects/create sequences.png">

## 🛠️ Setup and Execution Steps

To deploy and test the system, run the following files sequentially in your Oracle environment:

1.  **Schema Setup (DDL):** <a href="database/scripts/table_creation_and_sequence.sql">table_creation_and_sequence.sql</a>
2.  **Data Insertion (DML):** <a href="database/scripts/data_insertion.sql">data_insertion.sql</a>
3.  **Logic & Security:** <a href="documentation/design_decisions.md">design_decision.md</a>
4.  **analytical Reporting:** <a href="Queries/analytics_queries.sql">analytics_queries.sql</a>


## Testing and Proof
The folder `testing_validation/` contains the necessary scripts and screenshots to prove all security and business rules are correctly implemented.

<a href="Screenshots/test_results">test_results</a>

#### 1. Schedule Adherence Trend (Using COUNT() OVER)
``` sql
SELECT
    DUE_DATE,
    TASK_TYPE,
    COMPLETION_DATE,
    -- Running count of all tasks due up to this date
    COUNT(*) OVER (ORDER BY DUE_DATE) AS Running_Total_Tasks_Due
FROM
    SCHEDULES
WHERE
    CROP_ID = 1
ORDER BY
    DUE_DATE;
```
<img src="Screenshots/test_results/Testing the running total of completed task.png" height=400>

#### 2. Weather Volatility Analysis (Using LAG() OVER)
``` sql
SELECT
    OBSERVATION_DATE,
    RAINFALL_MM AS Today_Rain,
    -- LAG: Gets the rainfall value from the preceding row (yesterday)
    LAG(RAINFALL_MM, 1, 0) OVER (PARTITION BY FARM_ID ORDER BY OBSERVATION_DATE) AS Yesterday_Rain,
    -- Calculate the day-to-day change
    (RAINFALL_MM - LAG(RAINFALL_MM, 1, 0) OVER (PARTITION BY FARM_ID ORDER BY OBSERVATION_DATE)) AS Rainfall_Change
FROM 
    WEATHER
WHERE 
    FARM_ID = 1 AND OBSERVATION_DATE >= DATE '2024-03-01'
ORDER BY 
    OBSERVATION_DATE;
```
<img src="Screenshots/test_results/Testing the Comparison of rain on different days.png" height=400>

#  BPMN Process Explanation (Phase II Deliverable)

## Process Name
Automated Resource Management and Alert Generation

## Process Objective
To ensure immediate, accurate deduction of inventory following task completion and to proactively alert farm management when stock levels fall to a critical, predefined threshold.

---

## 1. Define Scope

The AgroTech system manages all core operational activities required for crop production within a farm.

### Automated Functions
* Task scheduling based on crop type and planting date.
* Real-time inventory deduction upon task completion.
* Proactive generation of deadline alerts (using **Explicit Cursors**).
* Conditional stock monitoring and critical low-stock alerting.
* Data integrity enforcement during sensitive DML transactions.

### MIS Relevance (Management Information System)
This process elevates inventory tracking from a manual, reactive system to an **automated Management Information System (MIS) function**.
* **Real-time Data:** The system guarantees inventory deduction (`UPDATE INVENTORY`) is synchronous with task completion (`UPDATE SCHEDULES`), providing real-time data integrity.
* **Proactive Alerting:** The system uses conditional logic (`FUNC_IS_STOCK_CRITICAL`) to generate low-stock alerts *before* a crisis occurs, preventing costly task delays and crop loss.

<img src="Screenshots/database_objects/BPMN Structure.png">

---

### Critical Security Validation Proofs (Phase VII)

The primary goal of the security implementation was to ensure the DML restriction policy could not be bypassed, while guaranteeing every violation is logged for compliance.

| Proof Component | Description |
| :--- | :--- |
| **1. DML Denial (ORA-20001)** | Proof that the **Compound Trigger** successfully intercepted the `UPDATE` attempt on the `INVENTORY` table and blocked it using the custom `ORA-20001` error code. This confirms the policy cannot be bypassed.
| **2. Audit Log Verification** | Proof that the trigger correctly executed the `INSERT INTO AUDIT_LOG` statement *before* raising the error, recording the transaction with **STATUS='DENIED'** and the reason for the violation. 

<img src="Screenshots/test_results/Compound Trigger (1).png">
<img src="Screenshots/test_results/Compound Trigger (2).png">

---

## 2. Identify Key Entities & Actors

### 👤 Users / Actors
* **Farm Managers / Field Supervisors:** Confirm task completion, monitor schedules.
* **Data Entry Personnel:** Input weather data, initial stock levels.
* **System Administrator:** Maintain PL/SQL logic, generate complex BI reports.
* **The Database (PL/SQL Layer):** The central actor, executing all automated logic.

### 🏢 Departments Involved
* **Field Operations:** Source of task completion data.
* **Resource Management/Warehouse:** Source of initial stock data, impacted by deductions.
* **Administration/IT:** Owner of the database and its security policies.

### 💡 Roles & Responsibilities

| Role | Primary Responsibility | Key Database Action |
| :--- | :--- | :--- |
| **Farm Manager** | Confirm task completion and resource use. | Inputs data that triggers `PRC_COMPLETE_TASK`. |
| **PL/SQL Layer** | Execute atomic DML and enforce rules. | Runs `PRC_COMPLETE_TASK`, triggers `TRG_INVENTORY_SECURITY`, and generates `ALERTS`. |
| **System Admin** | Generate reports and manage users/security. | Runs analytical queries (`DENSE_RANK`, `LAG`), manages `AUDIT_LOG`. |

---
###  Final Conclusion and Presentation Link

## 🚀 Conclusion

The AgroTech system successfully delivers a **secure, automated, and data-driven solution** that meets all capstone requirements, demonstrating proficiency in database design, advanced PL/SQL programming, security enforcement, and business intelligence reporting.

### Final Presentation
<a href="https://docs.google.com/presentation/d/1CVU3NZvMGhwj7gJYn8qWrKmerCjtNIpL/edit?usp=sharing&ouid=116521724856338087289&rtpof=true&sd=true">AgroTech Project Presentation</a>


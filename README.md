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

---
### 5. Final Conclusion and Presentation Link

## 🚀 Conclusion

The AgroTech system successfully delivers a **secure, automated, and data-driven solution** that meets all capstone requirements, demonstrating proficiency in database design, advanced PL/SQL programming, security enforcement, and business intelligence reporting.

### Final Presentation
<a href="https://docs.google.com/presentation/d/1CVU3NZvMGhwj7gJYn8qWrKmerCjtNIpL/edit?usp=sharing&ouid=116521724856338087289&rtpof=true&sd=true">AgroTech Project Presentation</a>


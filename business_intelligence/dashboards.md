#  AgroTech Management Dashboards: BI Mockups

This document provides the visual structure and core metrics for the three primary Business Intelligence dashboards derived from the AgroTech database.

---

## Dashboard 1: Executive Summary (Operational Health)

This dashboard provides farm owners with high-level KPIs based on the Schedule, Inventory, and Weather data.

###  Key Performance Indicators (KPIs)

| KPI | Value | Change | Source/Logic |
|-----|--------|---------|---|
| **Schedule Adherence** | **88%** | ▲ 3.0% | Percentage of tasks completed on or before the DUE_DATE. |
| **Inventory Critical Status** | **1/8** | ▼ 1 unit | Count of items flagged by FUNC_IS_STOCK_CRITICAL (stock < 100 units). |
| **Average Task Gap** | **4 days** | ▼ 1 day | Average (COMPLETION_DATE - DUE_DATE) for all tasks. |
| **Weather Volatility Index** | **6.5** | ▲ 1.1 | Derived from **LAG()** on WEATHER.RAINFALL_MM (Phase VIII Analytics). |

###  Resource Efficiency Ranking

This ranking uses the **DENSE_RANK()** Window Function to identify the most efficient farms by resource consumption percentage.

| Farm | Resource Usage % | Rank | Visual |
|---------|-------------|---------|---|
| **Highland Estate** | 18% | 1 | ███████████████ |
| **East Valley Farm** | 22% | 2 | ██████████████████ |
| **West Plains Co.** | 35% | 3 | ████████████████████████████ |

###  Alerts & Notifications

- 5 tasks detected due tomorrow by **PRC_GENERATE_DEADLINE_ALERTS**.
- **Maize Seeds (Type A)** is at 110 units (Near Critical Threshold).
- Next major harvest (Crop ID 1) due in **3 weeks**.

---

## Dashboard 2: Audit & Compliance Dashboard

This dashboard verifies the strict enforcement of the Phase VII security policy using the **AUDIT\_LOG** table.

###  Compliance Overview (DML Transactions)

| Metric | Value | Notes | Source/Logic |
|--------|--------|--------|---|
| **Total Transactions** | **850** | — | COUNT(*) from AUDIT_LOG. |
| **Allowed Transactions** | **780** | (91.8%) | STATUS = 'ALLOWED'. |
| **Violations Detected** | **70** | (8.2%) | STATUS = 'DENIED'. |

###  Violation Breakdown

| Type | Count | Percentage | Visual |
|-------|--------|--------------|---------|
| **Weekday DML Restriction** | 55 | 78% | ██████████████████████████████ |
| **Holiday DML Violation** | 15 | 22% | ██████████████ |

###  Recent Violations (Last 7 Days)

| Date | User | Table | Violation |
|-------|---------|---------|---------------|
| **07/12** | FARMER_01 | INVENTORY | Weekday UPDATE attempt |
| **06/12** | SUPERVISOR_01 | INVENTORY | Holiday INSERT attempt |

### ✅ Audit Trail Status

- Trigger successfully logs event **before** denial.
- All failed DML attempts are captured with **STATUS='DENIED'**.
- Security rule (`ORA-20001`) enforced successfully.

---

## Dashboard 3: Performance & System Health

This dashboard monitors the stability of the database and the efficiency of the custom PL/SQL code.

###  Database System Performance

| Metric | Value | Status | Source |
|--------|--------|---------|---|
| **PL/SQL Code Status** | **100% Valid** | Excellent | USER_OBJECTS query. |
| **Database Response Time** | **0.5s** | Good | — |
| **Active Sessions** | **4** | Low | — |
| **Invalid Objects** | **0** | Good | — |

###  Procedure Performance (Execution Time)

| Procedure | Execution Time | Visual |
|------------|------------------|---------|
| **PRC\_GENERATE\_DEADLINE\_ALERTS** | 1.9s | ████████████████████████████████ |
| **PRC\_COMPLETE\_TASK** | 0.4s | ████████████ |
| **FUNC\_CALCULATE\_HARVEST\_DATE** | 0.2s | ██████ |

###  Performance Alerts

- `PRC_GENERATE_DEADLINE_ALERTS` nearing **2s** threshold $\rightarrow$ Optimization plan required.
- **AUDIT\_LOG** growth is fast $\rightarrow$ Plan for creating an **archiving procedure** is necessary.

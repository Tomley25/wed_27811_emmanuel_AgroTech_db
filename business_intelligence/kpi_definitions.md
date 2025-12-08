#  Key Performance Indicator (KPI) Definitions

This document formalizes the calculation and data source for the primary KPIs used in the AgroTech Executive Summary Dashboard.

| KPI | Calculation Logic | Source Data / Technical Component |
|---|---|---|
| **Schedule Adherence** | Percentage of tasks where `COMPLETION_DATE <= DUE_DATE`. | `SCHEDULES` table (DML). |
| **Inventory Critical Status** | Count of inventory items where `STOCK_QUANTITY` is below the predefined critical threshold (e.g., 100 units). | `INVENTORY` table, checked via `AGROTECH_MGMT_PKG.FUNC_IS_STOCK_CRITICAL`. |
| **Resource Efficiency Rank** | Ratio of resources consumed (`RESOURCE_QUANTITY_NEEDED`) to total stock, ranked across all farms (Lowest ratio = Best Rank). | `INVENTORY` and `SCHEDULES` tables, calculated using the **`DENSE_RANK()` Window Function** (Phase VIII). |
| **Weather Volatility Index** | Average absolute difference in rainfall (or temperature) between consecutive days over the last 7 days. | `WEATHER` table, calculated using the **`LAG()` Window Function** (Phase VIII). |

#  BPMN Process Explanation (Phase II)

## Process Name
Automated Resource Management and Alert Generation

## Process Objective
To ensure immediate, accurate deduction of inventory following task completion and to proactively alert farm management when stock levels fall to a critical, predefined threshold.

## MIS Function Justification
This process elevates inventory tracking from a manual, reactive system to an **automated Management Information System (MIS) function**.
* **Real-time Data:** The system guarantees inventory deduction (`UPDATE INVENTORY`) is synchronous with task completion (`UPDATE SCHEDULES`), providing real-time data integrity.
* **Proactive Alerting:** The system uses conditional logic (`FUNC_IS_STOCK_CRITICAL`) to generate low-stock alerts *before* a crisis occurs, preventing costly task delays and crop loss.

## Organizational Impact
* **Risk Reduction:** Eliminates the risk of starting a task with insufficient resources due to stale data.
* **Improved Accountability:** Tasks are linked directly to resource consumption, allowing managers to better track material usage efficiency.
* **Efficiency:** Automating this process saves staff time previously spent on physical inventory checks and data reconciliation.

<img src = "Screenshots/database_objects/BPMN.png">

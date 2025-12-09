#  Design Decisions and Rationale

## 1. Security Enforcement (Phase VII - Critical Decision)
* **Decision:** Use a **Compound Trigger (`TRG_INVENTORY_SECURITY`)** and **`RAISE_APPLICATION_ERROR(-20001)`**.
* **Rationale:** Enforcement occurs at the lowest level (database kernel), making it impossible to bypass the rule via any application layer. The Compound Trigger ensures the **audit log record is successfully inserted** with `STATUS='DENIED'` before the mandatory transaction rollback, thus guaranteeing a verifiable audit trail for compliance.
<img src= "Screenshots/test_results/Compound Trigger (1).png">
<img src= "Screenshots/test_results/Compound Trigger (2).png">

## 2. DML Integrity (Phase VI)
* **Decision:** Consolidate all transactional DML (Schedule Update + Inventory Deduction) into the single **`PRC_COMPLETE_TASK`** procedure.
* **Rationale:** This establishes an **atomic transaction**. If the inventory deduction fails (e.g., due to the `CHECK >= 0` constraint), the entire transaction rolls back, preventing the schedule from incorrectly showing completion when the task was not fully executed.
<img src= "Screenshots/test_results/package (Procedure 1).png">
<img src= "Screenshots/test_results/package (Procedure 2).png">
<img src= "Screenshots/test_results/package (Procedure 3).png">

## 3. Business Intelligence (Phase VIII)
* **Decision:** Utilize **Window Functions** (`LAG`, `DENSE_RANK`) for analytical queries.
* **Rationale:** This moves complex, iterative data processing to the database layer, resulting in highly efficient, single-pass calculations across large datasets (e.g., the 400+ rows in WEATHER). This aligns with professional **performance tuning** standards (OEM monitoring).
<img src= "Screenshots/test_results/Testing Weather Shifting.png" width=800 height=400>
<img src= "Screenshots/test_results/Testing for Business Logic Unit .png" width=800 weight=400>

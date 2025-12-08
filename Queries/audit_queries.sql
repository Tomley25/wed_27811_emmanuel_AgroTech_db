-- 1. Verification of DENIED Transactions 
-- Use this query immediately after running the security test script to retrieve the denial log entry.
SELECT 
    TRANSACTION_DATE, 
    USER_NAME, 
    TABLE_NAME, 
    ACTION_TYPE, 
    STATUS, 
    REASON
FROM 
    AUDIT_LOG
WHERE 
    STATUS = 'DENIED' 
ORDER BY TRANSACTION_DATE DESC;

-- 2. Compliance Overview: Total Allowed vs. Denied Attempts
SELECT
    STATUS,
    COUNT(*) AS Total_Attempts,
    ROUND(COUNT(*) * 100 / SUM(COUNT(*)) OVER (), 1) AS Percentage
FROM
    AUDIT_LOG
GROUP BY
    STATUS;

-- 3. Detailed Breakdown of Violations by Reason (Supports Violation Breakdown chart)
SELECT
    REASON,
    COUNT(*) AS Violation_Count
FROM
    AUDIT_LOG
WHERE
    STATUS = 'DENIED'
GROUP BY
    REASON
ORDER BY Violation_Count DESC;

-- 4. Top 5 Users by Activity (Allowed or Denied)
SELECT
    USER_NAME,
    COUNT(*) AS Total_Operations
FROM
    AUDIT_LOG
GROUP BY
    USER_NAME
ORDER BY Total_Operations DESC
FETCH FIRST 5 ROWS ONLY;

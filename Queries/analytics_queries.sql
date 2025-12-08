-- 1. Resource Efficiency Ranking (Using DENSE_RANK() OVER)
-- Ranks farms by resource usage percentage (lower usage percentage is better/more efficient)
SELECT 
    FARM_ID,
    NAME AS Farm_Name,
    -- Calculate Usage Percentage (Simulated Consumption / Total Stock)
    (SUM(s.RESOURCE_QUANTITY_NEEDED) / SUM(i.STOCK_QUANTITY)) * 100 AS Usage_Percentage,
    -- DENSE_RANK assigns the ranking
    DENSE_RANK() OVER (ORDER BY (SUM(s.RESOURCE_QUANTITY_NEEDED) / SUM(i.STOCK_QUANTITY)) ASC) AS Efficiency_Rank
FROM 
    FARMS f
JOIN INVENTORY i ON f.FARM_ID = i.FARM_ID
LEFT JOIN CROPS c ON f.FARM_ID = c.FARM_ID
LEFT JOIN SCHEDULES s ON c.CROP_ID = s.CROP_ID
GROUP BY f.FARM_ID, f.NAME
ORDER BY Efficiency_Rank ASC;

-- 2. Weather Volatility Analysis (Using LAG() OVER)
-- Compares today's rainfall to the preceding day's rainfall to track volatility.
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

-- 3. Schedule Adherence Trend (Using COUNT() OVER)
-- Shows the running total of completed tasks to identify adherence trends.
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

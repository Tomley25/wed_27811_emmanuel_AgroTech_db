-- 1. Check current resource stock for Farm ID 1
SELECT 
    i.ITEM_NAME,
    i.STOCK_QUANTITY,
    f.NAME AS Farm_Name
FROM 
    INVENTORY i
JOIN 
    FARMS f ON i.FARM_ID = f.FARM_ID
WHERE 
    f.FARM_ID = 1;

-- 2. List all scheduled tasks for a specific crop (Crop ID 1: Maize)
SELECT
    s.SCHEDULE_ID,
    s.TASK_TYPE,
    s.DUE_DATE,
    s.COMPLETION_DATE
FROM
    SCHEDULES s
WHERE
    s.CROP_ID = 1
ORDER BY s.DUE_DATE;

-- 3. Retrieve all weather observations within a critical planting window
SELECT
    OBSERVATION_DATE,
    TEMPERATURE_C,
    RAINFALL_MM
FROM
    WEATHER
WHERE
    FARM_ID = 1 AND OBSERVATION_DATE BETWEEN DATE '2025-09-01' AND DATE '2025-10-01'
ORDER BY OBSERVATION_DATE DESC;

-- 4. Verify calculated expected harvest date
SELECT 
    c.CROP_ID,
    c.PLANTING_DATE,
    ct.GROWTH_DURATION_DAYS,
    AGROTECH_MGMT_PKG.FUNC_CALCULATE_HARVEST_DATE(c.CROP_ID) AS Calculated_Harvest_Date
FROM
    CROPS c
JOIN
    CROP_TYPES ct ON c.TYPE_ID = ct.TYPE_ID
WHERE
    c.CROP_ID = 1;

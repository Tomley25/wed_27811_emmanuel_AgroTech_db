--function 1: Check the best suitable weather

FUNCTION FUNC_IS_WEATHER_SUITABLE (
        p_farm_id IN NUMBER,
        p_task_type IN VARCHAR2
    )
    RETURN VARCHAR2
    IS
        c_rain_threshold CONSTANT NUMBER := 20.00; 
        v_total_rainfall NUMBER(10,2);
        v_suitability_flag VARCHAR2(1) := 'Y'; 
    BEGIN
        IF p_task_type NOT IN ('IRRIGATION', 'SPRAYING') THEN
            RETURN 'N/A';
        END IF;

        SELECT SUM(RAINFALL_MM)
        INTO v_total_rainfall
        FROM WEATHER
        WHERE FARM_ID = p_farm_id
          AND OBSERVATION_DATE >= TRUNC(SYSDATE) - 7 
          AND OBSERVATION_DATE < TRUNC(SYSDATE);
        
        IF v_total_rainfall IS NULL THEN
            v_total_rainfall := 0;
        END IF;

        IF v_total_rainfall >= c_rain_threshold THEN
            v_suitability_flag := 'N'; 
        ELSE
            v_suitability_flag := 'Y'; 
        END IF;

        RETURN v_suitability_flag;

    EXCEPTION WHEN OTHERS THEN RETURN 'ERROR';
    END FUNC_IS_WEATHER_SUITABLE;

-- function 2: Calculate the harvet date

FUNCTION FUNC_CALCULATE_HARVEST_DATE (
        p_crop_id IN NUMBER
    )
    RETURN DATE
    IS
        v_planting_date DATE;
        v_duration_days NUMBER(5);
        v_expected_harvest_date DATE;
    BEGIN
        SELECT 
            c.PLANTING_DATE,
            ct.GROWTH_DURATION_DAYS
        INTO 
            v_planting_date,
            v_duration_days
        FROM 
            CROPS c
        JOIN 
            CROP_TYPES ct ON c.TYPE_ID = ct.TYPE_ID
        WHERE 
            c.CROP_ID = p_crop_id;
            
        v_expected_harvest_date := v_planting_date + v_duration_days;

        RETURN v_expected_harvest_date;

    EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL; WHEN OTHERS THEN RETURN NULL;
    END FUNC_CALCULATE_HARVEST_DATE;

-- function 3: check if stock is critical

FUNCTION FUNC_IS_STOCK_CRITICAL (
        p_inventory_id IN NUMBER,
        p_threshold_pct IN NUMBER DEFAULT 10
    )
    RETURN VARCHAR2
    IS
        v_current_stock NUMBER(10,2);
    BEGIN
        SELECT STOCK_QUANTITY
        INTO v_current_stock
        FROM INVENTORY
        WHERE INVENTORY_ID = p_inventory_id;

        IF v_current_stock < 100 THEN
            RETURN 'Y'; 
        ELSE
            RETURN 'N';
        END IF;

    EXCEPTION WHEN NO_DATA_FOUND THEN RETURN 'N'; WHEN OTHERS THEN RETURN 'ERROR';
    END FUNC_IS_STOCK_CRITICAL;

END AGROTECH_MGMT_PKG;
/

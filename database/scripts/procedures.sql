-- PROCEDURE 1: The Package for the agrotect management

CREATE OR REPLACE PACKAGE AGROTECH_MGMT_PKG
AS
    PROCEDURE PRC_COMPLETE_TASK ( --Updates schedule status and deducts resources from inventory
        p_schedule_id IN NUMBER,
        p_completion_date IN DATE,
        p_task_status OUT VARCHAR2,
        p_inventory_message OUT VARCHAR2
    );

    PROCEDURE PRC_GENERATE_DEADLINE_ALERTS; --Checks for pending tasks due tomorrow and inserts alert records.
    
    PROCEDURE PRC_INSERT_INVENTORY_ALERT (    -- Creates a record in the ALERTS table for low inventory.
        p_farm_id IN NUMBER,
        p_inventory_id IN NUMBER,
        p_current_stock IN NUMBER
    );

    FUNCTION FUNC_IS_WEATHER_SUITABLE (           -- Function 1: Checks rainfall data to determine suitability for water-intensive tasks.
        p_farm_id IN NUMBER,
        p_task_type IN VARCHAR2
    )
    RETURN VARCHAR2;
    FUNCTION FUNC_CALCULATE_HARVEST_DATE (       -- Function 2: Calculates the expected harvest date based on crop type duration.
        p_crop_id IN NUMBER
    )
    RETURN DATE;
    FUNCTION FUNC_IS_STOCK_CRITICAL (
        p_inventory_id IN NUMBER,
        p_threshold_pct IN NUMBER DEFAULT 10
    )
    RETURN VARCHAR2;
END AGROTECH_MGMT_PKG;
/

-- PROCEDURE 2: Check the stock level

CREATE OR REPLACE FUNCTION FUNC_IS_STOCK_CRITICAL (
    p_inventory_id IN NUMBER,
    p_threshold_pct IN NUMBER DEFAULT 10 
)
RETURN VARCHAR2 -- Returns 'Y' if critical, 'N' if sufficient
IS
    v_current_stock NUMBER(10,2);
    v_original_stock NUMBER(10,2);
    v_critical_level NUMBER(10,2);
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

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'N'; 
    WHEN OTHERS THEN
        RETURN 'ERROR';
END FUNC_IS_STOCK_CRITICAL;
/

-- PROCEDURE 3: Creating Inventory Alert 

CREATE OR REPLACE PROCEDURE PRC_INSERT_INVENTORY_ALERT (
    p_farm_id IN NUMBER,
    p_inventory_id IN NUMBER,
    p_current_stock IN NUMBER
)
IS
    v_item_name VARCHAR2(50);
    
BEGIN
    SELECT ITEM_NAME
    INTO v_item_name
    FROM INVENTORY
    WHERE INVENTORY_ID = p_inventory_id;

    INSERT INTO ALERTS (
        ALERT_ID,
        FARM_ID,
        ALERT_TYPE,
        MESSAGE,
        SCHEDULE_ID
    )
    VALUES (
        ALERTS_SEQ.NEXTVAL,
        p_farm_id,
        'Low Stock Warning',
        'CRITICAL: Stock for ' || v_item_name || ' (ID: ' || p_inventory_id || ') is low. Current stock: ' || p_current_stock,
        NULL
    );
    
    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        NULL; 
    WHEN OTHERS THEN
        ROLLBACK;
END PRC_INSERT_INVENTORY_ALERT;
/

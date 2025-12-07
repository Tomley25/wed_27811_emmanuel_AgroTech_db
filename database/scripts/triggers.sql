-- Trigger 1: Inventory Security Change

CREATE OR REPLACE TRIGGER TRG_INVENTORY_SECURITY

FOR INSERT OR UPDATE OR DELETE ON INVENTORY
COMPOUND TRIGGER

    v_audit_action AUDIT_LOG.ACTION_TYPE%TYPE;
    v_audit_status AUDIT_LOG.STATUS%TYPE;
    v_audit_reason AUDIT_LOG.REASON%TYPE;
    
    AFTER STATEMENT IS
    BEGIN
    
        NULL; 
    END AFTER STATEMENT;

    BEFORE EACH ROW IS
    BEGIN
        v_audit_action := CASE 
                            WHEN INSERTING THEN 'INSERT'
                            WHEN UPDATING THEN 'UPDATE'
                            WHEN DELETING THEN 'DELETE'
                          END;

        IF FUNC_IS_DML_RESTRICTED(TRUNC(SYSDATE)) THEN

            v_audit_status := 'DENIED';
            v_audit_reason := 'DML restricted by policy on Weekdays/Holidays.';

            INSERT INTO AUDIT_LOG (AUDIT_ID, TABLE_NAME, ACTION_TYPE, STATUS, REASON)
            VALUES (AUDIT_LOG_SEQ.NEXTVAL, 'INVENTORY', v_audit_action, v_audit_status, v_audit_reason);

            RAISE_APPLICATION_ERROR(-20001, 'Security Policy Violation: DML is prohibited on INVENTORY on Weekdays/Holidays.');
        
        ELSE

            v_audit_status := 'ALLOWED';
            v_audit_reason := 'Transaction allowed: Outside restricted hours/days.';

            -- Log the ALLOWED attempt
            INSERT INTO AUDIT_LOG (AUDIT_ID, TABLE_NAME, ACTION_TYPE, STATUS, REASON)
            VALUES (AUDIT_LOG_SEQ.NEXTVAL, 'INVENTORY', v_audit_action, v_audit_status, v_audit_reason);
        
        END IF;

    END BEFORE EACH ROW;

END TRG_INVENTORY_SECURITY;
/

--Trigger 2: Vatlidation Tasting

SET SERVEROUTPUT ON;

DECLARE
    v_new_crop_id NUMBER := CROPS_SEQ.NEXTVAL;
    v_expected_harvest DATE;
BEGIN
    -- Insert a new Potato crop (TYPE_ID 2, duration 90 days)
    INSERT INTO CROPS (CROP_ID, FARM_ID, TYPE_ID, PLANTING_DATE)
    VALUES (v_new_crop_id, 1, 2, DATE '2025-10-01');
    COMMIT;
    
    -- Retrieve the new crop record
    SELECT EXPECTED_HARVEST_DATE INTO v_expected_harvest
    FROM CROPS
    WHERE CROP_ID = v_new_crop_id;
    
    DBMS_OUTPUT.PUT_LINE('New Crop ID: ' || v_new_crop_id);
    DBMS_OUTPUT.PUT_LINE('Planted Date: 2025-10-01');
    DBMS_OUTPUT.PUT_LINE('Expected Harvest Date (Calculated): ' || TO_CHAR(v_expected_harvest, 'YYYY-MM-DD'));

    IF v_expected_harvest = DATE '2025-12-30' THEN
        DBMS_OUTPUT.PUT_LINE('SUCCESS: Harvest date calculation is correct (90 days).');
    ELSE
        DBMS_OUTPUT.PUT_LINE('ERROR: Harvest date calculation failed.');
    END IF;
END;
/

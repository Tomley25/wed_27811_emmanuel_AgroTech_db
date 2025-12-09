#  Data Dictionary (Schema Definition)

This dictionary details the entities, attributes, data types, and constraints for the AgroTech Management System database schema.

| Table Name | Column Name | Data Type | Key/Constraint | Description |
|---|---|---|---|---|
| **FARMERS** | FARMER_ID | NUMBER(10) | PK | Unique identifier for the farmer/owner. |
| | CONTACT_EMAIL | VARCHAR2(100) | UNIQUE | Ensures a unique contact email for each farmer. |
| **FARMS** | FARM_ID | NUMBER(10) | PK | Unique identifier for a specific farm location. |
| | FARMER_ID | NUMBER(10) | FK | Links the farm to its managing farmer (1:M). |
| **CROP_TYPES** | TYPE_ID | NUMBER(10) | PK | Unique ID for the crop type (e.g., Maize). |
| | GROWTH_DURATION_DAYS | NUMBER(5) | NOT NULL | Defines the days needed from planting to harvest. |
| **CROPS** | CROP_ID | NUMBER(10) | PK | Unique ID for each instance of a planted crop. |
| | TYPE_ID | NUMBER(10) | FK | Links the crop instance to its TYPE_ID. |
| | PLANTING_DATE | DATE | NOT NULL | Date the crop was planted. |
| **INVENTORY** | INVENTORY_ID | NUMBER(10) | PK | Unique ID for the stock item (fertilizer, seeds). |
| | STOCK_QUANTITY | NUMBER(10,2) | CHECK >= 0 | **Critical Constraint:** Ensures stock level can never be negative. |
| **SCHEDULES** | SCHEDULE_ID | NUMBER(10) | PK | Unique ID for a scheduled task. |
| | RESOURCE_USED_ID | NUMBER(10) | FK | Links task to the inventory item consumed. |
| | COMPLETION_DATE | DATE | NULLABLE | Date the task was marked complete. |
| **WEATHER** | WEATHER_ID | NUMBER(10) | PK | Unique ID for the observation record. |
| | OBSERVATION_DATE | DATE | UNIQUE (per FARM_ID) | Ensures only one weather observation per day per farm. |
| **ALERTS** | ALERT_ID | NUMBER(10) | PK | Unique ID for the automated alert messages. |
| **AUDIT_LOG** | AUDIT_ID | NUMBER(10) | PK | Unique identifier for the security log entry. |
| | STATUS | VARCHAR2(10) | NOT NULL | Records whether the DML attempt was **'ALLOWED'** or **'DENIED'**. |
| **HOLIDAYS** | HOLIDAY_DATE | DATE | PK | Used by `FUNC_IS_DML_RESTRICTED` to enforce security policy. |

### Here is the ER- Diagram that says it well if you need to check out the images
<img src= "Screenshots/database_objects/ER Diagram.png">

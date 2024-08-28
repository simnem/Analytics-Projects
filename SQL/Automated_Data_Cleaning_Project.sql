## Automated Data Cleaning 

SELECT * 
FROM bakery.us_household_income;

SELECT * 
FROM bakery.us_household_income_cleaned;


DELIMITER $$
DROP PROCEDURE IF EXISTS Copy_and_Clean_Data; 
CREATE PROCEDURE Copy_and_Clean_Data()
BEGIN
##CREATING OUR TABLE
    CREATE TABLE IF NOT EXISTS `us_household_income_cleaned` (
      `id` text,
      `State_Code` text,
      `State_Name` text,
      `State_ab` text,
      `County` text,
      `City` text,
      `Place` text,
      `Type` text,
      `Primary` text,
      `Zip_Code` int DEFAULT NULL,
      `Area_Code` int DEFAULT NULL,
      `ALand` int DEFAULT NULL,
      `AWater` int DEFAULT NULL,
      `Lat` double DEFAULT NULL,
      `Lon` double DEFAULT NULL,
      `Mean` int DEFAULT NULL,
      `Median` int DEFAULT NULL,
      `Stdev` int DEFAULT NULL,
      `sum_w` double DEFAULT NULL,
      `TimeStamp` TIMESTAMP DEFAULT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
    
    ## COPY DATA TO NEW TABLE 
    INSERT INTO us_household_income_cleaned
    SELECT *, CURRENT_TIMESTAMP
    FROM bakery.us_household_income;
    
    ## Data Cleaning Steps
    ## 1. Remove Duplicates
    DELETE FROM us_household_income_cleaned
    WHERE 
        id IN (
        SELECT id
        FROM (
            SELECT id, 
                ROW_NUMBER() OVER (
                    PARTITION BY id, `TimeStamp`
                    ORDER BY id, `TimeStamp`) AS row_num
            FROM 
                us_household_income_cleaned
    ) duplicates
    WHERE 
        row_num > 1
    );
    ## 2. Standardization 
    UPDATE us_household_income_cleaned
    SET State_Name = 'Georgia'
    WHERE State_Name = 'georgia';

    UPDATE us_household_income_cleaned
    SET County = UPPER(County);

    UPDATE us_household_income_cleaned
    SET City = UPPER(City);

    UPDATE us_household_income_cleaned
    SET Place = UPPER(Place);

    UPDATE us_household_income_cleaned
    SET State_Name = UPPER(State_Name);

    UPDATE us_household_income_cleaned
    SET State_Name = UPPER(State_Name);

    UPDATE us_household_income_cleaned
    SET `Type` = 'CDP'
    WHERE `Type` = 'CPD';

    UPDATE us_household_income_cleaned
    SET `Type` = 'Borough'
    WHERE `Type` = 'Boroughs';

END$$
DELIMITER ;

CALL Copy_and_Clean_Data() ;

## CREATE EVENT 

DROP EVENT IF EXISTS run_data_cleaning;
CREATE EVENT run_data_cleaning
    ON SCHEDULE EVERY 30 DAY
    DO CALL Copy_and_Clean_Data() ;
    
## Debugging or Checking SP Works
SELECT id, row_num
FROM (
    SELECT id, 
        ROW_NUMBER() OVER (
            PARTITION BY id 
            ORDER BY id) AS row_num
    FROM
        us_household_income_cleaned
    ) duplicates
    WHERE 
        row_num > 1 ;

SELECT COUNT(id)
FROM us_household_income_cleaned ;

SELECT State_Name, COUNT(State_Name)
FROM us_household_income_cleaned
GROUP BY State_Name ; 




drop database shivam;
create database shivam;
use shivam;
CREATE TABLE `shivam`.`airbnb` (
    `listing_id` INT NOT NULL,
    `date` DATE NULL,
    `available` VARCHAR(1) NULL,
    `price` VARCHAR(10) NULL
);
desc airbnb;
drop table airbnb;
SELECT 
    *
FROM
    airbnb;
SHOW VARIABLES LIKE "secure_file_priv";
load data infile "/tmp/airbnb_calendar.csv"
into table airbnb
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

SELECT 
    *
FROM
    airbnb
ORDER BY listing_id;

SET SQL_SAFE_UPDATES = 0;
UPDATE airbnb 
SET 
    price = NULL
WHERE
    price = '';
UPDATE airbnb 
SET 
    price = TRIM(LEADING '$' FROM price);


 
/*=============Q1===================*/
-- Q1. What is the time period used?  
(SELECT 
    date
FROM
    airbnb
ORDER BY date
LIMIT 1) UNION (SELECT 
    date
FROM
    airbnb
ORDER BY date DESC
LIMIT 1);

/*=============Q2===================*/
-- Q2. How many properties have duplicate entries? 
-- Remove duplicate rows 
-- (say a row appears 3 times, remove 2 and keep 1)


SELECT 
    listing_id, date, COUNT(*) c
FROM
    airbnb
GROUP BY listing_id , date
HAVING COUNT(*) > 1;

DELETE t1 FROM (SELECT *, ROW_NUMBER () OVER(listing_id ) as rownum FROM airbnb) t1
INNER JOIN (SELECT *, ROW_NUMBER() OVER(listing_id) as rownum FROM airbnb) t2
WHERE
t1.date= t2.date AND
t1.listing_id = t2.listing_id AND
ti.rownum < t2.rownum;

/*=============Q3===================*/
-- Q3. For each property, find out the number of days the 
-- property was available and not available 
-- (create a table with listing_id, available days, 
-- unavailable days and available days as a fraction of total days) 
SELECT 
    listing_id AS property,
    SUM(CASE
        WHEN available = 't' THEN 1
        ELSE 0
    END) AS Available,
    SUM(CASE
        WHEN available = 'f' THEN 1
        ELSE 0
    END) AS Unavailable
FROM
    airbnb
GROUP BY listing_id;

/*=============Q4===================*/
-- Q4. How many properties were available on 
-- more than 50% of the days? 
-- How many properties were available 
-- on more than 75% of the days?

SELECT 
    listing_id, percent
FROM
    (SELECT 
        listing_id,
            (COUNT(CASE
                WHEN available = 't' THEN 1
            END) / COUNT(*)) * 100 AS percent
    FROM
        airbnb
    GROUP BY listing_id) AS temp
WHERE
    percent > 50;
SELECT 
    listing_id, percent
FROM
    (SELECT 
        listing_id,
            (COUNT(CASE
                WHEN available = 't' THEN 1
            END) / COUNT(*)) * 100 AS percent
    FROM
        airbnb
    GROUP BY listing_id) AS temp
WHERE
    percent > 75;

/*=============Q5===================*/
-- Q5. Create a table with max, 
-- min and average price of each property.
SELECT 
    listing_id AS property,
    MAX(price) AS Max,
    MIN(price) AS Min,
    AVG(price) AS Average
FROM
    airbnb
GROUP BY listing_id;


/*=============Q6===================*/
-- Q6. Extract properties with an average price of more than $500.
SELECT 
    listing_id, Price
FROM
    (SELECT 
        AVG(price) AS Price, listing_id
    FROM
        airbnb
    GROUP BY listing_id) AS temp
WHERE
    Price > 500;

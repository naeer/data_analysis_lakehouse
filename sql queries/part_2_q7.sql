-- part_2_q7.sql

-- Looking at the duplicate values in the table to get an idea
SELECT video_id, country, trending_date, count(*)
FROM table_youtube_final
GROUP BY video_id, country, trending_date
HAVING count(*) > 1;

-- Creating a table with only the bad duplicates - those duplicates that do not have the highest view count  
CREATE OR REPLACE TABLE table_youtube_duplicates AS
WITH 
view_orders AS (SELECT *,
row_number() over (partition by video_id, country, trending_date order by view_count desc) as view_order
FROM table_youtube_final)
SELECT * 
FROM view_orders 
WHERE view_order > 1;

-- Viewing the table_youtube_duplicates table
SELECT * FROM table_youtube_duplicates;


-- Reference: https://azurelib.com/explained-row_number-function-in-snowflake/
-- Reference: https://hevodata.com/learn/snowflake-row-number/

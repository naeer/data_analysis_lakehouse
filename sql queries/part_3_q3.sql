-- part_3_q3.sql file

-- Finding the most viewed video and its likes_ratio for each country and year_month
WITH video_ranks AS
(SELECT country, 
 date_from_parts(date_part(year, trending_date), date_part(month, trending_date), 1) AS year_month, 
 title, channeltitle, category_title, view_count,
 round((likes/view_count)*100,2) as likes_ratio,
row_number() over (partition by country, year_month order by view_count desc) as rk
FROM table_youtube_final)
SELECT country, year_month, title, channeltitle, category_title, view_count, likes_ratio
FROM video_ranks
WHERE rk = 1
ORDER BY year_month, country;

-- Reference: https://docs.snowflake.com/en/sql-reference/functions/date_from_parts.html
-- Reference: https://docs.snowflake.com/en/sql-reference/functions-date-time.html#label-supported-date-time-parts
-- Reference: https://docs.snowflake.com/en/sql-reference/functions/extract.html

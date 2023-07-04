-- part_3_q4.sql file

-- Finding which category_title has the most distinct videos for each country
CREATE OR REPLACE table t1 AS
WITH rank_videos_country AS
(SELECT country, category_title, count(distinct(video_id)) as total_category_video,
row_number() over (partition by country order by count(distinct(video_id)) desc) as rk
FROM table_youtube_final 
GROUP BY country, category_title
ORDER BY country, category_title, rk)
SELECT * FROM rank_videos_country
WHERE rk = 1;

-- Viewing the category_title's having the most distinct videos for each country
SELECT * FROM t1;

-- Finding the total distinct videos for each country
CREATE OR REPLACE table t2 as
SELECT country, count(distinct(video_id)) as total_country_video
FROM table_youtube_final
GROUP BY country
ORDER BY country;

-- Viewing the total distinct videos for each country
SELECT * FROM t2;

-- Finding out the percentage of total_category_video by total_country_video
SELECT t1.country, t1.category_title, t1.total_category_video, t2.total_country_video, round((t1.total_category_video/t2.total_country_video)*100,2) as percentage
FROM t1 left join t2
ON t1.country = t2.country
ORDER BY t1.category_title, t1.country;

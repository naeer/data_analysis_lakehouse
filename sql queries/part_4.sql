-- part_4.sql file

-- Finding the number of videos for each category in the trending data
SELECT category_title, count(category_title) as count
FROM table_youtube_final
GROUP BY category_title
ORDER BY count desc;
-- 'People & Blogs' and 'Gaming' appears the 3rd and 4th most in the trending data respectively

-- Finding the total views for the videos in each category and then ordering them in descending order by total views
SELECT category_title, sum(view_count) as total_views, sum(likes) as total_likes, sum(dislikes) as total_dislikes,
sum(comment_count) as total_comments
FROM table_youtube_final
GROUP BY category_title
ORDER BY total_views desc, total_likes desc, total_comments desc;
-- The categories with most total_views after 'Music' and 'Entertainment' are 'Gaming' and 'People & Blogs'

-- Creating a table with total views, total likes, total dislikes and total comments for each country and category title 
CREATE OR REPLACE table t1 AS
SELECT country, category_title, sum(view_count) as total_views, sum(likes) as total_likes, sum(dislikes) as total_dislikes,
sum(comment_count) as total_comments
FROM table_youtube_final
GROUP BY country, category_title
ORDER BY total_views desc;

-- Viewing the table t1 in descending order by total views
SELECT * FROM t1
ORDER BY total_views desc;

-- Finding the 3rd ranked category_title for each country with most total_views
WITH total_views_rank AS
(SELECT *, 
row_number() over (partition by country order by total_views desc) as rk 
FROM t1)
SELECT * FROM total_views_rank
WHERE rk = 3;
-- Gaming is the 3rd most viewed category for 4 countries, whereas 'People & Blogs' is the 3rd most viewed category for 6 countries.
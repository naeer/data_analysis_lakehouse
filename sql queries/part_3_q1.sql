-- part_3_q1.sql file

-- Finding top 3 most viewed videos in each country for Sports category in trending_date = '2021-10-17'
WITH video_ranks_per_country AS
(SELECT country, title, channeltitle, view_count,
row_number() over (partition by country order by view_count desc) as rk
FROM table_youtube_final
WHERE category_title = 'Sports'
AND trending_date = '2021-10-17')
SELECT *
FROM video_ranks_per_country
WHERE rk <= 3
ORDER BY country, rk;
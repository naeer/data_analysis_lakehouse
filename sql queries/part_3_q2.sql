-- part_3_q2.sql file

-- Finding the count of videos, in descending order, containing BTS in the title for each country
SELECT country, count(distinct(video_id)) as CT
FROM table_youtube_final
WHERE contains(title, 'BTS')
GROUP BY country
ORDER BY CT desc;
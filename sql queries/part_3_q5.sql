-- part_3_q5.sql file

-- Finding which channel title produced the most distinct videos
WITH video_count_ranks AS
(SELECT channeltitle, count(distinct(video_id)) as video_count,
row_number() over (order by video_count desc) as rk
FROM table_youtube_final
GROUP BY channeltitle)
SELECT channeltitle, video_count 
FROM video_count_ranks
WHERE rk = 1;

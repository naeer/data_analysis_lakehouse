-- part_2_q5.sql file

-- Finding the video id for which there is no channel title

SELECT video_id
FROM table_youtube_final
WHERE channeltitle is null;

-- The video with no channel title is '9b9MovPPewk'


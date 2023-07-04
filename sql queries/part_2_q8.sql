-- part_2_q8.sql file

-- Deleting all the duplicates from table_youtube_final that are present in table_youtube_duplicates
DELETE 
FROM table_youtube_final AS t1
WHERE EXISTS (SELECT 1
             FROM table_youtube_duplicates AS t2
             WHERE t1.id = t2.id);
             
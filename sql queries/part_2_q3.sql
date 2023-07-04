-- part_2_q3.sql file

-- Finding the categoryId for which the corresponding category title is missing
SELECT distinct(categoryid)
FROM table_youtube_final
WHERE category_title is null;

-- The category id for the missing cateogry titles is 29.
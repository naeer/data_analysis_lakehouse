-- part_2_q1.sql file

-- Finding out which category title has duplicates in table_youtube_category

SELECT country, category_title, count(*)
FROM table_youtube_category
GROUP BY country, category_title
HAVING count(*) > 1;

-- The category: 'Comedy' has duplicates in the table_youtube_category table
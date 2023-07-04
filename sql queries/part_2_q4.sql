--  part_2_q4.sql file

-- Replacing the null values in category title with the appropriate value by making use of the category_id
UPDATE table_youtube_final
SET category_title = (SELECT category_title
                     FROM table_youtube_category
                     WHERE categoryid = '29')
WHERE category_title is null

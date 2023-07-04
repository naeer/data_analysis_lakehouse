--  part_2_q2.sql file

-- Finding the category title that had only one corresponding country code
SELECT category_title
FROM table_youtube_category
GROUP BY category_title
HAVING count(distinct(country)) = 1;

-- Finding out for which country, the category_title:'Nonprofits & Activism' only appears once
SELECT * FROM table_youtube_category WHERE category_title = 'Nonprofits & Activism'

-- The category title: 'Nonprofits & Activism' only appears for US.

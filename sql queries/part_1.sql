-- Part_1.sql file

-- Creating a new database called bde_at_1
CREATE DATABASE bde_at_1;

-- Switching to bde_at_1 database
USE DATABASE bde_at_1;

-- Creating a storage integration to load data from the Azure storage account - utsbdenae
CREATE STORAGE INTEGRATION azure_bde_at_1
TYPE = EXTERNAL_STAGE
STORAGE_PROVIDER = AZURE
ENABLED = TRUE
AZURE_TENANT_ID = 'e8911c26-cf9f-4a9c-878e-527807be8791'
STORAGE_ALLOWED_LOCATIONS = ('azure://utsbdenae.blob.core.windows.net/bde-at-1');

-- Retrieving the Azure_consent_url by viewing the the azure_bde_at_1 storage integration
DESC STORAGE INTEGRATION azure_bde_at_1; 

-- Storage Data blob owner - xehiqysnowflakepacint

-- Loading the data from Azure into Snowflake ----------------------------------------

-- Creating a stage so that the data from the files can be loaded into a table
CREATE OR REPLACE STAGE stage_bde_at_1
STORAGE_INTEGRATION = azure_bde_at_1
URL = 'azure://utsbdenae.blob.core.windows.net/bde-at-1';

-- Viewing all the files inside the stage: stage_bde_at_1
list @stage_bde_at_1;

-- Creating an external table for all the csv files
CREATE OR REPLACE EXTERNAL TABLE ex_table_youtube_trending
WITH LOCATION = @stage_bde_at_1
FILE_FORMAT = (TYPE=CSV)
PATTERN = '.*[.]csv';

-- Looking at the column names and data types of each column
SELECT * FROM ex_table_youtube_trending limit 3;

-- Creating a file format for csv files
CREATE OR REPLACE FILE FORMAT file_format_csv 
TYPE = 'CSV' 
FIELD_DELIMITER = ',' 
SKIP_HEADER = 1
NULL_IF = ('\\N', 'NULL', 'NUL', '')
FIELD_OPTIONALLY_ENCLOSED_BY = '"'
;

-- Replacing the external table with the new file format for csv files
CREATE OR REPLACE EXTERNAL TABLE ex_table_youtube_trending
WITH LOCATION = @stage_bde_at_1
FILE_FORMAT = file_format_csv
PATTERN = '.*[.]csv';

-- Looking at the first 3 rows of the external table
SELECT * FROM ex_table_youtube_trending limit 3;

-- Viewing the top 10 rows from the external table with correct data types and column names
SELECT 
value:c1::varchar as video_id,
value:c2::varchar as title,
value:c3::timestamp as publishedAt,
value:c4::varchar as channelId,
value:c5::varchar as channelTitle,
value:c6::int as categoryId,
value:c7::date as trending_date,
value:c8::int as view_count,
value:c9::int as likes,
value:c10::int as dislikes,
value:c11::int as comment_count,
value:c12::boolean as comments_disabled
FROM ex_table_youtube_trending LIMIT 10;

-- Creating an external table with the correct data type and name for each columns
CREATE OR REPLACE EXTERNAL TABLE ex_table_youtube_trending
(
    video_id varchar as (value:c1::varchar),
    title varchar as (value:c2::varchar),
    publishedAt timestamp as (value:c3::timestamp),
    channelId varchar as (value:c4::varchar),
    channelTitle varchar as (value:c5::varchar),
    categoryId int as (value:c6::int),
    trending_date date as (value:c7::date),
    view_count int as (value:c8::int),
    likes int as (value:c9::int),
    dislikes int as (value:c10::int),
    comment_count int as (value:c11::int),
    comments_disabled boolean as (value:c12::boolean)
)
WITH LOCATION = @stage_bde_at_1
FILE_FORMAT = file_format_csv
PATTERN = '.*[.]csv';

--  Viewing all the columns from the ex_table_youtube_trending
SELECT * FROM ex_table_youtube_trending;

-- Looking at the file names of all the csv files 
SELECT metadata$filename FROM ex_table_youtube_trending;

-- Extracting the country code from each filename
SELECT
split_part(metadata$filename, '_', 0)
FROM ex_table_youtube_trending;


-- Transferring the data from the external table to a table for youtube_tranding data
CREATE OR REPLACE TABLE table_youtube_trending as
SELECT
video_id, title, publishedAt, channelId, channelTitle, categoryId, trending_date, view_count,
likes, dislikes, comment_count, comments_disabled,
split_part(metadata$filename, '_', 0) as country
FROM ex_table_youtube_trending;

-- View the table table_youtube_trending
select * from table_youtube_trending;


-- list all files from stage stage_bde_at_1
list @stage_bde_at_1;

-- Creating an external table for json files
CREATE OR REPLACE EXTERNAL TABLE ex_table_youtube_category
WITH LOCATION = @stage_bde_at_1
FILE_FORMAT = (TYPE=JSON)
PATTERN = '.*[.]json';

-- Viewing the external table of json files
SELECT * FROM ex_table_youtube_category;

-- Selecting the categoryId and category_title from the json objects
SELECT 
l.value:id::int as categoryId,
l.value:snippet:title::varchar as category_title
FROM ex_table_youtube_category,
LATERAL FLATTEN(value:items) as l;

-- Looking at the file names of all the json files 
SELECT metadata$filename FROM ex_table_youtube_category;

-- Extracting the country code from each filename
SELECT
split_part(metadata$filename, '_', 0)
FROM ex_table_youtube_category;

-- Creating a table with the extracted country code, categoryId and category_title
CREATE OR REPLACE TABLE table_youtube_category as
SELECT
split_part(metadata$filename, '_', 0) as country,
l.value:id::int as categoryId,
l.value:snippet:title::varchar as category_title
FROM ex_table_youtube_category,
LATERAL FLATTEN(value:items) as l;

-- Viewing table_youtube_category 
SELECT * FROM table_youtube_category;

-- Combining the two tables: table_youtube_trending and table_youtube_category
CREATE OR REPLACE TABLE table_youtube_final as
SELECT 
uuid_string() as id,
table_youtube_trending.video_id,
table_youtube_trending.title,
table_youtube_trending.publishedat,
table_youtube_trending.channelid,
table_youtube_trending.channeltitle,
table_youtube_trending.categoryid,
table_youtube_category.category_title,
table_youtube_trending.trending_date,
table_youtube_trending.view_count,
table_youtube_trending.likes,
table_youtube_trending.dislikes,
table_youtube_trending.comment_count,
table_youtube_trending.comments_disabled,
table_youtube_trending.country
FROM table_youtube_trending left outer join table_youtube_category
on table_youtube_trending.country = table_youtube_category.country and
table_youtube_trending.categoryid = table_youtube_category.categoryid;

-- Viewing the table_youtube_final table
SELECT * FROM table_youtube_final;

-- Checking the row counts of the tables
SELECT count(*) FROM table_youtube_trending;
SELECT count(*) FROM table_youtube_final;
SELECT count(*) FROM table_youtube_category;
--Netflix Data Analysis

select * from netflix

--Count the number of Movies vs TV Shows

select type, count(*) as total_count
from netflix
group by type;

--Find the most common rating for Movies and TV Shows

SELECT type, rating
FROM (
    SELECT 
        type,
        rating,
        COUNT(*) AS rating_count,
        RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS rank_no
    FROM netflix
    GROUP BY type, rating
) t
WHERE rank_no = 1;

--List all Movies released in a specific year (e.g., 2020)

SELECT *
FROM netflix
WHERE type = 'Movie'
  AND release_year = 2020;

--Find the top 5 countries with the most content on Netflix

SELECT
    TRIM(country_name) AS country,
    COUNT(*) AS total_content
FROM netflix
CROSS JOIN UNNEST(STRING_TO_ARRAY(country, ',')) AS country_name
GROUP BY country
ORDER BY total_content DESC
LIMIT 5;


--Identify the longest Movie or TV Show duration

select  
       type,
	   title,
	   duration
from netflix
where
type = 'Movie'
and duration = (select max(duration) from netflix);

--Find content added in the last 5 years
   
SELECT *
FROM netflix
where 
      to_date(date_added,'Month DD,YYYY') >= Current_date - interval '5 years';

--Find all Movies / TV Shows directed by Rajiv Chilaka

select * from netflix	 
	 where director like '%Rajiv Chilaka%'

--List all TV Shows with more than 5 seasons	 

SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND CAST(SPLIT_PART(duration, ' ', 1) AS INT) > 5;

--Count the number of content items in each genre

select
	 unnest(string_to_array(listed_in,',')) as genre,
	 count(show_id) as total_content
from netflix
group by 1;	

--Calculate the average number of content releases by Pakistan on Netflix for each year, 
--and return the top 5 years with the highest average releases.

SELECT
    EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year,
    COUNT(*) AS yearly_content,
    ROUND(
        COUNT(*)::numeric /
        (SELECT COUNT(*) FROM netflix WHERE country = 'Pakistan')::numeric * 100,
        2
    ) AS avg_content_per_year
FROM netflix
WHERE country = 'Pakistan'
GROUP BY year
ORDER BY avg_content_per_year DESC
LIMIT 5;

--List all Movies that are Documentaries	  

select  
       type,
	   listed_in
from netflix
       where type = 'Movie'
	   and listed_in ilike '%documentaries%';

--Find all content without a director

select * from netflix
where director is null

--Find how many Movies Mohamed Farraag appeared in during the last 10 years

 SELECT *
FROM netflix
WHERE casts ILIKE '%Mohamed Farraag%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;


--Find the top 10 actors with the highest number of Movies
SELECT
    TRIM(actor_name) AS actor,
    COUNT(*) AS total_content
FROM netflix
CROSS JOIN UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor_name
WHERE country ILIKE '%Pakistan%'
GROUP BY actor
ORDER BY total_content DESC
LIMIT 10;

--Categorize content based on keywords "kill" and "violence"

SELECT
    CASE
        WHEN description ILIKE '%kill%'
          OR description ILIKE '%violence%'
        THEN 'Bad'
        ELSE 'Good'
    END AS content_category,
    COUNT(*) AS total_count
FROM netflix
GROUP BY content_category;



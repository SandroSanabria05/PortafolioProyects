-- What are the sports that fulfilled all the games of the summer season?

with s1 as 
  (SELECT count(distinct games) as Total_summer_games 
  FROM OLYMPICS_HISTORY
  WHERE season = 'Summer'),
  
s2 as
  (SELECT distinct sport, games
  FROM OLYMPICS_HISTORY
  WHERE season = 'Summer' order by games),  
s3 as
  (SELECT sport, count(games) as no_of_games
  FROM s2
  group by sport)
  
  SELECT*
  FROM s3
  JOIN s1 on s1.Total_summer_games = s3.no_of_games;
  
-- Which are the 5 athletes who have at least a rank of 5 and a gold medall?
  
  with c1 as
  (SELECT name, COUNT(1) as total_medals
	  FROM olympics_history
  WHERE medal = 'Gold' 
   GROUP BY name
  ORDER BY COUNT(1) DESC),
  
c2 AS
  (SELECT *, DENSE_RANK() OVER(ORDER BY total_medals DESC) AS Rnk
  FROM c1)
  
 SELECT *
 FROM c2
 WHERE Rnk <= 5;
 
 -- Displays a list of players and which category they fall into
 
 SELECT DISTINCT name, city,
  CASE 
    WHEN weight ~ E'^\\d+$' AND CAST(weight AS integer) > 85 THEN 'Heavy'
    WHEN weight ~ E'^\\d+$' AND CAST(weight AS integer) >= 70 THEN 'Normal'
    ELSE 'Ligth'
  END AS weight_category
FROM olympics_history
ORDER BY name;
 
 
 -- What is the number of gold, bronze and silver medals that each country has?
 
 SELECT d.region as country, medal, count(1) as total_medals
FROM olympics_history as b
INNER JOIN olympics_history_noc_regions as d
ON d.noc = b.noc
where medal <> 'NA'
group by d.region, medal
order by d.region, medal;


SELECT country
, coalesce(gold, 0) as gold 
, coalesce(bronze, 0) as bronze
, coalesce(silver, 0) as silver
FROM crosstab ('SELECT d.region as country, medal, count(1) as total_medals
              FROM olympics_history as b
              INNER JOIN olympics_history_noc_regions as d on d.noc = b.noc 
              where medal <> ''NA''
              group by d.region, medal
              order by d.region, medal',
			  'values(''Bronze''), (''Gold''), (''Silver'')')
		as result(country varchar, bronze bigint, gold bigint, silver bigint) 
order by gold desc, bronze desc, silver desc;	    



 
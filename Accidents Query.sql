/*turning on the local infile*/
SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile=1;
/*dropping the table*/
DROP TABLE IF EXISTS accidents;
/*Creating a Table*/
create table accidents(
    SNo int AUTO_INCREMENT PRIMARY KEY,
    State VARCHAR(20) NOT NULL,
     Road_Accident_Cases int,
     Road_Accident_Injured int,
     	Road_Accident_Died int,
        	Railway_Accident_Cases int,
            	Railway_Accident_Injured int,
                	Railway_Accident_Died int,
                    	Railway_Crossing_Accidents_Cases int,
                        	Railway_Crossing_Accidents_Injured int,
                            	Railway_Crossing_Accidents_Died int,
                                	Total_Traffic_Accidents_Cases int,
                                    	Total_Traffic_Accidents_Injured int,
                                        	Total_Traffic_Accidents_Died int
);
/*Importing the .csv file*/ 
    Load data local INFILE'C:/Users/asus2/Downloads/Accidents.csv'
    into table accidents
    FIELDS TERMINATED by ','
    ENCLOSED by '"'
    Lines TERMINATED by '\n'
    IGNORE 1 ROWS;
    /*Retriving the Whole Data*/
    select * from accidents;
    /*Deleting the non Required Data*/
    DELETE from accidents where SNo >28;
/* returns states with maximum Road accident cases in descending order*/
    select State, max(Road_Accident_Cases) 
    FROM accidents
    GROUP BY State
    ORDER BY max(Road_Accident_Cases) DESC;
    /*Retriving States with more than 200 railway accidents cases*/
    SELECT State, Railway_Accident_Cases
    FROM accidents
    WHERE Railway_Accident_Cases>=200
    order by Railway_Accident_Cases;
/*returns top 10 road accidents cases states */
SELECT state, Road_Accident_Cases  FROM accidents
order by Road_Accident_Cases DESC 
limit 10;
/*top 10 road accidents deaths states*/
SELECT state, Road_Accident_Died  FROM accidents
order by Road_Accident_Died DESC 
limit 10;
/*states with 0 railway accident cases*/
SELECT state
FROM accidents
where Railway_Accident_Cases=0;
/*Average of road accidents*/
select avg(road_accident_cases)
from accidents;
/*Total number of road accident cases in india */
select SUM(road_accident_cases)
from accidents;
/*Total Accidents*/
SELECT State,Road_Accident_cases+Railway_accident_cases+railway_crossing_accidents_cases as total_cases
from accidents
order BY total_cases DESC;
/*States with mpore than 10000 road accidents*/
SELECT state
FROM accidents
where Road_Accident_Cases>10000;
/*states with 0 railway crossing accidents*/
SELECT state
FROM accidents
where Railway_crossing_Accidents_Cases=0;
/* Accident rate peer 100 deaths*/
SELECT state, ROUND(`Road_Accident_Died`*100/`Road_Accident_Cases`,2) as Road_death_rate
FROM accidents
ORDER BY Road_death_rate DESC;
/*railway cases injury rate*/
SELECT state, ROUND(`Railway_Accident_Injured`*100/`Railway_Accident_Cases`,2) as Railway_injury_rate
FROM accidents
ORDER BY Railway_injury_rate DESC ;
/*Top 5 states with lower Accidents*/
SELECT state as Safest_States, `Road_Accident_Cases`
FROM accidents
ORDER BY `Road_Accident_Cases`
LIMIT 5;
/*Top 5 states with Highest accidents*/
SELECT state as Dangerous_States, `Road_Accident_Cases`
FROM accidents
ORDER BY `Road_Accident_Cases` DESC
LIMIT 5;
/*Total Accidents by transport Type*/
Select sum(Road_Accident_cases) as Road,
SUM(Railway_Accident_Cases)as Railway,
SUM(railway_crossing_accidents_cases) as Railway_crossing
FROM accidents;
/*Ranking States by road accidents*/
SELECT State , Road_accident_cases,
RANK() OVER(ORDER BY Road_accident_cases DESC)as ranking
FROM accidents;
/*Dense_Ranking*/
SELECT State , Road_accident_cases,
DENSE_RANK() OVER(ORDER BY Road_accident_cases DESC)as ranking
FROM accidents;
/*Top 10% Accidents States*/
SELECT State , Road_accident_cases,
NTILE(10) OVER(ORDER BY Road_accident_cases DESC)as Percentage
FROM accidents;
/*Comparing Each state with national Average*/
SELECT state, Road_accident_cases, (SELECT ROUND(AVG(ROAD_ACCIDENT_CASES),2) FROM ACCIDENTS) as NATIONAL_AVERAGE
FROM ACCIDENTS;
/*STATES ABOVE AVERAGE ACCIDENTS*/
SELECT STATE, Road_accident_cases
FROM accidents
WHERE Road_accident_cases >(SELECT AVG(Road_accident_cases) 
FROM accidents);
/*Running Total*/
SELECT State , Road_accident_cases,
SUM(`Road_Accident_Cases`) OVER(ORDER BY Road_accident_cases DESC) as running_total
FROM accidents;
/*PERCENTAGE CONTRIBUTION*/
SELECT STATE , ROAD_ACCIDENT_CASES,ROUND( ROAD_ACCIDENT_CASES*100/(SUM( ROAD_ACCIDENT_CASES) OVER()),2)
FROM accidents
ORDER BY  ROAD_ACCIDENT_CASES;
/*INJURY-TO-DEATH RATIO of Road Accidents*/
SELECT STATE, ROUND( Road_Accident_Injured/Road_Accident_Died,2) AS INJURY_DEATH_RATIO
FROM accidents
ORDER BY  INJURY_DEATH_RATIO DESC;
/*STATE WITH MAXIMUM TOTAL ACCIDENTS*/
SELECT STATE, Road_Accident_Cases+Railway_Accident_Cases+Railway_Crossing_Accidents_Cases+Total_Traffic_Accidents_Cases AS TOTAL_ACCIDENTS
FROM accidents
ORDER BY  TOTAL_ACCIDENTS DESC
LIMIT 1;
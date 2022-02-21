--Data Exploration
SELECT * 
FROM [DATA_2019-20]
;




-- Ordering by 2020 Sat score

SELECT INSTNM, CITY, ADM_RATE, SAT_AVG
FROM [Data_2019-20]
ORDER BY SAT_AVG DESC;




-- Selecting a University Rank (TOP 20) sorted by lowest admision rate with AVG Sat Score (Avoiding null values)

SELECT TOP 20 INSTNM AS University, CITY, STABBR as STATE_CODE, ADM_RATE, Sat_AVG
FROM [Data_2019-20] AS D1
WHERE SAT_AVG IS NOT NULL 
AND ADM_RATE IS NOT NULL
ORDER BY ADM_RATE ASC;





-- See universities + cities in terms of annual cost (includes all expenses) ordered by descending cost

SELECT INSTNM, CITY, STABBR AS STATE_CODE, (COSTT4_A) AS ANNUAL_COST
FROM [Data_2019-20]
ORDER BY Annual_Cost DESC;




-- See the city in terms of annual cost (maximum for that city)

SELECT CITY, STABBR AS STATE_CODE, MAX(COSTT4_A) AS Annual_Cost
FROM [DATA_2019-20]
GROUP BY CITY, STABBR
ORDER BY Annual_Cost DESC;




--Inner Join with other years to compare data. Admision rates from one year to another.

SELECT TOP 20 D1.INSTNM AS University, D1.CITY, D1.STABBR as STATE_CODE, D1.ADM_RATE as AR_2019, D2.ADM_RATE as AR_2018, (D1.SAT_AVG + D2.SAT_AVG)/2 AS SAT_AVG
FROM [Data_2019-20] AS D1
INNER Join [Data_2018-19] AS D2
ON (D1.UNITID = D2.UNITID)
WHERE D1.SAT_AVG IS NOT NULL 
AND D1.ADM_RATE IS NOT NULL
ORDER BY D1.ADM_RATE ASC;




--  Inner Join with other years to compare data. Cost by university for 2017, 18 and 19

SELECT D1.INSTNM as University, D1.CITY as CITY, D1.STABBR AS STATE_CODE, D1.COSTT4_A AS COST_2019, D2.COSTT4_A AS COST_2018, D3.COSTT4_A AS COST_2017
	FROM [DATA_2019-20] AS D1
	INNER JOIN [DATA_2018-19] AS D2
	ON (D1.UNITID = D2.UNITID)
	INNER JOIN [DATA_2017-18] AS D3
	ON (D1.UNITID = D3.UNITID)

ORDER BY COST_2019 DESC;




--NUMBER OF UNIVERSITIES which have decreased costs over the last 3 years ranked by desc cost.

SELECT Count(D1.INSTNM) as Num_Unis_lwrCost
FROM [DATA_2019-20] AS D1
INNER JOIN [DATA_2018-19] AS D2
ON (D1.UNITID = D2.UNITID)
INNER JOIN [DATA_2017-18] AS D3
ON (D1.UNITID = D3.UNITID)
WHERE D1.COSTT4_A < D2.COSTT4_A AND D2.COSTT4_A < D3.COSTT4_A;




-- Which universities have decreased cost during both years? 

SELECT D1.INSTNM as University, D1.CITY as CITY, D1.STABBR AS STATE_CODE, D1.COSTT4_A AS COST_2019, D2.COSTT4_A AS COST_2018, D3.COSTT4_A AS COST_2017
FROM [DATA_2019-20] AS D1
INNER JOIN [DATA_2018-19] AS D2
ON (D1.UNITID = D2.UNITID)
INNER JOIN [DATA_2017-18] AS D3
ON (D1.UNITID = D3.UNITID)
WHERE D1.COSTT4_A < D2.COSTT4_A AND D2.COSTT4_A < D3.COSTT4_A
ORDER BY D1.COSTT4_A DESC;




-- Which of them increased prices? and By how much?

SELECT D1.INSTNM as University, D1.CITY as CITY, D1.STABBR AS STATE_CODE,
ROUND(((D1.COSTT4_A - D2.COSTT4_A)/D2.COSTT4_A)*100 , 3) as Delta_2019, ROUND(((D2.COSTT4_A - D3.COSTT4_A)/D3.COSTT4_A)*100 , 3) as Delta_2018
FROM [DATA_2019-20] AS D1
INNER JOIN [DATA_2018-19] AS D2
ON (D1.UNITID = D2.UNITID)
INNER JOIN [DATA_2017-18] AS D3
ON (D1.UNITID = D3.UNITID)
WHERE D1.COSTT4_A > D2.COSTT4_A AND D2.COSTT4_A > D3.COSTT4_A
ORDER BY  D1.COSTT4_A  DESC;




-- What share of students receive a loan in 2019/20 on the top expensive universities?

SELECT D1.INSTNM as University, D1.CITY as CITY, D1.STABBR AS STATE_CODE,
	D1.COSTT4_A AS COST_2019, D2.COSTT4_A AS COST_2018, D3.COSTT4_A AS COST_2017, D1.PCTFLOAN AS LOAN2019
FROM [DATA_2019-20] AS D1
INNER JOIN [DATA_2018-19] AS D2
ON (D1.UNITID = D2.UNITID)
INNER JOIN [DATA_2017-18] AS D3
ON (D1.UNITID = D3.UNITID)
ORDER BY COST_2019 DESC;




-- For those universities where the price increased, how did the loan share change?

SELECT D1.INSTNM AS UNIVERSITY, D1.CITY, D1.STABBR AS STATE_CODE,
		ISNULL(ROUND(((D1.PCTFLOAN - D2.PCTFLOAN)/NULLIF(D2.PCTFLOAN,0))*100 , 3),0) as DELTA_LOAN_2019, --ISNULL changes NULL into 0. NULLIF changes 0s into Nulls.
	   ISNULL(ROUND(((D2.PCTFLOAN - D3.PCTFLOAN)/NULLIF(D3.PCTFLOAN,0))*100 , 3),0) as DELTA_LOAN_2018 --Important to use Nullif//ISNULL when dividing by potential 0s. 
FROM [DATA_2019-20] AS D1 
INNER JOIN [DATA_2018-19] AS D2
ON (D1.UNITID = D2.UNITID)
INNER JOIN [DATA_2017-18] AS D3
ON (D1.UNITID = D3.UNITID)
WHERE D1.COSTT4_A > D2.COSTT4_A AND D2.COSTT4_A > D3.COSTT4_A
ORDER BY D1.COSTT4_A DESC;




-- Avg change of loan share for ttop 20 universities where the price increased. (use a subquery in the from clause)

SELECT AVG(DELTA_LOAN_2019) AS AVERAGE_CHANGE19, AVG(DELTA_LOAN_2018) AS AVERAGE_CHANGE18
FROM (SELECT TOP 20 D1.INSTNM AS UNIVERSITY, D1.CITY, D1.STABBR AS STATE_CODE,
		ISNULL(ROUND(((D1.PCTFLOAN - D2.PCTFLOAN)/NULLIF(D2.PCTFLOAN,0))*100 , 3),0) as DELTA_LOAN_2019, --ISNULL changes NULL into 0. NULLIF changes 0s into Nulls.
	    ISNULL(ROUND(((D2.PCTFLOAN - D3.PCTFLOAN)/NULLIF(D3.PCTFLOAN,0))*100 , 3),0) as DELTA_LOAN_2018 --Important to use Nullif//ISNULL when dividing by potential 0s. 
	FROM [DATA_2019-20] AS D1 
	INNER JOIN [DATA_2018-19] AS D2
	ON (D1.UNITID = D2.UNITID)
	INNER JOIN [DATA_2017-18] AS D3
	ON (D1.UNITID = D3.UNITID)
	WHERE D1.COSTT4_A > D2.COSTT4_A AND D2.COSTT4_A > D3.COSTT4_A
	ORDER BY D1.COSTT4_A DESC
	) 
DELTAS;-- we need to alias the subquery




-- Lowest Admision rate universities, loan share %-change per year.

SELECT TOP 20 D1.INSTNM AS UNIVERSITY,D1.CITY, D1.STABBR as STATE_CODE, 
		ISNULL(ROUND(((D1.PCTFLOAN - D2.PCTFLOAN)/NULLIF(D2.PCTFLOAN,0))*100 , 3),0) as DELTA_LOAN_2019, 
	   ISNULL(ROUND(((D2.PCTFLOAN - D3.PCTFLOAN)/NULLIF(D3.PCTFLOAN,0))*100 , 3),0) as DELTA_LOAN_2018 
FROM [DATA_2019-20] AS D1 
INNER Join [Data_2018-19] AS D2
ON (D1.UNITID = D2.UNITID)
INNER JOIN [DATA_2017-18] AS D3
ON (D1.UNITID = D3.UNITID)
WHERE D1.SAT_AVG IS NOT NULL AND D1.ADM_RATE IS NOT NULL
ORDER BY D1.ADM_RATE ASC;




-- Average Results for the lowest admision rate universities' loan %change per year

SELECT AVG(DELTA_LOAN_2019) AS AVERAGE_CHANGE19, AVG(DELTA_LOAN_2018) AS AVERAGE_CHANGE18
FROM (SELECT TOP 20 D1.INSTNM AS UNIVERSITY, ISNULL(ROUND(((D1.PCTFLOAN - D2.PCTFLOAN)/NULLIF(D2.PCTFLOAN,0))*100 , 3),0) as DELTA_LOAN_2019, 
		ISNULL(ROUND(((D2.PCTFLOAN - D3.PCTFLOAN)/NULLIF(D3.PCTFLOAN,0))*100 , 3),0) as DELTA_LOAN_2018 
	FROM [DATA_2019-20] AS D1
	INNER JOIN [DATA_2018-19] AS D2
	ON (D1.UNITID = D2.UNITID)
	INNER JOIN [DATA_2017-18] AS D3
	ON (D1.UNITID = D3.UNITID)
	WHERE D1.ADM_RATE IS NOT NULL AND D1.SAT_AVG IS NOT NULL
	ORDER BY D1.ADM_RATE ASC
	) DELTAS; --Decreasing loan shares for these top rated universities.



------------------------------------------------------------------------




-- Window Functions: Compare SAT_AVG with SAT_AVG grouped by city

SELECT INSTNM, CITY, STABBR, UGDS, SAT_AVG, ADM_RATE, AVG(SAT_AVG) OVER(PARTITION BY CITY) AS SAT_AVG_CITY, 
	CASE WHEN SAT_AVG > AVG(SAT_AVG) OVER(PARTITION BY CITY, STABBR)
		THEN 'Above City AVG'
		WHEN SAT_AVG = AVG(SAT_AVG) OVER(PARTITION BY CITY, STABBR)
		THEN 'At City AVG'
		ELSE 'Below City AVG'
	END AS SAT_COMPARED
FROM [DATA_2019-20]
WHERE SAT_AVG IS NOT NULL AND ADM_RATE IS NOT NULL
ORDER BY UGDS DESC;




-- Rank the UNIVERSITIES (without grouping them) using SAT_AVG Score

SELECT INSTNM, CITY, STABBR, UGDS, SAT_AVG, ADM_RATE, AVG(SAT_AVG) OVER(PARTITION BY CITY) AS SAT_AVG_CITY, 
	CASE WHEN SAT_AVG > AVG(SAT_AVG) OVER(PARTITION BY CITY, STABBR)
		THEN 'Above AVG'
		WHEN SAT_AVG = AVG(SAT_AVG) OVER(PARTITION BY CITY, STABBR)
		THEN 'At AVG'
		ELSE 'Below AVG'
	END AS SAT_COMPARED,
	RANK() OVER( ORDER BY SAT_AVG DESC) AS RANKS
FROM [DATA_2019-20]
WHERE SAT_AVG IS NOT NULL AND ADM_RATE IS NOT NULL
ORDER BY UGDS DESC;




-- Rank by state instead of overall. ADD total number of universities by state. 

SELECT INSTNM, CITY, STABBR, UGDS, SAT_AVG, ADM_RATE, AVG(SAT_AVG) OVER(PARTITION BY STABBR) AS SAT_AVG_STATE, -- Change the Average_(SATAVG) to State instead of City
	CASE WHEN SAT_AVG > AVG(SAT_AVG) OVER(PARTITION BY STABBR) 
		THEN 'Above AVG'
		WHEN SAT_AVG = AVG(SAT_AVG) OVER(PARTITION BY  STABBR)
		THEN 'At AVG'
		ELSE 'Below AVG'
	END AS SAT_COMPARED,
	DENSE_RANK() OVER(PARTITION BY STABBR ORDER BY SAT_AVG DESC) AS RANKS,
	COUNT(INSTNM) OVER (PARTITION BY STABBR) AS TOTAL_INST
FROM [DATA_2019-20]
WHERE SAT_AVG IS NOT NULL AND ADM_RATE IS NOT NULL
ORDER BY STABBR DESC;




-- Select only those universities that ranked 1st of each state (use recursive clause)

WITH RANKING AS (
SELECT INSTNM, CITY, STABBR, UGDS, SAT_AVG, ADM_RATE, AVG(SAT_AVG) OVER(PARTITION BY STABBR) AS SAT_AVG_STATE, 
	CASE WHEN SAT_AVG > AVG(SAT_AVG) OVER(PARTITION BY STABBR)
		THEN 'Above AVG'
		WHEN SAT_AVG = AVG(SAT_AVG) OVER(PARTITION BY  STABBR)
		THEN 'At AVG'
		ELSE 'Below AVG'
	END AS SAT_COMPARED,
	DENSE_RANK() OVER(PARTITION BY STABBR ORDER BY SAT_AVG DESC) AS RANKS,
	COUNT(INSTNM) OVER (PARTITION BY STABBR) AS TOTAL_INST
FROM [DATA_2019-20]
WHERE SAT_AVG IS NOT NULL AND ADM_RATE IS NOT NULL
)
SELECT INSTNM, CITY, STABBR, UGDS, SAT_AVG, ADM_RATE, SAT_AVG_STATE, SAT_COMPARED, RANKS, TOTAL_INST
FROM RANKING
WHERE RANKS = 1;




-- What is the approx. amount of appliacations that these top ranked universities get yearly? UGDS = enrolled students per year

WITH RANKING AS (
SELECT INSTNM, CITY, STABBR, UGDS, UGDS/ADM_RATE as TOTAL_APPLICATION, SAT_AVG, ADM_RATE, AVG(SAT_AVG) OVER(PARTITION BY STABBR) AS SAT_AVG_STATE, 
	CASE WHEN SAT_AVG > AVG(SAT_AVG) OVER(PARTITION BY STABBR)
		THEN 'Above AVG'
		WHEN SAT_AVG = AVG(SAT_AVG) OVER(PARTITION BY  STABBR)
		THEN 'At AVG'
		ELSE 'Below AVG'
	END AS SAT_COMPARED,
	DENSE_RANK() OVER(PARTITION BY STABBR ORDER BY SAT_AVG DESC) AS RANKS,
	COUNT(INSTNM) OVER (PARTITION BY STABBR) AS TOTAL_INST
FROM [DATA_2019-20]
WHERE SAT_AVG IS NOT NULL AND ADM_RATE IS NOT NULL
)
SELECT INSTNM, CITY, STABBR, UGDS, ROUND(UGDS/ADM_RATE, 0) as TOTAL_APPLICATIONS, SAT_AVG, ADM_RATE, SAT_AVG_STATE, SAT_COMPARED, RANKS, TOTAL_INST
FROM RANKING
WHERE RANKS = 1
ORDER BY SAT_AVG_STATE DESC;




-- What about the last 3 years? What universities are ranked first according to the 3 year mean istead of just looking at 2020?

WITH RANKING AS (
	SELECT D1.INSTNM, D1.CITY, D1.STABBR, D1.UGDS, D1.ADM_RATE, D1.SAT_AVG AS SAT_2020, D2.SAT_AVG AS SAT_2019, D3.SAT_AVG AS SAT_2018, ROUND(((D1.SAT_AVG+D2.SAT_AVG+D3.SAT_AVG)/3),2) AS MEAN_SAT_AVG,
		DENSE_RANK() OVER(PARTITION BY D1.STABBR ORDER BY (D1.SAT_AVG+D2.SAT_AVG+D3.SAT_AVG)/3 DESC) AS RANKS_BY_MEAN,
		COUNT(D1.INSTNM) OVER (PARTITION BY D1.STABBR) AS TOTAL_INST

	FROM [DATA_2019-20] AS D1
	INNER JOIN [DATA_2018-19] AS D2 ON (D1.UNITID = D2.UNITID)
	INNER JOIN [DATA_2017-18] AS D3 ON (D1.UNITID = D3.UNITID)
	WHERE D1.SAT_AVG IS NOT NULL AND D1.ADM_RATE IS NOT NULL
)
SELECT INSTNM, CITY, STABBR, UGDS, ADM_RATE, SAT_2020, SAT_2019, SAT_2018, MEAN_SAT_AVG,
RANKS_BY_MEAN
FROM RANKING 
WHERE RANKS_BY_MEAN = 1;




-- Compare both results using intersect/except

WITH RANKING AS (
	SELECT D1.INSTNM, D1.CITY, D1.STABBR, D1.UGDS, D1.ADM_RATE, D1.SAT_AVG AS SAT_2020, D2.SAT_AVG AS SAT_2019, D3.SAT_AVG AS SAT_2018, ROUND(((D1.SAT_AVG+D2.SAT_AVG+D3.SAT_AVG)/3),2) AS MEAN_SAT_AVG,
		DENSE_RANK() OVER(PARTITION BY D1.STABBR ORDER BY (D1.SAT_AVG+D2.SAT_AVG+D3.SAT_AVG)/3 DESC) AS RANKS_BY_MEAN,
		COUNT(D1.INSTNM) OVER (PARTITION BY D1.STABBR) AS TOTAL_INST,
		DENSE_RANK() OVER(PARTITION BY D1.STABBR ORDER BY D1.SAT_AVG DESC) AS RANKS

	FROM [DATA_2019-20] AS D1
	INNER JOIN [DATA_2018-19] AS D2 ON (D1.UNITID = D2.UNITID)
	INNER JOIN [DATA_2017-18] AS D3 ON (D1.UNITID = D3.UNITID)
	WHERE D1.SAT_AVG IS NOT NULL AND D1.ADM_RATE IS NOT NULL
)
SELECT INSTNM, STABBR
FROM RANKING
WHERE RANKS = 1
INTERSECT
SELECT INSTNM, STABBR
FROM RANKING 
WHERE RANKS_BY_MEAN = 1;




--Select Universities with a new student count above average that ranked first by state according to Sat Score (3 year mean):

WITH RANKING AS (
	SELECT D1.INSTNM AS INSTNM, D1.CITY AS CITY, D1.STABBR AS STATE, D1.ADM_RATE AS ADM_RATE, D1.UGDS AS UGDS,
	AVG(D1.UGDS) OVER() AS AVG_2020_UGDS, 
	DENSE_RANK() OVER(PARTITION BY D1.STABBR ORDER BY (D1.SAT_AVG+D2.SAT_AVG+D3.SAT_AVG)/3 DESC) AS RANKS_BY_MEAN,
	CASE WHEN D1.UGDS > AVG(D1.UGDS) OVER()
		THEN 'ABOVE AVG'
		ELSE 'BELOW AVG'
	END AS STUDENT_COUNT_CHECK

	FROM [DATA_2019-20] AS D1
	INNER JOIN [DATA_2018-19] AS D2 ON (D1.UNITID = D2.UNITID)
	INNER JOIN [DATA_2017-18] AS D3 ON (D1.UNITID = D3.UNITID)
	WHERE D1.SAT_AVG IS NOT NULL AND D1.ADM_RATE IS NOT NULL
)
SELECT INSTNM, CITY, STATE, ADM_RATE, UGDS
FROM RANKING 
WHERE RANKS_BY_MEAN = 1 AND STUDENT_COUNT_CHECK = 'ABOVE AVG'
ORDER BY UGDS DESC;




-- Select the university with a new student count above avg, with the highest adm_rate and that ranked first according to sat score (3 year mean):

WITH RANKING AS (
	SELECT D1.INSTNM AS INSTNM, D1.CITY AS CITY, D1.STABBR AS STATE, D1.ADM_RATE AS ADM_RATE, D1.UGDS AS UGDS,
	AVG(D1.UGDS) OVER() AS AVG_2020_UGDS, 
	DENSE_RANK() OVER(PARTITION BY D1.STABBR ORDER BY (D1.SAT_AVG+D2.SAT_AVG+D3.SAT_AVG)/3 DESC) AS RANKS_BY_MEAN,
    COUNT(D1.INSTNM) OVER (PARTITION BY D1.STABBR) AS TOTAL_INST,
	CASE WHEN D1.UGDS > AVG(D1.UGDS) OVER()
		THEN 'ABOVE AVG'
		ELSE 'BELOW AVG'
	END AS STUDENT_COUNT_CHECK

	FROM [DATA_2019-20] AS D1
	INNER JOIN [DATA_2018-19] AS D2 ON (D1.UNITID = D2.UNITID)
	INNER JOIN [DATA_2017-18] AS D3 ON (D1.UNITID = D3.UNITID)
	WHERE D1.SAT_AVG IS NOT NULL AND D1.ADM_RATE IS NOT NULL
)
SELECT TOP 5 INSTNM, CITY, STATE, ADM_RATE, UGDS, TOTAL_INST
FROM RANKING 
WHERE RANKS_BY_MEAN = 1 AND STUDENT_COUNT_CHECK = 'ABOVE AVG'
ORDER BY ADM_RATE DESC; --Big universities, top 1 of their States in terms of Sat Score, WITH A HIGH ADMISION RATE.
--Without a clue of how these universities really are, if I wanted to ensure I got into a decent College, I would go for University of Kansas...


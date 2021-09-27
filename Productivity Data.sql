/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [RespondentID]
      ,[Age]
      ,[How important would you say feeling productive is to your happin]
      ,[How productive do you currently feel overall?]
      ,[In what city do you live?]
      ,[In what state or U#S# state or territory do you live (if applica]
      ,[What country do you live in?]
      ,[What is the biggest challenge you face to being productive?]
      ,[When are you most productive?]
      ,[Which of the following best describes the principal industry of ]
      ,[Date]
  FROM [Project3].[dbo].[fProductivityData]

  --LOOKING AT THE DATA
SELECT *
FROM [Project3].[dbo].[fProductivityData]
ORDER BY [Age]

--1. REMOVE UNUSED COLUMN
  ALTER TABLE [Project3].[dbo].[fProductivityData]
  DROP COLUMN [In what city do you live?], [In what state or U#S# state or territory do you live (if applica]
--2. REMOVE UNUSED COLUMN
  ALTER TABLE [Project3].[dbo].[fProductivityData]
  DROP COLUMN [Date]
---


--3. a) REPLACE NULL by No information in the column 
  UPDATE [Project3].[dbo].[fProductivityData]
  SET [Age] = 'No information'
  WHERE [Age] is NULL
--3. b) REPLACE NULL by No information in the column 
  UPDATE [Project3].[dbo].[fProductivityData]
  SET [What country do you live in?] = 'No Information'
  WHERE [What country do you live in?] is NULL
--3. c) REPLACE NULL by No information in the column 
  UPDATE [Project3].[dbo].[fProductivityData]
  SET [What is the biggest challenge you face to being productive?] = 'No Information'
  WHERE [What is the biggest challenge you face to being productive?] is NULL
--3. d) REPLACE NULL by No information in the column 
  UPDATE [Project3].[dbo].[fProductivityData]
  SET [Job] = 'No Information'
  WHERE [Job] is NULL
---


--4. Looking at the second table, looking at duplicates:
USE [Project3]
SELECT [RespondentID],  COUNT(*)
FROM [Project3].[dbo].[dHelpfulThings]
GROUP BY [RespondentID]


---


 -- 4.a ) REPLACE NULL BY No information in the column
USE [Project3]
UPDATE [Project3].[dbo].[dHelpfulThings]
SET [what makes you energized] = 'No information'
WHERE [what makes you energized] is NULL
-- 4.b) Verify if it works.
USE [Project3]
SELECT *
FROM [Project3].[dbo].[dHelpfulThings]
---


-- 5. Combine two tables based on a related column by JOIN
SELECT *
FROM [Project3].[dbo].[fProductivityData] f
	LEFT JOIN [Project3].[dbo].[dHelpfulThings] d
	ON f.[RespondentID] = d.[RespondentID]
ORDER BY [Age]

--- 6. The quantity of respondets
SELECT count(*) as [The Quantity of Respondets]
FROM Project3.[dbo].[fProductivityData]



-- 7. How important would you say feeling productive is your happinness. TEMP TABLE was created to store results.
--7a) Age 22 - 25 
DROP TABLE IF EXISTS #FeelingProductive
CREATE TABLE #FeelingProductive (
[Age] varchar(300),
[How important would you say feeling productive is to your happin] varchar(300),
[The Quantity of feeling productivity is your happinnes] int NOT NULL
)
INSERT INTO #FeelingProductive
	SELECT DISTINCT  [Age],[How important would you say feeling productive is to your happin], 
			CAST(count([How important would you say feeling productive is to your happin]) OVER (PARTITION BY [How important would you say feeling productive is to your happin]) AS NUMERIC) as [The Quantity of feeling productivity is your happinnes]
	FROM Project3.[dbo].[fProductivityData]
	WHERE [Age] = '22-25'
	ORDER BY [The Quantity of feeling productivity is your happinnes] DESC
 
-- 7b) Age 30-33
DROP TABLE IF EXISTS #FeelingProductive3033
CREATE TABLE #FeelingProductive3033 (
[Age] varchar(300),
[How important would you say feeling productive is to your happin] varchar(300),
[The Quantity of feeling productivity is your happinnes] int NOT NULL
)
INSERT INTO #FeelingProductive3033
	SELECT DISTINCT  [Age],[How important would you say feeling productive is to your happin], 
			CAST(count([How important would you say feeling productive is to your happin]) OVER (PARTITION BY [How important would you say feeling productive is to your happin]) AS NUMERIC) as [The Quantity of feeling productivity is your happinnes]
	FROM Project3.[dbo].[fProductivityData]
	WHERE [Age] = '30-33'
	ORDER BY [The Quantity of feeling productivity is your happinnes] DESC


 --7c) Age 38-44
DROP TABLE IF EXISTS #FeelingProductive3844
CREATE TABLE #FeelingProductive3844 (
[Age] varchar(300),
[How important would you say feeling productive is to your happin] varchar(300),
[The Quantity of feeling productivity is your happinnes] int NOT NULL
)
INSERT INTO #FeelingProductive3844
	SELECT DISTINCT  [Age],[How important would you say feeling productive is to your happin], 
			CAST(count([How important would you say feeling productive is to your happin]) OVER (PARTITION BY [How important would you say feeling productive is to your happin]) AS NUMERIC) as [The Quantity of feeling productivity is your happinnes]
	FROM Project3.[dbo].[fProductivityData]
	WHERE [Age] = '38-44'
	ORDER BY [The Quantity of feeling productivity is your happinnes] DESC

--7d) Age 55+
DROP TABLE IF EXISTS #FeelingProductive55
CREATE TABLE #FeelingProductive55 (
[Age] varchar(300),
[How important would you say feeling productive is to your happin] varchar(300),
[The Quantity of feeling productivity is your happinnes] int NOT NULL
)
INSERT INTO #FeelingProductive55
	SELECT DISTINCT  [Age],[How important would you say feeling productive is to your happin], 
			CAST(count([How important would you say feeling productive is to your happin]) OVER (PARTITION BY [How important would you say feeling productive is to your happin]) AS NUMERIC) as [The Quantity of feeling productivity is your happinnes]
	FROM Project3.[dbo].[fProductivityData]
	WHERE [Age] = '55+'
	ORDER BY [The Quantity of feeling productivity is your happinnes] DESC


--7e) Showing all records on the perctangein one table by using CTE and Union.
-- We create CTE to store the result set of queries, then we combine these results into one by UNION
DECLARE @Total1 float;
SET @Total1 = (SELECT SUM([The Quantity of feeling productivity is your happinnes]) as Total1 FROM #FeelingProductive);
PRINT @Total1
DECLARE @Total2 float;
SET @Total2 = (SELECT SUM([The Quantity of feeling productivity is your happinnes]) as Total2 FROM #FeelingProductive3033);
PRINT @Total2
DECLARE @Total3 float;
SET @Total3 = (SELECT SUM([The Quantity of feeling productivity is your happinnes]) as Total3 FROM #FeelingProductive3844);
PRINT @Total3
DECLARE @Total4 float;
SET @Total4 = (SELECT SUM([The Quantity of feeling productivity is your happinnes]) as Total4 FROM #FeelingProductive55);
PRINT @Total4;
WITH  Age2225 AS (
SELECT [Age],[How important would you say feeling productive is to your happin],
		CONCAT((CAST(CAST([The Quantity of feeling productivity is your happinnes] as float) / @Total1 as DECIMAL(32,2))*100), ' ','%') as [The Percentage of feeling productivity is your happinnes]
FROM #FeelingProductive
), Age3033 AS (
SELECT [Age],[How important would you say feeling productive is to your happin],
		CONCAT((CAST(CAST([The Quantity of feeling productivity is your happinnes] as float) / @Total2 as DECIMAL(32,2))*100), ' ','%') as [The Percentage of feeling productivity is your happinnes]
FROM #FeelingProductive3033
), Age3844 AS (
SELECT [Age],[How important would you say feeling productive is to your happin],
		CONCAT((CAST(CAST([The Quantity of feeling productivity is your happinnes] as float) / @Total3 as DECIMAL(32,2))*100), ' ','%') as [The Percentage of feeling productivity is your happinnes]
FROM #FeelingProductive3844
), Age55 AS (
SELECT [Age],[How important would you say feeling productive is to your happin],
		CONCAT((CAST(CAST([The Quantity of feeling productivity is your happinnes] as float) / @Total4 as DECIMAL(32,2))*100), ' ','%') as [The Percentage of feeling productivity is your happinnes]
FROM #FeelingProductive55
)
SELECT *
FROM Age2225
UNION ALL
SELECT *
FROM Age3033
UNION ALL
SELECT *
FROM Age3844
UNION ALL
SELECT *
FROM Age55
ORDER BY 1,3 DESC




---8. How productive do you currently feel overall?. TEMP TABLE was created to store results.
--8.a) Age 22-25
DROP TABLE IF EXISTS #HowYouFeelProductiveOverall2225
CREATE TABLE #HowYouFeelProductiveOverall2225 (
[Age] varchar(300),
[How productive do you currently feel overall?] varchar(300),
[The Quantity of Feel productive overall] int NOT NULL
)
INSERT INTO #HowYouFeelProductiveOverall2225
	SELECT DISTINCT  [Age],[How productive do you currently feel overall?], 
			CAST(count([How productive do you currently feel overall?]) OVER (PARTITION BY [How productive do you currently feel overall?]) AS NUMERIC) as [The Quantity of Feel productive overall]
	FROM Project3.[dbo].[fProductivityData]
	WHERE [Age] = '22-25'
	ORDER BY [The Quantity of Feel productive overall] DESC


--8.b) Age 30-33
DROP TABLE IF EXISTS #HowYouFeelProductiveOverall3033
CREATE TABLE #HowYouFeelProductiveOverall3033 (
[Age] varchar(300),
[How productive do you currently feel overall?] varchar(300),
[The Quantity of Feel productive overall] int NOT NULL
)
INSERT INTO #HowYouFeelProductiveOverall3033
	SELECT DISTINCT  [Age],[How productive do you currently feel overall?], 
			CAST(count([How productive do you currently feel overall?]) OVER (PARTITION BY [How productive do you currently feel overall?]) AS NUMERIC) as [The Quantity of Feel productive overall]
	FROM Project3.[dbo].[fProductivityData]
	WHERE [Age] = '30-33'
	ORDER BY [The Quantity of Feel productive overall] DESC

--8c) Age 38-44
DROP TABLE IF EXISTS #HowYouFeelProductiveOverall3844
CREATE TABLE #HowYouFeelProductiveOverall3844 (
[Age] varchar(300),
[How productive do you currently feel overall?] varchar(300),
[The Quantity of Feel productive overall] int NOT NULL
)
INSERT INTO #HowYouFeelProductiveOverall3844
	SELECT DISTINCT  [Age],[How productive do you currently feel overall?], 
			CAST(count([How productive do you currently feel overall?]) OVER (PARTITION BY [How productive do you currently feel overall?]) AS NUMERIC) as [The Quantity of Feel productive overall]
	FROM Project3.[dbo].[fProductivityData]
	WHERE [Age] = '38-44'
	ORDER BY [The Quantity of Feel productive overall] DESC


--8.d) Age 55+
DROP TABLE IF EXISTS #HowYouFeelProductiveOverall55
CREATE TABLE #HowYouFeelProductiveOverall55 (
[Age] varchar(300),
[How productive do you currently feel overall?] varchar(300),
[The Quantity of Feel productive overall] int NOT NULL
)
INSERT INTO #HowYouFeelProductiveOverall55
	SELECT DISTINCT  [Age],[How productive do you currently feel overall?], 
			CAST(count([How productive do you currently feel overall?]) OVER (PARTITION BY [How productive do you currently feel overall?]) AS NUMERIC) as [The Quantity of Feel productive overall]
	FROM Project3.[dbo].[fProductivityData]
	WHERE [Age] = '55+'
	ORDER BY [The Quantity of Feel productive overall] DESC



--8.e) Showing all records on the perctangein one table by using CTE and Union.
-- We create CTE to store the result set of queries, then we combine these results into one by UNION
DECLARE @Total5 float;
SET @Total5 = (SELECT SUM([The Quantity of Feel productive overall]) as Total5 FROM #HowYouFeelProductiveOverall2225);
PRINT @Total5
DECLARE @Total6 float;
SET @Total6 = (SELECT SUM([The Quantity of Feel productive overall]) as Total6 FROM #HowYouFeelProductiveOverall3033);
PRINT @Total6
DECLARE @Total7 float;
SET @Total7 = (SELECT SUM([The Quantity of Feel productive overall]) as Total7 FROM #HowYouFeelProductiveOverall3844);
PRINT @Total7
DECLARE @Total8 float;
SET @Total8 = (SELECT SUM([The Quantity of Feel productive overall]) as Total8 FROM #HowYouFeelProductiveOverall55);
PRINT @Total8;
WITH Age2225 AS (
	SELECT [Age],[How productive do you currently feel overall?],
			CONCAT((CAST(CAST([The Quantity of Feel productive overall] as float) / @Total5 as DECIMAL(32,2))*100), ' ', '%') as [The Percentage of feeling productivty overall]
	FROM #HowYouFeelProductiveOverall2225
), Age3033 AS (
SELECT [Age],[How productive do you currently feel overall?],
		CONCAT((CAST(CAST([The Quantity of Feel productive overall] as float) / @Total6 as DECIMAL(32,2))*100),' ','%') as [The Percentage of feeling productivty overall]
FROM #HowYouFeelProductiveOverall3033
), Age3844 AS (
	SELECT [Age],[How productive do you currently feel overall?],
		CONCAT((CAST(CAST([The Quantity of Feel productive overall] as float) / @Total7 as DECIMAL(32,2))*100),' ','%') as [The Percentage of feeling productivty overall]
FROM #HowYouFeelProductiveOverall3844
), Age55 AS (
SELECT [Age],[How productive do you currently feel overall?],
		CONCAT((CAST(CAST([The Quantity of Feel productive overall] as float) / @Total8 as DECIMAL(32,2))*100),' ','%') as [The Percentage of feeling productivty overall]
FROM #HowYouFeelProductiveOverall55
)
SELECT *
FROM Age2225
UNION ALL
SELECT *
FROM Age3033
UNION ALL
SELECT *
FROM Age3844
UNION ALL
SELECT *
FROM Age55
ORDER BY 1,3 DESC




---9. What country do you live. TEMP TABLE was created to store results.
--9.a) Age 22-25
DROP TABLE IF EXISTS #Country2225
CREATE TABLE #Country2225 (
[Age] varchar(300),
[What country do you live in] varchar(300),
[The Quantity of Respondets Country] int NOT NULL
)
INSERT INTO #Country2225
	SELECT DISTINCT  [Age],[What country do you live in?], 
			CAST(count([What country do you live in?]) OVER (PARTITION BY [What country do you live in?]) AS NUMERIC) as [The Quantity of Respondets Country]
	FROM Project3.[dbo].[fProductivityData]
	WHERE [Age] = '22-25'
	ORDER BY [The Quantity of Respondets Country] DESC

--9.b) Age 30-33
DROP TABLE IF EXISTS #Country3033
CREATE TABLE #Country3033 (
[Age] varchar(300),
[What country do you live in] varchar(300),
[The Quantity of Respondets Country] int NOT NULL
)
INSERT INTO #Country3033
	SELECT DISTINCT  [Age],[What country do you live in?], 
			CAST(count([What country do you live in?]) OVER (PARTITION BY [What country do you live in?]) AS NUMERIC) as [The Quantity of Respondets Country]
	FROM Project3.[dbo].[fProductivityData]
	WHERE [Age] = '30-33'
	ORDER BY [The Quantity of Respondets Country] DESC

--9.c) Age 38-44
DROP TABLE IF EXISTS #Country3844
CREATE TABLE #Country3844 (
[Age] varchar(300),
[What country do you live in] varchar(300),
[The Quantity of Respondets Country] int NOT NULL
)
INSERT INTO #Country3844
	SELECT DISTINCT  [Age],[What country do you live in?], 
			CAST(count([What country do you live in?]) OVER (PARTITION BY [What country do you live in?]) AS NUMERIC) as [The Quantity of Respondets Country]
	FROM Project3.[dbo].[fProductivityData]
	WHERE [Age] = '38-44'
	ORDER BY [The Quantity of Respondets Country] DESC


--9.d) Age 55+
DROP TABLE IF EXISTS #Country55
CREATE TABLE #Country55 (
[Age] varchar(300),
[What country do you live in] varchar(300),
[The Quantity of Respondets Country] int NOT NULL
)
INSERT INTO #Country55
	SELECT DISTINCT  [Age],[What country do you live in?], 
			CAST(count([What country do you live in?]) OVER (PARTITION BY [What country do you live in?]) AS NUMERIC) as [The Quantity of Respondets Country]
	FROM Project3.[dbo].[fProductivityData]
	WHERE [Age] = '55+'
	ORDER BY [The Quantity of Respondets Country] DESC

--9.e) e) Showing all records on the perctangein one table by using CTE and Union.
-- We create CTE to store the result set of queries, then we combine these results into one by UNION

DECLARE @Total9 float;
SET @Total9 = (SELECT SUM([The Quantity of Respondets Country]) as Total9 FROM #Country2225);
PRINT @Total9
DECLARE @Total10 float;
SET @Total10 = (SELECT SUM([The Quantity of Respondets Country]) as Total10 FROM #Country3033);
PRINT @Total10
DECLARE @Total11 float;
SET @Total11 = (SELECT SUM([The Quantity of Respondets Country]) as Total11 FROM #Country3844);
PRINT @Total11
DECLARE @Total12 float;
SET @Total12 = (SELECT SUM([The Quantity of Respondets Country]) as Total12 FROM #Country55);
PRINT @Total12;
WITH Age2225 AS (
	SELECT [Age],[What country do you live in],
			CONCAT((CAST(CAST([The Quantity of Respondets Country] as int) / @Total9 as DECIMAL(32,3))*100), ' ','%') as [The Percentage of respondents' country]
	FROM #Country2225
), Age3033 AS (
	SELECT [Age],[What country do you live in],
			CONCAT((CAST(CAST([The Quantity of Respondets Country] as int) / @Total10 as DECIMAL(32,3))*100), ' ','%') as [The Percentage of respondents' country]
	FROM #Country3033
), Age3844 AS (
	SELECT [Age],[What country do you live in],
			CONCAT((CAST(CAST([The Quantity of Respondets Country] as int) / @Total11 as DECIMAL(32,3))*100), ' ','%') as [The Percentage of respondents' country]
	FROM #Country3844
), Age55 AS (
	SELECT [Age],[What country do you live in],
			CONCAT((CAST(CAST([The Quantity of Respondets Country] as int) / @Total12 as DECIMAL(32,3))*100), ' ','%') as [The Percentage of respondents' country]
	FROM #Country55
)
SELECT *
FROM Age2225
UNION ALL
SELECT *
FROM Age3033
UNION ALL
SELECT *
FROM Age3844
UNION ALL
SELECT *
FROM Age55
ORDER BY 1,3 DESC


---10. What is the biggest challenge you face to being productive. TEMP TABLE was created to store results.
---10. a) Age 22-25
DROP TABLE IF EXISTS #ChallengeBeingProductive2225
CREATE TABLE #ChallengeBeingProductive2225 (
[Age] varchar(300),
[What is the biggest challenge you face to being productive?] varchar(300),
[The Quantity of The Biggest Challenge to be productive] int NOT NULL
)
INSERT INTO #ChallengeBeingProductive2225
	SELECT DISTINCT  [Age],[What is the biggest challenge you face to being productive?] , 
			CAST(count([What is the biggest challenge you face to being productive?] ) OVER (PARTITION BY [What is the biggest challenge you face to being productive?] ) AS NUMERIC) as [The Quantity of The Biggest Challenge to be productive]
	FROM Project3.[dbo].[fProductivityData]
	WHERE [Age] = '22-25'
	ORDER BY [The Quantity of The Biggest Challenge to be productive] DESC

-- 10.b) Age 30-33
DROP TABLE IF EXISTS #ChallengeBeingProductive3033
CREATE TABLE #ChallengeBeingProductive3033 (
[Age] varchar(300),
[What is the biggest challenge you face to being productive?] varchar(300),
[The Quantity of The Biggest Challenge to be productive] int NOT NULL
)
INSERT INTO #ChallengeBeingProductive3033
	SELECT DISTINCT  [Age],[What is the biggest challenge you face to being productive?] , 
			CAST(count([What is the biggest challenge you face to being productive?] ) OVER (PARTITION BY [What is the biggest challenge you face to being productive?] ) AS NUMERIC) as [The Quantity of The Biggest Challenge to be productive]
	FROM Project3.[dbo].[fProductivityData]
	WHERE [Age] = '30-33'
	ORDER BY [The Quantity of The Biggest Challenge to be productive] DESC

--10.c) Age 38-44
DROP TABLE IF EXISTS #ChallengeBeingProductive3844
CREATE TABLE #ChallengeBeingProductive3844 (
[Age] varchar(300),
[What is the biggest challenge you face to being productive?] varchar(300),
[The Quantity of The Biggest Challenge to be productive] int NOT NULL
)
INSERT INTO #ChallengeBeingProductive3844
	SELECT DISTINCT  [Age],[What is the biggest challenge you face to being productive?] , 
			CAST(count([What is the biggest challenge you face to being productive?] ) OVER (PARTITION BY [What is the biggest challenge you face to being productive?] ) AS NUMERIC) as [The Quantity of The Biggest Challenge to be productive]
	FROM Project3.[dbo].[fProductivityData]
	WHERE [Age] = '38-44'
	ORDER BY [The Quantity of The Biggest Challenge to be productive] DESC

--10.d) Age 55+
DROP TABLE IF EXISTS #ChallengeBeingProductive55
CREATE TABLE #ChallengeBeingProductive55 (
[Age] varchar(300),
[What is the biggest challenge you face to being productive?] varchar(300),
[The Quantity of The Biggest Challenge to be productive] int NOT NULL
)
INSERT INTO #ChallengeBeingProductive55
	SELECT DISTINCT  [Age],[What is the biggest challenge you face to being productive?] , 
			CAST(count([What is the biggest challenge you face to being productive?] ) OVER (PARTITION BY [What is the biggest challenge you face to being productive?] ) AS NUMERIC) as [The Quantity of The Biggest Challenge to be productive]
	FROM Project3.[dbo].[fProductivityData]
	WHERE [Age] = '55+'
	ORDER BY [The Quantity of The Biggest Challenge to be productive] DESC


--10.e) Showing all records on the perctangein one table by using CTE and Union.
-- We create CTE to store the result set of queries, then we combine these results into one by UNION

DECLARE @Total13 float;
SET @Total13 = (SELECT SUM([The Quantity of The Biggest Challenge to be productive]) as Total13 FROM #ChallengeBeingProductive2225);
PRINT @Total13
DECLARE @Total14 float;
SET @Total14 = (SELECT SUM([The Quantity of The Biggest Challenge to be productive]) as Total14 FROM #ChallengeBeingProductive2225);
PRINT @Total14
DECLARE @Total15 float;
SET @Total15 = (SELECT SUM([The Quantity of The Biggest Challenge to be productive]) as Total15 FROM #ChallengeBeingProductive3844);
PRINT @Total15
DECLARE @Total16 float;
SET @Total16 = (SELECT SUM([The Quantity of The Biggest Challenge to be productive]) as Total16 FROM #ChallengeBeingProductive55);
PRINT @Total16;
WITH Age2225 AS (
SELECT [Age],[What is the biggest challenge you face to being productive?],
		CONCAT((CAST(CAST([The Quantity of The Biggest Challenge to be productive] as int) / @Total13 as DECIMAL(32,2))*100),' ','%') as [The Percentage of biggest challenge of being productive]
FROM #ChallengeBeingProductive2225
), Age3033 AS (
SELECT [Age],[What is the biggest challenge you face to being productive?],
		CONCAT((CAST(CAST([The Quantity of The Biggest Challenge to be productive] as int) / @Total14 as DECIMAL(32,2))*100),' ','%') as [The Percentage of biggest challenge of being productive]
FROM #ChallengeBeingProductive3033
), Age3844 AS (
SELECT [Age],[What is the biggest challenge you face to being productive?],
		CONCAT((CAST(CAST([The Quantity of The Biggest Challenge to be productive] as int) / @Total15 as DECIMAL(32,2))*100),' ','%') as [The Percentage of biggest challenge of being productive]
FROM #ChallengeBeingProductive3844
), Age55 AS (
SELECT [Age],[What is the biggest challenge you face to being productive?],
		CONCAT((CAST(CAST([The Quantity of The Biggest Challenge to be productive] as int) / @Total16 as DECIMAL(32,2))*100),' ','%') as [The Percentage of biggest challenge of being productive]
FROM #ChallengeBeingProductive55
)
SELECT *
FROM Age2225
UNION ALL
SELECT *
FROM Age3033
UNION ALL
SELECT *
FROM Age3844
UNION ALL
SELECT *
FROM Age55
ORDER BY Age,[The Percentage of biggest challenge of being productive] DESC



---11.When are you most productive. TEMP TABLE was created to store results.
---11.a) Age 22-25
DROP TABLE IF EXISTS #whenareyoumostproductive2225
CREATE TABLE #whenareyoumostproductive2225 (
[Age] varchar(300),
[When are you most productive?] varchar(300),
[The Quantity of the most productive time] int NOT NULL
)
INSERT INTO #whenareyoumostproductive2225
	SELECT DISTINCT [Age], [When are you most productive?], 
			CAST(count([When are you most productive?]) OVER (PARTITION BY [When are you most productive?] ) AS NUMERIC) as [The Quantity of the most productive time]
	FROM Project3.[dbo].[fProductivityData]
	WHERE [Age] = '22-25'
	ORDER BY [The Quantity of the most productive time] DESC



--11.b) Age 30-33
DROP TABLE IF EXISTS #whenareyoumostproductive3033
CREATE TABLE #whenareyoumostproductive3033 (
[Age] varchar(300),
[When are you most productive?] varchar(300),
[The Quantity of the most productive time] int NOT NULL
)
INSERT INTO #whenareyoumostproductive3033
	SELECT DISTINCT [Age], [When are you most productive?], 
			CAST(count([When are you most productive?]) OVER (PARTITION BY [When are you most productive?] ) AS NUMERIC) as [The Quantity of the most productive time]
	FROM Project3.[dbo].[fProductivityData]
	WHERE [Age] = '30-33' and [When are you most productive?] IS NOT NULL
	ORDER BY [The Quantity of the most productive time] DESC



--11.c) Age 38-44
DROP TABLE IF EXISTS #whenareyoumostproductive3844
CREATE TABLE #whenareyoumostproductive3844 (
[Age] varchar(300),
[When are you most productive?] varchar(300),
[The Quantity of the most productive time] int NOT NULL
)
INSERT INTO #whenareyoumostproductive3844
	SELECT DISTINCT [Age], [When are you most productive?], 
			CAST(count([When are you most productive?]) OVER (PARTITION BY [When are you most productive?] ) AS NUMERIC) as [The Quantity of the most productive time]
	FROM Project3.[dbo].[fProductivityData]
	WHERE [Age] = '30-33' and [When are you most productive?] IS NOT NULL
	ORDER BY [The Quantity of the most productive time] DESC



--11.d) Age 55
DROP TABLE IF EXISTS #whenareyoumostproductive55
CREATE TABLE #whenareyoumostproductive55 (
[Age] varchar(300),
[When are you most productive?] varchar(300),
[The Quantity of the most productive time] int NOT NULL
)
INSERT INTO #whenareyoumostproductive55
	SELECT DISTINCT [Age], [When are you most productive?], 
			CAST(count([When are you most productive?]) OVER (PARTITION BY [When are you most productive?] ) AS NUMERIC) as [The Quantity of the most productive time]
	FROM Project3.[dbo].[fProductivityData]
	WHERE [Age] = '55+' and [When are you most productive?] IS NOT NULL
	ORDER BY [The Quantity of the most productive time] DESC


--11.e) Showing all records on the perctangein one table by using CTE and Union.
-- We create CTE to store the result set of queries, then we combine these results into one by UNION
DECLARE @Total17 float;
SET @Total17 = (SELECT SUM([The Quantity of the most productive time]) as Total17 FROM #whenareyoumostproductive2225);
PRINT @Total17
DECLARE @Total18 float;
SET @Total18 = (SELECT SUM([The Quantity of the most productive time]) as Total18 FROM #whenareyoumostproductive3033);
PRINT @Total18
DECLARE @Total19 float;
SET @Total19 = (SELECT SUM([The Quantity of the most productive time]) as Total19 FROM #whenareyoumostproductive3844);
PRINT @Total19
DECLARE @Total20 float;
SET @Total20 = (SELECT SUM([The Quantity of the most productive time]) as Total20 FROM #whenareyoumostproductive55);
PRINT @Total20;
WITH Age2225 AS (
SELECT [Age],[When are you most productive?],
		CONCAT((CAST(CAST([The Quantity of the most productive time] as int) / @Total17 as DECIMAL(32,2))*100), ' ','%') as [The Percentage of time of being most productive]
FROM #whenareyoumostproductive2225
), Age3033 AS (
SELECT [Age],[When are you most productive?],
		CONCAT((CAST(CAST([The Quantity of the most productive time] as int) / @Total18 as DECIMAL(32,2))*100), ' ','%') as [The Percentage of time of being most productive]
FROM #whenareyoumostproductive3033
), Age3844 AS (
SELECT [Age],[When are you most productive?],
		CONCAT((CAST(CAST([The Quantity of the most productive time] as int) / @Total19 as DECIMAL(32,2))*100), ' ','%') as [The Percentage of time of being most productive]
FROM #whenareyoumostproductive3844
), Age55 AS (
SELECT [Age],[When are you most productive?],
		CONCAT((CAST(CAST([The Quantity of the most productive time] as int) / @Total20 as DECIMAL(32,2))*100), ' ','%') as [The Percentage of time of being most productive]
FROM #whenareyoumostproductive55
)
SELECT *
FROM Age2225
UNION ALL
SELECT *
FROM Age3033
UNION ALL
SELECT *
FROM Age3844
UNION ALL
SELECT *
FROM Age55
ORDER BY 1,3 DESC


--12. Job. TEMP TABLE was created to store results.
--12.a) Age 22-25
DROP TABLE IF EXISTS #job2225
CREATE TABLE #job2225 (
[Age] varchar(300),
[Job] varchar(300),
[The Quantity of Job] int NOT NULL
)
INSERT INTO #job2225
	SELECT DISTINCT  [Age],[Job], 
			CAST(count([Job]) OVER (PARTITION BY [Job] ) AS NUMERIC) as [The Quantity of Job]
	FROM Project3.[dbo].[fProductivityData]
	WHERE [Age] = '22-25'
	ORDER BY [The Quantity of Job] DESC



--12.b) Age 30-33
DROP TABLE IF EXISTS #job3033
CREATE TABLE #job3033 (
[Age] varchar(300),
[Job] varchar(300),
[The Quantity of Job] int NOT NULL
)
INSERT INTO #job3033
	SELECT DISTINCT  [Age],[Job], 
			CAST(count([Job]) OVER (PARTITION BY [Job] ) AS NUMERIC) as [The Quantity of Job]
	FROM Project3.[dbo].[fProductivityData]
	WHERE [Age] = '30-33'
	ORDER BY [The Quantity of Job] DESC



--12.c) Age 38-44
DROP TABLE IF EXISTS #job3844
CREATE TABLE #job3844 (
[Age] varchar(300),
[Job] varchar(300),
[The Quantity of Job] int NOT NULL
)
INSERT INTO #job3844
	SELECT DISTINCT  [Age],[Job], 
			CAST(count([Job]) OVER (PARTITION BY [Job] ) AS NUMERIC) as [The Quantity of Job]
	FROM Project3.[dbo].[fProductivityData]
	WHERE [Age] = '38-44'
	ORDER BY [The Quantity of Job] DESC

--12.d) Age 55+
DROP TABLE IF EXISTS #job55
CREATE TABLE #job55 (
[Age] varchar(300),
[Job] varchar(300),
[The Quantity of Job] int NOT NULL
)
INSERT INTO #job55
	SELECT DISTINCT  [Age],[Job], 
			CAST(count([Job]) OVER (PARTITION BY [Job] ) AS NUMERIC) as [The Quantity of Job]
	FROM Project3.[dbo].[fProductivityData]
	WHERE [Age] = '55+'
	ORDER BY [The Quantity of Job] DESC



--12.e) Showing all records on the perctangein one table by using CTE and Union.
-- We create CTE to store the result set of queries, then we combine these results into one by UNION
DECLARE @Total21 float;
SET @Total21 = (SELECT SUM([The Quantity of Job]) as Total21 FROM #job2225);
PRINT @Total21
DECLARE @Total22 float;
SET @Total22 = (SELECT SUM([The Quantity of Job]) as Total21 FROM #job3033);
PRINT @Total22
DECLARE @Total23 float;
SET @Total23 = (SELECT SUM([The Quantity of Job]) as Total23 FROM #job3844);
PRINT @Total23
DECLARE @Total24 float;
SET @Total24 = (SELECT SUM([The Quantity of Job]) as Total23 FROM #job55);
PRINT @Total24;
WITH Job2225 AS (
SELECT [Age],[Job],
		CONCAT((CAST(CAST([The Quantity of Job] as int) / @Total21 as DECIMAL(32,3))*100), ' ','%') as [The Percentage of Job Respondent]
FROM #job2225
), Job3033 AS (
SELECT [Age],[Job],
		CONCAT((CAST(CAST([The Quantity of Job] as int) / @Total22 as DECIMAL(32,3))*100), ' ','%') as [The Percentage of Job Respondent]
FROM #job3033
), Job3844 AS (
SELECT [Age],[Job],
		CONCAT((CAST(CAST([The Quantity of Job] as int) / @Total23 as DECIMAL(32,3))*100), ' ','%') as [The Percentage of Job Respondent]
FROM #job3844
), Job55 AS (
SELECT [Age],[Job],
		CONCAT((CAST(CAST([The Quantity of Job] as int) / @Total24 as DECIMAL(32,3))*100), ' ','%') as [The Percentage of Job Respondent]
FROM #job55
)
SELECT *
FROM Job2225
UNION ALL
SELECT * 
FROM Job3033
UNION ALL
SELECT *
FROM Job3844
UNION ALL
SELECT *
FROM Job55
ORDER BY 1,3 DESC

-- 13. Choose few things that make you energized. TEMP TABLE was created to store results.
--13.a) Age 22-25
DROP TABLE IF EXISTS #energized2225
CREATE TABLE #energized2225 (
[Age] varchar(300),
[What makes you energized] varchar(300),
[The number of respondets] int NOT NULL
)
INSERT INTO #energized2225
SELECT DISTINCT f.[Age],d.[what makes you energized] as [What Makes you Energized],
	count( [what makes you energized]) OVER (PARTITION BY [what makes you energized])  as [The number of respondents]
FROM [Project3].[dbo].[fProductivityData] f
JOIN  [Project3].[dbo].[dHelpfulThings] d
	ON f.[RespondentID] = d.[RespondentID]
WHERE f.[Age] = '22-25'
ORDER BY [The number of respondents] DESC



--13.b) Age 30-33
DROP TABLE IF EXISTS #energized3033
CREATE TABLE #energized3033 (
[Age] varchar(300),
[What makes you energized] varchar(300),
[The number of respondets] int NOT NULL
)
INSERT INTO #energized3033
SELECT DISTINCT f.[Age],d.[what makes you energized] as [What Makes you Energized],
	count( [what makes you energized]) OVER (PARTITION BY [what makes you energized])  as [The number of respondents]
FROM [Project3].[dbo].[fProductivityData] f
JOIN  [Project3].[dbo].[dHelpfulThings] d
	ON f.[RespondentID] = d.[RespondentID]
WHERE f.[Age] = '30-33'
ORDER BY [The number of respondents] DESC



--13.c) Age 38-44
DROP TABLE IF EXISTS #energized3844
CREATE TABLE #energized3844 (
[Age] varchar(300),
[What makes you energized] varchar(300),
[The number of respondets] int NOT NULL
)
INSERT INTO #energized3844
SELECT DISTINCT f.[Age],d.[what makes you energized] as [What Makes you Energized],
	count( [what makes you energized]) OVER (PARTITION BY [what makes you energized])  as [The number of respondents]
FROM [Project3].[dbo].[fProductivityData] f
JOIN  [Project3].[dbo].[dHelpfulThings] d
	ON f.[RespondentID] = d.[RespondentID]
WHERE f.[Age] = '38-44'
ORDER BY [The number of respondents] DESC


--13d) Age 55+

DROP TABLE IF EXISTS #energized55
CREATE TABLE #energized55 (
[Age] varchar(300),
[What makes you energized] varchar(300),
[The number of respondets] int NOT NULL
)
INSERT INTO #energized55
SELECT DISTINCT f.[Age],d.[what makes you energized] as [What Makes you Energized],
	count( [what makes you energized]) OVER (PARTITION BY [what makes you energized])  as [The number of respondents]
FROM [Project3].[dbo].[fProductivityData] f
JOIN  [Project3].[dbo].[dHelpfulThings] d
	ON f.[RespondentID] = d.[RespondentID]
WHERE f.[Age] = '55+'
ORDER BY [The number of respondents] DESC



--13.e) Showing all records on the perctangein one table by using CTE and Union.
-- We create CTE to store the result set of queries, then we combine these results into one by UNION
DECLARE @Total25 float;
SET @Total25 = (SELECT SUM([The number of respondets]) as Total25 FROM #energized2225);
PRINT @Total25
DECLARE @Total26 float;
SET @Total26 = (SELECT SUM([The number of respondets]) as Total26 FROM #energized3033);
PRINT @Total26
DECLARE @Total27 float;
SET @Total27 = (SELECT SUM([The number of respondets]) as Total27 FROM #energized3844);
PRINT @Total27
DECLARE @Total28 float;
SET @Total28 = (SELECT SUM([The number of respondets]) as Total28 FROM #energized55);
PRINT @Total28;
WITH Age2225 AS (
SELECT [Age],[What makes you energized],
		CONCAT((CAST(CAST([The number of respondets] as int) / @Total25 as DECIMAL(32,2))*100), ' ','%') as [The Percentage of Respondets]
FROM #energized2225
), Age3033 AS ( 
SELECT [Age],[What makes you energized],
		CONCAT((CAST(CAST([The number of respondets] as int) / @Total26 as DECIMAL(32,2))*100), ' ','%') as [The Percentage of Respondets]
FROM #energized3033
), Age3844 AS (
SELECT [Age],[What makes you energized],
		CONCAT((CAST(CAST([The number of respondets] as int) / @Total27 as DECIMAL(32,2))*100), ' ','%') as [The Percentage of Respondets]
FROM #energized3844
), Age55 AS (
SELECT [Age],[What makes you energized],
		CONCAT((CAST(CAST([The number of respondets] as int) / @Total28 as DECIMAL(32,2))*100), ' ','%') as [The Percentage of Respondets]
FROM #energized55
)
SELECT *
FROM Age2225
UNION ALL
SELECT *
FROM Age3033
UNION ALL
SELECT *
FROM Age3844
UNION ALL
SELECT *
FROM Age55
ORDER BY 1,3 DESC




-- ADDING JOIN TO THIS TABLE AND What makes
-- 8. Selected people 18-21
SELECT *
FROM Project3.[dbo].[fProductivityData]
WHERE [Age] = '18-21'
---


-- 9. Selected people 22-25
SELECT *
FROM Project3.[dbo].[fProductivityData]
WHERE [Age] = '22-25'
---


-- 9. Selected people 26-29
SELECT *
FROM Project3.[dbo].[fProductivityData]
WHERE [Age] = '26-29'
---


-- 9. Selected people 18-21
SELECT *
FROM Project3.[dbo].[fProductivityData]
WHERE [Age] = '30-33'
---


-- 9. Selected people 18-21
SELECT *
FROM Project3.[dbo].[fProductivityData]
WHERE [Age] = '34-37'
---


-- 9. Selected people 18-21
SELECT *
FROM Project3.[dbo].[fProductivityData]
WHERE [Age] = '38-44'
---


-- 9. Selected people 18-21
SELECT *
FROM Project3.[dbo].[fProductivityData]
WHERE [Age] = '45-54'
---


-- 9. Selected people 18-21
SELECT *
FROM Project3.[dbo].[fProductivityData]
WHERE [Age] = '55+'
---


-- 9. Selected people 18-21
SELECT *
FROM Project3.[dbo].[fProductivityData]
WHERE [Age] = 'No information'
---


-- Try to sum these data by union or pivot?? PUT IT ON ONE TABLE!@!!
--The number of respondents by category Age, trying to combine these tables!! if not . left it
CREATE VIEW PercNumberOfRespondentsByAge AS 
	SELECT DISTINCT
		[Age],
		count([Age]) OVER (PARTITION BY [Age])  as [Number of respondents]
	FROM [Project3].[dbo].[fProductivityData] 
	WHERE [How important would you say feeling productive is to your happin] IS NOT NULL;

DECLARE @SumQuaOfRespon float
SET @SumQuaOfRespon = (SELECT SUM([Number of respondents]) as [Sum Of Quantity of Respondets] FROM PercNumberOfRespondentsByAge  )
PRINT @SumQuaOfRespon
SELECT [Age],	
	CONCAT((CAST(CAST([Number of respondents] as int) / @SumQuaOfRespon as DECIMAL(32,3))*100), ' ','%') as [The Percentage of Respondents]
FROM PercNumberOfRespondentsByAge
ORDER BY [Number of respondents] DESC

--The number of respondents by category How important would you say feeling productive is to your happin
CREATE VIEW PercentageOfFeelingProdIsHapp AS
	SELECT DISTINCT
		[How important would you say feeling productive is to your happin],
		count([How important would you say feeling productive is to your happin]) OVER (PARTITION BY [How important would you say feeling productive is to your happin])  as [Number of respondents]
	FROM [Project3].[dbo].[fProductivityData] f
	WHERE [How important would you say feeling productive is to your happin] IS NOT NULL

DECLARE @SumQuaOfRespon1 float
SET @SumQuaOfRespon1 = (SELECT SUM([Number of respondents]) as [Sum Of Quantity of Respondets] FROM PercentageOfFeelingProdIsHapp  )
PRINT @SumQuaOfRespon1
SELECT [How important would you say feeling productive is to your happin],	
	CONCAT((CAST(CAST([Number of respondents] as int) / @SumQuaOfRespon1 as DECIMAL(32,2))*100), ' ','%') as [The Percentage of Respondents]
FROM PercentageOfFeelingProdIsHapp
ORDER BY [Number of respondents] DESC


--- The number of respondents by category How productive do you currently feel overall?
CREATE VIEW PercentageOfFeelProducOverall AS
	SELECT DISTINCT  [How productive do you currently feel overall?],
		count([How productive do you currently feel overall?]) OVER (PARTITION BY [How productive do you currently feel overall?]) as [The number of respondents]
	FROM [Project3].[dbo].[fProductivityData] f
	WHERE [How productive do you currently feel overall?] IS NOT NULL

DECLARE @SumQuanOfRespond2 float
SET @SumQuanOfRespond2 = (SELECT SUM([The number of respondents]) as [Sum Of Quantity of Respondets] FROM PercentageOfFeelProducOverall)
PRINT @SumQuanOfRespond2
SELECT [How productive do you currently feel overall?],
	CONCAT((CAST(CAST([The number of respondents] as int) / @SumQuanOfRespond2 as DECIMAL(32,2))*100), ' ','%') as [The Percentage of Respondents]
FROM PercentageOfFeelProducOverall
ORDER BY [The number of respondents] DESC


---The number of respondents by category What country do you live in?
CREATE VIEW CountryOfRespondetas as
	SELECT DISTINCT [What country do you live in?],
		count([What country do you live in?]) OVER (PARTITION BY [What country do you live in?]) as [The number of respondents]
	FROM [Project3].[dbo].[fProductivityData] 

DECLARE @SumOfQuanRespond3 float
SET @SumOfQuanRespond3 = (SELECT SUM([The number of respondents]) as [Sum Of Quantity of Respondets] FROM CountryOfRespondetas)
PRINT @SumOfQuanRespond3
SELECT [What country do you live in?] as Country,
	CONCAT((CAST(CAST([The number of respondents] as int) / @SumOfQuanRespond3 as DECIMAL(32,3))*100), ' ','%') as [The Percentage of Respondents]
FROM CountryOfRespondetas
ORDER BY [The number of respondents] DESC
--



--- The number of respondents by category What is the biggest challenge you face to being productive?

CREATE VIEW BiggestChallenge AS 
	SELECT DISTINCT [What is the biggest challenge you face to being productive?],
		count([What is the biggest challenge you face to being productive?]) OVER (PARTITION BY [What is the biggest challenge you face to being productive?]) as [The number of respondents]
	FROM [Project3].[dbo].[fProductivityData] 

DECLARE @SumOfQuanRespond4 float
SET @SumOfQuanRespond4 = (SELECT SUM([The number of respondents]) as [Sum Of Quantity of Respondets] FROM BiggestChallenge)
PRINT @SumOfQuanRespond4
SELECT [What is the biggest challenge you face to being productive?],
		CONCAT((CAST(CAST([The number of respondents] as int) / @SumOfQuanRespond4 as DECIMAL(32,2))*100), ' ','%') as [The Percentage of Respondents]
FROM BiggestChallenge
ORDER BY [The number of respondents] DESC



--- The number of respondents by category When are you most productive?
CREATE VIEW WhenMostProductive AS
	SELECT DISTINCT [When are you most productive?],
		count([When are you most productive?]) OVER (PARTITION BY [When are you most productive?]) as [The number of respondents]
	FROM [Project3].[dbo].[fProductivityData] f
	WHERE [When are you most productive?] IS NOT NULL 

DECLARE @SumOfQuanRespond5 float
SET @SumOfQuanRespond5 = (SELECT SUM([The number of respondents]) as [Sum Of Quantity of Respondets] FROM WhenMostProductive)
PRINT @SumOfQuanRespond5
SELECT [When are you most productive?],
		CONCAT((CAST(CAST([The number of respondents] as int) / @SumOfQuanRespond5 as DECIMAL(32,2))*100), ' ','%') as [The Percentage of Respondents]
FROM WhenMostProductive
ORDER BY [The number of respondents] DESC


-- The number of respondents by category Job
CREATE VIEW Job AS
	SELECT DISTINCT [Job],
		count([Job]) OVER (PARTITION BY Job) as [The number of respondents]
	FROM [Project3].[dbo].[fProductivityData] f
	WHERE [When are you most productive?] IS NOT NULL

DECLARE @SumOfQuanRespond6 float
SET @SumOfQuanRespond6 = (SELECT SUM([the number of respondents]) as [Sum of Quantity of Respondets] FROM Job)
PRINT @SumOfQuanRespond6
SELECT [Job],
		CONCAT((CAST(CAST([The number of respondents] as int) / @SumOfQuanRespond6 as DECIMAL(32,3))*100), ' ','%') as [The Percentage of Respondents]
FROM Job
ORDER BY [The number of respondents] DESC



-- The number of respondents by category What makes you energized?
CREATE VIEW Energized AS 
	SELECT DISTINCT d.[what makes you energized] as [What Makes you Energized],
		count( [what makes you energized]) OVER (PARTITION BY [what makes you energized])  as [The number of respondents]
	FROM [Project3].[dbo].[fProductivityData] f
	LEFT JOIN [Project3].[dbo].[dHelpfulThings] d
		ON f.[RespondentID] = d.[RespondentID]

DECLARE @SumOfQuanRespond7 float
SET @SumOfQuanRespond7 = (SELECT SUM([the number of respondents]) as [Sum of Quantity of Respondets] FROM Energized)
PRINT  @SumOfQuanRespond7
SELECT [what makes you energized],
		CONCAT((CAST(CAST([The number of respondents] as int) / @SumOfQuanRespond7 as DECIMAL(32,2))*100), ' ','%') as [The Percentage of Respondents]
FROM Energized
ORDER BY [The number of respondents] DESC

---


DECLARE @SumOfQuanRespond6 float
SET @SumOfQuanRespond6 = (SELECT SUM([the number of respondents]) as [Sum of Quantity of Respondets] FROM Job)
PRINT @SumOfQuanRespond6
DECLARE @SumOfQuanRespond7 float
SET @SumOfQuanRespond7 = (SELECT SUM([the number of respondents]) as [Sum of Quantity of Respondets] FROM Energized)
PRINT  @SumOfQuanRespond7;
WITH A AS (
SELECT [Job],
		CONCAT((CAST(CAST([The number of respondents] as int) / @SumOfQuanRespond6 as DECIMAL(32,3))*100), ' ','%') as [The Percentage of Respondents]
FROM Job
), B AS (
SELECT [what makes you energized],
		CONCAT((CAST(CAST([The number of respondents] as int) / @SumOfQuanRespond7 as DECIMAL(32,2))*100), ' ','%') as [The Percentage of Respondents]
FROM Energized

)
SELECT DISTINCT * 
FROM A
UNION ALL
SELECT DISTINCT *
FROM B




  SELECT * FROM [Project3].[dbo].[fProductivityData]
  ORDER BY [Age]

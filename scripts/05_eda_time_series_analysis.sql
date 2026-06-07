/*
How are the total number of laid off distributed by year and month?
*/
SELECT 
	YEAR(lc.date) AS [layoff_year],
	MONTH(lc.date) AS [layoff_month],
	SUM(lc.total_laid_off) AS monthly_layoffs
FROM dbo.layoffs_clean AS lc
WHERE YEAR(lc.date) IS NOT NULL AND MONTH(lc.date) IS NOT NULL
GROUP BY YEAR(lc.date),	MONTH(lc.date)
ORDER BY YEAR(lc.date) ASC,	MONTH(lc.date) ASC;



/*
What is the cumulative total (Rolling Total) laid off 
month by month?
*/
WITH MonthlyLayoffsCTE AS (
    SELECT 
        YEAR(lc.[date]) AS [layoff_year],
        MONTH(lc.[date]) AS [layoff_month],
        SUM(lc.total_laid_off) AS monthly_laid_off
    FROM dbo.layoffs_clean AS lc
    WHERE lc.[date] IS NOT NULL
    GROUP BY YEAR(lc.[date]), MONTH(lc.[date])
)
SELECT 
    [layoff_year],
    [layoff_month],
    monthly_laid_off,
    SUM(monthly_laid_off) OVER (ORDER BY [layoff_year], [layoff_month]) AS rolling_total_layoffs
FROM MonthlyLayoffsCTE
ORDER BY [layoff_year], [layoff_month];





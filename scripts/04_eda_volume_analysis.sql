/*
The top 10 companies that laid off the most employees
and what was their average funding?
*/
SELECT TOP 10
	company,
	SUM(lc.total_laid_off) total_laid_off,
	AVG(lc.funds_raised_millions) avg_funds_raised_millions
FROM dbo.layoffs_clean AS lc
GROUP BY company
ORDER BY total_laid_off DESC;



/*
Which sectors (industry) have been most affected 
in terms of the number of layoffs?
*/
SELECT
	lc.industry,
	SUM(lc.total_laid_off) total_laid_off
FROM dbo.layoffs_clean AS lc
WHERE lc.industry IS NOT NULL
GROUP BY lc.industry
ORDER BY total_laid_off DESC;

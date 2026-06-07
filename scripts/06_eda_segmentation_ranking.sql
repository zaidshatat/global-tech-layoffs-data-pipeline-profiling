/*
What are the top 3 companies that lay off the most employees in each sector?
*/
WITH RankedIndustryLayoffs AS (
    SELECT 
        lc.industry,
        lc.company,
        SUM(lc.total_laid_off) AS total_company_layoffs,
        DENSE_RANK() OVER(PARTITION BY lc.industry ORDER BY SUM(lc.total_laid_off) DESC) ranking
    FROM dbo.layoffs_clean AS lc
    WHERE lc.industry IS NOT NULL AND lc.total_laid_off IS NOT NULL
    GROUP BY lc.industry, lc.company
)

SELECT 
    *
FROM RankedIndustryLayoffs
WHERE ranking <= 3
ORDER BY industry ASC, ranking ASC



-- 1. View for Top Companies & Funding
CREATE VIEW dbo.v_top_companies_layoffs AS
SELECT TOP 10
    company,
    SUM(total_laid_off) AS total_laid_off,
    AVG(funds_raised_millions) AS avg_funds_raised_millions
FROM dbo.layoffs_clean
GROUP BY company
ORDER BY total_laid_off DESC;
GO

-- 2. View for Industry Impact
CREATE VIEW dbo.v_industry_layoffs AS
SELECT
    industry,
    SUM(total_laid_off) AS total_laid_off
FROM dbo.layoffs_clean
WHERE industry IS NOT NULL
GROUP BY industry;
GO

-- 3. View for Monthly Trends & Cumulative Rolling Total
CREATE VIEW dbo.v_monthly_rolling_layoffs AS
WITH MonthlyLayoffsCTE AS (
    SELECT 
        YEAR([date]) AS [layoff_year],
        MONTH([date]) AS [layoff_month],
        SUM(total_laid_off) AS monthly_laid_off
    FROM dbo.layoffs_clean
    WHERE [date] IS NOT NULL
    GROUP BY YEAR([date]), MONTH([date])
)
SELECT 
    [layoff_year],
    [layoff_month],
    monthly_laid_off,
    SUM(monthly_laid_off) OVER (ORDER BY [layoff_year], [layoff_month]) AS rolling_total_layoffs
FROM MonthlyLayoffsCTE;
GO

-- 4. View for Top 3 Companies Per Industry (Segmentation)
CREATE VIEW dbo.v_top_3_companies_per_industry AS
WITH RankedIndustryLayoffs AS (
    SELECT 
        lc.industry,
        lc.company,
        SUM(lc.total_laid_off) AS total_company_layoffs,
        DENSE_RANK() OVER(PARTITION BY lc.industry ORDER BY SUM(lc.total_laid_off) DESC) AS ranking
    FROM dbo.layoffs_clean AS lc
    WHERE lc.industry IS NOT NULL AND lc.total_laid_off IS NOT NULL
    GROUP BY lc.industry, lc.company
)
SELECT 
    industry,
    company,
    total_company_layoffs,
    ranking
FROM RankedIndustryLayoffs
WHERE ranking <= 3;
GO
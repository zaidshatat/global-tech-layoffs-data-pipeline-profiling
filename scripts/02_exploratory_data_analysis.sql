-- ====================================================================
-- Step 2: Exploratory Data Analysis (EDA)
-- ====================================================================

-- 1. Check Data Types
SELECT 
	COLUMN_NAME AS [Column Name],
	DATA_TYPE AS [Data Type]
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'layoffs_clean';

-- 2. Identify Total Null Values per Column
SELECT
	SUM(CASE WHEN [location] IS NULL THEN 1 ELSE 0 END) AS [location NULL],
	SUM(CASE WHEN [industry] IS NULL THEN 1 ELSE 0 END) AS [industry NULL],
	SUM(CASE WHEN [total_laid_off] IS NULL THEN 1 ELSE 0 END) AS [total_laid_off NULL],
	SUM(CASE WHEN [percentage_laid_off] IS NULL THEN 1 ELSE 0 END) AS [percentage_laid_off NULL],
	SUM(CASE WHEN [date] IS NULL THEN 1 ELSE 0 END) AS [date NULL],
	SUM(CASE WHEN [stage] IS NULL THEN 1 ELSE 0 END) AS [stage NULL],
	SUM(CASE WHEN [country] IS NULL THEN 1 ELSE 0 END) AS [country NULL],
	SUM(CASE WHEN [funds_raised_millions] IS NULL THEN 1 ELSE 0 END) AS [funds_raised_millions NULL]
FROM dbo.layoffs_clean;

-- 3. Descriptive Statistics for Numeric Columns
SELECT 
    'total_laid_off' AS [Column],
    COUNT(total_laid_off) AS [Count (Non-Null)],
    SUM(CASE WHEN total_laid_off IS NULL THEN 1 ELSE 0 END) AS [Missing Values],
    AVG(total_laid_off) AS [Mean],
    MIN(total_laid_off) AS [Min],
    MAX(total_laid_off) AS [Max]
FROM dbo.layoffs_clean
UNION ALL
SELECT 
    'percentage_laid_off',
    COUNT(percentage_laid_off),
    SUM(CASE WHEN percentage_laid_off IS NULL THEN 1 ELSE 0 END),
    AVG(percentage_laid_off),
    MIN(percentage_laid_off),
    MAX(percentage_laid_off)
FROM dbo.layoffs_clean
UNION ALL
SELECT 
    'funds_raised_millions',
    COUNT(funds_raised_millions),
    SUM(CASE WHEN funds_raised_millions IS NULL THEN 1 ELSE 0 END),
    AVG(funds_raised_millions),
    MIN(funds_raised_millions),
    MAX(funds_raised_millions)
FROM dbo.layoffs_clean;

-- 4. Check Industry Frequencies and Categories
SELECT industry, COUNT(*) AS [Frequency]
FROM dbo.layoffs_clean
GROUP BY industry
ORDER BY Frequency DESC;
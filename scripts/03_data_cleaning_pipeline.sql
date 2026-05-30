-- ====================================================================
-- Step 3: Data Cleaning & Standardization Pipeline
-- ====================================================================

-- 1. Remove Exact Duplicates using CTE and ROW_NUMBER
WITH duplicateCTE AS (
	SELECT 
		*,
		ROW_NUMBER() 
		OVER(PARTITION BY company, [location], industry, total_laid_off, 
        percentage_laid_off, [date], stage, country, funds_raised_millions
		ORDER BY [country]) AS [row_number]
	FROM dbo.layoffs_clean
)
DELETE FROM duplicateCTE
WHERE [row_number] > 1;

-- 2. Standardize Company Names (Remove leading/trailing spaces)
UPDATE dbo.layoffs_clean
SET company = TRIM(company)
WHERE company <> TRIM(company);

-- 3. Standardize Industry Categories (Merge variations)
UPDATE dbo.layoffs_clean
SET industry = CASE
	WHEN industry LIKE 'Crypto%' THEN 'Crypto'
	WHEN industry = 'Fin-Tech' THEN 'Finance'
	WHEN TRIM(industry) = 'NULL' OR TRIM(industry) = '' THEN NULL
	ELSE industry
END
WHERE industry LIKE 'Crypto%' 
   OR industry = 'Fin-Tech' 
   OR TRIM(industry) = 'NULL' 
   OR TRIM(industry) = '';

-- 4. Standardize Country Names & Locations (Remove trailing dots)
UPDATE dbo.layoffs_clean
SET
	[location] = TRIM(location),
	country = CASE 
	WHEN country LIKE '%.' THEN TRIM(LEFT(country, LEN(country) - 1))
	ELSE TRIM(country)
END
WHERE country LIKE '%.' 
   OR country <> TRIM(country)
   OR location <> TRIM(location);

-- 5. Standardize Date Formats
UPDATE dbo.layoffs_clean
SET [date] = TRY_CONVERT(DATE, [date])
WHERE TRY_CONVERT(DATE, [date]) IS NOT NULL;

ALTER TABLE dbo.layoffs_clean
ALTER COLUMN date DATE;

-- 6. Populate Missing Industry Data via Self-Join
UPDATE t1
SET t1.industry = t2.industry
FROM dbo.layoffs_clean t1
JOIN dbo.layoffs_clean t2 
    ON t1.company = t2.company
WHERE t1.industry IS NULL
  AND t2.industry IS NOT NULL;

-- 7. Remove Useless Rows (Where both core metrics are missing)
DELETE FROM dbo.layoffs_clean
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;
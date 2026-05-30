-- ====================================================================
-- Step 1: Data Ingestion & Safe Type Casting
-- ====================================================================

-- 1. Create the target table structure
/*
CREATE TABLE dbo.layoffs_clean(
    company VARCHAR(50),
    location VARCHAR(50),
    industry VARCHAR(50),
    total_laid_off INT,
    percentage_laid_off FLOAT,
    [date] DATE,
    stage VARCHAR(50),
    country VARCHAR(50),
    funds_raised_millions INT
);
*/

-- 2. Insert raw data with safe casting to prevent ingestion failures
INSERT INTO dbo.layoffs_clean
SELECT 
    company, 
    location, 
    industry, 
    TRY_CAST(total_laid_off AS INT),
    TRY_CAST(percentage_laid_off AS FLOAT),
    TRY_CAST([date] AS DATE),
    stage, 
    country, 
    TRY_CAST(funds_raised_millions AS INT)
FROM dbo.layoffs;
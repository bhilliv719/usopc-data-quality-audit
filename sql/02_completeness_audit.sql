-- 1. Calculate the overall percentage of missing data for key identifier fields
SELECT
    COUNT(*) as total_records,
    SUM(CASE WHEN `Phone Number` IS NULL OR `Phone Number` = '' THEN 1 ELSE 0 END) as missing_phone,
    ROUND(SUM(CASE WHEN `Phone Number` IS NULL OR `Phone Number` = '' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as phone_missing_pct,
    
    SUM(CASE WHEN `Email Address` IS NULL OR `Email Address` = '' THEN 1 ELSE 0 END) as missing_email,
    ROUND(SUM(CASE WHEN `Email Address` IS NULL OR `Email Address` = '' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as email_missing_pct,
    
    SUM(CASE WHEN `Birthdate` IS NULL OR `Birthdate` LIKE '1900-01-01%' THEN 1 ELSE 0 END) as invalid_or_missing_birthdate,
    ROUND(SUM(CASE WHEN `Birthdate` IS NULL OR `Birthdate` LIKE '1900-01-01%' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as birthdate_issue_pct
FROM 
    `cleaned_USOPC_data`;

-- 2. Audit non-conformed Sport Codes highlighted in Phase 2 report (COV, BLD_P, STA)
SELECT 
    `Sport Code`,
    `Sport Code Conformed`,
    `Source System`,
    COUNT(*) as occurrence_count
FROM 
    `cleaned_USOPC_data`
WHERE 
    `Sport Code` IN ('COV', 'BLD_P', 'STA')
    OR `Sport Code Conformed` IS NULL
GROUP BY 
    1, 2, 3
ORDER BY 
    occurrence_count DESC;

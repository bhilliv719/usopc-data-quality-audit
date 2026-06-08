-- 1. Identify specific MDM Person IDs that have duplicate entries
SELECT 
    `MDM Person ID`,
    COUNT(*) as record_count,
    COUNT(DISTINCT `Source System`) as unique_systems_involved
FROM 
    `cleaned_USOPC_data`
GROUP BY 
    `MDM Person ID`
HAVING 
    COUNT(*) > 1
ORDER BY 
    record_count DESC;

-- 2. Deep-dive audit: Look at the exact data discrepancy between duplicated records
SELECT 
    `MDM Person ID`,
    `Source System`,
    `First Name`,
    `Last Name`,
    `Birthdate`,
    `Sport Code`,
    `Country`
FROM 
    `cleaned_USOPC_data`
WHERE 
    `MDM Person ID` IN (
        SELECT `MDM Person ID` 
        FROM `cleaned_USOPC_data` 
        GROUP BY `MDM Person ID` 
        HAVING COUNT(*) > 1
    )
ORDER BY 
    `MDM Person ID`, `Source System`;

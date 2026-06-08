# Load required packages
library(dplyr)
library(tidyr)

# Load the verified dataset
usopc_data <- read.csv("../data/cleaned_USOPC_data.csv", stringsAsFactors = FALSE, check.names = FALSE)

# 1. Profile missing rates grouped systematically by Source System
system_profile <- usopc_data %>%
  group_by(`Source System`) %>%
  summarize(
    Total_Records = n(),
    Missing_Birthdate_Pct = round(sum(is.na(Birthdate) | Birthdate == "" | grepl("1900-01-01", Birthdate)) / n() * 100, 2),
    Missing_Gender_Pct    = round(sum(is.na(Gender) | Gender == "") / n() * 100, 2),
    Missing_Phone_Pct     = round(sum(is.na(`Phone Number`) | `Phone Number` == "") / n() * 100, 2),
    Missing_Country_Pct   = round(sum(is.na(Country) | Country == "") / n() * 100, 2)
  )

# Output profiling table to console
print("--- USOPC DATA QUALITY COMPLETENESS PROFILE BY SYSTEM ---")
print(system_profile)

# 2. Extract anomalous tracking entries for manual cleanup routing
flagged_anomalies <- usopc_data %>%
  filter(is.na(`Phone Number`) | `Phone Number` == "" | Country %in% c("USAA", "AUSAtrai")) %>%
  select(`MDM Person ID`, `Source System`, `First Name`, `Last Name`, `Phone Number`, Country)

# Export the targeted cleaning action list to a CSV
write.csv(flagged_anomalies, "../data/remediation_action_list.csv", row.names = FALSE)
print("Remediation list generated and stored in data directory.")

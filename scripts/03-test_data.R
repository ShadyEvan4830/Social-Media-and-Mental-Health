#### Preamble ####
# Purpose: Basic tests codes for dataset.
# Author: Tianen (Evan) Hao
# Date: 11 March 2024 
# Contact: evan.hao@mail.utoronto.ca 
# License: MIT
# Pre-requisites: 
# 00-simulate_data.R
# 01-data_cleaning.R

#### Workspace setup ####
library(dplyr)

#### Test data ####
data <- read.csv(here::here("data/analysis_data/cleaned_categorized_data.csv"))
test_non_negative <- all(select(data, -work_hours) >= 0)
print(test_non_negative)
#The result shows that the year columns does not contain non-negative values.

# 2. Verify that Work Hours Categories Match Expected Set 
#Checks if the work_hours categories exactly match a predefined list.
expected_categories <- c("No Response", "0-20", "21-40", "41-60", "61-80","80+","Total")
test_categories_match <- all(data$work_hours %in% expected_categories)
print(test_categories_match)
#We do have these categories, indicating that our cleaning is successful.

# 3. Confirm No Missing Values in Year Columns
#Confirms there are no NA values in the columns representing years.
test_no_missing_values <- all(!is.na(select(data, -work_hours)))
print(test_no_missing_values)
#We do not have missing values in year columns, meaning that we did not lose
#data during the process of cleaning.

# 4. Check for a Specific Year's Range of Values
# Verifies that the values for a specific year fall within an expected range.
test_year_range <- all(data$`2022` >= 50 & data$`2022` <= 2000)
print(test_year_range)
#The data still falls in the range, meaning no outstanding number errors after
#the process the cleaning.

# 5. Check for Consistency in Data Types
#Ensures that the data type for the year columns is integer, as expected from the simulation setup.
test_data_types <- all(sapply(data[,-c(1,2)], is.integer))
print(test_data_types)
#The data is consistent as everything except working hours are integers.


# 6. Check that responses range from 1974 through 2022 #
min(colnames(data)[2:36]) <= 1972
max(colnames(data)[2:36]) >= 2022

# 7. Check number of work hours categories
data$work_hours |>
  unique() |>
  length() == 7

#8. Check number of columns(work_hours + years)
colnames(data) |>
  unique() |>
  length() == 37

#9. Check if the totals are consistent
sum(data[1:6,3]) == data[7,3]

total <- 0
for(i in 3:36){
  total <- total + data[3,i] 
}
total == data[3,37]

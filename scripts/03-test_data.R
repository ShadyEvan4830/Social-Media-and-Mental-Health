#### Preamble ####
# Purpose: Test codes for the dataset.
# Author: Tianen (Evan) Hao
# Date: 28 March 2024 
# Contact: evan.hao@mail.utoronto.ca 
# License: MIT
# Pre-requisites: 
# 00-simulate_data.R
# 01-data_cleaning.R

#### Workspace setup ####
library(dplyr)
library(here)

#### Test data ####
data <- read.csv(here::here("Welfare and The Economy/data/analysis_data/cleaned_data.csv"))

# 1. Verify that all reported welfare perceptions are non-negative
test_non_negative <- all(select(data, -c(year, AGE, SEX)) >= 0)
print(paste("Test non-negative values: ", test_non_negative))

# 2. Verify that response categories are as expected
expected_responses <- c("Too Much", "About Right", "Too Little")
test_response_categories <- all(data$response %in% expected_responses)
print(paste("Test response categories match: ", test_response_categories))

# 3. Confirm there are no missing values in key columns
test_no_missing_values <- all(!is.na(data$response) & !is.na(data$year))
print(paste("Test no missing values: ", test_no_missing_values))

# 4. Check for valid age range (assuming 18-99 as a reasonable range)
test_valid_ages <- all(data$AGE >= 18 & data$AGE <= 99)
print(paste("Test valid age range: ", test_valid_ages))

# 5. Check for consistent gender data
expected_genders <- c("MALE", "FEMALE")
test_gender_data <- all(data$SEX %in% expected_genders)
print(paste("Test gender consistency: ", test_gender_data))

# 6. Ensure year column covers the correct range
test_correct_year_range <- min(data$year) >= 1972 & max(data$year) <= 2024
print(paste("Test correct year range: ", test_correct_year_range))

# 7. Check that each year has a plausible number of responses (for simulation purpose)
# Assuming an expected minimum and maximum number of responses per year
min_responses <- 100  # Minimum expected responses
max_responses <- 1000  # Maximum expected responses
test_year_responses <- all(data$response_count >= min_responses & data$response_count <= max_responses)
print(paste("Test year responses in range: ", test_year_responses))

# Note: Replace 'response_count' with the actual column name that stores the number of responses per year

# 8. Check for consistency in data types
# Assuming that year should be integer and response should be character
test_data_types <- is.integer(data$year) & is.character(data$response)
print(paste("Test data types consistency: ", test_data_types))

#### Preamble ####
# Purpose: Simulate public responses to welfare adequacy across various economic conditions
# Author: Tianen (Evan) Hao
# Date: 14 March 2023 
# Contact: evan.hao@mail.utoronto.ca 
# License: MIT
# Pre-requisites: none

#### Workspace setup ####
library(tibble)
library(dplyr)
library(tidyr)

#### Simulate data ####
# Define years and responses categories to welfare questions

# Some of the years may be chosen based on significant economic events or data availability
years <- c(1972, 1980, 1992, 2000, 2008, 2012, 2016, 2020, 2024)
welfare_responses_categories <- c("Too Much", "About Right", "Too Little")

# Simulate data
set.seed(123) # For reproducibility
simulated_data <- tibble(year = rep(years, each = length(welfare_responses_categories)),
                         welfare_response = rep(welfare_responses_categories, times = length(years)),
                         count = round(runif(n = length(years) * length(welfare_responses_categories), min = 100, max = 1000)))

# Pivot to wide format
simulated_data_wide <- simulated_data %>%
  pivot_wider(names_from = year, values_from = count)

# Check the range for a specific year (e.g., 2020)
test_year_range <- all(simulated_data_wide[["2020"]] >= 100 & simulated_data_wide[["2020"]] <= 1000)
print(paste("Test Year Range for 2020: ", test_year_range))

# Output the first few rows to check the structure
print(head(simulated_data_wide))

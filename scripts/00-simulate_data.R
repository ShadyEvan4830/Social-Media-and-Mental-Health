#### Preamble ####
# Purpose: Simulates number of reports in different amount of hours working
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
# Define years and work hours categories

# Some of the years are not included due to the fact that many years are
# missing from the GSS data set
years <- c(1992, 1993, 1994, 1995, 1996, 1997, 1998, 1999, 2000, 2001, 
           2002, 2003, 2004, 2005, 2006, 2008, 2010, 2012, 2014, 2016, 
           2018, 2021, 2022)
work_hours_categories <- c("No Response", "0-20", "21-40", "41-60", "61-80")

# Simulate data
set.seed(123) # For reproducibility
simulated_data <- tibble(year = rep(years, each = length(work_hours_categories)),
                         work_hours = rep(work_hours_categories, times = length(years)),
                         value = runif(n = length(years) * length(work_hours_categories), min = 50, max = 2000))

# Pivot to wide format
simulated_data_wide <- simulated_data %>%
  pivot_wider(names_from = year, values_from = value)

# Round the values to remove decimals
simulated_data_wide <- simulated_data_wide %>%
  mutate(across(-work_hours, round))

# Check the range for a specific year (e.g., 2022)
test_year_range <- all(simulated_data_wide[["2022"]] >= 50 & simulated_data_wide[["2022"]] <= 2000)
print(paste("Test Year Range for 2022: ", test_year_range))

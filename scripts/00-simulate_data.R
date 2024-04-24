#### Preamble ####
# Purpose: Simulates number of reports in different amount of hours working
# Author: Tianen (Evan) Hao
# Date: 29 March 2023 
# Contact: evan.hao@mail.utoronto.ca 
# License: MIT
# Pre-requisites: none

# Workplace setup and Load necessary libraries
library(tibble)
library(dplyr)
library(ggplot2)

# Define the years and categories for responses
years <- seq(1972, 2022, by = 2)  # Every two years from 1972 to 2022
response_types <- c("Too Little", "About Right", "Too Much")

# Set seed for reproducibility
set.seed(123)

# Create a tibble with simulated data
simulated_data <- expand.grid(year = years, response_type = response_types) %>%
  mutate(count_responses = runif(n = n(), min = 100, max = 1000))  # Random counts between 100 and 1000

# View the first few rows of the simulated data
head(simulated_data)

# Pivot data to wide format
simulated_data_wide <- simulated_data %>%
  pivot_wider(names_from = response_type, values_from = count_responses)

# Round the values to make them easier to read
simulated_data_wide <- simulated_data_wide %>%
  mutate(across(.cols = starts_with("Too"), .fns = round))

# Print the wide format data
print(simulated_data_wide)

# Plotting the data
ggplot(simulated_data, aes(x = year, y = count_responses, color = response_type)) +
  geom_line() +
  labs(title = "Simulated Public Responses to Welfare Adequacy Over Time",
       x = "Year",
       y = "Number of Responses",
       color = "Response Type") +
  theme_minimal()

# Compute summary statistics
summary_stats <- simulated_data %>%
  group_by(response_type) %>%
  summarize(mean_responses = mean(count_responses),
            median_responses = median(count_responses),
            max_responses = max(count_responses),
            min_responses = min(count_responses))

# Display summary statistics
print(summary_stats)


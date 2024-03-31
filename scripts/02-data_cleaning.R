#### Preamble ####
# Purpose: Clean GSS Dataset
# Author: Tianen (Evan) Hao
# Date: 11 March 2024 
# Contact: evan.hao@mail.utoronto.ca 
# License: MIT
# Pre-requisites: R 4.3.2

#### Workspace setup ####
library(janitor)  # For cleaning column names
library(tidyverse)  # For data manipulation and visualization
library(readr)  # For reading csv files

#### Load and Clean Data ####
# Adjusted path for raw data
data_path <- "~/Welfare and The Economy/data/raw_data/raw_data.csv"
data <- read_csv(data_path)

# Clean column names (removing any unwanted prefixes or spaces)
data <- janitor::clean_names(data)

# Remove unwanted columns 'ballot' and 'x5', and rename 'natfare' to 'response'
data <- data %>%
  select(-ballot, -x5) %>%
  rename(response = natfare) %>%
  # Filter out inapplicable or irrelevant responses from the 'response' column
  filter(!response %in% c(".i:  Inapplicable", ".n:  No answer",
                          ".d:  Do not Know/Cannot Choose", ".s:  Skipped on Web")) %>%
  # Optionally, rename responses in 'response' for clarity
  mutate(response = factor(response,
                           levels = c("TOO MUCH", "TOO LITTLE", "ABOUT RIGHT"),
                           labels = c("Too Much", "Too Little", "About Right")))

# Save the cleaned data to the specified path
cleaned_data_path <- "~/Welfare and The Economy/data/analysis_data/cleaned_data.csv"
write_csv(data, cleaned_data_path)

#### Further Analysis ####
# This section would contain your specific analysis code,
# such as data summarization, visualization, or statistical modeling.

# Example of summarizing opinions by year
summary_data <- data %>%
  group_by(year, response) %>%
  summarize(count = n(), .groups = 'drop')

# Example visualization with ggplot2
ggplot(summary_data, aes(x = year, y = count, color = response)) +
  geom_line() +
  labs(title = "Public Opinion on Welfare Over Time",
       x = "Year",
       y = "Number of Responses",
       color = "Opinion")

library(tidyverse)

# Load the data
cleaned_data <- read.csv("~/Welfare and The Economy/data/analysis_data/cleaned_data.csv")

# Categorize the data by response type across years and compute the counts
categorized_data <- cleaned_data %>%
  count(year, response) %>%
  spread(key = response, value = n, fill = 0)

# Convert 'year' to character so it can be combined with the 'Total' character string
categorized_data$year <- as.character(categorized_data$year)

# Add a 'Total' column
categorized_data$Total <- rowSums(categorized_data[,-1])

# Calculate 'Total' row
total_row <- colSums(categorized_data[, -1])

# Convert the total_row to a data frame and make sure all its columns except 'year' are numeric
total_row_df <- as.data.frame(t(total_row))
total_row_df$year <- "Total"

# Now bind the rows
categorized_data <- bind_rows(categorized_data, total_row_df)

# Preview the first five rows
print(head(categorized_data))

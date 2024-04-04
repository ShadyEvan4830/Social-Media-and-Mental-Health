#### Preamble ####
# Purpose: Code for replicating GSS Tables and Graphs in the Paper
# Author: Tianen (Evan) Hao
# Date: 28 March 2024 
# Contact: evan.hao@mail.utoronto.ca 
# License: MIT
# Pre-requisites: R 4.3.2, cleaned_Data.csv

# Load Packages
library(knitr)
library(kableExtra)

## Read raw data
# Load packages
library(knitr)
library(kableExtra)

# Read raw data
raw_data <- read.csv("~/Welfare and The Economy/data/raw_data/raw_data.csv")

# Create a table preview with only the first five columns
table_preview <- data.frame(
  Variable = names(raw_data)[1:5],
  NewName = names(raw_data)[1:5],
  Description = c("The year of the survey recorded",
                  "Unique identifier for the respondent",
                  "Respondent's attitude towards national welfare",
                  "Respondent's type of ballot",
                  "Content unclear, column unnamed")[1:5],
  Example = as.character(sapply(raw_data[1:5], function(col) col[1]))
)

# Use kable and kableExtra to create the table
kable(table_preview, "latex", row.names = FALSE, booktabs = TRUE) %>%
  kable_styling(full_width = FALSE, font_size = 12) %>%
  column_spec(1, bold = TRUE)  # Only specify LaTeX-compatible styling


## Cleaned_data Preview
# Load the necessary libraries
library(tidyverse)
library(knitr)
library(kableExtra)

# Load the data
cleaned_data <- read.csv("~/Welfare and The Economy/data/analysis_data/cleaned_data.csv")

# Categorize and summarize the data
categorized_data <- cleaned_data %>%
  count(year, response) %>%
  spread(key = response, value = n, fill = 0) %>%
  mutate(year = as.character(year), # Convert 'year' to character to combine with the 'Total' string later
         Total = rowSums(.[,-1])) # Add a 'Total' column

# Calculate the total row
total_row <- colSums(categorized_data[,-1]) # Sum all columns except 'year'
total_row_df <- as.data.frame(t(total_row))
colnames(total_row_df) <- colnames(categorized_data)[-1] # Ensure column names match
total_row_df$year <- "Total" # Add a 'year' column with the value 'Total'

# Combine the total row with the data frame
categorized_data <- bind_rows(categorized_data, total_row_df)

# Select the top 5 rows for display
categorized_data_top5 <- head(categorized_data, 5)

# Create the table with kable and kableExtra, displaying only the top 5 rows
categorized_data_table <- categorized_data_top5 %>%
  select(year, everything()) %>% # Ensure the 'year' column is first
  kable("latex", row.names = FALSE, booktabs = TRUE) %>%  # Use LaTeX format for PDF
  kable_styling(full_width = FALSE, position = "center") %>%
  row_spec(0, bold = TRUE) %>%  # Make the header row bold
  column_spec(1, bold = TRUE)  # Make the first column bold

# Print the table
categorized_data_table


## Trends in Public Opinion Over Time in The US
ggplot(total_responses_per_year, aes(x = year, y = total_responses)) +
  geom_line(color = "#2C3E50", size = 1) +
  geom_point(color = "#E74C3C", size = 3, shape = 18) +
  theme_minimal(base_size = 14) +
  labs(title = "Trend of Total Responses per Year",
       x = "Year",
       y = "Total Responses",
       caption = "Annual trend showing the total number of responses to welfare adequacy surveys.") +
  theme(plot.title = element_text(hjust = 0.5))

## Comparison between 1980 and 1982, 2018 and 2021
library(ggplot2)
library(dplyr)
library(readr)

# Load the cleaned data
cleaned_data <- read_csv("~/Welfare and The Economy/data/analysis_data/cleaned_data.csv")

# Filter data for the years and "Too Little" response
comparison_data <- cleaned_data %>%
  filter(year %in% c(1980, 1982, 2018, 2021), response == "Too Little") %>%
  count(year)

# Create the comparison graph
ggplot(comparison_data, aes(x = as.factor(year), y = n, fill = as.factor(year))) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Comparison of 'Too Little' Responses in Selected Years",
       x = "Year",
       y = "Count of 'Too Little' Responses",
       fill = "Year") +
  theme_minimal() +
  theme(legend.position = "none")  # We do not need a legend since the year is on the x-axis



## Years Ranked by the Highest Proportion of "Too Much" Responses
top_five_too_much <- head(too_much_proportion, 5)

ggplot(top_five_too_much, aes(x = reorder(year, proportion), y = proportion)) +
  geom_col(fill = "#3498DB") +
  coord_flip() +
  theme_minimal(base_size = 14) +
  labs(title = "Top Five Years by Proportion of 'Too Much' Responses",
       x = "Year",
       y = "Proportion",
       caption = "Identifying the top five years with the highest proportion of 'Too Much' responses regarding welfare adequacy.") +
  theme(plot.title = element_text(hjust = 0.5))

## Years Ranked by the Highest Proportion of "Too Little" Responses
library(tidyverse)

# Load cleaned data
cleaned_data <- read.csv("~/Welfare and The Economy/data/analysis_data/cleaned_data.csv")

# Assuming cleaned_data has a 'response' column where 'Too Little' responses are indicated
# Calculate the proportion of 'Too Much' responses for each year
too_much_proportion <- cleaned_data %>%
  filter(response == "Too Little") %>%
  count(year) %>%
  mutate(total_responses = sum(n), proportion = n / total_responses) %>%
  select(year, proportion)

## Comparison of "Too Little" Responses
ggplot(specific_years_comparison, aes(x = as.factor(year), y = count, fill = as.factor(year))) +
  geom_col(position = "dodge", show.legend = FALSE) +
  scale_fill_manual(values = c("#1ABC9C", "#9B59B6", "#3498DB", "#E74C3C")) +
  theme_minimal(base_size = 14) +
  labs(title = "Comparison of 'Too Little' Responses",
       x = "Year",
       y = "Number of 'Too Little' Responses",
       caption = "Comparing 'Too Little' responses for the years 2021, 2018, 1982, and 1980.") +
  theme(plot.title = element_text(hjust = 0.5), axis.text.x = element_text(angle = 45, hjust = 1))


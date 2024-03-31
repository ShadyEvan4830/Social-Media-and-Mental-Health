#### Preamble ####
# Purpose: Code for replicating GSS Tables and Graphs in the Paper
# Author: Tianen (Evan) Hao
# Date: 28 March 2024 
# Contact: evan.hao@mail.utoronto.ca 
# License: MIT
# Pre-requisites: R 4.3.2, cleaned_Data.csv

## Raw_data overview
# Load the data
raw_data <- read.csv("~/Welfare and The Economy/data/raw_data/raw_data.csv")

# Create a data frame for the table preview
table_preview <- data.frame(
  Variable = names(raw_data),
  NewName = names(raw_data), # Assuming you want to keep the variable names as new names
  Description = c("The year of the survey recorded",
                  "Unique identifier for the respondent",
                  "Respondent's attitude towards national welfare",
                  "Respondent's type of ballot",
                  "Content unclear, column unnamed"), # Descriptions based on your dataset
  Example = as.character(sapply(raw_data, function(col) col[1])) # First entry of each column as example
)

# Print the table
print(table_preview)

## Cleaned_data Preview
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
print(head(categorized_data, 5))


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

## Trend of the Number of Responses per Year
ggplot(too_much_proportion, aes(x = reorder(year, proportion), y = proportion)) +
  geom_col(fill = "#3498DB") +
  coord_flip() +
  theme_minimal(base_size = 14) +
  labs(title = "Years Ranked by Proportion of 'Too Much' Responses",
       x = "Year",
       y = "Proportion",
       caption = "Ranking of years by the proportion of 'Too Much' responses regarding welfare adequacy.") +
  theme(plot.title = element_text(hjust = 0.5))


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

# Years Ranked by the Highest Proportion of "Too Little" Responses
top_five_too_little <- head(too_little_proportion, 5)

ggplot(top_five_too_little, aes(x = reorder(year, proportion), y = proportion)) +
  geom_col(fill = "#E67E22") +
  coord_flip() +
  theme_minimal(base_size = 14) +
  labs(title = "Top Five Years by Proportion of 'Too Little' Responses",
       x = "Year",
       y = "Proportion",
       caption = "Highlighting the top five years where the public most frequently felt welfare provisions were 'Too Little'.") +
  theme(plot.title = element_text(hjust = 0.5))

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



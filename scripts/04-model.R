#### Preamble ####
# Purpose: Code for replicating GSS Tables and Graphs in the Paper
# Author: Tianen (Evan) Hao
# Date: 29 March 2024 
# Contact: evan.hao@mail.utoronto.ca 
# License: MIT
# Pre-requisites: R 4.3.2, cleaned_Data.csv


library(tidyverse)

# Assuming 'cleaned_data' is already loaded and it has 'year', 'id', and 'response' columns.

# Calculate the total responses per year
total_responses_per_year <- cleaned_data %>%
  group_by(year) %>%
  summarise(total_responses = n())

# Calculate the count of "Too Little" responses per year
too_little_responses <- cleaned_data %>%
  filter(response == "Too Little") %>%
  count(year)

# Merge the counts with the total responses
too_little_data <- too_little_responses %>%
  left_join(total_responses_per_year, by = "year") %>%
  mutate(proportion_too_little = n / total_responses)

# Linear model to assess the trend of "Too Little" responses over years
model <- lm(proportion_too_little ~ year, data = too_little_data)

# Summary of the model to check for significance and trend
summary_model <- summary(model)

# Visualizing the trend
ggplot(too_little_data, aes(x = year, y = proportion_too_little)) +
  geom_point() +
  geom_smooth(method = "lm", color = "blue") +
  labs(title = "Trend of 'Too Little' Responses Over Years",
       x = "Year",
       y = "Proportion of 'Too Little' Responses",
       caption = "Linear model showing the trend of 'Too Little' responses indicating public perception of welfare inadequacy over time.") +
  theme_minimal()

# Attempt to save the model and catch any errors
tryCatch({
  saveRDS(model, file = "~/Welfare and The Economy/models/analysis_of_the_trend_model.rds")
  file_info <- file.info("~/Welfare and The Economy/models/analysis_of_the_trend_model.rds")
  if (!is.na(file_info$mtime)) {
    print(paste("Model saved successfully. Last modified:", file_info$mtime))
  } else {
    print("The file does not exist. It may not have been saved correctly.")
  }
}, error = function(e) {
  print(paste("An error occurred:", e$message))
})

# To print the summary of the model
print(summary_model)


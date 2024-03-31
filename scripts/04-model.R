#### Preamble ####
# Purpose: Code for replicating GSS Tables and Graphs in the Paper
# Author: Tianen (Evan) Hao
# Date: 29 March 2024 
# Contact: evan.hao@mail.utoronto.ca 
# License: MIT
# Pre-requisites: R 4.3.2, cleaned_Data.csv


# Assuming 'summary_data' contains the year, natfare type, and count of responses
# And that 'total_responses_per_year' contains the total responses per year

# Calculating the proportion of "Too Little" responses for each year
too_little_data <- summary_data %>%
  filter(natfare == "Too Little") %>%
  mutate(proportion_too_little = count / total_responses_per_year$total_responses)

# Linear model to assess the trend of "Too Little" responses over years
model <- lm(proportion_too_little ~ year, data = too_little_data)

# Summary of the model to check for significance and trend
summary(model)

# Visualizing the trend
ggplot(too_little_data, aes(x = year, y = proportion_too_little)) +
  geom_point() +
  geom_smooth(method = "lm", color = "blue") +
  labs(title = "Trend of 'Too Little' Responses Over Years",
       x = "Year",
       y = "Proportion of 'Too Little' Responses",
       caption = "Linear model showing the trend of 'Too Little' responses indicating public perception of welfare inadequacy over time.") +
  theme_minimal()

#### Save model ####
# LINEAR MODEL
saveRDS(
  analysis_of_the_trend_model,
  file = "~/Welfare and The Economy/models/analysis_of_the_trend_model.rds"
)

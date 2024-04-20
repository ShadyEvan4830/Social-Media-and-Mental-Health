#### Preamble ####
# Purpose: Code for replicating GSS Tables and Graphs in the Paper
# Author: Tianen (Evan) Hao
# Date: 29 March 2024 
# Contact: evan.hao@mail.utoronto.ca 
# License: MIT
# Pre-requisites: R 4.3.2, cleaned_Data.csv

#### Workspace setup ####
library(tidyverse)
library(rstanarm)
library(arrow)

#### Read data #### -- put this section into cleaning "additional data set for model"
model_data <- read_csv("~/Welfare and The Economy/data/analysis_data/model_data.csv")

### Model data ####
first_model <-
  stan_glm(
    formula = total_responses ~ year,
    data = model_data,
    family = gaussian(),
    prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_aux = exponential(rate = 1, autoscale = TRUE),
    seed = 853
  )

model_file_path <- "~/Welfare and The Economy/models/first_model.rds"
#### Save model ####
saveRDS(
  first_model,
  file = model_file_path
)


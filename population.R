# set working directory to the folder containing this script
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# load required packages
library(tidycensus)
library(tidyverse)

# only need to run this one to install your census api key in REnviron
census_api_key("09a9edd9b1fa04af9fa3f415d4bb68ba7b0077fa", install = TRUE)

pop <- get_estimates(
  geography = "state",
  product = "population",
  state = "CA",
  time_series = TRUE
)


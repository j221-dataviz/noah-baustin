# set working directory to the folder containing this script
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# load required packages
library(tidycensus)
library(tidyverse)

# only need to run this one to install your census api key in REnviron
census_api_key("09a9edd9b1fa04af9fa3f415d4bb68ba7b0077fa", install = TRUE, overwrite=TRUE)

#show the variables we can call for the census api
variables <- load_variables(2020, "pl")
view(variables)

ca_pop_2020 <- get_decennial(
  geography = "state",
  
  
  
)




#Peter had written this... don't use for now
pop <- get_estimates(
  geography = "state",
  product = "population",
  state = "CA",
  time_series = TRUE
)


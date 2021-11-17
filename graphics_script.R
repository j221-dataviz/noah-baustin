# set working directory to the folder containing this script
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# load required packages
library(tidycensus)
library(tidyverse)
library(ggplot2)

# only need to run this one to install your census api key in REnviron
#census_api_key("09a9edd9b1fa04af9fa3f415d4bb68ba7b0077fa", install = TRUE, overwrite=TRUE)

#read in csv's
mari_misdemeanor_total <- read_csv("./processed_data/ca_misdemeanor_category_age.csv")
mari_felony_total <- read_csv("./processed_data/ca_felony_category.csv")

#create dataframe with total number of misdemeanor marijuana arrests per year
mari_mis_per_year <- mari_misdemeanor_total %>%
  filter(category == "Marijuana") %>%
  mutate(group = c("total_marijuana_misdem")) %>%
  select(total, year, group)

#create dataframe with total number of misdemeanor drug arrests per year NOT including marijuana
drug_mis_per_year <- mari_misdemeanor_total %>%
  filter(category == "Other drug") %>%
  mutate(group = c("total_drug_misdem_no_mari")) %>%
  select(total, year, group)

#create dataframe with total number of felony marijuana arrests per year
mari_felony_per_year <- mari_felony_total %>%
  mutate(total = marijuana) %>%
  mutate(group = c("total_marijuana_felony")) %>%
  select(total, year, group)

#create dataframe with total number of felony drug arrests per year NOT including marijuana
drug_felon_per_year <- mari_felony_total %>%
  mutate(total = drug_offenses - marijuana) %>%
  mutate(group = c("total_drug_felony_no_mari")) %>%
  select(total, year, group)

#bind our dataframes so we have the totals for marijuana arrests and total drug offenses in one dataframe.
#Also, this pulls the data into the correct shape for the stacked bar chart in R. 
annual_totals <- rbind(mari_mis_per_year, drug_mis_per_year, mari_felony_per_year, drug_felon_per_year)
view(annual_totals)

##########################
#I left off here! I finally have my data in the correct shape, so the next step is to graph it!
#here's the reference for the stacked bar chart: https://r-charts.com/part-whole/stacked-bar-chart-ggplot2/
#here's another reference for the chart: https://www.r-graph-gallery.com/48-grouped-barplot-with-ggplot2.html

#create our stacked bar graph
ggplot(annual_totals, aes(x = year, fill = ))












######################
#saving the below old code just in case I want to go back to it

#create dataframe with total number of misdemeanor marijuana arrests per year
mari_mis_per_year <- mari_misdemeanor_total %>%
  filter(category == "Marijuana") %>%
  mutate(total_marijuana_misdem = total) %>%
  select(total_marijuana_misdem, year)

#create dataframe with total number of misdemeanor drug arrests per year NOT including marijuana
drug_mis_per_year <- mari_misdemeanor_total %>%
  filter(category == "Other drug") %>%
  mutate(total_drug_misdem_no_mar = total) %>%
  select(total_drug_misdem_no_mar, year)

#create dataframe with total number of felony marijuana arrests per year
mari_felony_per_year <- mari_felony_total %>%
  mutate(total_marijuana_felony = marijuana) %>%
  select(total_marijuana_felony, year)

#create dataframe with total number of felony drug arrests per year NOT including marijuana
drug_felon_per_year <- mari_felony_total %>%
  mutate(total_drug_felony_no_mar = drug_offenses - marijuana) %>%
  select(total_drug_felony_no_mar, year)

#join our dataframes so we have the totals for marijuana arrests and total drug offenses in one dataframe
annual_totals <- mari_mis_per_year %>%
  inner_join(drug_mis_per_year, by="year") %>%
  inner_join(mari_felony_per_year, by="year") %>%
  inner_join(drug_felon_per_year, by="year")

annual_totals <- mari_mis_per_year %>%
  outer_join(drug_mis_per_year, by="group") %>%
  inner_join(mari_felony_per_year, by="year") %>%
  inner_join(drug_felon_per_year, by="year")

view(annual_totals)
  
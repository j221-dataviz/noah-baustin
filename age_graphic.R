# set working directory to the folder containing this script
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# load required packages
library(tidycensus)
library(tidyverse)
library(ggplot2)
library(plotly)
library(htmlwidgets)

#prevent scientific notation
options(scipen=999)

#read in csv's
misdem_age <- read_csv("./processed_data/ca_misdemeanor_category_age.csv")
felony_age <- read_csv("./processed_data/ca_felony_category_age.csv")
ca_pop <- read_csv("./processed_data/popest.csv")

#take a look at column data types
glimpse(misdem_age)
glimpse(felony_age)
glimpse(ca_pop)

head(misdem_age)
head(felony_age)
head(ca_pop)

#clean data: 
#condense to age category 19 and below (to match census format)
#filter so we're only looking at marijuana arrests
#select the columns I want to use
mari_misdem_age <- misdem_age %>%
  mutate(age_to_19 = (age_under_18 + age_18_19)) %>%
  filter(category == "Marijuana") %>%
  select(total, age_to_19, age_20_39, `age_40+`, year) %>%
  mutate(arrest_type = c("misdem"))

view(mari_misdem_age)

#clean data: 
#condense to age category 19 and below (to match census format)
#filter so we're only looking at marijuana arrests
#select the columns I want to use
mari_felony_age <- felony_age %>%
  mutate(age_to_19 = (age_under_18 + age_18_19)) %>%
  filter(category == "Marijuana") %>%
  select(total, age_to_19, age_20_39, `age_40+`, year) %>%
  mutate(arrest_type = c("felony"))

view(mari_felony_age)

#combine the misdemeanor and felony marijuana arrest data into one dataframe 
annual_totals_age <- rbind(mari_misdem_age, mari_felony_age)

#adding up the felony and misdemeanor arrests for each year to express total marijuana arrests
all_mari_arrests <- annual_totals_age %>%
  group_by(year) %>%
  summarize(total = sum(total),
            age_to_19 = sum(age_to_19),
            age_20_39 = sum(age_20_39),
            `age_40+` = sum(`age_40+`)
            ) 

#create a dataframe that expresses each age group as a percentage of arrests out of the annual total
arrests_pct <- all_mari_arrests %>%
  mutate(age_to_19_pct = (age_to_19 / total) * 100) %>%
  mutate(age_20_39_pct = (age_20_39 / total) * 100) %>%
  mutate(`age_40+_pct` = (`age_40+` / total) * 100) %>%
  select(year, age_to_19_pct, age_20_39_pct, `age_40+_pct`)
  
head(ca_pop)
glimpse(ca_pop)

#create a dataframe that contains the annual percentage of the population each age bracket made up
ca_pop_pct <- ca_pop %>%
  mutate(population_age_to_19_pct = (population_age_to_19 / total_population) * 100 ) %>%
  mutate(population_age_20_39_pct = (population_age_20_39 / total_population) * 100) %>%
  mutate(population_age_40_plus_pct = (population_age_40_plus / total_population) * 100) %>%
  select(year, population_age_to_19_pct, population_age_20_39_pct, population_age_40_plus_pct)

view(ca_pop_pct)

#create a dataframe that shows the annual difference between the percentage of total arrests each...
#... age bracket made up and the percentage of the population that age bracket represents
#positive numbers mean that people in that age group were disproportionately MORE likely to be arrested
#negative numbers mean that people in that age group were disproportionately LESS likely to be arrested

arrests_to_pop_pct <- arrests_pct %>%
  left_join(ca_pop_pct, by="year") %>%
  mutate(diff_to_19 = (age_to_19_pct - population_age_to_19_pct)) %>%
  mutate(diff_20_39 = (age_20_39_pct - population_age_20_39_pct)) %>%
  mutate(diff_40_plus = (`age_40+_pct` - population_age_40_plus_pct)) %>%
  select(year, diff_to_19, diff_20_39, diff_40_plus)

#export dataframe to a .csv file to upload into Datawrapper
write.csv(arrests_to_pop_pct,"/Volumes/T7/Data_Viz/Final_Project/noah-baustin/processed_data/arrests_to_pop_pct.csv", row.names = FALSE)

#link to Datawrapper heat map: https://www.datawrapper.de/_/iAdWx/

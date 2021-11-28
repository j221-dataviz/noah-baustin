# set working directory to the folder containing this script
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# load required packages
library(tidyverse)
library(tidycensus)
library(janitor)
library(forecast)

# 2000 to 2010 population estimates

files <- list.files("data/population_data", full.names = TRUE)

age_codes <- read_csv(files[1])

popest_to_2009 <- read_csv(files[3]) %>%
  clean_names() %>%
  left_join(age_codes, by = c("agegrp" = "age_code")) %>%
  filter(name == "California" & race == 0 & origin == 0) %>%
  select(contains("popest"),sex,age_label) %>%
  mutate(sex = case_when(sex == 0 ~ "Both sexes",
                         sex == 1 ~ "Male",
                         sex == 2 ~ "Female")) %>%
  pivot_longer(cols = c(1:11),
               names_to = "year",
               values_to = "population") %>%
  mutate(year = as.integer(gsub("popestimate","",year))) %>%
  filter(year < 2010) # 2010  is in the more recent intercensual data so let's go with that and drop here

# 2010 to 2019 population estimates
year_codes <- tibble(date = c(3:12), year = c(2010:2019)) 

popest_to_2019_breakdown <- get_estimates(geography = "state", 
                               product = "characteristics", 
                               breakdown = c("AGEGROUP","SEX"),  
                               breakdown_labels = TRUE,
                               time_series = TRUE,
                               state = "CA") %>%
  clean_names() %>%
  inner_join(year_codes, by = "date") %>%
  filter(agegroup != "Median age") %>%
  select(year, age_label = agegroup, sex, population = value) 

popest_to_2019_total <- get_estimates(geography = "state", 
                                product = "population",      
                                time_series = TRUE,
                                state = "CA") %>%
  clean_names() %>%
  inner_join(year_codes, by = "date") %>%
  filter(variable == "POP") %>%
  select(year, total_population = value)

# combine the data

# total population
popest_total <- popest_to_2009 %>%
  filter(sex == "Both sexes" & age_label == "Total") %>%
  select(year, total_population = population) %>%
  bind_rows(popest_to_2019_total)
  
# by sex
popest_sex_to_2009 <- popest_to_2009 %>%
  filter(sex != "Both sexes" & age_label == "Total") 
popest_sex_to_2019 <- popest_to_2019_breakdown %>%
  filter(sex != "Both sexes" & age_label == "All ages") 
popest_sex  <- bind_rows(popest_sex_to_2009,popest_sex_to_2019) %>%
  pivot_wider(names_from = "sex", values_from = "population") %>%
  select(year, male_population = Male, female_population = Female)
  
# by age groups
# NB changed the mutate so that it now breaks up 20_39 into two seperate buckets
popest_age_to_2009 <- popest_to_2009 %>%
  filter(sex == "Both sexes" & age_label != "Total")
popest_age_to_2019 <- popest_to_2019_breakdown %>%
  filter(sex == "Both sexes" & age_label != "All ages") 
popest_age  <- bind_rows(popest_age_to_2009,popest_age_to_2019) %>%
  pivot_wider(names_from = "age_label", values_from = "population") %>%
  select(2:20) %>%
  rowwise() %>%
  mutate(population_age_to_19 = sum(across(2:5)),
         population_age_20_29 = sum(across(6:7)),
         population_age_30_39 = sum(across(8:9)),
         population_age_40_plus = sum(across(10:19))) %>%
  select(year,20:23)

view(popest_age)

# combine and extrapolate for 2020 using defaults from forecast package
popest_working <- popest_total %>%
  inner_join(popest_sex) %>%
  inner_join(popest_age)

forecast_2020 <- as_tibble(forecast(ts(popest_working), h = 1))
forecast_2020 <- forecast_2020 %>%
  select(2,3) %>%
  t() %>%
  as_tibble() %>%
  tail(1) %>%
  mutate_all(as.integer)
names(forecast_2020) <- names(popest_working)

popest_working <- bind_rows(popest_working, forecast_2020)

# write as csv
write_csv(popest_working, "processed_data/popest.csv", na = "")

              
  




  



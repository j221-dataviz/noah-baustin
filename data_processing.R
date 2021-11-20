####### DO NOT RUN THIS SCRIPT AGAIN ###########
#This was the script that originally parsed the data into condensed .csv's.


# set working directory to the folder containing this script
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# load required packages
library(tidyverse)
library(janitor)

#########
# parse ca felonies by category

folder <- list.files("data/csv_exports/felony")[1]

files <- list.files(paste0("data/csv_exports/felony/",folder), full.names = TRUE)

ca_felony_category <- tibble()

for (f in files) try({
  print(f)
  tmp <- read_csv(f) %>%
    clean_names() %>%
    select(1:7)
  names(tmp) <- c("category", names(tmp)[2:7])
  tmp <- tmp %>%
    filter(grepl("total|drug offenses|marijuana",category,ignore.case = TRUE)) %>%
    mutate(category = gsub("\\.","",category)) %>%
    pivot_longer(-category, names_to = "year", values_to = "value") %>%
    mutate(value = word(value),
           value = as.integer(gsub(",","",value)),
           year = as.integer(gsub("x","",year))) %>%
    pivot_wider(names_from = category, values_from = value) %>%
    clean_names() 
  ca_felony_category <- bind_rows(ca_felony_category,tmp)
})
rm(tmp)

ca_felony_category <- ca_felony_category %>%
  mutate(year = c(1997:2020)) %>%
  rename(all_offenses = total)

write_csv(ca_felony_category, "processed_data/ca_felony_category.csv", na = "")


#########
# parse ca felonies by category and age group

folder <- list.files("data/csv_exports/felony")[2]

files <- list.files(paste0("data/csv_exports/felony/",folder), full.names = TRUE)

ca_felony_category_age <- tibble()

for (f in files) try({
  print(f)
  year <- as.integer(substr(f,nchar(f)-7,nchar(f)-4))
  tmp <- read_csv(f) %>%
    clean_names() %>%
    separate(number, into = c("age_18_19","age_20_29"), sep = " ") %>%
    select(1:7)
  names(tmp) <- c("category","total","age_under_18","age_18_19","age_20_29","age_30_39","age_40+")
  tmp <- tmp %>%
    filter(grepl("total|drug offenses|marijuana",category,ignore.case = TRUE)) %>%
    mutate(year = year,
           category = gsub("\\.","",category)) %>%
    mutate_all(~ gsub(",", "", .)) %>%
    mutate(across(total:year,as.integer))
  ca_felony_category_age <- bind_rows(ca_felony_category_age,tmp)
})
rm(tmp)

ca_felony_category_age <- ca_felony_category_age %>%
  mutate(category = gsub("Total", "All offenses", category))

write_csv(ca_felony_category_age, "processed_data/ca_felony_category_age.csv", na = "")
# needed some manual editing of output file
# needs more

#########
# parse ca felonies by sex and race

folder <- list.files("data/csv_exports/felony")[3]

files <- list.files(paste0("data/csv_exports/felony/",folder), full.names = TRUE)

ca_felony_category_sex_race <- tibble()

for (f in files) try({
  print(f)
  year <- as.integer(substr(f,nchar(f)-7,nchar(f)-4))
  tmp <- read_csv(f) %>%
    clean_names() %>%
    separate(x3, into = c("male","female"), sep = " ") %>%
    separate(x5, into = c("hispanic","black"), sep = " ") %>%
    select(1:8)
  names(tmp) <- c("category","total","male","female","white","hispanic","black", "other_race")
  tmp <- tmp %>%
    filter(grepl("total|drug offenses|marijuana",category,ignore.case = TRUE)) %>%
    mutate(year = year,
           category = gsub("\\.","",category)) %>%
    mutate_all(~ gsub(",", "", .)) %>%
    mutate(across(total:year,as.integer))
  ca_felony_category_sex_race <- bind_rows(ca_felony_category_sex_race,tmp)
})
rm(tmp)

ca_felony_category_sex_race <- ca_felony_category_sex_race %>%
  mutate(category = gsub("Total", "All offenses", category)) %>%
  arrange(year)

write_csv(ca_felony_category_sex_race, "processed_data/ca_felony_category_sex_race.csv", na = "")
# needed some manual editing of output file
# needs more

#########
# parse ca misdemeanors by category and age group

folder <- list.files("data/csv_exports/misdemeanor")[3]

files <- list.files(paste0("data/csv_exports/misdemeanor/",folder), full.names = TRUE)

ca_misdemeanor_category_age <- tibble()

for (f in files) try({
  print(f)
  year <- as.integer(substr(f,nchar(f)-7,nchar(f)-4))
  tmp <- read_csv(f) %>%
    clean_names() %>%
    separate(number, into = c("age_18_19","age_20_29"), sep = " ") %>%
    select(1:7)
  names(tmp) <- c("category","total","age_under_18","age_18_19","age_20_29","age_30_39","age_40+")
  tmp <- tmp %>%
    filter(grepl("total|other drug|marijuana",category,ignore.case = TRUE)) %>%
    mutate(year = year,
           category = gsub("\\.","",category)) %>%
    mutate_all(~ gsub(",", "", .)) %>%
    mutate(across(total:year,as.integer))
  ca_misdemeanor_category_age <- bind_rows(ca_misdemeanor_category_age,tmp)
})
rm(tmp)

ca_misdemeanor_category_age <- ca_misdemeanor_category_age %>%
  mutate(category = gsub("Total", "All offenses", category))

write_csv(ca_misdemeanor_category_age, "processed_data/ca_misdemeanor_category_age.csv", na = "")
# needed some manual editing of output file
# needs more 

#########
# parse ca misdemeanors by sex and race

folder <- list.files("data/csv_exports/misdemeanor")[2]

files <- list.files(paste0("data/csv_exports/misdemeanor/",folder), full.names = TRUE)

ca_misdemeanor_category_sex_race <- tibble()

for (f in files) try({
  print(f)
  year <- as.integer(substr(f,nchar(f)-7,nchar(f)-4))
  tmp <- read_csv(f) %>%
    clean_names() %>%
    separate(x3, into = c("male","female"), sep = " ") %>%
    separate(x5, into = c("hispanic","black"), sep = " ") %>%
    select(1:8)
  names(tmp) <- c("category","total","male","female","white","hispanic","black", "other_race")
  tmp <- tmp %>%
    filter(grepl("total|other drug|marijuana",category,ignore.case = TRUE)) %>%
    mutate(year = year,
           category = gsub("\\.","",category)) %>%
    mutate_all(~ gsub(",", "", .)) %>%
    mutate(across(total:year,as.integer))
  ca_misdemeanor_category_sex_race <- bind_rows(ca_misdemeanor_category_sex_race,tmp)
})
rm(tmp)

ca_misdemeanor_category_sex_race <- ca_misdemeanor_category_sex_race %>%
  mutate(category = gsub("Total", "All offenses", category))

write_csv(ca_misdemeanor_category_sex_race, "processed_data/ca_misdemeanor_category_sex_race.csv", na = "")
# needed some manual editing of output file
# needs more 


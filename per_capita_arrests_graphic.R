#####
#TO DO ON THIS: 
  #change the legend names
  #get the line to work in interactive version
  #save out so I can embed in webpage

# set working directory to the folder containing this script
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# load required packages
library(tidyverse)
library(ggplot2)
library(plotly)
library(htmlwidgets)
library(scales)
library(readr)
libary(htmlwidgets)

#prevent scientific notation
options(scipen=999)

#read in csv's
ca_misdemeanors <- read_csv("processed_data/ca_misdemeanor_category_age.csv", 
                                        col_types = cols(total = col_integer(), 
                                        age_under_18 = col_integer(), age_18_19 = col_integer(), 
                                        age_20_29 = col_integer(), age_30_39 = col_integer(), 
                                        `age_40+` = col_integer(), year = col_integer()))

ca_felony_category <- read_csv("processed_data/ca_felony_category.csv", 
                               col_types = cols(year = col_integer(), 
                                           all_offenses = col_integer(), 
                                           drug_offenses = col_integer(), 
                                           marijuana = col_integer()))

popest <- read_csv("processed_data/popest.csv", 
                   col_types = cols(year = col_integer(), 
                                    total_population = col_integer(), 
                                    male_population = col_integer(), 
                                    female_population = col_integer(), 
                                    population_age_to_19 = col_integer(), 
                                    population_age_20_29 = col_integer(), 
                                    population_age_30_39 = col_integer(), 
                                    population_age_40_plus = col_integer()))

#create clean dataframe for the felonies
felony_marijuana <- ca_felony_category %>%
  mutate(type = "felony") %>%
  mutate(marijuana_arrests = marijuana) %>%
  select(year, marijuana_arrests, type) %>%
  filter(year >= 2000, year < 2020)

#create clean dataframe for the misdemeanors
misdem_marijuana <- ca_misdemeanors %>%
  filter(category == "Marijuana") %>%
  mutate(marijuana_arrests = total) %>%
  mutate(type = "misdemeanor") %>%
  select(year, marijuana_arrests, type) %>%
  filter(year >= 2000, year < 2020)

#create a total arrests dataframe
total_arrests <- felony_marijuana %>%
  left_join(misdem_marijuana, by = "year") %>%
  mutate(type = "all_arrests") %>%
  mutate(marijuana_arrests = marijuana_arrests.x + marijuana_arrests.y) %>%
  select(year, marijuana_arrests, type)

#bind all our data into a new dataframe, stacks the data on top of each other
combined_data <- bind_rows(felony_marijuana, misdem_marijuana, total_arrests)

#grab just the total CA population and 2000 - 2019
ca_pop <- popest %>%
  select(year, total_population) %>%
  filter(year >= 2000, year < 2020)

#add the population data into our combined dataframe
combined_data <- combined_data %>%
  left_join(ca_pop, by = "year")

#create a column with my per 100K rate of arrests
combined_data <- combined_data %>%
  mutate(mari_arrests_per_100K = round(marijuana_arrests / total_population * 100000, digits = 0))

glimpse(combined_data)

#create my static graphic
plot2 <- ggplot(combined_data, 
       aes(x = year,
           y = mari_arrests_per_100K,
           color = type,
           text = paste0("<b>Year: </b>", year,"<br>",
                         "<b>Arrests per 100K: </b>", prettyNum(mari_arrests_per_100K, big.mark = ",")),
           group = type
           )) +
  geom_point() +
  geom_line() +
  xlab("") +
  ylab("") +
  theme_minimal(base_size = 14, base_family = "Arial") +
  scale_color_brewer(name = "", palette = "Set1", labels = c("All Arrests", "Felony", "Misdemeanor")) +
  theme(legend.position = "top",
        panel.grid.major.x = element_blank(), # changed here so we can see y axis grid lines
        panel.grid.minor.x = element_blank() # makes chart easier to read
  ) +
  scale_x_continuous(breaks = c(2000, 2005, 2010, 2015, 2020)) +
  # scale_color_discrete(name = "", labels = c("All Arrests", "Felony", "Misdemeanor")) +
  geom_hline(yintercept = 0, size = 0.3) +
  ggtitle("California marijuana related arrests per 100K people") 

######################
#Let's create our interactive chart now
plot2_interact <- ggplotly(plot2, tooltip = "text") %>% 
  config(displayModeBar = FALSE) %>%
  layout(xaxis = list(fixedrange = TRUE),
         yaxis = list(fixedrange = TRUE),
         legend = list(orientation = "h",
                       y = 1.08))

#save our graphic
######NOTE: not working right now!!
saveWidget(plot2_interact, 
           "ca_arrests_per_cap.html", 
           selfcontained = TRUE, 
           libdir = NULL, background = "white")


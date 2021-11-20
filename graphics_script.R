# set working directory to the folder containing this script
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# load required packages
library(tidyverse)
library(ggplot2)
library(plotly)
library(htmlwidgets)
library(scales)

#prevent scientific notation
options(scipen=999)

# took your census key out of script

#read in csv's
mari_misdemeanor_total <- read_csv("./processed_data/ca_misdemeanor_category_age.csv")
mari_felony_total <- read_csv("./processed_data/ca_felony_category.csv")

#create dataframe with total number of misdemeanor marijuana arrests per year
mari_mis_per_year <- mari_misdemeanor_total %>%
  filter(category == "Marijuana") %>%
  mutate(group = "Marijuana") %>%
  select(total, year, group)

#create dataframe with total number of misdemeanor drug arrests per year NOT including marijuana
drug_mis_per_year <- mari_misdemeanor_total %>%
  filter(category == "Other drug") %>%
  mutate(group = "Other") %>%
  select(total, year, group)

#create dataframe with total number of felony marijuana arrests per year
mari_felony_per_year <- mari_felony_total %>%
  mutate(total = marijuana) %>%
  mutate(group = "Marijuana") %>%
  select(total, year, group)

#create dataframe with total number of felony drug arrests per year NOT including marijuana
drug_felon_per_year <- mari_felony_total %>%
  mutate(total = drug_offenses - marijuana) %>%
  mutate(group = "Other") %>%
  select(total, year, group)

#bind our dataframes so we have the totals for marijuana arrests and total drug offenses in one dataframe.
#Also, this pulls the data into the correct shape for the stacked bar chart in R. 
annual_totals <- bind_rows(mari_mis_per_year, drug_mis_per_year, mari_felony_per_year, drug_felon_per_year) %>%
  filter(year > 1999) %>%
  group_by(group,year) %>%
  summarize(total = sum(total)) %>%
  mutate(group = factor(group,
                        levels = c("Other","Marijuana")))

# view(annual_totals)

##########################
#Let's create our static stacked bar chart:
#here's the reference for the stacked bar chart: https://r-charts.com/part-whole/stacked-bar-chart-ggplot2/
#here's another reference for the chart: https://www.r-graph-gallery.com/48-grouped-barplot-with-ggplot2.html

#create our stacked bar graph
plot1 <- ggplot(annual_totals, 
                aes(x = year, 
                    y = total, 
                    fill = group,
                    # changed the tooltip because yours gave the total twice with the same number
                    text = paste0("<b>Year: </b>", year,"<br>",
                                  "<b>Arrests: </b>", prettyNum(total, big.mark = ",")) 
                    )) +
  xlab("") +
  ylab("") +
  geom_col(alpha = 0.7) + # some transparency to see grid lines (see below)
  # geom_bar(stat = "identity") + # geom_col can be used instead
  theme_minimal(base_size = 14, base_family = "Arial") +
  scale_fill_brewer(palette = "Set2", direction = -1,
                    name = "") +
  theme(legend.position = "top",
        panel.grid.major.x = element_blank(), # changed here so we can see y axis grid lines
        panel.grid.minor.x = element_blank() # makes chart easier to read
        ) +
  scale_y_continuous(breaks = c(100000, 200000, 300000), labels = comma) +
  geom_hline(yintercept = 0, size = 0.3) +
  ggtitle("California Drug Arrests") 

######################
#Let's create our interactive chart now
ggplotly(plot1, tooltip = "text") %>% 
  config(displayModeBar = FALSE) %>%
  layout(xaxis = list(fixedrange = TRUE),
         yaxis = list(fixedrange = TRUE),
         hovermode = "x", # this is what makes both tool tips appear at same point on x axis
         legend = list(orientation = "h",
                       y = 1.1))


  
  
  
  
  
  

# ########################################################################################
# #saving the below old code just in case I want to go back to it
# #this code create four different buckets -- separating misdemeanor and felony crimes
# #for marijuana vs. non marijuana drug crimes
# 
# 
# #create dataframe with total number of misdemeanor marijuana arrests per year
# mari_mis_per_year <- mari_misdemeanor_total %>%
#   filter(category == "Marijuana") %>%
#   mutate(group = c("total_marijuana_misdem")) %>%
#   select(total, year, group)
# 
# #create dataframe with total number of misdemeanor drug arrests per year NOT including marijuana
# drug_mis_per_year <- mari_misdemeanor_total %>%
#   filter(category == "Other drug") %>%
#   mutate(group = c("total_drug_misdem_no_mari")) %>%
#   select(total, year, group)
# 
# #create dataframe with total number of felony marijuana arrests per year
# mari_felony_per_year <- mari_felony_total %>%
#   mutate(total = marijuana) %>%
#   mutate(group = c("total_marijuana_felony")) %>%
#   select(total, year, group)
# 
# #create dataframe with total number of felony drug arrests per year NOT including marijuana
# drug_felon_per_year <- mari_felony_total %>%
#   mutate(total = drug_offenses - marijuana) %>%
#   mutate(group = c("total_drug_felony_no_mari")) %>%
#   select(total, year, group)
# 
# 
# 
# 
# ######################
# #saving the below old code just in case I want to go back to it
# 
# #create dataframe with total number of misdemeanor marijuana arrests per year
# mari_mis_per_year <- mari_misdemeanor_total %>%
#   filter(category == "Marijuana") %>%
#   mutate(total_marijuana_misdem = total) %>%
#   select(total_marijuana_misdem, year)
# 
# #create dataframe with total number of misdemeanor drug arrests per year NOT including marijuana
# drug_mis_per_year <- mari_misdemeanor_total %>%
#   filter(category == "Other drug") %>%
#   mutate(total_drug_misdem_no_mar = total) %>%
#   select(total_drug_misdem_no_mar, year)
# 
# #create dataframe with total number of felony marijuana arrests per year
# mari_felony_per_year <- mari_felony_total %>%
#   mutate(total_marijuana_felony = marijuana) %>%
#   select(total_marijuana_felony, year)
# 
# #create dataframe with total number of felony drug arrests per year NOT including marijuana
# drug_felon_per_year <- mari_felony_total %>%
#   mutate(total_drug_felony_no_mar = drug_offenses - marijuana) %>%
#   select(total_drug_felony_no_mar, year)
# 
# #join our dataframes so we have the totals for marijuana arrests and total drug offenses in one dataframe
# annual_totals <- mari_mis_per_year %>%
#   inner_join(drug_mis_per_year, by="year") %>%
#   inner_join(mari_felony_per_year, by="year") %>%
#   inner_join(drug_felon_per_year, by="year")
# 
# annual_totals <- mari_mis_per_year %>%
#   outer_join(drug_mis_per_year, by="group") %>%
#   inner_join(mari_felony_per_year, by="year") %>%
#   inner_join(drug_felon_per_year, by="year")
# 
# view(annual_totals)
  
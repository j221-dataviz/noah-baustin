# noah-baustin-final-project

***Project goal:***
The primary goal of this project is to analyze how marijuana arrests in California have changed over the past twenty years. Running from 2000 through 2020.

***Data sources:***
The arrest data in this project comes from the California Department of Justice. It draws from an annual report the department publishes called 'Crime in California.' All of those reports are published on the California DOJ website [here](https://oag.ca.gov/cjsc/pubs#crime).

This project will also utilize population data published by the US Census. Here is a US Census dataset covering state population demographics [2010-2019](https://www.census.gov/data/datasets/time-series/demo/popest/2010s-state-detail.html). Here are the state [intercensal datasets](https://www.census.gov/data/datasets/time-series/demo/popest/intercensal-2000-2010-state.html) for 2000-2010 from the US Census.

***Questions this project addresses:***
- What was the per capita number of marijuana felony and misdemeanor arrests in California from 2000 through 2020?
- What portion of the total drug crime arrests were marijuana crimes from 2000 through 2020?
- How have the age demographics of who was arrested for marijuana crimes changed over time 2000 to 2020?

***Methodology***
The raw data for this project is saved in the 'data' folder. There you can find the original_pdfs, which are the downloaded Crime in California reports. You'll also see edited_pdfs, which contains the trimmed down reports, containing only the tables used in this analysis. Finally, the population_data folder has the downloaded data from the US Census Bureau.

I used Tabula to extract the data from the edited pdfs into a .csv format. You can find those extractions in csv_exports.

Peter Aldhous wrote two R scripts that cleaned the raw arrest and population data. The resulting data is saved in processed_data, and those scripts are named data_processing.R and population.R.

The graphics_script.R file contains the data analysis for the California Drug Arrests graphic and also has the script for plotting that data into the plotly graphic you can see on the site.

The per_capita_arrests_graphic.R file contains the data analysis for the California marijuana arrests per 100K people graphic and also has the script for plotting that data into the plotly graphic you can see on the site.

The age_graphic.R file contains the data processing behind the CA marijuana arrests by age group graphic. That data was visualized using Datawrapper.

*** Data Key ***
For reference, here is a list of types of information that was pulled from the Crime in California reports, and the name of the corresponding table in the reports where you can find that data.

CA number of felony marijuana arrests:
FELONY ARRESTS
By Category and Offense

CA number of misdemeanor marijuana arrests:
MISDEMEANOR ARRESTS
Offense by Gender and Race/Ethnic Group of Arrestee

CA number of felony drug arrests:
FELONY ARRESTS
By Category and Offense

CA number of misdemeanor drug arrests:
MISDEMEANOR ARRESTS
By Offense for Adult and Juvenile Arrests

Age demographics of CA marijuana felony arrests:
FELONY ARRESTS
Offense by Age Group of Arrestee

Age demographics of CA marijuana misdemeanor arrests:
MISDEMEANOR ARRESTS
Category and Offense by Age Group of Arrestee

Racial demographics of CA marijuana felony arrests:
FELONY ARRESTS
Category and Offense by Gender and Race/Ethnic Group of Arrestee

Racial demographics of CA marijuana misdemeanor arrests:
MISDEMEANOR ARRESTS
Offense by Gender and Race/Ethnic Group of Arrestee




# Final Project Pitch

***Explain the goals of your project***
The primary goal of this project is to analyze how marijuana arrests in California have changed over the past thirty years.

***Detail the data sources you intend to use (include links or add data to a data folder in your repo, if your data is in files smaller than 100MB). Explain how you intend to search for data sources if you have not identified them.***
I intend to use data published by the California Department of Justice for this project. The data was published each year from 1997 through 2020 in a report called ‘Crime in California’. All of those reports are published on the California DOJ website [here](https://oag.ca.gov/cjsc/pubs#crime).

To extend the time period I’m looking at further back, I will use a publication called Report on Drug Arrests in California, from 1990 to 1999. This report was also published by the CA DOJ and can be found [here](https://oag.ca.gov/sites/all/files/agweb/pdfs/cjsc/publications/misc/drugarrests-full-report.pdf).

I’ll also need solid population data for this analysis that includes the age and race demographics of California from 1990 through 2020. Here is a US Census dataset covering state population demographics [2010-2019](https://www.census.gov/data/datasets/time-series/demo/popest/2010s-state-detail.html). Here are the state [intercensal datasets](https://www.census.gov/data/datasets/time-series/demo/popest/intercensal-2000-2010-state.html) for 2000-2010 from the US Census, and [here](https://www.census.gov/data/datasets/time-series/demo/popest/intercensal-1990-2000-state-and-county-characteristics.html) are the state and county intercensal datasets from 1990-2000. I’ll be curious to hear your feedback on whether or not these are the most accurate population estimates to use.

***Identify the questions you wish to address and building from these questions, provide an initial outline of how you intend to visualize the data, describing the charts/maps you are considering.***

- What was the per capita number of marijuana felony and misdemeanor arrests in California from 1990 through 2020?
	- Since this is a comparison over time, I think this data would best be displayed in a line chart. Likely with two lines, one for felony arrests and one for misdemeanor arrests. Possibly with a third line for total marijuana arrests (combo of the two).

- What portion of the total drug crime arrests were marijuana crimes from 1990 through 2020?
	- Likely: displaying felonies and misdemeanors separately, to show how marijuana crimes were increasingly prosecuted as misdemeanors as time went on.
	- Since this is both a part-to-whole analysis and a change over time analysis, I think the best chart to use would be a stacked column chart, displaying felony marijuana arrests, misdemeanor marijuana arrests, and total drug crime arrests.

- How have the age demographics of who was arrested for marijuana crimes changed over time 1990 to 2020?
	- I’ll want to adjust this to the changing age demographics of the state. So I’ll want to express the numbers in comparison to the total population of each age group in a given year.
	- Since I want to adjust this to population, this is a tricky one to display. Because I could do a simple area chart that would show the raw number of arrests for each age group over time. But that chart may end up just tracking the changing age demographics of the state. So I think this actually calls for a heat map. The actual information displayed would be how likely that age group was to get arrested compared with its portion of the general population. The heat map could use gradients of two different colors, one color expressing groups that were more likely to be arrested, and the other showing groups that were less likely. For example, if 18-29 year olds made up 20% of the population in a year but were 25% of the arrests, then they would be displayed as more likely to be arrested in that year. 

- How the racial demographics of who was arrested for marijuana crimes changed over time from 1990 to 2020?
	- I’ll want to adjust this to the changing racial demographics of the state. So I’ll want to express the numbers in comparison to the total population of each racial group in a given year.
	- For the same reasons I outlined in the age demographics section, I think a heat map would likely be the best way to display this information if I want to show all of it.
	- Another option could be to choose a specific racial group to display over time. I could then use a line graph, with positive numbers displaying where the group was disproportionately more likely to be arrested, and negatives for when they were disproportionately less likely to be arrested. If I wanted to be ambitious, I could also display that group’s likelihood to be arrested for any crime over time on the same graph, because I’ve heard anecdotally in my reporting that the racial inequities in marijuana arrests closely track the inequities of the entire criminal justice system. 

***Final Note***
I’ll be glad to hear your feedback on this pitch. As you can tell, there’s quite a few analyses related to this data that I’m interested in. However, it would be great to hear what you think is feasible within the scope of this class. I don’t want to bite off more than is reasonable for the semester.

Thanks.
Noah Baustin



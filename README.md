## Exploring War, Decolonization, & Factors of Independence 	
Within this repository are the data sources and R script for my project *Exploring War, Decolonization, & Factors of Independence*, the final project of a course in risk modeling for political science. All data sources are publically accessible. Contact me [here](https://github.com/weinsteinabi#contact-information) to discuss the project further. 

### Project Overview
This project, overseen by Professor Joseph Wright of Pennsylvania State University, was an exploration of the varying roles state-sanctioned violence played on the success of colonial independence movements. We asked whether or not war involvement of either the colony or imperial power in some capacity influenced instances of decolonization amongst those colonies. To do address this, we utilized a country-year dyad style dataset containing information for 120 countries from 1817 to 1989. These years were selected as the bookends for the age of "New Imperialism" and the eras that followed. This period is characterized by an exapansion of colonial efforts made by former colonies themselves before gradually giving way to the imperial motives of WWII and the Cold War. 

Using this data, we created three logistic regression models controlling for geographic and demographic factors that address three different aspects of war: war involvement of the occupied territory, the *type* of war engaged in, and war involvement of the imperial power. Models are evaluated using results from _k_-fold cross validation techniques. Model fit and accuracy is presented in the form of specificity, senesitivity, and AUC obtained from reciever operating characteristic (ROC) curve calculations. 

### Methodology
...


### Results
... 
insert images here!!


### R Script Navigation
All scripts for data cleaning can be found [here](https://github.com/weinsteinabi/war_decol/tree/main/scripts), in the scripts folder of the repository. Each is titled with the data they primarily work with.


### Data Sources
Below is a list of all data sources utilized in this project. Data files exist in this repository in the [data sources file](https://github.com/weinsteinabi/war_decol/tree/main/data_sources) for most sources. For those that are not (in italics), links will be included to the sources. 

- **Conflict Data**: obtained from the [Correlates of War Project](https://correlatesofwar.org/data-sets/cow-war/), specifically from their 2010 versions of data. Contains data from inter- (v.4.0), intra-(v.5.1), and extra-state (v.4.0) conflicts.
- **Colony Data**: pulled from two sources, the [Colonial Dates (COLDAT) Dataset](https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/T9SDEW) and Andreas Wimmer's ["From Empire to Nation-State" dataset](https://www.awimmer.com/data).
- ***Control Data***: obtained from the [Varieties of Democacy v15 complete dataset](https://v-dem.net/data/the-v-dem-dataset/country-year-v-dem-fullothers-v15/). 
- **Supplementary Population Data**: obtained from [World Population Review](https://worldpopulationreview.com/about), contained in three .csv files containing data for the years 1800, 1900, and 1989.
- ***Supplementary Geographic Data***: obtained from [public web sources](https://en.wikipedia.org/wiki/List_of_countries_and_dependencies_by_length_of_coastline) to supplement missing data from Wimmer's data. 

The **final** dataset is found separate from these files. 

### Sources
1) Coppedge et al. (2025). V-Dem [Country-Year/Country-Date] Dataset v15. Varieties of Democracy (V-Dem) Project. https://doi.org/10.23696/vdemds25. Accessed Nov. 15, 2025. 

2) Sarkees, Meredith Reid and Frank Wayman. (2010). Resort to War: 1816 – 2007. Washington DC: CQ Press. Accessed Nov. 27, 2025.

3) Becker, Bastian. (2019). Colonial Dates Dataset (COLDAT), https://doi.org/10.7910/DVN/T9SDEW. Harvard Dataverse, V3. Accessed Nov. 21, 2025. 

4) Wimmer, A., \& Min, B. (2006). From Empire to Nation-State: Explaining Wars in the Modern World, 1816-2001. American Sociological Review, 71(6), 867–897. http://www.jstor.org/stable/25472435. Accessed Nov. 15, 2025. 

5) Paine, L. (2020). Rediscovering the age of discovery. In Jowitt, C. (Ed.), The Routledge Companion to Marine and Maritime Worlds 1400-1800, 50-66. Routledge. 

6) The British North America Acts,	SC 1974-75-76, c 53. (1975)

7) Thomas, M. (2023). Grand Narratives: Decolonisation and Its Wars. War \& Society, 42(1), 60 - 71. https://doi.org/10.1080/07292473.2023.2150480.

8) Sarkees, M. (2010). The COW Typology of War: Defining and Categorizing Wars (Version 4 of the Data). Washington DC: CQ Press.

9) Mustafa, Z. (1971). The Principle of Self-Determination in International Law. The International Lawyer, 5(3), 479-487. https://www.jstor.org/stable/40704674

10) Fisch, J. (2015). The Cold War and the Second Decolonization, 1945–1989. In The Right of Self-Determination of Peoples: The Domestication of an Illusion. Cambridge University Press.

11) Munro, D.\& Zeisberger, C. (2011). Demographics: The Ratio of Revolution. Insead.

12) Goldstone, J. (2002). Population and Security: How Demographic Change Can Lead to Violent Conflict. Journal of International Affairs, 56(1), 3-21. https://www.jstor.org/stable/24357881

13) Goldstone, J. (2021). Population, rebellion and revolution. In A Research Agenda for Political Demography, 131–145.

14) Kratovic, A. (2010). Testing for the Domino Effect of Self-Determination Movements: Montenegro, Kosovo, and the Serb Republic.

15) Goldsmith, B. E., \& He, B. (2008). Letting Go without a Fight: Decolonization, Democracy and War, 1900-94. Journal of Peace Research, 45(5), 587–611. http://www.jstor.org/stable/27640735

16) Ravlo, H., Gleditsch, N. P., \& Dorussen, H. (2003). Colonial War and the Democratic Peace. Journal of Conflict Resolution, 47(4), 520-548. doi: 10.1177/0022002703254295.

17) Norbrook, Alexander. (2025). Exploiting Natural Resources in a Decolonizing World: Evidence, Sovereignty, and Development Discourses in the UN (1951–1962). The Princeton Historical Review, 10(2). 

18) Boswell, T. (1989). Colonial Empires and the Capitalist World-Economy: A Time Series Analysis of Colonization, 1640-1960. American Sociological Review, 54(2), 180–196. https://doi.org/10.2307/2095789

19) World Population Review. (2025). Population by Country in 1800. https://worldpopulationreview.com/country-rankings/population-by-country-in-1800 

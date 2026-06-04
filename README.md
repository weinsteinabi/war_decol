## Exploring War, Decolonization, & Factors of Independence 	
Within this repository are the data sources and R script for my project *Exploring War, Decolonization, & Factors of Independence*, the final project of a course in risk modeling for political science. All data sources are publically accessible. Contact me [here](https://github.com/weinsteinabi#contact-information) to discuss the project further. 

This project was completed December 15th, 2025. It was added to this profile June 4th, 2026. 

## Project Overview
This project, overseen by Professor Joseph Wright of Pennsylvania State University, was an exploration of the varying roles state-sanctioned violence played on the success of colonial independence movements. We asked whether or not war involvement of either the colony or imperial power in some capacity influenced instances of decolonization amongst those colonies. To do address this, we utilized a country-year style dataset containing information for 120 countries from 1817 to 1989. These years were selected as the bookends for the age of "New Imperialism" and the eras that followed. This period is characterized by an exapansion of colonial efforts made by former colonies themselves before gradually giving way to the imperial motives of WWII and the Cold War. 

Using this data, we created three logistic regression models controlling for geographic and demographic factors that address three different aspects of war: war involvement of the occupied territory, the *type* of war engaged in, and war involvement of the imperial power. Models are evaluated using results from _k_-fold cross validation techniques. Model fit and accuracy is presented in the form of specificity, senesitivity, and AUC obtained from reciever operating characteristic (ROC) curve calculations. 

## Methodology
These are the steps taken to complete this project
1) Because a number of datasets were synthesized to create our final dataset, a significant amount of cleaning had to be done prior to modeling. This includes the following: 
    - Ensuring uniform country names and country codes
    - Ensuring unifrom conflict names and conflict codes (a change in the coding system made this necessary to do manually
    - Transforming population and geographic measures into logged form, supplementing as needed
    - Creating a *lagyear* variable to associate control and war variables with
2) Once this was completed, data needed to be pivoted to exist at the country-year level. Conflict, colony, and control data was then merged on the country, year, lagyear, and country code to ensure consistency.
3) Observations that did not have an instance of being a colony during the specified time frame (1817-1989) were excluded from the dataset. 
4) Additional variables were created to be utilized in our models:
    - *warsum*: calculates the number of wars the imperial power was engaged in during the previous year
    - *war*: a flag that indicates colony participation in armed conflict during the previous year
    - *decolonization*: a flag that indicates decolonization events during the current year
5) Build the logistic regression models:
    - Model 1: identifies instances of decolonization using war engagment of occupied territory as the primary predictor, controlling for logged population and region metrics
    - Model 2: identifies instances of decolonization using the _type_ of conflcit engaged in as identified by the Correlates of War, controlling for logged population, region, and imperial power democracy level.
    - Model 3: identifies instances of decolonization using war engagment of the imperial power as the primary predictor, controlling for logged resources, population, and region. 
6) Conduct _k_-fold cross validation on each model and pull AUC values, as well as sensitivity and specificity based on the average occurance of a decolonization event

## Results
Outcomes of this project indicate fairly strong predictive power across all models, with average accuracy existing around 70% regardless of event occurance. More nuanced analysis indicates that Models 1 and 3 are mostly random when it comes to correctly predicting the occurance of decolonization event, while Model 2 was correct 75% of the time at the sample threshold utilized. Model fit, as evaluated by the AUC of the ROC curve, indicates the Model 2 is the best fitting of all models (AUC = .82). This is likely due to the inclusion of democracy metrics in the model. Further exploration should be done with this model to identify the scale of impact democracy metrics and war have on the decolonization events, as it is likely that both have prominent influences that are both being considered in the general outcome of the model. 

<p align="center">
  <img width="460" height="400" src="https://github.com/weinsteinabi/war_decol/blob/main/visuals/rocauc.png">
</p>

Future directions include further developing these models with a more stable theoretical base and examining coefficients of the models upon repeated training to identify scale of influence and significance to our dependent variable. 

## R Script Navigation
All scripts for data cleaning can be found [here](https://github.com/weinsteinabi/war_decol/tree/main/scripts), in the scripts folder of the repository. Each is titled with the data they primarily work with. Please note that these scripts are in the process of being refined for use beyond my own system. 

## Data Sources
Below is a list of all data sources utilized in this project. Data files exist in this repository in the [data sources file](https://github.com/weinsteinabi/war_decol/tree/main/data_sources) for most sources. For those that are not (in italics), links will be included to the sources. 

- **Conflict Data**: obtained from the [Correlates of War Project](https://correlatesofwar.org/data-sets/cow-war/), specifically from their 2010 versions of data. Contains data from inter- (v.4.0), intra-(v.5.1), and extra-state (v.4.0) conflicts.
- **Colony Data**: pulled from two sources, the [Colonial Dates (COLDAT) Dataset](https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/T9SDEW) and Andreas Wimmer's ["From Empire to Nation-State" dataset](https://www.awimmer.com/data).
- ***Control Data***: obtained from the [Varieties of Democacy v15 complete dataset](https://v-dem.net/data/the-v-dem-dataset/country-year-v-dem-fullothers-v15/). 
- **Supplementary Population Data**: obtained from [World Population Review](https://worldpopulationreview.com/about), contained in three .csv files containing data for the years 1800, 1900, and 1989.
- ***Supplementary Geographic Data***: obtained from [public web sources](https://en.wikipedia.org/wiki/List_of_countries_and_dependencies_by_length_of_coastline) to supplement missing data from Wimmer's data. 

The **final** dataset is found separate from these files. 

### Citations
1) Coppedge et al. (2025). V-Dem [Country-Year/Country-Date] Dataset v15. Varieties of Democracy (V-Dem) Project. https://doi.org/10.23696/vdemds25. Accessed Nov. 15, 2025. 

2) Sarkees, Meredith Reid and Frank Wayman. (2010). Resort to War: 1816 – 2007. Washington DC: CQ Press. Accessed Nov. 27, 2025.

3) Becker, Bastian. (2019). Colonial Dates Dataset (COLDAT), https://doi.org/10.7910/DVN/T9SDEW. Harvard Dataverse, V3. Accessed Nov. 21, 2025. 

4) Wimmer, A., \& Min, B. (2006). From Empire to Nation-State: Explaining Wars in the Modern World, 1816-2001. American Sociological Review, 71(6), 867–897. http://www.jstor.org/stable/25472435. Accessed Nov. 15, 2025. 

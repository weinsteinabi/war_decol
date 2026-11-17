#import libraries
library(readxl)
library(rvest)
library(xml2)
library(dplyr)
library(tidyverse)
library(countrycode)
library(tidyr)
library(R.utils)
library(reshape2)

#import data
url <- "https://en.wikipedia.org/wiki/List_of_countries_by_length_of_coastline"
page <- read_html(url)
tables <- page %>% html_nodes("table")
coastData <- tables[[1]] %>% 
  html_table(fill = TRUE)

url <- "https://en.wikipedia.org/wiki/List_of_elevation_extremes_by_country"
page <- read_html(url)
tables <- page %>% html_nodes("table")
mntData <- tables[[1]] %>% 
  html_table(fill = TRUE)

wimmerWar_full <- read_excel("data/WimmerMin1.0.xls")
vdem <- readRDS("data/V-Dem-CY-Full+Others-v15.rds")

rm(url, tables, page)
########################################################################################
#panel data for miscellaneous characteristics of colonies
#clean data - coastData
cd_col <- coastData[1, ]

#clean columns
colnames(coastData) <- cd_col
coastData <- coastData[, !duplicated(colnames(coastData))]

#select and rename columns
coastData <- coastData %>% dplyr::select(`Location`,`(CIA)`, `Land area(km2)`) %>% filter(Location != "Location")
colnames(coastData) <- c("country", "coastline", "land_area")

#note: possible removal of data - india = 11,098 (cd) 

#format columns
coastData$coastline <- as.numeric(sub(",", "", coastData$coastline))
coastData$land_area <- as.numeric(gsub(",", "", coastData$land_area))
coastData <- coastData %>% mutate(
  coastline = ifelse(country == "India", 11098, coastline)
)
coastData$lncoast <- log(coastData$coastline)
coastData$ln_area <- log(coastData$land_area)
coastData$lncoast[coastData$lncoast == -Inf] <- 0.0

#generate COWCODE
coastData$cowcode <- countrycode(coastData$country, "country.name", "cown")
coastData <- coastData %>% drop_na(cowcode)

#clean mountain data
mntData <- mntData %>% dplyr::select(`Country or region`, `Elevation span`)
colnames(mntData) <- c("country", "elevation")
mntData$elevation <- as.numeric(sub("([0-9]+).*", "\\1", mntData$elevation))
mntData <- mntData %>% mutate( 
  lnmtn = log(elevation/100), 
  lnmtn = ifelse(lnmtn < 0, 0, lnmtn)
)

mntData$cowcode <- countrycode(mntData$country, "country.name", "cown")
mntData <- mntData %>% drop_na(cowcode) %>% dplyr::select(-c(elevation))

#clean data - vdemCHAR - select and rename columns
vdem <- vdem %>% dplyr::select(country_name, COWcode, year, v2x_libdem, e_regionpol, 
                                  v2cagenmob, v2exl_legitideolcr_0, 
                                  v2exl_legitideolcr_3)

#fix names 
vdem$country_name[vdem$country_name == "Burma/Myanmar"] <- "Myanmar"
vdem$country_name[vdem$country_name == "The Gambia"] <- "Gambia"
vdem$country_name[vdem$country_name == "Serbia"] <- "Yugoslavia"
vdem$country_name[vdem$country_name == "Türkiye"] <- "Turkey"
vdem

vdem <- vdem %>% mutate(
  country_name = ifelse(country_name == "South Korea" & COWcode == 730, "Korea", country_name), 
  country_name = ifelse(country_name == "Austria" & COWcode == 300, "Austria-Hungary", country_name), 
  e_regionpol = ifelse(e_regionpol == 9 | e_regionpol == 6 | e_regionpol == 8, 7, e_regionpol), 
  e_regionpol = ifelse(e_regionpol == 10, 2, e_regionpol), 
  e_regionpol = ifelse(e_regionpol == 1, 5, e_regionpol))

colnames(vdem) <- c("country", "cowcode", "year", "demo_score", "region", "mobilization", 
                         "nationalist", "separatist")

#clean data - wimmerCHAR - select columns
wimmer_char <- wimmerWar_full %>% dplyr::select("year", "country", "cowcode", "lmtnest", "lnpop") 

#merge miscellaneous characteristics data
char_all <- full_join(vdem, wimmer_char, by = c("cowcode", "year", "country"))
char_all <- full_join(char_all, coastData, by = c("cowcode", "country"))
char_all <- full_join(char_all, mntData, by = c("cowcode", "country"))
char_all <- char_all %>% dplyr::select(-c("coastline", "land_area", "lmtnest")) %>% rename(lagyear = "year") %>% mutate(
  year = lagyear + 1)

char_all$country[char_all$country == "Myanmar"] <- "Myanmar (Burma)"

rm(vdem, wimmer_char, mntData, coastData, cd_col, wimmerWar_full)

#find more pop data 
pop1800 <- read_csv("data/population-by-country-in-1800.csv")
pop1800$cowcode <- countrycode(pop1800$country, "country.name", "cown")
pop1800 <- pop1800 %>% dplyr::select(-c(flagCode)) %>% filter(!is.na(cowcode))
pop1800 <- pop1800 %>% mutate(
  pop = PopulationIn1800/1000,
  lnpop = log(pop), 
  year = 1800
) %>% dplyr::select(-c(PopulationIn1800, pop))

pop1900 <- read_csv("data/population-by-country-in-1900.csv")
pop1900$cowcode <- countrycode(pop1900$country, "country.name", "cown")
pop1900 <- pop1900 %>% dplyr::select(-c(flagCode)) %>% filter(!is.na(cowcode))
pop1900 <- pop1900 %>% mutate(
  pop = PopulationIn1900/1000,
  lnpop = log(pop), 
  year = 1900
) %>% dplyr::select(-c(PopulationIn1900, pop))

popoldest <- char_all %>% dplyr::select(country, cowcode, lagyear, lnpop) %>% group_by(cowcode) %>% 
  filter(!is.na(lnpop)) %>% filter(lagyear == min(lagyear))
colnames(popoldest) <- c("country", "cowcode", "year", "lnpop")
popoldest <- popoldest %>% dplyr::select(country, cowcode, lnpop, year)

pop89 <- read_csv("data/population-by-country-in-1989.csv")
pop89$cowcode <- countrycode(pop89$country, "country.name", "cown")
pop89 <- pop89 %>% dplyr::select(-c(flagCode)) %>% filter(!is.na(cowcode))
pop89 <- pop89 %>% mutate(
  pop = `1989Population_1989`/1000,
  lnpop = log(pop), 
  year = 1989
) %>% dplyr::select(-c(`1989Population_1989`, pop))


#predicting in segments
pop <- rbind(pop1800, pop1900)
pop <- rbind(pop, popoldest)
pop <- pop %>% group_by(cowcode) %>% mutate(
  count = n()) %>% filter(count >= 3)


#predicting population data - 1815:1819
years_to_predict = 1815:1819
pred_pop <- pop %>% 
  group_by(cowcode) %>% 
  arrange(cowcode, year) %>% reframe(pred_pop = approx(x = year, y = lnpop, xout = 1815:1819)$y,  
            year = years_to_predict)
colnames(pred_pop) <- c("cowcode", "pred_pop1", "lagyear")

#predicting population data - 1815 - 1950
years_to_predict = 1815:1949
pred_pop_2 <- pop %>% group_by(cowcode) %>% 
  arrange(cowcode, year) %>% 
  reframe(pred_pop_2 = approx(x = year, y = lnpop, xout = 1815:1949)$y,  
            year = years_to_predict)
colnames(pred_pop_2) <- c("cowcode", "pred_pop2", "lagyear")

#predicting population data - n/a in data 
pop <- rbind(pop1800, pop1900)
pop <- rbind(pop, pop89)
pop <- pop %>% group_by(cowcode) %>% mutate(
  count = n()) %>% filter(count > 2)

years_to_predict = 1815:1989
pred_pop_3 <- pop %>% group_by(cowcode) %>% 
  arrange(cowcode, year) %>% 
  reframe(pred_pop_3 = approx(x = year, y = lnpop, xout = 1815:1989)$y,  
            year = years_to_predict)
colnames(pred_pop_3) <- c("cowcode", "pred_pop3", "lagyear")


yugopop <- char_all %>% filter(country == "Yugoslavia") %>% dplyr::select(c(cowcode, lagyear, lnpop))
pred <- lm(lnpop ~ lagyear, data = yugopop)
pred_years <- char_all %>% filter(country == "Yugoslavia") %>% filter(lagyear < 1820) %>% dplyr::select(c(cowcode, lagyear))
pred_years$lnpop2 <- predict(pred, newdata = pred_years)

population_estimates <- left_join(pred_pop_3, pred_pop_2)
population_estimates <- left_join(population_estimates, pred_pop)
population_estimates <- full_join(population_estimates, pred_years)


rm(pop, pop1800, pop1900, pop89, popoldest, pred_pop, pred_pop_2, pred_pop_3, years_to_predict, pred, pred_years, yugopop)

char_all <- char_all %>% mutate(
  country = ifelse(cowcode == 316, "Czech Republic", country), 
  country = ifelse(cowcode == 315, "Czechoslovakia", country)
)
char_all <- char_all %>% group_by(country) %>% mutate(
  ln_area = ifelse(country == "Yugoslavia", log(255400), ln_area), 
  lncoast = ifelse(country == "Yugoslavia", log(1873), lncoast),
  lnmtn = ifelse(country == "Yugoslavia", log(2864/100), lnmtn),
  demo_score = ifelse(country == "Austria-Hungary" & year == 1850, 0.53, demo_score), 
  demo_score = ifelse(country == "Austria-Hungary" & year >= 1861 & year <= 1872, .178, demo_score), 
  demo_score = ifelse(country == "Egypt" & year == 1866, 0.078, demo_score), 
  demo_score = ifelse(country == "Yugoslavia" & (year > 1931 & year < 1935), .067, demo_score), 
  demo_score = ifelse(country == "Czechoslovakia" & year == 1917, .283, demo_score), 
  region = ifelse(country == "Belize", 2, region)
) 

char_all <- char_all %>% group_by(cowcode) %>% distinct(year, .keep_all = TRUE)
#duplicate for colony and colonizer
colony_char <- char_all %>% dplyr::select(-c("demo_score"))
colony_char <- rename(colony_char, colony_cowcode = "cowcode")
colony_char <- colony_char %>% arrange(country, year)

colonizer_char <- char_all %>% dplyr::select("cowcode", "country", "year", "lagyear", "demo_score")
newCol <- c(colonizer_cowcode = "cowcode", colonizer = "country")
colonizer_char <- rename(colonizer_char, all_of(newCol))
colonizer_char <- colonizer_char %>% arrange(colonizer, year)


#save
write.csv(colonizer_char, "clean_data/colonizer_char.csv")
write.csv(colony_char, "clean_data/colony_char.csv")
write.csv(population_estimates, "clean_data/pop_est.csv")
#clean space
rm(newCol, char_all)

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

vdem_full <- readRDS("data/V-Dem-CY-Full+Others-v15.rds")

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

#format columns
coastData$coastline <- as.numeric(sub(",", "", coastData$coastline))
coastData$land_area <- as.numeric(gsub(",", "", coastData$land_area))
coastData$lncoast <- log(coastData$coastline)
coastData$ln_area <- log(coastData$land_area)
coastData$lncoast[coastData$lncoast == -Inf] <- 0.0

#generate COWCODE
coastData$cowcode <- countrycode(coastData$country, "country.name", "cown")
coastData <- coastData %>% drop_na(cowcode)

#clean mountain data
mtData <- mntData %>% dplyr::select(`Country or region`, `Elevation span`)
colnames(mtData) <- c("country", "elevation")
mtData$elevation <- as.numeric(sub("([0-9]+).*", "\\1", mtData$elevation))
mtData <- mtData %>% mutate( 
  lnmtn = log(elevation/100), 
  lnmtn = ifelse(lnmtn < 0, 0, lnmtn)
)

mtData$cowcode <- countrycode(mtData$country, "country.name", "cown")
mtData <- mtData %>% drop_na(cowcode) %>% dplyr::select(-c(elevation))

#clean data - vdemCHAR - select and rename columns

vdem_char <- vdem_full %>% dplyr::select(country_name, COWcode, year, v2x_libdem, e_regionpol, 
                                  v2cagenmob, v2exl_legitideolcr_0, 
                                  v2exl_legitideolcr_3)

#fix names 
vdem_char$country_name[vdem_char$country_name == "Burma/Myanmar"] <- "Myanmar"
vdem_char$country_name[vdem_char$country_name == "The Gambia"] <- "Gambia"
vdem_char$country_name[vdem_char$country_name == "Serbia"] <- "Yugoslavia"
vdem_char$country_name[vdem_char$country_name == "Türkiye"] <- "Turkey"

vdem_char <- vdem_char %>% mutate(
  country_name = ifelse(country_name == "South Korea" & COWcode == 730, "Korea", country_name), 
  country_name = ifelse(country_name == "Austria" & COWcode == 300, "Austria-Hungary", country_name), 
  v2x_libdem = ifelse(country_name == "Austria-Hungary" & year == 1850, 0.53, v2x_libdem), 
  v2x_libdem = ifelse(country_name == "Austria-Hungary" & year >= 1861 & year <= 1872, .178, v2x_libdem), 
  e_regionpol = ifelse(e_regionpol == 9 | e_regionpol == 6 | e_regionpol == 8, 7, e_regionpol), 
  e_regionpol = ifelse(e_regionpol == 10, 2, e_regionpol), 
  e_regionpol = ifelse(e_regionpol == 1, 5, e_regionpol)
)

colnames(vdem_char) <- c("country", "cowcode", "year", "demo_score", "region", "mobilization", 
                         "nationalist", "separatist")

#clean data - wimmerCHAR - select columns
wimmer_char <- wimmerWar_full %>% dplyr::select("year", "country", "cowcode", "lmtnest", "lnpop") 

#merge miscellaneous characteristics data
char_all <- full_join(vdem_char, wimmer_char, by = c("cowcode", "year", "country"))
char_all <- full_join(char_all, coastData, by = c("cowcode", "country"))
char_all <- full_join(char_all, mtData, by = c("cowcode", "country"))
char_all <- char_all %>% dplyr::select(-c("coastline", "land_area", "lmtnest")) %>% rename(lagyear = "year") %>% mutate(
  year = lagyear + 1)

char_all$country[char_all$country == "Myanmar"] <- "Myanmar (Burma)"
 
#duplicate for colony and colonizer
colony_char <- char_all %>% dplyr::select(-c("demo_score"))
colony_char <- rename(colony_char, colony_cowcode = "cowcode")
colony_char <- colony_char %>% group_by(colony_cowcode) %>% distinct(year, .keep_all = TRUE)
colony_char <- colony_char %>% arrange(country, year)

colonizer_char <- char_all %>% dplyr::select("cowcode", "country", "year", "lagyear", "demo_score")
newCol <- c(colonizer_cowcode = "cowcode", colonizer = "country")
colonizer_char <- rename(colonizer_char, all_of(newCol))
colonizer_char <- colonizer_char %>% group_by(colonizer_cowcode) %>% distinct(year, .keep_all = TRUE)
colonizer_char <- colonizer_char %>% arrange(colonizer, year)


#clean space
rm(cd_col, page, tables, vdem_char, wimmer_char, newCol, url, coastData, mntData, mtData)

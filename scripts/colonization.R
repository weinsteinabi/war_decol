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
wimmerWar_full <- read_excel("Data/WimmerMin1.0.xls")
colony_colonizer <- read_csv("Data/COLDAT_dyads.csv")

###############################################################################################
#panel data for colonies + colonizers
#clean data - colony-colonizer: note, only uses data from 8 European colonizers
#filter for ONLY colony rows, select one measure of year
colony_colonizer <- colony_colonizer %>% filter(colony_colonizer$col == 1)
colony_colonizer <- colony_colonizer %>% dplyr::select(country, colonizer, colstart_mean, colend_mean)

#format data where necessary
colony_colonizer$country[colony_colonizer$country == "Congo - Kinshasa"] <- "Congo, Democratic Republic of the"
colony_colonizer$country[colony_colonizer$country == "Congo - Brazzaville"] <- "Congo, Republic of the"
colony_colonizer$colonizer <- capitalize(colony_colonizer$colonizer)

#generate cowcodes
colony_colonizer$colony_cowcode <- countrycode(colony_colonizer$country, "country.name", "cown")
colony_colonizer$colonizer_cowcode <- countrycode(colony_colonizer$colonizer, "country.name", "cown")

#expand to year by year
pivot <- with(colony_colonizer, expand.grid(year = seq(min(colstart_mean), max(colend_mean)), id = colony_cowcode))
pivot <- rename(pivot, colony_cowcode = id)

colonies <- merge(colony_colonizer, pivot, by = "colony_cowcode")

#only include colonization years, sort
colonies <- colonies %>% filter((colonies$colstart_mean <= colonies$year))
colonies <- colonies %>% mutate(
  colonizer = case_when(
    year > colend_mean ~ NA, 
    year <= colend_mean ~ colonizer
  ),
  colonizer_cowcode = case_when(
    year > colend_mean ~ NA, 
    year <= colend_mean ~ colonizer_cowcode
  )
)
colonies <- colonies %>% arrange(country, year)

#clean data - wimmerWar_COLONY DATA:
#select only countries colonized
wimmerWarColonization <- wimmerWar_full %>% dplyr::select(year:country, imppower)

#rename columns 
wimmerWarColonization <- rename(wimmerWarColonization, colonizer = imppower)
wimmerWarColonization <- rename(wimmerWarColonization, colony_cowcode = cowcode)

#generate cowcodes
wimmerWarColonization$colonizer_cowcode <- countrycode(wimmerWarColonization$colonizer, "country.name", "cown")
wimmerWarColonization <- wimmerWarColonization %>% mutate(
  colonizer_cowcode = ifelse(colonizer == "MIXED RULE", 10000, colonizer_cowcode)
)


wimmerWarColonization <- wimmerWarColonization %>% 
  group_by(country, colonizer) %>% mutate(
    colstart_mean = case_when(
      is.na(colonizer) ~ NA,
      !is.na(colonizer) ~ min(year)), 
      colend_mean = case_when(
      is.na(colonizer) ~ NA, 
      !is.na(colonizer) ~ max(year)), 
    colonizer_cowcode = ifelse(colonizer == "Korea", 730, colonizer_cowcode)
    
  )

#merge and create colonies panel data (omg I did it yay)
colonies <- rbind(colonies, wimmerWarColonization)
colonies <- colonies %>% group_by(colony_cowcode, colonizer) %>% distinct(year, .keep_all = TRUE)

#reorder columns
colonies <- colonies %>% dplyr::select("colony_cowcode", "country", "year", "colonizer_cowcode", "colonizer", "colstart_mean", "colend_mean")

#notes: if up to it later, make colonizer names consistent. data still accurate due to CowCodes
colonies$colonizer <-  countrycode(colonies$colonizer_cowcode, "cown", "country.name")
colonies <- colonies %>% mutate(
  colonizer = ifelse(colonizer_cowcode == 10000, "MIXED RULE", colonizer), 
  colonizer = ifelse(colonizer_cowcode == 730, "Korea", colonizer), 
  colonizer = ifelse(colonizer_cowcode == 315, "Czechia", colonizer)
)


colonies <- colonies %>% group_by(colony_cowcode, colonizer_cowcode) %>% mutate(
  yrbeg = min(colstart_mean, na.rm = TRUE),
  yrend = max(colend_mean, na.rm = TRUE)
)

colonies <- colonies %>% dplyr::select(-c("colstart_mean", "colend_mean"))
colonies <- colonies %>% filter(year >= 1816)
colonies <- colonies %>% arrange(country, year)

colonies <- colonies %>% filter(!is.na(colonizer_cowcode) & year <= yrend)

colonies <- colonies %>% group_by(country) %>% mutate(
  yrbeg = ifelse(is.na(colonizer_cowcode), NA, yrbeg), 
  yrend = ifelse(is.na(colonizer_cowcode), NA, yrend)
)

colonies <- colonies %>% group_by(country) %>% filter(year >= min(yrbeg, na.rm = TRUE))
rm(pivot, wimmerWarColonization)

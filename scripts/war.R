#FINAL PROJECT LAB

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
cow_extra <- read_csv("Data/Extra-StateWarData_v4.0.csv")
cow_inter <- read_csv("Data/Inter-StateWarData_v4.0.csv")
cow_intra <- read_csv("Data/Intra-StateWarData_v4.1.csv")

#######################################################################################################
#War Panel

#COW data subsets - run this chunk separately! 
cow_extra <- cow_extra %>% dplyr::select("SideA", "ccode1", "WarName", "WarNum", "WarType", "StartYear1", "EndYear1")

cow_intra <- cow_intra %>% dplyr::select("SideA", "CcodeA", "SideB", "CcodeB", "WarName", "WarNum", "WarType", "StartYear1", "EndYear1") %>%
  filter(!is.na(CcodeA) & !is.na(CcodeB))
for (i in 1:nrow(cow_intra)){
  if (cow_intra$CcodeA[i] < 0) {
    cow_intra$SideA[i] <- cow_intra$SideB[i]
    cow_intra$CcodeA[i] <- cow_intra$CcodeB[i]}
}

#run this chunk separately! 

cow_intra <- cow_intra %>% dplyr::select(-c("SideB", "CcodeB"))

cow_inter <- cow_inter %>% dplyr::select("StateName", "ccode", "WarName",  "WarNum", "WarType","StartYear1", "EndYear1")

#rename as needed
colnames(cow_intra) <- c( "StateName", "ccode", "WarName",  "WarNum", "WarType","StartYear1", "EndYear1")
colnames(cow_extra) <- c("StateName", "ccode", "WarName",  "WarNum", "WarType", "StartYear1", "EndYear1")

#join and filter
cowWarAll <- rbind(cow_extra, cow_intra, cow_inter)
cowWarAll <- cowWarAll %>% filter(EndYear1 >= 0)
cowWarAll <- cowWarAll %>% filter(ccode > 0 )

#flag duplicates
cowWarAll$dupflag <- duplicated(cowWarAll[c("ccode", "WarNum")])
cowWarAll <- cowWarAll %>% group_by(ccode, WarNum) %>% mutate(
  yrbeg = min(StartYear1),
  yrend = max(EndYear1)
)

#drop duplicates
cowWarAll <- cowWarAll %>% dplyr::select(-c("StartYear1", "EndYear1")) %>% filter(dupflag != TRUE)
cowWarAll <- cowWarAll %>% dplyr::select(-c("dupflag"))

#rename columns
colnames(cowWarAll) <- c("country", "cowcode", "warname", "warno", "wartype", "yrbeg", "yrend")
cowWarAll <- cowWarAll %>% mutate(
  country = ifelse(cowcode == 315, "Czechia", country), 
  country = ifelse(cowcode == 640, "Turkey", country), 
  country = ifelse(cowcode == 300, "Austria-Hungary", country), 
  country = ifelse(cowcode == 345, "Yugoslavia", country), 
  country = ifelse(cowcode == 775, "Myanmar", country)
)

#expand into annual observations
pivot2 <- with(cowWarAll, expand.grid(year = seq(min(yrbeg), max(yrend)), id = cowcode))
pivot2 <- rename(pivot2, cowcode = id)

#clean wimmer war data
wimmerWar <- wimmerWar_full %>% dplyr::select("year", "country", "cowcode", "onset", 
                                          "war", "wartype", "warname","warno","yrbeg", "yrend")
#create main df 
war <- full_join(pivot2, wimmerWar, by = c("cowcode", "year"))
war <- war %>% filter(cowcode > 0)
war <- unique(war)


#rename war data
war <- war %>% mutate(
  country = ifelse(cowcode == 315, "Czechia", country), 
  country = ifelse(cowcode == 640, "Turkey", country), 
  country = ifelse(cowcode == 300, "Austria-Hungary", country), 
  country = ifelse(cowcode == 345, "Yugoslavia", country), 
  country = ifelse(cowcode == 775, "Myanmar", country)
)

#reassign war type var 1 (Inter), 2 (Extra), 3 (Intra)
war <- war %>% mutate(
  wartype = case_when(
    wartype == "INTER" ~ 1,
    wartype == "CONQ" ~ 2, 
    wartype == "CIVIL" ~ 3, 
    wartype == "NONIND" ~ 3, 
    wartype == "NATIND" ~ 3, 
  )
)

#add cowWar data to full df, filter as needed
war2 <- full_join(pivot2, cowWarAll, by = c("cowcode"))
war2 <- war2 %>% filter((war2$yrbeg <= war2$year) & (war2$yrend >= war2$year))
war2 <- war2 %>% filter(cowcode > 0)
war2 <- unique(war2)

#add necessary vars
war2 <- war2 %>% mutate(
  onset = case_when(
    yrbeg == year ~ 1,
    yrbeg != year ~ 0
  ), 
  war = 1, 
  wartype = case_when(
    wartype == 1 ~ 1, 
    wartype <= 3 ~ 2, 
    wartype > 3 ~ 3
  )
)

#fill in missing wars 
wars <- rbind(war, war2)
wars <- wars %>% group_by(cowcode, warno) %>% distinct(year, .keep_all = TRUE)
wars <- unique(wars)

#resolve inconsistencies
wars <- wars %>% group_by(cowcode, warno) %>% mutate(
  yrbeg = min(yrbeg),
  yrend = max(yrend), 
  onset = case_when(
    yrbeg == year ~ 1,
    yrbeg != year ~ 0
  ),
  war = ifelse(is.na(warname), 0, 1), 
  wartype = ifelse(is.na(wartype), 0, wartype), 
  onset = ifelse(is.na(onset), 0, onset)
)

#fill in missing data and flag duplicate rows
wars$country <- countrycode(wars$cowcode, "cown", "country.name")
wars <- wars %>% mutate(
  country = ifelse(cowcode == 730, "Korea", country), 
  country = ifelse(cowcode == 315, "Czechia", country), 
  country = ifelse(cowcode == 316, "Czech Republic", country))
wars <- wars %>% group_by(cowcode, year) %>% mutate(
  warsum = sum(war), 
  yeargr = n(), 
  drop = ifelse(yeargr > 1, ifelse(war == 0, 1, 0), 0)
)

#drop and organize data
wars <- wars %>% filter(drop == 0) %>% dplyr::select(-c("drop", "yeargr"))
wars <- wars %>% arrange(country, year)

#subset data - colonizer data
colonizer_wars <- wars %>% dplyr::select("cowcode", "country", "year", "warsum")
newCol <- c(colonizer_cowcode = "cowcode", colonizer = "country")
colonizer_wars <- rename(colonizer_wars, all_of(newCol))
colonizer_wars <- colonizer_wars %>% group_by(colonizer_cowcode) %>% 
  distinct(year, .keep_all = TRUE) %>% rename(lagyear = "year") %>% mutate(year = lagyear + 1)

#subset data - colony data
colony_wars <- wars %>% dplyr::select(-c("warsum"))
newCol <- c(colony_cowcode = "cowcode", war_begin = "yrbeg", war_end = "yrend")
colony_wars <- rename(colony_wars, newCol)

colony_wars <- colony_wars %>% group_by(country, year) %>% mutate(
  sum_war = sum(war), 
  warname = ifelse(sum_war > 1, paste(warname, collapse = "; "), warname)
)

colony_wars <- colony_wars %>% group_by(country, year, wartype) %>% mutate(
 count = n())
colony_wars <- colony_wars %>% group_by(country, year) %>% mutate(
  wartype2 = ifelse(!is.na(wartype) & count == max(count, na.rm = TRUE), wartype, 0), 
  wartype = ifelse(sum_war > 1 & count != sum_war, max(wartype2, na.rm = TRUE), wartype), 
  onset2 = ifelse(year == war_begin, 1, 0), 
  onset = ifelse(max(onset2) == 1, 1, 0),
  onset = ifelse(is.na(onset2), 0, onset), 
  warname = ifelse(is.na(warname), "-", warname)) %>% 
  distinct(warname, .keep_all = TRUE)
colony_wars <- colony_wars %>% dplyr::select(-c(wartype2, onset2, sum_war, count, war_begin, war_end, warno))

colony_wars <- colony_wars %>% rename(lagyear = "year") %>% mutate(year = lagyear + 1)
  
rm(wimmerWar, war, war2, pivot2, cowWarAll, cow_intra, cow_inter, cow_extra, newCol, i)

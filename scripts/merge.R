library(readxl)
library(rvest)
library(xml2)
library(dplyr)
library(tidyverse)
library(countrycode)
library(tidyr)
library(R.utils)
library(reshape2)
library(xts)



#load data
colonies <- read.csv("clean_data/colonies.csv")
colony_char <- read.csv("clean_data/colony_char.csv")
colonizer_char <- read.csv("clean_data/colonizer_char.csv")
colony_war <- read.csv("clean_data/colony_wars.csv")
colonizer_war <- read.csv("clean_data/colonizer_wars.csv")
pop_est <- read.csv("clean_data/pop_est.csv")

#remove extra vars
colonies <- colonies %>% dplyr::select(-c(`X`))
colony_char <- colony_char %>% dplyr::select(-c(`X`))
colonizer_char <- colonizer_char %>% dplyr::select(-c(`X`))
colony_war <- colony_war %>% dplyr::select(-c(`X`))
colonizer_war <- colonizer_war %>% dplyr::select(-c(`X`))
pop_est <- pop_est %>% dplyr::select(-c(`X`))

#data merge
# modify code if saved as different objects
#note: colony_char data is lagged or constant 
warcolony <- full_join(colonies, colony_char, by = c("year", "colony_cowcode", "country"))
warcolony <- warcolony %>% group_by(colony_cowcode) %>% mutate(
  region = replace_na(region, dplyr::first(region[!is.na(region)])), #const
  lnmtn = replace_na(lnmtn, dplyr::first(lnmtn[!is.na(lnmtn)])), #const
  lncoast = replace_na(lncoast, dplyr::first(lncoast[!is.na(lncoast)])), #const
  ln_area =  replace_na(ln_area, dplyr::first(ln_area[!is.na(ln_area)])), #const
  lagyear = ifelse(is.na(lagyear), year - 1, lagyear)
)
warcolony <- warcolony %>% group_by(colony_cowcode, year) %>% mutate(
  count = n()
) %>% ungroup()
warcolony <- warcolony %>% arrange(country, year)
warcolony <- warcolony %>% unique()

#population data
warcolony <- left_join(warcolony, pop_est, by = join_by(colony_cowcode == cowcode, lagyear == lagyear))
warcolony <- warcolony %>% mutate(
  lnpop = ifelse(is.na(lnpop) & lagyear < 1820, pred_pop1, lnpop), 
  lnpop = ifelse(is.na(lnpop) & lagyear < 1950, pred_pop2, lnpop), 
  lnpop = ifelse(is.na(lnpop), pred_pop3, lnpop), 
  lnpop = ifelse(is.na(lnpop) & colony_cowcode == 345, lnpop2, lnpop)
) %>% dplyr::select(-c(pred_pop1, pred_pop2, pred_pop3, lnpop2))

#for competing rule
warcolony <- warcolony %>% group_by(colony_cowcode, year) %>% mutate(
  count = n(),
  colonizer = ifelse(count > 1 & colonizer_cowcode[1] != colonizer_cowcode[2], "MIXED RULE", colonizer),
  colonizer_cowcode = ifelse(colonizer == "MIXED RULE", 10000, colonizer_cowcode), 
  yrend = ifelse(colonizer == "MIXED RULE", min(yrend), yrend), 
  yrbeg = ifelse(colonizer == "MIXED RULE", max(yrbeg), yrbeg)
)
warcolony <- warcolony %>% ungroup() %>% unique()

#introducing post-colonization observations
warcolony <- warcolony %>% group_by(colony_cowcode) %>% mutate(
  colonizer = ifelse(is.na(colonizer) & year == dplyr::first(yrend) + 1,  first(colonizer), colonizer),
  colonizer = ifelse(is.na(colonizer) & year == max(yrend, na.rm = TRUE) + 1, lag(colonizer), colonizer)) %>% filter(lagyear >= 1816)
warcolony$colonizer_cowcode <-  countrycode(warcolony$colonizer, "country.name", "cown")
warcolony <- warcolony %>% mutate(
  country = ifelse(colony_cowcode == 437, "Ivory Coast", country),
  colonizer_cowcode = ifelse(colonizer ==  "MIXED RULE", 10000, colonizer_cowcode), 
  colonizer_cowcode = ifelse(colonizer == "Korea", 730, colonizer_cowcode) #unified korea?
)

#drop duplicate years - removes possible overlap between recurrent colonies
warcolony <- warcolony %>% group_by(colony_cowcode) %>% mutate(
  colonizer_cowcode = ifelse(year == max(yrbeg, na.rm = TRUE) & year == yrend, NA, colonizer_cowcode)
)
warcolony <- warcolony %>% filter(!is.na(colonizer_cowcode)) %>% dplyr::select(-c(count))

#lagged democracy score of colonizer
warcolony <- left_join(warcolony, colonizer_char, by = c("colonizer", "year", "lagyear", "colonizer_cowcode"))
warcolony <- rename(warcolony, colonizer_demoscore = demo_score)
warcolony <- warcolony %>% mutate(
  colonizer_demoscore = ifelse(colonizer == "Korea" & year > 1905, .033, colonizer_demoscore), 
  
)
#lagged total wars of colonizer
warcolony <- left_join(warcolony, colonizer_war, by = c("colonizer", "year","lagyear", "colonizer_cowcode"))
warcolony <- rename(warcolony, colonizer_warsum = warsum)

#lagged war involvement of colony
warcolony <- left_join(warcolony, colony_war, by = c("country", "lagyear", "year", "colony_cowcode"))

#remove observations with no primary variable
warcolony <- warcolony %>% drop_na(war)

#flag whether or not variable is a colony
warcolony <- warcolony %>%  group_by(country, colonizer) %>% mutate(
  colony = ifelse(year > max(yrend, na.rm = TRUE), 0, 1))

warcolony <- warcolony %>%  group_by(country) %>% mutate(
  decolonized = case_when(
    year == (dplyr::first(yrend) + 1) & colony == 0 & year != max(yrbeg, na.rm = TRUE) ~ 1,
    year == (max(yrend, na.rm = TRUE) + 1) & colony == 0 ~ 1,
    colony == 1 ~ 0
  )
)
warcolony <- warcolony %>% filter(!(country == "Chad" & lagyear < 1889))
warcolony <- warcolony %>% filter(year >= 1816 & year <= 1991) %>% drop_na(decolonized) %>% 
  dplyr::select(-c(mobilization, nationalist, separatist)) #end date changed to maintain former soviet states independence events

warcolony <- warcolony %>% group_by(country) %>% distinct(year, .keep_all = TRUE)
warcolony <- warcolony[!duplicated(warcolony), ]

write.csv(warcolony, "warcolonyfinal.csv")
rm(colonies, colonizer_char, pop_est 
   colonizer_war, colony_char, colony_war)


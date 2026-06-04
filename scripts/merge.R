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

#data merge
# using objects created in war.R, controlchar.R, and colonization.R
# modify code if saved as different objects
#note: colony_char data is lagged or constant 
finalDraft <- full_join(colonies, colony_char, by = c("year", "colony_cowcode", "country"))
finalDraft <- finalDraft %>% group_by(colony_cowcode) %>% mutate(
  region = replace_na(region, dplyr::first(region[!is.na(region)])),
  lnmtn = replace_na(lnmtn, dplyr::first(lnmtn[!is.na(lnmtn)])),
  lncoast = replace_na(lncoast, dplyr::first(lncoast[!is.na(lncoast)])),
  ln_area =  replace_na(ln_area, dplyr::first(ln_area[!is.na(ln_area)]))
)

finalDraft <- finalDraft %>% arrange(country, year)
#all lagged vars are the PREVIOUS YEARS stats
finalDraft <- finalDraft %>% group_by(colony_cowcode) %>% mutate(
  colonizer = ifelse(is.na(colonizer) & year == dplyr::first(yrend) + 1,  first(colonizer), colonizer),
  colonizer = ifelse(is.na(colonizer) & year == max(yrend, na.rm = TRUE) + 1,  lag(colonizer), colonizer),
  lagyear = ifelse(is.na(lagyear), year - 1, lagyear)) %>% filter(lagyear >= 1816)
finalDraft$colonizer_cowcode <-  countrycode(finalDraft$colonizer, "country.name", "cown")
finalDraft <- finalDraft %>% mutate(
  colonizer_cowcode = ifelse(colonizer ==  "MIXED RULE", 10000, colonizer_cowcode), 
  colonizer_cowcode = ifelse(colonizer == "Korea", 730, colonizer_cowcode), 
  colonizer_cowcode = ifelse(colonizer == "Czechia", 315, colonizer_cowcode)
)
#drop duplicate years
finalDraft <- finalDraft %>% group_by(colony_cowcode) %>% mutate(
  colonizer_cowcode = ifelse(year == max(yrbeg, na.rm = TRUE) & year == yrend, NA, colonizer_cowcode)
)
finalDraft <- finalDraft %>% filter(!is.na(colonizer_cowcode))

#lagged democracy score
finalDraft <- left_join(finalDraft, colonizer_char, by = c("colonizer", "lagyear", "year", "colonizer_cowcode"))
finalDraft <- rename(finalDraft, colonizer_demoscore = demo_score)

#lagged total wars 
finalDraft <- left_join(finalDraft, colonizer_wars, by = c("colonizer", "lagyear", "year", "colonizer_cowcode"))
finalDraft <- rename(finalDraft, colonizer_warsum = warsum)

#lagged war involvement
finalDraft <- left_join(finalDraft, colony_wars, by = c("country", "lagyear", "year", "colony_cowcode"))
finalDraft <- finalDraft %>% drop_na(war)

#flag whether or not variable is a colony
finalDraft <- finalDraft %>%  group_by(country, colonizer) %>% mutate(
  colony = ifelse(year > max(yrend, na.rm = TRUE), 0, 1), 
  colonizersum = sum(colonizer_cowcode, na.rm = TRUE))
finalDraft <- finalDraft %>% filter(colonizersum > 0)
finalDraft <- finalDraft %>%  group_by(country) %>% mutate(
  decolonized = case_when(
    year == (first(yrend,na.rm = TRUE) + 1) & colony == 0 & year != max(yrbeg, na.rm = TRUE) ~ 1,
    year == (max(yrend, na.rm = TRUE) + 1) & colony == 0 ~ 1,
    colony == 1 ~ 0
  )
)

#fill in missing data
#region
finalDraft <- finalDraft %>% group_by(country) %>% mutate(
  region = ifelse(country == "Belize", 2, region), 
  ln_area = ifelse(country == "Yugoslavia", log(255400), ln_area), 
  lncoast = ifelse(country == "Yugoslavia", log(1873), lncoast),
  lnmtn = ifelse(country == "Yugoslavia", log(2864/100), lnmtn),
  colonizer_demoscore = ifelse(colonizer == "Egypt" & lagyear == 1866, 0.078, colonizer_demoscore), 
  colonizer_demoscore = ifelse(colonizer == "Korea" & lagyear > 1905, .033, colonizer_demoscore), 
  colonizer_demoscore = ifelse(colonizer == "Yugoslavia" & (lagyear > 1931 & lagyear < 1935), .067, colonizer_demoscore), 
  colonizer_demoscore = ifelse(colonizer == "Czechia" & lagyear == 1917, .283, colonizer_demoscore)
) %>% filter(!(country == "Chad" & lagyear < 1889))

#predicting population
#find more pop data 
pop1800 <- read_csv("Data/population-by-country-in-1800.csv")
pop1800$cowcode <- countrycode(pop1800$country, "country.name", "cown")
pop1800 <- pop1800 %>% dplyr::select(-c(flagCode)) %>% filter(!is.na(cowcode))
pop1800 <- pop1800 %>% mutate(
  pop = PopulationIn1800/1000,
  lnpop = log(pop), 
  year = 1800
) %>% dplyr::select(-c(PopulationIn1800, pop))

pop1900 <- read_csv("Data/population-by-country-in-1900.csv")
pop1900$cowcode <- countrycode(pop1900$country, "country.name", "cown")
pop1900 <- pop1900 %>% dplyr::select(-c(flagCode)) %>% filter(!is.na(cowcode))
pop1900 <- pop1900 %>% mutate(
  pop = PopulationIn1900/1000,
  lnpop = log(pop), 
  year = 1900
) %>% dplyr::select(-c(PopulationIn1900, pop))

popoldest <- finalDraft %>% dplyr::select(colony_cowcode, lagyear, lnpop) %>% group_by(colony_cowcode) %>% 
  filter(!is.na(lnpop)) %>% filter(lagyear == min(lagyear))
colnames(popoldest) <- c("country", "cowcode", "year", "lnpop")

pop89 <- read_csv("Data/population-by-country-in-1989.csv")
pop89$cowcode <- countrycode(pop89$country, "country.name", "cown")
pop89 <- pop89 %>% dplyr::select(-c(flagCode)) %>% filter(!is.na(cowcode))
pop89 <- pop89 %>% mutate(
  pop = `1989Population_1989`/1000,
  lnpop = log(pop), 
  year = 1989
) %>% dplyr::select(-c(`1989Population_1989`, pop))

pop <- rbind(pop1800, pop1900)
pop <- rbind(pop, popoldest)
pop <- pop %>% group_by(cowcode) %>% mutate(
  count = n()) %>% filter(count >= 3)


#predicting population data - 1815:1819
years_to_predict = 1815:1819
pred_pop <- pop %>% 
  group_by(cowcode) %>% 
  arrange(cowcode, year) %>% 
  summarise(pred_pop = approx(x = year, y = lnpop, xout = 1815:1819)$y,  
            year = years_to_predict)
colnames(pred_pop) <- c("colony_cowcode", "pred_pop", "lagyear")

#predicting population data - 1815 - 1950
years_to_predict = 1815:1949
pred_pop_2 <- pop %>% group_by(cowcode) %>% 
  arrange(cowcode, year) %>% 
  summarise(pred_pop = approx(x = year, y = lnpop, xout = 1815:1949)$y,  
            year = years_to_predict)
colnames(pred_pop_2) <- c("colony_cowcode", "pred_pop", "lagyear")

#predicting population data - n/a in data 
pop <- rbind(pop1800, pop1900)
pop <- rbind(pop, pop89)
pop <- pop %>% group_by(cowcode) %>% mutate(
  count = n()) %>% filter(count > 2)

years_to_predict = 1815:1989
pred_pop_3 <- pop %>% group_by(cowcode) %>% 
  arrange(cowcode, year) %>% 
  summarise(pred_pop_3 = approx(x = year, y = lnpop, xout = 1815:1989)$y,  
            year = years_to_predict)
colnames(pred_pop_3) <- c("colony_cowcode", "pred_pop", "lagyear")
  
#connect to dataframe
finalDraft <- left_join(finalDraft, pred_pop, by = c("colony_cowcode", "lagyear"))
finalDraft <- left_join(finalDraft, pred_pop_2, by = c("colony_cowcode", "lagyear"))
finalDraft <- left_join(finalDraft, pred_pop_3, by = c("colony_cowcode", "lagyear"))

finalDraft <- finalDraft %>% group_by(country) %>% mutate(
  lnpop = ifelse(is.na(lnpop) & lagyear < 1820, pred_pop.x, lnpop), 
  lnpop = ifelse(is.na(lnpop) & lagyear < 1950, pred_pop.y, lnpop), 
  lnpop = ifelse(is.na(lnpop), pred_pop, lnpop)
) %>% dplyr::select(-c(pred_pop.x, pred_pop.y, pred_pop))

#first five years of Yugoslavia
yugopop <- finalDraft %>% filter(country == "Yugoslavia") %>% dplyr::select(c(country, lagyear, lnpop))
pred <- lm(lnpop ~ lagyear, data = yugopop)
pred_years <- finalDraft %>% filter(country == "Yugoslavia") %>% filter(lagyear < 1820) %>% dplyr::select(c(country, lagyear))
pred_years$lnpop2 <- predict(pred, newdata = pred_years)

finalDraft <- left_join(finalDraft, pred_years, by = c("country", "lagyear"))
finalDraft <- finalDraft %>% group_by(country) %>% mutate(
  lnpop = ifelse(is.na(lnpop), lnpop2, lnpop)
) %>% dplyr::select(-c(lnpop2))

#pass to final dataframe
finalDraft <- finalDraft %>% filter(year >= 1816 & year <= 1989) %>% drop_na(decolonized) %>% 
  dplyr::select(-c(colonizersum, mobilization, nationalist, separatist))
finalDraft <- finalDraft %>% group_by(country) %>% distinct(year, .keep_all = TRUE)
final <- finalDraft[!duplicated(finalDraft), ]

write.csv(final, "C:\\Users\\abiwe\\OneDrive\\Desktop\\warcolonyfinal.csv")
rm(vdem_full, wimmerWar_full, finalDraft, final, colony_colonizer, char_all, colonies, colonizer_char, 
   colonizer_wars, colony_char, colony_wars, wars, pop, pop1800, pop1900, pop89, pred_pop, pred_pop_2, 
   pred_pop_3, popoldest, years_to_predict, pred_years, pred, yugopop)


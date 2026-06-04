library(psych)
library(readr)
library(kableExtra)
library(knitr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(tidyverse)

#data description
#NEED TO REWORK WITH NEW DATASET
#import data
warcolony <- read_csv("Data/warcolonyfinal.csv")
warcolony <- warcolony %>% dplyr::select(-c(...1))

#filter data 
warcolonysub <- warcolony %>% dplyr::select(colony_cowcode, year, decolonized, war, colonizer_warsum, wartype, 
                                            region, lncoast, lnmtn, colonizer_demoscore, lnpop)
warcolprim <- warcolony %>% dplyr::select(decolonized, war, colonizer_warsum, wartype, lagyear, colonizer_cowcode)

#create count table for vars - all
summarystats <- psych::describe(warcolony)
summarystats <- summarystats %>% dplyr::select(n)
sum <- summarystats %>% mutate(
  across(n, ~ format(.x, big.mark = ","))) %>%
  kable(
    caption = "Non-Missing Observations") %>% 
  kable_classic()
sum

#create summary statistics table - primary variables
summarystats <- psych::describe(warcolonysub)
summarystats <- summarystats %>% mutate(
   var = rownames(summarystats), 
   rownum = row_number()
)
summarystats <- summarystats %>% select(var, n, mean, min, max, sd, rownum)
summarystats <- summarystats %>% rowwise() %>% 
  mutate(across(n:sd,~ case_when(
    rownum == 1 | rownum == 2 | rownum == 7  ~ round(.x, 0), 
    rownum != 1 & rownum != 2 & rownum != 7 ~ round(.x, 2)
  ))) %>% select(-c(rownum))
sum <- summarystats %>% mutate(
  across(n, ~ format(.x, big.mark = ","))) %>%
  kable(
    col.names = c(" ", "count", "mean", "min", "max", "std. dev."), 
    caption = "Summary Statistics for Primary Variables",
    digit = 2) %>% 
  kable_classic()
sum

#create summary statistics table - outcome and predictors
summarystats <- psych::describe(warcolprim)
summarystats <- summarystats %>% dplyr::select(n) %>% mutate(
  var = rownames(summarystats)) %>% filter(var != "lagyear")

pos_events <- warcolprim %>% dplyr::select(-c(lagyear)) %>% mutate(
  decolonized = sum(decolonized != 0), 
  war = sum(war != 0), 
  colonizer_warsum = sum(colonizer_warsum != 0, na.rm = TRUE), 
  wartype = sum(wartype != 0))  %>% 
  pivot_longer(decolonized:wartype, names_to = "var", values_to = "count") 
pos_events <- pos_events %>% filter(!duplicated(pos_events))

summarystats <- left_join(summarystats, pos_events) %>% dplyr::select(c(var, n, count))
sum <- summarystats %>% mutate(
  mean = count/n,
  across(n, ~ format(.x, big.mark = ",")), 
  across(count, ~ format(.x, big.mark = ","))) %>%
  kable(
    col.names = c(" ", "total count", "count", "mean"),
    caption = "Outcome and Predictor Means", 
    digit = 4) %>% 
  kable_classic()
sum                                                              
                                                               
#temporal plot of colonies (DV) and wars (IV) over time 
#partition and pivot data
decol <- warcolprim %>% group_by(lagyear) %>% mutate(
  decolonized = sum(decolonized), 
  war = sum(war), 
  colonizer_warsum = sum(colonizer_warsum != 0, na.rm = TRUE))
  
decol <- decol %>% pivot_longer(cols = decolonized:colonizer_warsum,
                                    names_to = "variable", values_to = "value")
decol1 <- decol %>% filter(variable != "colonizer_warsum")
decol2 <- decol %>% filter(variable != "war")
#generate plot - Colony War
fig1 <- ggplot(decol1, aes(x = lagyear, y = value, color = variable)) + geom_line(linewidth = 1) + 
  stat_smooth(method = "loess", linewidth = .5) +
  labs(
    title = "Trends in Instances of Decolonization and War",
    subtitle = "Colonies at War",
    x = "Year (1817 - 1989)",
    y = "Annual Number of Events",
    color = "Legend") + 
    scale_color_manual(labels = c("Decolonization", "Colony War"), values =c("#b27372", "#91c0ce")) + 
    scale_x_continuous(limits = c(1815, 1990), n.breaks = 10) + 
    scale_y_continuous(limits = c(-.5, 20), breaks = c(0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20)) + 
    theme_minimal() + 
    theme(
      plot.title = element_text(hjust = 0.5),
      plot.subtitle = element_text(hjust = 0.5),
      legend.position = "top"                  
    )
fig1

#generate plot - Colonizer War
fig2 <- ggplot(decol2, aes(x = lagyear, y = value, color = variable)) + geom_line(linewidth = 1) + 
  stat_smooth(method = "loess", linewidth = .5) +
  labs(
    title = "Trends in Instances of Decolonization and War",
    subtitle = "Colonizers at War", 
    x = "Year (1817 - 1989)",
    y = "Annual Number of Events",
    color = "Legend") + 
  scale_color_manual(labels = c("Colonizer War", "Decolonization"),values = c("#0e8474","#b27372")) + 
  scale_x_continuous(limits = c(1815, 1990), n.breaks = 10) + 
  scale_y_continuous(limits = c(-.5, 90), n.breaks = 10) + 
  theme_minimal() + 
  theme(
    plot.title = element_text(hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5),
    legend.position = "top"                  
  )
fig2

#within and between variation - colony independence
between_colony <- warcolony %>% group_by(colony_cowcode) %>% 
  summarize(independence = mean(decolonized, na.rm = TRUE), .groups = "drop")
sd_between <- sd(between_colony$independence, na.rm = TRUE) #between groups st. dev.

within_colony <- warcolony %>% group_by(colony_cowcode) %>% 
  mutate(independence = decolonized - mean(decolonized, na.rm = TRUE)) %>% 
  pull(independence)
sd_within <- sd(within_colony, na.rm = TRUE)

ratio <- sd_within/(sd_between + sd_within) # ratio =  .53875 

#save values
warcolvar <- data.frame(var = c("Ratio", "Within-Group Variance", "Between-Group Variance"), 
                        colony = c(ratio, sd_within, sd_between))

between_colony <- warcolony %>% group_by(colony_cowcode) %>% 
  summarize(war = mean(war, na.rm = TRUE), .groups = "drop")
sd_between <- sd(between_colony$war, na.rm = TRUE) #between groups st. dev.

within_colony <- warcolony %>% group_by(colony_cowcode) %>% 
  mutate(war = war - mean(war, na.rm = TRUE)) %>% 
  pull(war)
sd_within <- sd(within_colony, na.rm = TRUE)

ratio <- sd_within/(sd_between + sd_within) # ratio =  .53875 
warcolvar$war <- c(ratio, sd_within, sd_between)


between_colony <- warcolony %>% group_by(colony_cowcode) %>% 
  summarize(colonizerwar = mean(colonizer_warsum, na.rm = TRUE), .groups = "drop")
sd_between <- sd(between_colony$colonizerwar, na.rm = TRUE) #between groups st. dev.

within_colony <- warcolony %>% group_by(colony_cowcode) %>% 
  mutate(coloinzerwar = colonizer_warsum - mean(colonizer_warsum, na.rm = TRUE)) %>% 
  pull(war)
sd_within <- sd(within_colony, na.rm = TRUE)

ratio <- sd_within/(sd_between + sd_within) # ratio =  .53875 
warcolvar$colonizerwar <- c(ratio, sd_within, sd_between)


warcolvartable <- warcolvar %>% kable(
  col.names = c(" ", "Decolonization", "Colony War", "Colonizer War"), 
  caption = "Outcome and Predictor Variation", 
  digit = 4
) %>% kable_classic()
warcolvartable

rm(decol, decol1, decol2, fig1, fig2, summarystats, sum, between_colony, within_colony, sd_between, 
   sd_within, ratio, pos_events, warcolonysub, warcolprim, warcolvartable, warcolvar)

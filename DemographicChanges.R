library(dplyr)
library(tidyverse)
library(ggplot2)
library(gganimate)
library(ggrepel)

library(rworldmap)
library(rgeos)
library(RColorBrewer)
library(rstudioapi)
library(knitr)



BirthRate <- read.csv("/Users/kdm/programowanie w R/demographicChanges_project/data/birthRateCrudo.csv", 
                      stringsAsFactors = F)
DeathRate <- read.csv("/Users/kdm/programowanie w R/demographicChanges_project/data/death_rateCrudo.csv",
                      stringsAsFactors = F)
FertRateTot <- read.csv("/Users/kdm/programowanie w R/demographicChanges_project/data/fertilityRateTotal.csv",
                        stringsAsFactors = F)
LaborForceTot <- read.csv("/Users/kdm/programowanie w R/demographicChanges_project/data/LaborForceTotal.csv",
                          stringsAsFactors = F)
PopTot <- read.csv( "/Users/kdm/programowanie w R/demographicChanges_project/data/populationTotal.csv",
                    stringsAsFactors = F)

#The Highest Fertility Rate in the World in 2019
HighFertRat <- FertRateTot %>%
  filter(X2019 == max(X2019, na.rm = T)) %>%
  select(Country.Name, X2019) %>%
  mutate(hfr = round(X2019,1))

#The Lowest Fertility Rate in the World in 2019
LowFertRat <- FertRateTot %>%
  filter(X2019 == min(X2019, na.rm = T)) %>%
  select(Country.Name, X2019) %>%
  mutate(lfr = round(X2019,1))

#The Top 10 Countries with The Highest Fertility Rate and FR difference declining from 1960 to 2019
top_10_hfr <- FertRateTot %>%
  mutate(gain = X2019 - X1960) %>%
  top_n(10, wt = gain) %>%
  arrange(-gain) %>%
  mutate(gain_str = paste(format(round(gain, 1)), "births per woman")) %>%
  select(Country.Name, gain_str)
 
#world map & the Fertility Rate in 2019 (first att)
comb_data_map_fr <- joinCountryData2Map(
  FertRateTot,
  joinCode = "ISO3",
  nameJoinColumn = "Country.Code",
  mapResolution = "high"
)


##Death Rate
#The Highest Death Rate in the World in 2019
HighDeathRat <- DeathRate %>%
  filter(X2019 == max(X2019, na.rm = T)) %>%
  select(Country.Name, X2019) %>%
  mutate(hdr = round(X2019,1))

#The Lowest Death Rate in the World in 2019
LowDeathRat <- DeathRate %>%
  filter(X2019 == min(X2019, na.rm = T)) %>%
  select(Country.Name, X2019) %>%
  mutate(ldr = round(X2019,1))

#The Top 10 Countries with The Highest Death Rate and DR difference declining from 1960 to 2019
top_10_hdr <- DeathRate %>%
  mutate(gain = X2019 - X1960) %>%
  top_n(10, wt = gain) %>%
  arrange(-gain) %>%
  mutate(gain_str = paste(format(round(gain, 1)), "crude (per 1000 people)")) %>%
  select(Country.Name, gain_str)

#world map & the Death Rate in 2019 (first att)
comb_data_map_dr <- joinCountryData2Map(
  DeathRate,
  joinCode = "ISO3",
  nameJoinColumn = "Country.Code",
  mapResolution = "high"
)

##Birth Rate
#The Highest Birth Rate in the World in 2019
HighBirthRat <- BirthRate %>%
  filter(X2019 == max(X2019, na.rm = T)) %>%
  select(Country.Name, X2019) %>%
  mutate(hbr = round(X2019,1))

#The Lowest Birth Rate in the World in 2019
LowBirthRat <- BirthRate %>%
  filter(X2019 == min(X2019, na.rm = T)) %>%
  select(Country.Name, X2019) %>%
  mutate(lbr = round(X2019,1))

#The Top 10 Countries with The Highest Birth Rate and BR difference declining from 1960 to 2019
top_10_hbr <- BirthRate %>%
  mutate(gain = X2019 - X1960) %>%
  top_n(10, wt = gain) %>%
  arrange(-gain) %>%
  mutate(gain_str = paste(format(round(gain, 1)), "crude (per 1000 people)")) %>%
  select(Country.Name, gain_str)

#world map & the Birth Rate in 2019 
comb_data_map_br <- joinCountryData2Map(
  BirthRate,
  joinCode = "ISO3",
  nameJoinColumn = "Country.Code",
  mapResolution = "high"
)


##Life Expectation
#The Highest Life Expectation in the World in 2019
HighLifeExpect <- LifeExpect %>%
  filter(X2019 == max(X2019, na.rm = T)) %>%
  select(Country.Name, X2019) %>%
  mutate(hle = round(X2019,1))

#The Lowest High Expectation in the World in 2019
LowLifeExpect <- LifeExpect %>%
  filter(X2019 == min(X2019, na.rm = T)) %>%
  select(Country.Name, X2019) %>%
  mutate(lle = round(X2019,1))

#The Top 10 Countries with the Largest Life Expectancy gains since 1960 to 2019
top_10_hleg <- LifeExpect %>%
  mutate(gain = X2019 - X1960) %>%
  top_n(10, wt = gain) %>%
  arrange(-gain) %>%
  mutate(gain_str = paste(format(round(gain, 1)), "total (years)")) %>%
  select(Country.Name, gain_str)

#world map & the Life Expectation in 2019 
comb_data_map_le <- joinCountryData2Map(
  LifeExpect,
  joinCode = "ISO3",
  nameJoinColumn = "Country.Code",
  mapResolution = "high"
)


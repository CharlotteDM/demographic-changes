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
LifeExpect <- read.csv("/Users/kdm/programowanie w R/demographicChanges_project/data/LifeExpectancyTotal.csv",
                       stringsAsFactors = F)
ContracFem <- read.csv("/Users/kdm/programowanie w R/demographicChanges_project/data/contraceptive.csv",
                    stringsAsFactors = F,
                    skip = 4)
LaborFem <- read.csv("/Users/kdm/programowanie w R/demographicChanges_project/data/laborFem.csv",
                     stringsAsFactors = F,
                     skip = 4)


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


#filters data from EU countries
#filter data from EU
EU_FertRateTot <- filter (FertRateTot, Country.Code == "POL" | Country.Code == "AUT" |
                Country.Code == "BEL" | Country.Code == "BGR" | Country.Code == "HRV" |
                Country.Code == "CYP" |
                Country.Code == "CZE" | Country.Code == "DNK" | Country.Code == "EST" |
                Country.Code == "FIN" | Country.Code == "FRA" | Country.Code == "GRC" |
                Country.Code == "ESP" | Country.Code == "NLD" | Country.Code == "IRL" |
                Country.Code == "LTU" | Country.Code == "LUX" | Country.Code == "LVA" |
                Country.Code == "MLT" | Country.Code == "DEU" | Country.Code == "PRT" |
                Country.Code == "ROU" | Country.Code == "SVK" | Country.Code == "SVN" |
                Country.Code == "SWE" | Country.Code == "HUN" | 
                Country.Code == "ITA")

#The Highest Fertility Rate in the EU in 2019
EU_HighFertRat <- EU_FertRateTot %>%
  filter(X2019 == max(X2019, na.rm = T)) %>%
  select(Country.Name, X2019) %>%
  mutate(eu_hfr = round(X2019,1))

#The Lowest Fertility Rate in the World in 2019
EU_LowFertRat <- EU_FertRateTot %>%
  filter(X2019 == min(X2019, na.rm = T)) %>%
  select(Country.Name, X2019) %>%
  mutate(eu_lfr = round(X2019,1))

#map FR in EU countries in 2019
comb_data_map_eu_fr <- joinCountryData2Map(
  EU_FertRateTot,
  joinCode = "ISO3",
  nameJoinColumn = "Country.Code",
  mapResolution = "high"
)

#chart: EU countries & Fertility Rate in 2019 
EU_FR <- ggplot(data = EU_FertRateTot) + geom_col(aes(x = reorder(Country.Name, X2019), y = X2019, fill = X2019)) + 
  scale_fill_gradient(low="lightblue", high="red") +
  coord_flip() +
  theme_light() +
  labs(
    title = "Fertility rate in EU in 2019",
    subtitle = "(births per woman)",
    caption = "(based on data from: https://data.worldbank.org/indicator/SP.DYN.TFRT.IN)",
    x = "EU Country",
    y = "Fertility rate") +
  theme(
    plot.title = element_text(color="royalblue4", size=14, face="bold"),
    axis.title.x = element_text(color="steelblue2", size=14, face="bold"),
    axis.title.y = element_text(color="steelblue2", size=14, face="bold"),
    legend.position = "none") 

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


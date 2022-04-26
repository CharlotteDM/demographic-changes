library("dplyr")
library("tidyverse")
library("ggplot2")
library(gganimate)
library(ggrepel)
library("rworldmap")
library(rgeos)
library("RColorBrewer")
library(rstudioapi)
library("knitr")
library("plotly")
library("htmlwidgets")
library("GGally")

#install.packages("Hmisc")
#library("Hmisc")
#install.packages("ggstatsplot")
#library("ggstatsplot")

BirthRate <- read.csv("/Users/kdm/programowanie w R/demographicChanges_project/data/birthRateCrudo.csv", 
                      stringsAsFactors = F)
DeathRate <- read.csv("/Users/kdm/programowanie w R/demographicChanges_project/data/death_rateCrudo.csv",
                      stringsAsFactors = F)
FertRateTot <- read.csv("/Users/kdm/programowanie w R/demographicChanges_project/data/fertilityRateTotal.csv",
                        stringsAsFactors = F)
LifeExpect <- read.csv("/Users/kdm/programowanie w R/demographicChanges_project/data/LifeExpectancyTotal.csv",
                       stringsAsFactors = F)
LaborFem <- read.csv("/Users/kdm/programowanie w R/demographicChanges_project/data/laborFem.csv",
                     stringsAsFactors = F,
                     skip = 4)
AgeWom <- read.csv("/Users/kdm/programowanie w R/demographicChanges_project/data/AgeWomFirstChild.csv",
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

### Mean age of women at birth of first child - preparing df
MeanAgeWom <- select(AgeWom, indic_de:OBS_VALUE) 
MeanAgeWom2019 <- filter(MeanAgeWom, 
                     indic_de=="AGEMOTH1",
                     TIME_PERIOD==2019)
# Mean age of women at birth of first child - replacing country code
MeanAgeWom2019[MeanAgeWom2019 == "BE"] <- "BEL"
MeanAgeWom2019[MeanAgeWom2019 == "BG"] <- "BGR"
MeanAgeWom2019[MeanAgeWom2019 == "CZ"] <- "CZE"
MeanAgeWom2019[MeanAgeWom2019 == "DK"] <- "DNK"
MeanAgeWom2019[MeanAgeWom2019 == "DE"] <- "DEU"
MeanAgeWom2019[MeanAgeWom2019 == "EE"] <- "EST"
MeanAgeWom2019[MeanAgeWom2019 == "EL"] <- "GRC"
MeanAgeWom2019[MeanAgeWom2019 == "ES"] <- "ESP"
MeanAgeWom2019[MeanAgeWom2019 == "FR"] <- "FRA"
MeanAgeWom2019[MeanAgeWom2019 == "HR"] <- "HRV"
MeanAgeWom2019[MeanAgeWom2019 == "IT"] <- "ITA"
MeanAgeWom2019[MeanAgeWom2019 == "CY"] <- "CYP"
MeanAgeWom2019[MeanAgeWom2019 == "LV"] <- "LVA"
MeanAgeWom2019[MeanAgeWom2019 == "LT"] <- "LTU"
MeanAgeWom2019[MeanAgeWom2019 == "LU"] <- "LUX"
MeanAgeWom2019[MeanAgeWom2019 == "HU"] <- "HUN"
MeanAgeWom2019[MeanAgeWom2019 == "MT"] <- "MLT"
MeanAgeWom2019[MeanAgeWom2019 == "NL"] <- "NLD"
MeanAgeWom2019[MeanAgeWom2019 == "AT"] <- "AUT"
MeanAgeWom2019[MeanAgeWom2019 == "PL"] <- "POL"
MeanAgeWom2019[MeanAgeWom2019 == "PT"] <- "PRT"
MeanAgeWom2019[MeanAgeWom2019 == "RO"] <- "ROU"
MeanAgeWom2019[MeanAgeWom2019 == "SI"] <- "SVN"
MeanAgeWom2019[MeanAgeWom2019 == "SK"] <- "SVK"
MeanAgeWom2019[MeanAgeWom2019 == "FI"] <- "FIN"
MeanAgeWom2019[MeanAgeWom2019 == "SE"] <- "SWE"
MeanAgeWom2019[MeanAgeWom2019 == "IE"] <- "IRL"

# Mean age of women at birth of first child - removing other countries and some other records
MeanAgeWom2019 <- MeanAgeWom2019[-c(1, 2, 4, 7, 12, 13, 17, 20, 24, 29, 32, 36, 40:42), ]

# Mean age of women at birth of first child - renaming column's name
MeanAgeWom2019 <- MeanAgeWom2019 %>% rename(Country.Code = geo)

# Mean age of women at birth of first child - joining df's
comb_data_agewom_fr <- left_join(EU_FertRateTot, MeanAgeWom2019, by = "Country.Code")

# Mean age of women at birth of first child & fertility rate - correlation
cor(comb_data_agewom_fr$X2019, comb_data_agewom_fr$OBS_VALUE, use = "complete.obs")

# Mean age of women at birth of first child & fertility rate - chart
ggFR <- ggplot(data = comb_data_agewom_fr) +
  geom_text(mapping = aes(x = X2019, y = OBS_VALUE, label = Country.Code)) +
  theme_light() +
  labs(
    title = "Fertility rate & mean age of woman at birth of first child",
    subtitle = "in EU countries in 2019",
    caption = "(based on data from: https://data.worldbank.org/indicator/SP.DYN.TFRT.IN
    https://ec.europa.eu/eurostat/databrowser/view/TPS00017/default/table?lang=en&category=demo.demo_fer)",
    x = "Fertility rate",
    y = "Mean age (at birth of first child)", 
    col = "EU Country") +
  theme(
    plot.title = element_text(color="royalblue4", size=14, face="bold"),
    plot.subtitle = element_text(color="slateblue", size=8, face="italic"),
    plot.caption = element_text(color="deeppink", size=7),
    axis.title.x = element_text(color="darkmagenta", size=10),
    axis.title.y = element_text(color="darkmagenta", size=10)
  ) 

ggFR

###Contraceptive modern method in EU countries

#creates new data frame
Country.Code <- c("AUT", "BEL", "BGR", "CYP", "CZE", "DEU", "DNK", "ESP", "EST", "FIN", "FRA",
                  "GRC", "HRV", "HUN", "IRL", "ITA", "LTU", "LUX", "LVA", "MLT", "NLD", "POL", 
                  "PRT", "ROU", "SVK", "SVN", "SWE")
AnyMethod <- c(60.7, 58.3, 59.2, NA, 54, 58.1, 62.3, 56.5, 54.8, 78, 63.5, 50.8, 
               50.8, 45, 65, 55.6, 42.2, NA, 57.2, 48.2, 62.3, 46, 59.8, 53.5, 52.4, 50.2, 59.8)

PrevContrMeth <- data.frame(Country.Code, AnyMethod)

#joins data
comb_data_agewom_fr_contr <- left_join(comb_data_agewom_fr, PrevContrMeth, by = "Country.Code")

# Fertility rate & contraceptive methods(prevalence) - correlation
cor(comb_data_agewom_fr_contr$X2019, comb_data_agewom_fr_contr$AnyMethod, use = "complete.obs")

# Mean age of women at birth of first child & contraceptive methods(prevalence) - correlation
cor(comb_data_agewom_fr_contr$OBS_VALUE, comb_data_agewom_fr_contr$AnyMethod, use = "complete.obs")

# Chart: Mean age of women at birth of first child & contraceptive methods
ggCM <- ggplot(data = comb_data_agewom_fr_contr) +
  geom_point(mapping = aes(x = OBS_VALUE, y = AnyMethod, 
                           color = Country.Code, size = X2019)) +
  theme_light() +
  labs(
    title = "Contraceptive methods - prevalence \n& mean age of woman at birth of first child",
    subtitle = "in 2019 in EU Countries",
    caption = "(based on data from: https://data.worldbank.org/indicator/SP.DYN.TFRT.IN
    https://ec.europa.eu/eurostat/databrowser/view/TPS00017/default/table?lang=en&category=demo.demo_fer
    https://www.un.org/development/desa/pd/sites/www.un.org.development.desa.pd/files/files/documents/2020/Jan/un_2019_contraceptiveusebymethod_databooklet.pdf)",
    x = "Mean age (at birth of first child)",
    y = "Contraceptive methods - prevalence (%)", 
    col = "EU Country",
    size = "Fertility Rate") +
  theme(
    plot.title = element_text(color="royalblue4", size=14, face="bold"),
    plot.subtitle = element_text(color="slateblue", size=8, face="italic"),
    plot.caption = element_text(color="deeppink", size=7),
    axis.title.x = element_text(color="darkmagenta", size=10),
    axis.title.y = element_text(color="darkmagenta", size=10)
  ) 
ggCM
ggplotly(ggCM) 


#Plotly: Mean age of women at birth of first child & contraceptive methods
legendtitle <- list(yref='paper',xref="paper",y=1.05,x=1.1, 
                    yanchor = "bottom", xanchor = "left",
                    text="Country", color = "darkpink", 
                    size = 7, face = "bold", showarrow=F)

cust_color <- col2rgb(c(palette = 1:3))

plt <- plot_ly(
  data = comb_data_agewom_fr_contr,
  x = ~OBS_VALUE,
  y = ~AnyMethod,
  type = "scatter",
  mode = "markers",
  color = ~Country.Code, 
  size = ~X2019,
  colors = rgb(0:255,0, 100:200, 255, maxColorValue = 255),
  hoverinfo = "text",
  text = ~paste("</br> Mean Age: ", OBS_VALUE,
                "</br> Contr Meth (%): ", AnyMethod,
                "</br> Country: ", Country.Code,
                "</br> Fertility Rate: ", X2019)) %>%
  layout(
    title = "Contraceptive methods - prevalence \n & mean age of woman at birth of first child",
    titlefont = list(
      size = 18,
      color = "darkblue"),
         xaxis = list(title = "Mean age (at birth of first child)", 
                      color="deeppink", size=10),
         yaxis = list(title = "Contraceptive methods - prevalence (%)", 
                      color="deeppink", size=10),
         annotations = legendtitle)
       
plt

#adds data: GDP 2019
#data source: https://ec.europa.eu/eurostat/databrowser/view/sdg_08_10/default/table

GDP_per_cap <- c(36080, 6630, 18460, 49270, 35980, 15510, 17760, 25200, 33320, 12700, 27230, 25370,
                 12530, 14050, 85030, 13270, 22660, 41980, 38110, 13020, 18670, 9120, 20720, 15890,
                 37150, 44180, 60130)
Country.Code <- c("BEL", "BGR", "CZE", "DNK", "DEU", "EST", "GRC", "ESP", "FRA", "HRV", "ITA",
                  "CYP", "LVA", "LTU", "LUX", "HUN", "MLT", "NLD", "AUT", "POL", "PRT", "ROU", 
                  "SVN", "SVK", "FIN", "SWE", "IRL")

GDP_EU_2019 <- data.frame(Country.Code, GDP_per_cap)      

#joins data
comb_data_agewom_fr_contr_gdp <- left_join(comb_data_agewom_fr_contr, GDP_EU_2019, by = "Country.Code")

#correlation: FR and GDP
cor(comb_data_agewom_fr_contr_gdp$X2019,comb_data_agewom_fr_contr_gdp$GDP_per_cap)
sd(comb_data_agewom_fr_contr_gdp$X2019)
   
#correlation: Mean age at the birth of first child and GDP
cor(comb_data_agewom_fr_contr_gdp$OBS_VALUE,comb_data_agewom_fr_contr_gdp$GDP_per_cap)
sd(comb_data_agewom_fr_contr_gdp$GDP_per_cap)

#correlation: Prevalence of contraceptive methods and GDP
cor(comb_data_agewom_fr_contr_gdp$AnyMethod, comb_data_agewom_fr_contr_gdp$GDP_per_cap, use = "complete.obs") 

#ggpairs
ggpFR <- ggpairs(comb_data_agewom_fr_contr_gdp, 
        columns = c("OBS_VALUE", "AnyMethod", "GDP_per_cap"),
        title = "Correlations",
        columnLabels = c("Mean age", "Contracept prev", "GDP per cap"),
        upper = list(continuous = wrap("cor", size = 2.5)),
        lower = list(continuous = "smooth"))


#regression


exists("GDP_per_cap")
exists("X2019")

ls()


regressionLM <- lm(GDP_per_cap ~ AnyMethod, data = comb_data_agewom_fr_contr_gdp)
regressionLM
summary(regressionLM)


### Death Rate
#remove rows with region or groups of countries

DeathRate <- DeathRate[-c(2, 4, 8, 37, 62, 63, 64, 65, 66, 
                    69, 74, 75, 96, 99, 103, 104, 105, 106, 
                    108, 111, 129, 135, 136, 137, 140, 
                    141, 143, 154, 157, 162, 171, 
                    182, 184, 192, 199, 205, 216, 218, 219, 231, 232, 
                    237, 239, 242, 242, 250, 260), ]

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


#filter data from EU
EU_DeathRate <- filter (DeathRate, Country.Code == "POL" | Country.Code == "AUT" |
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


#The Highest Death Rate in the EU in 2019
EU_HighDeathRat <- EU_DeathRate %>%
  filter(X2019 == max(X2019, na.rm = T)) %>%
  select(Country.Name, X2019) %>%
  mutate(eu_hdr = round(X2019,1))

#The Lowest Death Rate in the World in 2019
EU_LowDeathRat <- EU_DeathRate %>%
  filter(X2019 == min(X2019, na.rm = T)) %>%
  select(Country.Name, X2019) %>%
  mutate(eu_ldr = round(X2019,1))

#map FR in EU countries in 2019
comb_data_map_eu_dr <- joinCountryData2Map(
  EU_DeathRate,
  joinCode = "ISO3",
  nameJoinColumn = "Country.Code",
  mapResolution = "high"
)

#animations: Death Rate in Pl 

year_dr_pl <- c(1960, 1961, 1962, 1963, 1964, 1965, 1966, 1967, 1968, 1969, 1970, 
                1971, 1972, 1973, 1974, 1975, 1976, 1977, 1978, 1979, 
                 1980, 1981, 1982, 1983, 1984, 1985, 1986, 1987, 1988,
                 1989, 1990, 1991, 1992, 1993, 1994, 1995, 1996, 1997,
                 1998, 1999, 2000, 2001, 2002, 2003, 2004, 2005, 2006,
                 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015,
                 2016, 2017, 2018, 2019)

EU_DeathRate[22, ]
dr_pl <- c(7.6, 7.6, 7.9, 7.5, 7.6, 7.4, 7.4, 7.7, 7.6, 8.1, 8.2, 8.7, 8, 8.4, 8.2, 8.7, 8.9,
           9, 9.4, 9.2, 9.8, 9.2, 9.3, 9.6, 10, 10.3, 10.1, 10.1, 9.9, 10.1, 10.2, 10.6,
           10.3, 10.2, 10, 10, 10, 9.8, 9.7, 9.9, 9.6, 9.5, 9.4, 9.6, 9.5, 9.6, 9.7,
           9.9, 10, 10.1, 9.9, 9.9, 10.1, 10.2, 9.9, 10.4, 10.2, 10.6, 10.9, 10.8)

PL_DR <- data.frame(year_dr_pl, dr_pl)

ggPL_DR <- ggplot(data = PL_DR, aes(x=year_dr_pl, y=dr_pl, color=dr_pl)) +
  geom_line() +
  geom_point() +
  ggtitle("Death rate in Poland") +
  xlab("Year") +
  ylab("Death rate") +
  transition_reveal(year_dr_pl)

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


#Life Expectancy and depressive symptoms
#source of data: https://ec.europa.eu/eurostat/databrowser/view/HLTH_EHIS_MH1E/default/table?lang=en&category=hlth.hlth_state.hlth_sph

#filters data from EU countries
EU_LifeExpect <- filter (LifeExpect, Country.Code == "POL" | Country.Code == "AUT" |
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

#The Highest LE in the EU in 2019
EU_HighLE <- EU_LifeExpect %>%
  filter(X2019 == max(X2019, na.rm = T)) %>%
  select(Country.Name, X2019) %>%
  mutate(eu_hlifexp = round(X2019,1))

#The Lowest Fertility Rate in the World in 2019
EU_LowLE <- EU_LifeExpect%>%
  filter(X2019 == min(X2019, na.rm = T)) %>%
  select(Country.Name, X2019) %>%
  mutate(eu_llifexp = round(X2019,1))

#map LE in EU countries in 2019
comb_data_map_eu_le <- joinCountryData2Map(
  EU_LifeExpect,
  joinCode = "ISO3",
  nameJoinColumn = "Country.Code",
  mapResolution = "high"
)

#adds data about depressive symptoms
Depr_sympt <- c(8.4, 5.0, 4.2, 8.3, 9.4, 8.2, 2.7, 4.8, 10.8, 8.9, 4.2, 2.5,
                 5.7, 6.2, 8.8, 5.5, 8.8, 8.3, 5.6, 5.2, 8.5, 4.3, 7.5, 3.2,
                 6.5, 10.5, 4.9)
Country.Code <- c("BEL", "BGR", "CZE", "DNK", "DEU", "EST", "GRC", "ESP", "FRA", "HRV", "ITA",
                  "CYP", "LVA", "LTU", "LUX", "HUN", "MLT", "NLD", "AUT", "POL", "PRT", "ROU", 
                  "SVN", "SVK", "FIN", "SWE", "IRL")

Depr_GDP_EU_2019 <- data.frame(Country.Code, Depr_sympt, GDP_per_cap)  

#new data frame with depressive symptoms and GDP_per_capita
EU_LifeExpect_depr_GDP <- left_join(EU_LifeExpect, Depr_GDP_EU_2019, by = "Country.Code")

#correlation: Life expectancy and depressive symptoms
cor(EU_LifeExpect_depr_GDP$X2019, EU_LifeExpect_depr_GDP$Depr_sympt, use = "complete.obs") 

#correlation: Life expectancy and GDP
cor(EU_LifeExpect_depr_GDP$X2019, EU_LifeExpect_depr_GDP$GDP_per_cap, use = "complete.obs") 

###rcorr(EU_LifeExpect_depr_GDP$X2019, EU_LifeExpect_depr_GDP$GDP_per_cap, use = "complete.obs",
     ###method = "pearson")
   
#other method   
test <- cor.test(EU_LifeExpect_depr_GDP$X2019, EU_LifeExpect_depr_GDP$GDP_per_cap, use = "complete.obs")
test


#ggpairs
ggpLE <- ggpairs(EU_LifeExpect_depr_GDP, 
              columns = c("X2019", "Depr_sympt", "GDP_per_cap"),
              title = "Correlations",
              columnLabels = c("Life expect", "Depression sympt", "GDP per cap"),
              upper = list(continuous = wrap("cor", size = 2.5)),
              lower = list(continuous = "smooth"))
ggpLE



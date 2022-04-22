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
    x = "Fertility Rate",
    y = "Mean age", 
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
      size = 20,
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



### Death Rate
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


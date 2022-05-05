library("dplyr")
library("tidyverse")
library("ggplot2")
library("gganimate")
library("ggrepel")
library("rworldmap")
library("rgeos")
library("RColorBrewer")
library("knitr")
library("plotly")
library("htmlwidgets")
library("GGally")

#install.packages("Hmisc")
#library("Hmisc")
#install.packages("ggstatsplot")
#library("ggstatsplot")

BirthRate <- read.csv("/Users/kdm/programowanie w R/demographicChanges_project/data/BirthRate_update.csv", 
                      stringsAsFactors = F,
                      skip = 4)
DeathRate <- read.csv("/Users/kdm/programowanie w R/demographicChanges_project/data/DeathRate_update.csv",
                      stringsAsFactors = F,
                      skip = 4)
FertRateTot <- read.csv("/Users/kdm/programowanie w R/demographicChanges_project/data/FertilityRate_update.csv",
                        stringsAsFactors = F,
                        skip = 4)
LifeExpect <- read.csv("/Users/kdm/programowanie w R/demographicChanges_project/data/LifeExpectancy_update.csv",
                       stringsAsFactors = F,
                       skip = 4)
LaborFem <- read.csv("/Users/kdm/programowanie w R/demographicChanges_project/data/LaborForce_update.csv",
                     stringsAsFactors = F,
                     skip = 4)
AgeWom <- read.csv("/Users/kdm/programowanie w R/demographicChanges_project/data/Age WomFirstChild_update.csv",
                   stringsAsFactors = F)

GDP_EU <- read.csv("/Users/kdm/programowanie w R/demographicChanges_project/data/GDP_EU_update.csv",
                        stringsAsFactors = F)

continents <- read.csv("/Users/kdm/programowanie w R/demographicChanges_project/data/continents.csv",
                       stringsAsFactors = F)
colnames(continents)[5] <- "Country.Code"
#(data source:https://gist.github.com/stevewithington/20a69c0b6d2ff846ea5d35e5fc47f26c#file-country-and-continent-codes-list-csv-csv) )


#mortality rate: EU 2020-2022
EU_MR_20202022 <- read.csv("/Users/kdm/programowanie w R/demographicChanges_project/data/EU_MR20202022.csv",
                           stringsAsFactors = F)

EU_MR_20202022$geo[EU_MR_20202022$geo == "AT"] <- "AUT"
EU_MR_20202022$geo[EU_MR_20202022$geo == "BE"] <- "BEL"
EU_MR_20202022$geo[EU_MR_20202022$geo == "BG"] <- "BGR"
EU_MR_20202022$geo[EU_MR_20202022$geo == "BG"] <- "BGR"
EU_MR_20202022$geo[EU_MR_20202022$geo == "CH"] <- "CHE"
EU_MR_20202022$geo[EU_MR_20202022$geo == "CY"] <- "CYP"
EU_MR_20202022$geo[EU_MR_20202022$geo == "CZ"] <- "CZE"
EU_MR_20202022$geo[EU_MR_20202022$geo == "DE"] <- "DEU"
EU_MR_20202022$geo[EU_MR_20202022$geo == "DK"] <- "DNK"
EU_MR_20202022$geo[EU_MR_20202022$geo == "EE"] <- "EST"
EU_MR_20202022$geo[EU_MR_20202022$geo == "EL"] <- "GRC"
EU_MR_20202022$geo[EU_MR_20202022$geo == "ES"] <- "ESP"
EU_MR_20202022$geo[EU_MR_20202022$geo == "FI"] <- "FIN"
EU_MR_20202022$geo[EU_MR_20202022$geo == "FR"] <- "FRA"
EU_MR_20202022$geo[EU_MR_20202022$geo == "HR"] <- "HRV"
EU_MR_20202022$geo[EU_MR_20202022$geo == "HU"] <- "HUN"
EU_MR_20202022$geo[EU_MR_20202022$geo == "IE"] <- "IRL"
EU_MR_20202022$geo[EU_MR_20202022$geo == "IS"] <- "ISL"
EU_MR_20202022$geo[EU_MR_20202022$geo == "IT"] <- "ITA"
EU_MR_20202022$geo[EU_MR_20202022$geo == "LI"] <- "LIE"
EU_MR_20202022$geo[EU_MR_20202022$geo == "LT"] <- "LTU"
EU_MR_20202022$geo[EU_MR_20202022$geo == "LU"] <- "LUX"
EU_MR_20202022$geo[EU_MR_20202022$geo == "LV"] <- "LVA"
EU_MR_20202022$geo[EU_MR_20202022$geo == "MT"] <- "MLT"
EU_MR_20202022$geo[EU_MR_20202022$geo == "NL"] <- "NLD"
EU_MR_20202022$geo[EU_MR_20202022$geo == "NO"] <- "NOR"
EU_MR_20202022$geo[EU_MR_20202022$geo == "PL"] <- "POL"
EU_MR_20202022$geo[EU_MR_20202022$geo == "PT"] <- "PRT"
EU_MR_20202022$geo[EU_MR_20202022$geo == "RO"] <- "ROU"
EU_MR_20202022$geo[EU_MR_20202022$geo == "SE"] <- "SWE"
EU_MR_20202022$geo[EU_MR_20202022$geo == "SI"] <- "SVN"
EU_MR_20202022$geo[EU_MR_20202022$geo == "SK"] <- "SVK"

#filters data from EU
EUonly_MR_20202022 <- filter (EU_MR_20202022, geo == "POL" | geo == "AUT" |
                            geo == "BEL" | geo == "BGR" | geo == "HRV" |
                            geo == "CYP" |
                            geo == "CZE" | geo == "DNK" | geo == "EST" |
                            geo == "FIN" | geo == "FRA" | geo == "GRC" |
                            geo == "ESP" | geo == "NLD" | geo == "IRL" |
                            geo == "LTU" | geo == "LUX" | geo == "LVA" |
                            geo == "MLT" | geo == "DEU" | geo == "PRT" |
                            geo == "ROU" | geo == "SVK" | geo == "SVN" |
                            geo == "SWE" | geo == "HUN" | 
                            geo == "ITA")


#The Highest Fertility Rate in the World in 2020
HighFertRat <- FertRateTot %>%
  filter(X2020 == max(X2020, na.rm = T)) %>%
  dplyr::select(Country.Name, X2020) %>%
  mutate(hfr = round(X2020,2))

#The Lowest Fertility Rate in the World in 2020
LowFertRat <- FertRateTot %>%
  filter(X2020 == min(X2020, na.rm = T)) %>%
  dplyr::select(Country.Name, X2020) %>%
  mutate(lfr = round(X2020,2))

#The Top 10 Countries with The Highest Fertility Rate and FR difference declining from 1960 to 2020
top_10_hfr <- FertRateTot %>%
  mutate(gain = X2020 - X1960) %>%
  top_n(10, wt = gain) %>%
  arrange(-gain) %>%
  mutate(gain_str = paste(format(round(gain, 2)), "births per woman")) %>%
  dplyr::select(Country.Name, gain_str)
 
#world map & the Fertility Rate in 2020 
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

#The Highest Fertility Rate in the EU in 2020
EU_HighFertRat <- EU_FertRateTot %>%
  filter(X2020 == max(X2020, na.rm = T)) %>%
  dplyr::select(Country.Name, X2020) %>%
  mutate(eu_hfr = round(X2020,2))

#The Lowest Fertility Rate in the World in 2020
EU_LowFertRat <- EU_FertRateTot %>%
  filter(X2020 == min(X2020, na.rm = T)) %>%
  dplyr::select(Country.Name, X2020) %>%
  mutate(eu_lfr = round(X2020,2))

#map FR in EU countries in 2020
comb_data_map_eu_fr <- joinCountryData2Map(
  EU_FertRateTot,
  joinCode = "ISO3",
  nameJoinColumn = "Country.Code",
  mapResolution = "high"
)



#chart: EU countries & Fertility Rate in 2020
EU_FR <- ggplot(data = EU_FertRateTot) + geom_col(aes(x = reorder(Country.Name, X2020), y = X2020, fill = X2020)) + 
  scale_fill_gradient(low="lightblue", high="red") +
  coord_flip() +
  theme_light() +
  labs(
    title = "Fertility rate in EU in 2020 (births per woman)",
    caption = "(based on data from: https://data.worldbank.org/indicator/SP.DYN.TFRT.IN)",
    x = "EU Country",
    y = "Fertility rate") +
  theme(
    plot.title = element_text(color="royalblue4", size=14, face="bold", hjust = 0.5),
    axis.title.x = element_text(color="steelblue2", size=14, face="bold"),
    axis.title.y = element_text(color="steelblue2", size=14, face="bold"),
    legend.position = "none") 

### Mean age of women at birth of first child - preparing df with data from 2020
MeanAgeWom2020 <- filter(AgeWom,
                     TIME_PERIOD==2020)

# Mean age of women at birth of first child - replacing country code
MeanAgeWom2020[MeanAgeWom2020 == "BE"] <- "BEL"
MeanAgeWom2020[MeanAgeWom2020 == "BG"] <- "BGR"
MeanAgeWom2020[MeanAgeWom2020 == "CZ"] <- "CZE"
MeanAgeWom2020[MeanAgeWom2020 == "DK"] <- "DNK"
MeanAgeWom2020[MeanAgeWom2020 == "DE"] <- "DEU"
MeanAgeWom2020[MeanAgeWom2020 == "EE"] <- "EST"
MeanAgeWom2020[MeanAgeWom2020 == "EL"] <- "GRC"
MeanAgeWom2020[MeanAgeWom2020 == "ES"] <- "ESP"
MeanAgeWom2020[MeanAgeWom2020 == "FR"] <- "FRA"
MeanAgeWom2020[MeanAgeWom2020 == "HR"] <- "HRV"
MeanAgeWom2020[MeanAgeWom2020 == "IT"] <- "ITA"
MeanAgeWom2020[MeanAgeWom2020 == "CY"] <- "CYP"
MeanAgeWom2020[MeanAgeWom2020 == "LV"] <- "LVA"
MeanAgeWom2020[MeanAgeWom2020 == "LT"] <- "LTU"
MeanAgeWom2020[MeanAgeWom2020 == "LU"] <- "LUX"
MeanAgeWom2020[MeanAgeWom2020 == "HU"] <- "HUN"
MeanAgeWom2020[MeanAgeWom2020 == "MT"] <- "MLT"
MeanAgeWom2020[MeanAgeWom2020 == "NL"] <- "NLD"
MeanAgeWom2020[MeanAgeWom2020 == "AT"] <- "AUT"
MeanAgeWom2020[MeanAgeWom2020 == "PL"] <- "POL"
MeanAgeWom2020[MeanAgeWom2020 == "PT"] <- "PRT"
MeanAgeWom2020[MeanAgeWom2020 == "RO"] <- "ROU"
MeanAgeWom2020[MeanAgeWom2020 == "SI"] <- "SVN"
MeanAgeWom2020[MeanAgeWom2020 == "SK"] <- "SVK"
MeanAgeWom2020[MeanAgeWom2020 == "FI"] <- "FIN"
MeanAgeWom2020[MeanAgeWom2020 == "SE"] <- "SWE"
MeanAgeWom2020[MeanAgeWom2020 == "IE"] <- "IRL"

# Mean age of women at birth of first child - removing other countries and some other records
MeanAgeWom2020 <- MeanAgeWom2020[-c(1, 5, 10, 11, 15, 21, 23, 27, 28, 31, 35, 39), ]
                                 
# Mean age of women at birth of first child - renaming column's name
MeanAgeWom2020 <- MeanAgeWom2020 %>% rename(Country.Code = geo)

# Removes columns
MeanAgeWom2020 <- subset (MeanAgeWom2020, select = -c(1:4, 6, 8))

# Renames column
MeanAgeWom2020 <- MeanAgeWom2020 %>% rename(Mean_Age = OBS_VALUE)

# Mean age of women at birth of first child - joining df's
comb_data_agewom_fr <- left_join(EU_FertRateTot, MeanAgeWom2020, by = "Country.Code")

# Mean age of women at birth of first child & fertility rate - correlation
cor(comb_data_agewom_fr$X2020, comb_data_agewom_fr$Mean_Age, use = "complete.obs")

# Mean age of women at birth of first child & fertility rate - chart
ggFR <- ggplot(data = comb_data_agewom_fr) +
  geom_text(mapping = aes(x = X2020, y = Mean_Age, label = Country.Code)) +
  theme_light() +
  labs(
    title = "Fertility rate & mean age of woman at birth of first child",
    subtitle = "in EU countries in 2020",
    caption = "(based on data from: https://data.worldbank.org/indicator/SP.DYN.TFRT.IN
    https://ec.europa.eu/eurostat/databrowser/view/TPS00017/default/table?lang=en&category=demo.demo_fer)",
    x = "Fertility rate",
    y = "Mean age (at birth of first child)", 
    col = "EU Country") +
  theme(
    plot.title = element_text(color="royalblue4", size=14, face="bold", hjust = 0.5),
    plot.subtitle = element_text(color="slateblue", size=8, face="italic"),
    plot.caption = element_text(color="deeppink", size=7),
    plot.caption.position = "plot",
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
cor(comb_data_agewom_fr_contr$X2020, comb_data_agewom_fr_contr$AnyMethod, use = "complete.obs")

# Mean age of women at birth of first child & contraceptive methods(prevalence) - correlation
cor(comb_data_agewom_fr_contr$Mean_Age, comb_data_agewom_fr_contr$AnyMethod, use = "complete.obs")

# Chart: Mean age of women at birth of first child & contraceptive methods
ggCM <- ggplot(data = comb_data_agewom_fr_contr) +
  geom_point(mapping = aes(x = Mean_Age, y = AnyMethod, 
                           color = Country.Code, size = X2020)) +
  theme_light() +
  labs(
    title = "Contraceptive methods - prevalence in 2019 \n& mean age of woman at birth of first child in 2020 in EU Countries",
    caption = "(based on data from: https://data.worldbank.org/indicator/SP.DYN.TFRT.IN
    https://ec.europa.eu/eurostat/databrowser/view/TPS00017/default/table?lang=en&category=demo.demo_fer
    https://www.un.org/development/desa/pd/sites/www.un.org.development.desa.pd/files/files/documents/2020/Jan/un_2019_contraceptiveusebymethod_databooklet.pdf)",
    x = "Mean age (at birth of first child)",
    y = "Contraceptive methods - prevalence (%)", 
    col = "EU Country",
    size = "Fertility Rate") +
  theme(
    plot.title = element_text(color="royalblue4", size=12, face="bold", hjust = 0.5),
    plot.subtitle = element_text(color="slateblue", size=8, face="italic"),
    plot.caption = element_text(color="deeppink", size=7),
    plot.caption.position = "plot",
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
  x = ~Mean_Age,
  y = ~AnyMethod,
  type = "scatter",
  mode = "markers",
  color = ~Country.Code, 
  size = ~X2020,
  colors = rgb(0:255,0, 100:200, 255, maxColorValue = 255),
  hoverinfo = "text",
  text = ~paste("</br> Mean Age: ", Mean_Age,
                "</br> Contr Meth (%): ", AnyMethod,
                "</br> Country: ", Country.Code,
                "</br> Fertility Rate: ", X2020)) %>%
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

#adds data: GDP 2020 - non actual
#data source: https://ec.europa.eu/eurostat/databrowser/view/sdg_08_10/default/table

#GDP_per_cap <- c(36080, 6630, 18460, 49270, 35980, 15510, 17760, 25200, 33320, 12700, 27230, 25370,
                 #12530, 14050, 85030, 13270, 22660, 41980, 38110, 13020, 18670, 9120, 20720, 15890,
                 #37150, 44180, 60130)
#Country.Code <- c("BEL", "BGR", "CZE", "DNK", "DEU", "EST", "GRC", "ESP", "FRA", "HRV", "ITA",
                  #"CYP", "LVA", "LTU", "LUX", "HUN", "MLT", "NLD", "AUT", "POL", "PRT", "ROU", 
                  #"SVN", "SVK", "FIN", "SWE", "IRL")

#GDP_EU_2019 <- data.frame(Country.Code, GDP_per_cap)      

#joins data
#comb_data_agewom_fr_contr_gdp <- left_join(comb_data_agewom_fr_contr, GDP_EU_2019, by = "Country.Code")


### GDP in 2020 - preparing df
GDP_EU <- select(GDP_EU, geo, TIME_PERIOD, OBS_VALUE) 
GDP_EU_2020 <- filter(GDP_EU,TIME_PERIOD==2020)

# GDP - replacing country code
GDP_EU_2020[GDP_EU_2020 == "BE"] <- "BEL"
GDP_EU_2020[GDP_EU_2020 == "BG"] <- "BGR"
GDP_EU_2020[GDP_EU_2020 == "CZ"] <- "CZE"
GDP_EU_2020[GDP_EU_2020 == "DK"] <- "DNK"
GDP_EU_2020[GDP_EU_2020 == "DE"] <- "DEU"
GDP_EU_2020[GDP_EU_2020 == "EE"] <- "EST"
GDP_EU_2020[GDP_EU_2020 == "EL"] <- "GRC"
GDP_EU_2020[GDP_EU_2020 == "ES"] <- "ESP"
GDP_EU_2020[GDP_EU_2020 == "FR"] <- "FRA"
GDP_EU_2020[GDP_EU_2020 == "HR"] <- "HRV"
GDP_EU_2020[GDP_EU_2020 == "IT"] <- "ITA"
GDP_EU_2020[GDP_EU_2020 == "CY"] <- "CYP"
GDP_EU_2020[GDP_EU_2020 == "LV"] <- "LVA"
GDP_EU_2020[GDP_EU_2020 == "LT"] <- "LTU"
GDP_EU_2020[GDP_EU_2020 == "LU"] <- "LUX"
GDP_EU_2020[GDP_EU_2020 == "HU"] <- "HUN"
GDP_EU_2020[GDP_EU_2020 == "MT"] <- "MLT"
GDP_EU_2020[GDP_EU_2020 == "NL"] <- "NLD"
GDP_EU_2020[GDP_EU_2020 == "AT"] <- "AUT"
GDP_EU_2020[GDP_EU_2020 == "PL"] <- "POL"
GDP_EU_2020[GDP_EU_2020 == "PT"] <- "PRT"
GDP_EU_2020[GDP_EU_2020 == "RO"] <- "ROU"
GDP_EU_2020[GDP_EU_2020 == "SI"] <- "SVN"
GDP_EU_2020[GDP_EU_2020 == "SK"] <- "SVK"
GDP_EU_2020[GDP_EU_2020 == "FI"] <- "FIN"
GDP_EU_2020[GDP_EU_2020 == "SE"] <- "SWE"
GDP_EU_2020[GDP_EU_2020 == "IE"] <- "IRL"

# GDP- removing other countries and some other records
GDP_EU_2020 <- GDP_EU_2020[-c(1, 5, 10, 14, 20, 25, 28, 36), ]

# GDP- renaming column's name
GDP_EU_2020 <- GDP_EU_2020 %>% rename(Country.Code = geo)

#GDP - removing column
GDP_EU_2020$TIME_PERIOD <- NULL

#GDP - renaming column's name
GDP_EU_2020 <- GDP_EU_2020 %>% rename(GDP_per_cap2020 = OBS_VALUE)

# GDP - joining df's
comb_data_agewom_fr_contr_gdp <- left_join(comb_data_agewom_fr_contr, GDP_EU_2020, by = "Country.Code")

#correlation: FR and GDP
cor(comb_data_agewom_fr_contr_gdp$X2020,comb_data_agewom_fr_contr_gdp$GDP_per_cap2020)
round(sd(comb_data_agewom_fr_contr_gdp$X2020), 2)
   
#correlation: Mean age at the birth of first child and GDP
cor(comb_data_agewom_fr_contr_gdp$Mean_Age,comb_data_agewom_fr_contr_gdp$GDP_per_cap2020)
round(sd(comb_data_agewom_fr_contr_gdp$GDP_per_cap), 2)

#correlation: Prevalence of contraceptive methods and GDP
cor(comb_data_agewom_fr_contr_gdp$AnyMethod, comb_data_agewom_fr_contr_gdp$GDP_per_cap2020, use = "complete.obs") 

#ggpairs
ggpFR <- ggpairs(comb_data_agewom_fr_contr_gdp, 
        columns = c("Mean_Age", "AnyMethod", "GDP_per_cap2020"),
        title = "Correlations",
        columnLabels = c("Mean age", "Contracept prev", "GDP per cap"),
        upper = list(continuous = wrap("cor", size = 2.5)),
        lower = list(continuous = "smooth"))


### Death Rate
#removes rows with region or groups of countries

DeathRate <- DeathRate[-c(2, 4, 8, 37, 62, 63, 64, 65, 66, 
                    69, 74, 75, 96, 99, 103, 104, 105, 106, 
                    108, 111, 129, 135, 136, 137, 140, 
                    141, 143, 154, 157, 162, 171, 
                    182, 184, 192, 199, 205, 216, 218, 219, 231, 232, 
                    237, 239, 242, 242, 250, 260), ]

#The Highest Death Rate in the World in 2020
HighDeathRat <- DeathRate %>%
  filter(X2020 == max(X2020, na.rm = T)) %>%
  dplyr::select(Country.Name, X2020) %>%
  mutate(hdr = round(X2020,2))

#The Lowest Death Rate in the World in 2020
LowDeathRat <- DeathRate %>%
  filter(X2020 == min(X2020, na.rm = T)) %>%
  dplyr::select(Country.Name, X2020) %>%
  mutate(ldr = round(X2020,2))

#The Top 10 Countries with The Highest Death Rate and DR difference declining from 1960 to 2020
top_10_hdr <- DeathRate %>%
  mutate(gain = X2020 - X1960) %>%
  top_n(10, wt = gain) %>%
  arrange(-gain) %>%
  mutate(gain_str = paste(format(round(gain, 2)), "crude (per 1000 people)")) %>%
  dplyr::select(Country.Name, gain_str)

#world map & the Death Rate in 2020
comb_data_map_dr <- joinCountryData2Map(
  DeathRate,
  joinCode = "ISO3",
  nameJoinColumn = "Country.Code",
  mapResolution = "high"
)

#joins data frames - Death Rate and Continents (notice: code for continent is below in the Birth Rate section)
DeathRate_join <- left_join(DeathRate, continents, by = "Country.Code" )


#boxplot: Death Rate in 2020
boxplot_DR <- ggplot (data = DeathRate_join, (aes(Continent_Name,X2020, color=Continent_Name))) +
  geom_boxplot() +
  geom_jitter(width=0.15, alpha=0.3) +
  labs(
    title = "Death Rate in 2020",
    caption = "(based on data from: https://data.worldbank.org/indicator/SP.DYN.CDRT.IN)",
    x = "Continent",
    y = "Death Rate") +
  theme(
    plot.title = element_text(color="royalblue4", size=14, face="bold", hjust = 0.5),
    axis.title.x = element_text(color="steelblue2", size=14, face="bold"),
    axis.title.y = element_text(color="steelblue2", size=14, face="bold"),
    plot.caption.position = "plot",
    legend.position = "none")

boxplot_DR



#calculations

calcDR <- as.data.frame(DeathRate_join %>%
                          group_by(Continent_Name) %>%
                          dplyr::summarise((AvgDR = round(mean(X2020, na.rm = T), 2)),
                                           (MedDR = round(median(X2020, na.rm = T), 2)),
                                           (SDDR = round(sd(X2020, na.rm = T), 2))))

                   

#filters data from EU
EU_DeathRate <- filter (DeathRate_join, Country.Code == "POL" | Country.Code == "AUT" |
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

#removes duplicated row - Cyprus
EU_DeathRate <- EU_DeathRate[-4, ]

#The Highest Death Rate in the EU in 2020
EU_HighDeathRat <- EU_DeathRate %>%
  filter(X2020 == max(X2020, na.rm = T)) %>%
  dplyr::select(Country.Name, X2020) %>%
  mutate(eu_hdr = round(X2020,2))

#The Lowest Death Rate in the World in 2020
EU_LowDeathRat <- EU_DeathRate %>%
  filter(X2020 == min(X2020, na.rm = T)) %>%
  dplyr::select(Country.Name, X2020) %>%
  mutate(eu_ldr = round(X2020,2))

#map DR in EU countries in 2020
comb_data_map_eu_dr <- joinCountryData2Map(
  EU_DeathRate,
  joinCode = "ISO3",
  nameJoinColumn = "Country.Code",
  mapResolution = "high"
)

#chart: EU countries & Death Rate in 2020
eu_dr_chart <- ggplot(data = EU_DeathRate) + geom_col(aes(x = reorder(Country.Name, X2020), y = X2020, fill = X2020)) + 
  scale_fill_gradient(low = "darkgreen", high = "darkred") +
  coord_flip() +
  theme_light() +
  labs(
    title = "Death rate in EU in 2020",
    caption = "(based on data from: https://data.worldbank.org/indicator/SP.DYN.CDRT.IN)",
    x = "EU Country",
    y = "Death rate") +
  theme(
    plot.title = element_text(color="royalblue4", size=14, face="bold", hjust = 0.5),
    axis.title.x = element_text(color="steelblue2", size=14, face="bold"),
    axis.title.y = element_text(color="steelblue2", size=14, face="bold"),
    legend.position = "none") 

eu_dr_chart


#animation - EU - COVID-19
#data source:  https://ec.europa.eu/eurostat/databrowser/view/DEMO_MEXRT__custom_1210067/bookmark/table?lang=en&bookmarkId=fc27a3a9-082b-461d-830b-a4c7b36caf4f
# data source: https://ec.europa.eu/eurostat/web/covid-19/data



EUonly_MR_20202022$TIME_PERIOD <- as.Date(paste(EUonly_MR_20202022$TIME_PERIOD,"-01",sep="")) 
class(EUonly_MR_20202022$TIME_PERIOD)


ggeu_mr <- ggplot(
  EUonly_MR_20202022, 
  aes(x = TIME_PERIOD, y = OBS_VALUE, colour = geo)) +
  geom_point(show.legend = TRUE, alpha = 0.7) +
  scale_size(range = c(2, 12)) +
  labs(x = "Time", 
       y = "Death Rate",
       title = "Year: {frame_time}") +
  shadow_wake(wake_length = 0.2) +
  shadow_mark(alpha = 0.3, size = 0.5) +
  transition_time(TIME_PERIOD) 

animate(ggeu_mr, 
        duration = 30)



#animations: Death Rate in Pl (1960-2020)
#data source: https://data.worldbank.org/indicator/SP.DYN.CDRT.IN?locations=PL

year_dr_pl <- c(1960, 1961, 1962, 1963, 1964, 1965, 1966, 1967, 1968, 1969, 1970, 
                1971, 1972, 1973, 1974, 1975, 1976, 1977, 1978, 1979, 
                 1980, 1981, 1982, 1983, 1984, 1985, 1986, 1987, 1988,
                 1989, 1990, 1991, 1992, 1993, 1994, 1995, 1996, 1997,
                 1998, 1999, 2000, 2001, 2002, 2003, 2004, 2005, 2006,
                 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015,
                 2016, 2017, 2018, 2019, 2020)

EU_DeathRate[22, ]
dr_pl <- c(7.6, 7.6, 7.9, 7.5, 7.6, 7.4, 7.4, 7.7, 7.6, 8.1, 8.2, 8.7, 8, 8.4, 8.2, 8.7, 8.9,
           9, 9.4, 9.2, 9.8, 9.2, 9.3, 9.6, 10, 10.3, 10.1, 10.1, 9.9, 10.1, 10.2, 10.6,
           10.3, 10.2, 10, 10, 10, 9.8, 9.7, 9.9, 9.6, 9.5, 9.4, 9.6, 9.5, 9.6, 9.7,
           9.9, 10, 10.1, 9.9, 9.9, 10.1, 10.2, 9.9, 10.4, 10.2, 10.6, 10.9, 10.8, 12.6)

PL_DR <- data.frame(year_dr_pl, dr_pl)

ggPL_DR <- ggplot(data = PL_DR, aes(x=year_dr_pl, y=dr_pl, color=dr_pl)) +
  geom_line() +
  geom_point() +
  ggtitle("Death rate in Poland since 1960 to 2020") +
  xlab("Year") +
  ylab("Death Rate") +
  labs(color = "Death Rate in Poland") +
  transition_reveal(year_dr_pl)


### Birth Rate
#The Highest Birth Rate in the World in 2020
HighBirthRat <- BirthRate %>%
  filter(X2020 == max(X2020, na.rm = T)) %>%
  dplyr::select(Country.Name, X2020) %>%
  mutate(hbr = round(X2020,2))

#The Lowest Birth Rate in the World in 2020
LowBirthRat <- BirthRate %>%
  filter(X2020 == min(X2020, na.rm = T)) %>%
  dplyr::select(Country.Name, X2020) %>%
  mutate(lbr = round(X2020,2))

#The Top 10 Countries with The Highest Birth Rate and BR difference declining from 1960 to 2020
top_10_hbr <- BirthRate %>%
  mutate(gain = X2020 - X1960) %>%
  top_n(10, wt = gain) %>%
  arrange(-gain) %>%
  mutate(gain_str = paste(format(round(gain, 2)), "crude (per 1000 people)")) %>%
  dplyr::select(Country.Name, gain_str)

#world map & the Birth Rate in 2020 
comb_data_map_br <- joinCountryData2Map(
  BirthRate,
  joinCode = "ISO3",
  nameJoinColumn = "Country.Code",
  mapResolution = "high"
)

#correlation: FR and BR in the whole world in 2020
cor(FertRateTot$X2020, BirthRate$X2020, use = "complete.obs")


#Small Multiples: BR & continents in 2020
BirthRate <- left_join(BirthRate, continents, by = "Country.Code")
                                      
                                      
BR_cont <- ggplot(data = BirthRate) +
  geom_point(mapping = aes(x = Country.Code, y = X2020), color = "green") +
  facet_wrap(~ Continent_Name,nrow = 1, scales = "free_x") +
  theme(axis.ticks.x = element_blank(),
        axis.text.x = element_blank()) +
  labs(
    title = "Birth rate in the world in 2020",
    caption = "(based on data from: https://data.worldbank.org/indicator/SP.DYN.CBRT.IN)",
    x = "Country",
    y = "Birth rate") +
  theme(
    plot.title = element_text(color="darkgreen", size=14, face="bold", hjust = 0.5),
    plot.caption = element_text(color = "black", size = 10), 
    plot.caption.position = "plot",
    axis.title.x = element_text(color="darkgreen", size=14, face="bold"),
    axis.title.y = element_text(color="darkgreen", size=14, face="bold"))

BR_cont

#calculations

calcBR <- as.data.frame(BirthRate %>%
  group_by(Continent_Name) %>%
  dplyr::summarise((AvgBR = round(mean(X2020, na.rm = T), 2)),
                   (MedBR = round(median(X2020, na.rm = T), 2)),
                   (SDBR = round(sd(X2020, na.rm = T), 2))))


#correlation: BR & LF in the world
LaborFem <- LaborFem %>% rename(LF2020 = X2020)

cor(BirthRate$X2020, LaborFem$LF2020, use = "complete.obs") 

### BR and Labor Force in female group in EU 
#EU BR
EU_BirthRate<- filter (BirthRate, Country.Code == "POL" | Country.Code == "AUT" |
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

#removes duplicated row - Cyprus
EU_BirthRate <- EU_BirthRate[-4, ]

#EU LF
EU_LaborFem<- filter (LaborFem, Country.Code == "POL" | Country.Code == "AUT" |
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

#EU_LF - renaming column's name
EU_LaborFem <- EU_LaborFem %>% rename(LF2020 = X2020)


#joins column with Labor Force in 2020 value to EU_BirthRate 
EU_BR_LF <- cbind(EU_BirthRate, LF2020 = EU_LaborFem$LF2020)

#correlation: BR & LF in EU over the 30 years
cor(EU_BirthRate$X2020, EU_LaborFem$LF2020, use = "complete.obs") 
cor(EU_BirthRate$X2015, EU_LaborFem$X2015, use = "complete.obs") 
cor(EU_BirthRate$X2010, EU_LaborFem$X2010, use = "complete.obs") 
cor(EU_BirthRate$X2005, EU_LaborFem$X2005, use = "complete.obs") 
cor(EU_BirthRate$X2000, EU_LaborFem$X2000, use = "complete.obs") 
cor(EU_BirthRate$X1995, EU_LaborFem$X1995, use = "complete.obs") 
cor(EU_BirthRate$X1990, EU_LaborFem$X1990, use = "complete.obs") 

#chart
plot_LF <- ggplot(data = EU_BR_LF) + 
  geom_col(aes(x = reorder(Country.Name, LF2020), y = LF2020, fill = LF2020)) + 
  scale_fill_gradient(low="blue", high="red") +
  coord_flip() +
  theme_light() +
  labs(
    title = "Labor Force in female group",
    subtitle = "in 2020 in EU",
    caption = "(based on data from: https://data.worldbank.org/indicator/SL.TLF.TOTL.FE.ZS)",
    x = "EU Country",
    y = "Labor Force, fem (%)") +
  theme(
    plot.title = element_text(color="royalblue4", size=14, face="bold"),
    axis.title.x = element_text(color="steelblue2", size=14, face="bold"),
    axis.title.y = element_text(color="steelblue2", size=14, face="bold"),
    legend.position = "none") 



### Life Expectation
#The Highest Life Expectation in the World in 2020
HighLifeExpect <- LifeExpect %>%
  filter(X2020 == max(X2020, na.rm = T)) %>%
  dplyr::select(Country.Name, X2020) %>%
  mutate(hle = round(X2020,2))

#The Lowest High Expectation in the World in 2020
LowLifeExpect <- LifeExpect %>%
  filter(X2020 == min(X2020, na.rm = T)) %>%
  dplyr::select(Country.Name, X2020) %>%
  mutate(lle = round(X2020,2))

#The Top 10 Countries with the Largest Life Expectancy gains since 1960 to 2020
top_10_hleg <- LifeExpect %>%
  mutate(gain = X2020 - X1960) %>%
  top_n(10, wt = gain) %>%
  arrange(-gain) %>%
  mutate(gain_str = paste(format(round(gain, 2)), "total (years)")) %>%
  dplyr::select(Country.Name, gain_str)

#world map & the Life Expectation in 2020 
comb_data_map_le <- joinCountryData2Map(
  LifeExpect,
  joinCode = "ISO3",
  nameJoinColumn = "Country.Code",
  mapResolution = "high"
)


#Life expectancy and depressive symptoms
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

#The Highest LE in the EU in 2020
EU_HighLE <- EU_LifeExpect %>%
  filter(X2020 == max(X2020, na.rm = T)) %>%
  dplyr::select(Country.Name, X2020) %>%
  mutate(eu_hlifexp = round(X2020,2))

#The Lowest Fertility Rate in the World in 2020
EU_LowLE <- EU_LifeExpect%>%
  filter(X2020 == min(X2020, na.rm = T)) %>%
  dplyr::select(Country.Name, X2020) %>%
  mutate(eu_llifexp = round(X2020,2))

#map LE in EU countries in 2020
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

DEPR_EU <- data.frame(Country.Code, Depr_sympt)

#new data frame with depressive symptoms and life expectancy
EU_LifeExpect_depr <- left_join(EU_LifeExpect, DEPR_EU, comb_data_agewom_fr_contr_gdp$GDP_per_cap2020, by = "Country.Code")

#correlation: GDP and depressive symptoms
cor(comb_data_agewom_fr_contr_gdp$GDP_per_cap2020, EU_LifeExpect_depr$Depr_sympt, use = "complete.obs") 

#correlation: Life expectancy and GDP
cor(EU_LifeExpect_depr$X2020, comb_data_agewom_fr_contr_gdp$GDP_per_cap2020, use = "complete.obs") 


#other method   
test <- cor.test(EU_LifeExpect_depr$X2020, comb_data_agewom_fr_contr_gdp$GDP_per_cap2020, use = "complete.obs")
test

#joins column with GDP value to EU_LifeExpect_depr 
EU_LE_DEPR_GDP <- cbind(EU_LifeExpect_depr, GDP_per_cap2020 = comb_data_agewom_fr_contr_gdp$GDP_per_cap2020)


#ggpairs
ggpLE <- ggpairs(EU_LE_DEPR_GDP, 
              columns = c("X2020", "Depr_sympt", "GDP_per_cap2020"),
              title = "Correlations",
              columnLabels = c("Life expect", "Depression sympt", "GDP per cap"),
              upper = list(continuous = wrap("cor", size = 2.5)),
              lower = list(continuous = "smooth"))
ggpLE


### Others correlations -> results: weak correlations
cor(FertRateTot$X2020, LaborFem$LF2020, use = "complete.obs") 
cor(EU_BirthRate$X2020, EU_LaborFem$LF2020, use = "complete.obs")
cor(EU_FertRateTot$X2020, EU_LaborFem$LF2020, use = "complete.obs") 
cor(comb_data_agewom_fr_contr_gdp$GDP_per_cap2020, EU_LaborFem$LF2020, use = "complete.obs")
cor(comb_data_agewom_fr_contr_gdp$Mean_Age,EU_LaborFem$LF2020, use = "complete.obs") 
cor(comb_data_agewom_fr_contr_gdp$AnyMethod, EU_LaborFem$LF2020, use = "complete.obs") 
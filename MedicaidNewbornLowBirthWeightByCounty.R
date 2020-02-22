## Based on data from here:
##     https://health.data.ny.gov/Health/Medicaid-Inpatient-Prevention-Quality-Indicator-PQ/aapx-etcg



## INIT ========================================================================
library(tidyverse)


## VARS ========================================================================

## Our data vars.
data_url <- "https://health.data.ny.gov/api/views/aapx-etcg/rows.csv?accessType=DOWNLOAD"
dest_file <- "MedicaidNewbornLowBirthWeightByCounty.csv"

## Defines county regions.
wny <- c("Niagara", "Erie", "Chautauqua", "Cattaraugus", "Allegany")
fl  <- c("Orleans", "Genesee", "Wyoming", "Monroe", "Livingston", "Wayne", "Ontario", "Yates", "Seneca")
st  <- c("Steuben", "Schuyler", "Chemung", "Tompkins", "Tioga", "Chenango", "Broome", "Delaware")
cny <- c("Cortland", "Cayuga", "Onondaga", "Oswego", "Madison")
nc  <- c("St Lawrence", "Lewis", "Jefferson", "Hamilton/Schuyler", "Essex", "Clinton", "Franklin")
mv  <- c("Oneida", "Herkimer", "Fulton", "Montgomery", "Otsego", "Schoharie")
cd  <- c("Albany", "Columbia", "Greene", "Warren", "Washington", "Saratoga", "Schenectady", "Rensselaer")
hv  <- c("Sullivan", "Ulster", "Dutchess", "Orange", "Putnam", "Rockland", "Westchester")
nyc <- c("New York", "Bronx", "Queens", "Kings", "Richmond")
li  <- c("Nassau", "Suffolk")

## Defines Upstate/Downstate
ups <- c("Western New York","Finger Lakes", "Southern Tier", "Central New York", "North Country", "Nohawk Valley", "Capital District")



## DATA ========================================================================
Data <- read_csv(data_url)
names(Data) <- c("Year","County","LowBirthWeightNewborns","NewbornPopulation", "Observed")
Data <- Data %>%
    filter(County != "Statewide") %>%
    mutate(County = case_when(County == "New" ~ "New York",
                              TRUE            ~ County),
           Region = case_when(County %in% wny ~ "Western New York",
                              County %in%  fl ~ "Finger Lakes",
                              County %in%  st ~ "Southern Tier",
                              County %in% cny ~ "Central New York",
                              County %in%  nc ~ "North Country",
                              County %in%  mv ~ "Mohawk Valley",
                              County %in%  cd ~ "Capital District",
                              County %in%  hv ~ "Hudson Valley",
                              County %in% nyc ~ "New York City",
                              County %in%  li ~ "Long Island"),
           Upstate = case_when(Region %in% ups ~ TRUE,
                               TRUE            ~ FALSE),
           Burrough = case_when(County == "New York" ~ "Manhattan",
                                County == "Bronx"    ~ "The Bronx",
                                County == "Queens"   ~ "Queens",
                                County == "Kings"    ~ "Brooklyn",
                                County == "Richmond" ~ "Staten Island",
                                TRUE                 ~ as.character(NA))) %>%
    select(Year, County, Burrough, Region, Upstate, LowBirthWeightNewborns, NewbornPopulation)

write_csv(Data, dest_file, append = FALSE)

# Set up workspace
setwd("/Users/Josh/Documents/Spring 2016/DataScience/Project2/project2-cycle2-8/")
library(shiny)
library(dplyr)
library(data.table)
library(leaflet)

# Read in data
water <- readRDS("data/data_4.Rds")
water_qual <- readRDS("data/water_quality.rds")
# https://data.cityofnewyork.us/Environment/Drinking-Water-Quality-Distribution-Monitoring-Dat/bkwf-xfky

# Make map
m <- leaflet()
m <- addTiles(m)
m <- setView(m, 74.0059, 40.7127, zoom = 18)
m  # the RStudio 'headquarter'
water_qual[water_qual$Turbidity > 1 & grepl('12', water_qual$Date)]$Turbidity
leaflet(width="100%") %>% addProviderTiles("Stamen.TonerLite") %>% addMarkers(74.0059, 40.7127, popup="The birthplace of R") %>% setView(74.0059, 40.7127, zoom = 18)
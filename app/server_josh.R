setwd("/Users/Josh/Documents/Spring 2016/DataScience/Project2/project2-cycle2-8/")
library(shiny)
library(dplyr)
library(data.table)

# Read in data
water <- readRDS("data/data_4.Rds")
water_qual <- readRDS("data/water_quality.rds")
# https://data.cityofnewyork.us/Environment/Drinking-Water-Quality-Distribution-Monitoring-Dat/bkwf-xfky

# Make map
#m = leaflet() %>% addTiles() %>% setView(74.0059, 40.7127, zoom = 18)

#drink_water <- filter(water, water$Complaint.Type == "Drinking Water")
#quality_water <- filter(water, water$Complaint.Type == "Water Quality")
#hot_water <- filter(water, water$Complaint.Type == "HEAT/HOT WATER")
#conserve_water <- filter(water, water$Complaint.Type == "Water Conservation")
#standing_water <- filter(water, water$Complaint.Type == "Standing Water")
#puddle <- filter(water, water$Complaint.Type == "Standing Water" & water$Descriptor == "Puddle in Ground")
#water_leak <- filter(water, water$Complaint.Type == "WATER LEAK")
#system_water <- filter(water, water$Complaint.Type == "Water System")
# https://data.cityofnewyork.us/Environment/Drinking-Water-Quality-Distribution-Monitoring-Dat/bkwf-xfky

shinyServer(function(input, output) {
  output$mymap <- renderLeaflet({
    leaflet() %>% addTiles() %>% setView(74.0059, 40.7127, zoom = 18)
  })
})
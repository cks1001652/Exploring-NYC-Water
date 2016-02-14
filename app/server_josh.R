library(shiny)
library(dplyr)

water <- readRDS("../data/data_2.Rds")
drink_water <- filter(water, water$Complaint.Type == "Drinking Water")
quality_water <- filter(water, water$Complaint.Type == "Water Quality")
hot_water <- filter(water, water$Complaint.Type == "HEAT/HOT WATER")
conserve_water <- filter(water, water$Complaint.Type == "Water Conservation")
standing_water <- filter(water, water$Complaint.Type == "Standing Water")
puddle <- filter(water, water$Complaint.Type == "Standing Water" & water$Descriptor == "Puddle in Ground")
water_leak <- filter(water, water$Complaint.Type == "WATER LEAK")

# https://data.cityofnewyork.us/Environment/Drinking-Water-Quality-Distribution-Monitoring-Dat/bkwf-xfky
shinyServer(function(input, output) {
  
})
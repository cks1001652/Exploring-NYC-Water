setwd("/Users/Josh/Documents/Spring 2016/DataScience/Project2/project2-cycle2-8/")
library(shiny)
library(dplyr)
library(data.table)

water <- readRDS("data/data_4.Rds")
water_qual <- fread("data/water_quality.csv")
water_quality <- saveRDS(water_qual, file="data/water_quality.rds")
water_qual[water_qual$Turbidity > 1 & grepl('12', water_qual$Date)]$Turbidity
water_qual[water_qual$Turbidity > 5]


drink_water <- filter(water, water$Complaint.Type == "Drinking Water")
quality_water <- filter(water, water$Complaint.Type == "Water Quality")
hot_water <- filter(water, water$Complaint.Type == "HEAT/HOT WATER")
conserve_water <- filter(water, water$Complaint.Type == "Water Conservation")
standing_water <- filter(water, water$Complaint.Type == "Standing Water")
puddle <- filter(water, water$Complaint.Type == "Standing Water" & water$Descriptor == "Puddle in Ground")
water_leak <- filter(water, water$Complaint.Type == "WATER LEAK")
system_water <- filter(water, water$Complaint.Type == "Water System")
# https://data.cityofnewyork.us/Environment/Drinking-Water-Quality-Distribution-Monitoring-Dat/bkwf-xfky
shinyServer(function(input, output) {
  
})
setwd("/Users/Josh/Documents/Spring 2016/DataScience/Project2/project2-cycle2-8/")
library(shiny)
library(dplyr)
library(data.table)
library(png)

# Read in data
water <- readRDS("data/data_4.Rds")
water$Created.Date <- NULL
water$Resolution.Action.Updated.Date <- NULL
water_qual <- readRDS("data/water_quality.rds")
# https://data.cityofnewyork.us/Environment/Drinking-Water-Quality-Distribution-Monitoring-Dat/bkwf-xfky

drink_water <- filter(water, water$Complaint.Type == "Drinking Water")
quality_water <- filter(water, water$Complaint.Type == "Water Quality")
#hot_water <- filter(water, water$Complaint.Type == "HEAT/HOT WATER")
#conserve_water <- filter(water, water$Complaint.Type == "Water Conservation")
#standing_water <- filter(water, water$Complaint.Type == "Standing Water")
#puddle <- filter(water, water$Complaint.Type == "Standing Water" & water$Descriptor == "Puddle in Ground")
#water_leak <- filter(water, water$Complaint.Type == "WATER LEAK")
#system_water <- filter(water, water$Complaint.Type == "Water System")
# https://data.cityofnewyork.us/Environment/Drinking-Water-Quality-Distribution-Monitoring-Dat/bkwf-xfky

shinyServer(function(input, output) {
  output$mymap <- renderLeaflet({
    leaflet(drink_water) %>% addTiles() %>% addProviderTiles("CartoDB.DarkMatter") %>%setView(lng = -73.9857, lat = 40.7577, zoom = 12) %>% addCircleMarkers(radius=6, fillOpacity = 0.5, popup = ~as.character(Date), clusterOptions = markerClusterOptions())
  })
  output$text1 = renderText({
      paste("{ ", man.nbhd[as.numeric(input$nbhd)+1], " }")
  })
  
  
})
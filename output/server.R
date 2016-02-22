library(shiny)
library(dplyr)
library(data.table)
library(wordcloud)
library(plotly)
library(zoo)
library(leaflet)
water <- readRDS("~/Github/project2-cycle2-8/data/data_4.Rds")
water$Created.Date <- NULL
water$Resolution.Action.Updated.Date <- NULL
water$Date <- format(as.yearmon(water$Date, "%Y-%m-%d"), "%Y")
water$Date <- as.factor(water$Date)
waternew <- data.frame(c(water[,c("Complaint.Type","Borough","Latitude","Longitude","Date")]))
system.time(source(file = "~/Github/project2-cycle2-8/output/part1.R"))
shinyServer(function(input, output) {
#   output$histo <- renderPlot({
#     if ( input$borough=="BRONX"& input$year == "All" ){
#       watertypedata0 <- dataclean(waternew,fulllist[1],fulltime)
#     }
#     if ( input$borough=="BROOKLYN"& input$year == "All" ){
#       watertypedata0 <- dataclean(waternew,fulllist[2],fulltime)
#     }
#     if ( input$borough=="MANHATTAN"& input$year == "All" ){
#       watertypedata0 <- dataclean(waternew,fulllist[3],fulltime)
#     }
#     if ( input$borough=="QUEENS"& input$year == "All" ){
#       watertypedata0 <- dataclean(waternew,fulllist[4],fulltime)}
#     if ( input$borough=="STATEN ISLAND"& input$year == "All" ){
#       watertypedata0 <- dataclean(waternew,fulllist[5],fulltime)}
#     if ( input$borough=="BRONX"& input$year == 2013 ){
#       watertypedata0 <- dataclean(waternew,fulllist[1],fulltime[1])}
#     if ( input$borough=="BROOKLYN"& input$year == 2013 ){
#       watertypedata0 <- dataclean(waternew,fulllist[2],fulltime[1])}
#     if ( input$borough=="MANHATTAN"& input$year == 2013 ){
#       watertypedata0 <- dataclean(waternew,fulllist[3],fulltime[1])}
#     if ( input$borough=="QUEENS"& input$year == 2013 ){
#       watertypedata0 <- dataclean(waternew,fulllist[4],fulltime[1])}
#     if ( input$borough=="STATEN ISLAND"& input$year == 2013 ){
#       watertypedata0 <- dataclean(waternew,fulllist[5],fulltime[1])}
#     if ( input$borough=="BRONX"& input$year == 2014 ){
#       watertypedata0 <- dataclean(waternew,fulllist[1],fulltime[2])}
#     if ( input$borough=="BROOKLYN"& input$year == 2014 ){
#       watertypedata0 <- dataclean(waternew,fulllist[2],fulltime[2])}
#     if ( input$borough=="MANHATTAN"& input$year == 2014 ){
#       watertypedata0 <- dataclean(waternew,fulllist[3],fulltime[2])}
#     if ( input$borough=="QUEENS"& input$year == 2014 ){
#       watertypedata0 <- dataclean(waternew,fulllist[4],fulltime[2])}
#     if ( input$borough=="STATEN ISLAND"& input$year == 2014 ){
#       watertypedata0 <- dataclean(waternew,fulllist[5],fulltime[2])}
#     if ( input$borough=="BRONX"& input$year == 2015 ){
#       watertypedata0 <- dataclean(waternew,fulllist[1],fulltime[3])}
#     if ( input$borough=="BROOKLYN"& input$year == 2015 ){
#       watertypedata0 <- dataclean(waternew,fulllist[2],fulltime[3])}
#     if ( input$borough=="MANHATTAN"& input$year == 2015 ){
#       watertypedata0 <- dataclean(waternew,fulllist[3],fulltime[3])}
#     if ( input$borough=="QUEENS"& input$year == 2015 ){
#       watertypedata0 <- dataclean(waternew,fulllist[4],fulltime[3])}
#     if ( input$borough=="STATEN ISLAND"& input$year == 2015 ){
#       watertypedata0 <- dataclean(waternew,fulllist[5],fulltime[3])}
#     
#     histo(watertypedata0,"#56B4F9")
#     },bg="transparent")
#   output$piechart <- renderPlot({
#     
#     if ( input$borough=="BRONX"& input$year == "All" ){
#       watertypedata0 <- dataclean(waternew,fulllist[1],fulltime)
#       watertypedata <- calculation(watertypedata0)}
#     if ( input$borough=="BROOKLYN"& input$year == "All" ){
#       watertypedata0 <- dataclean(waternew,fulllist[2],fulltime)
#       watertypedata <- calculation(watertypedata0)}
#     if ( input$borough=="MANHATTAN"& input$year == "All" ){
#       watertypedata0 <- dataclean(waternew,fulllist[3],fulltime)
#       watertypedata <- calculation(watertypedata0)}
#     if ( input$borough=="QUEENS"& input$year == "All" ){
#       watertypedata0 <- dataclean(waternew,fulllist[4],fulltime)
#       watertypedata <- calculation(watertypedata0)}
#     if ( input$borough=="STATEN ISLAND"& input$year == "All" ){
#       watertypedata0 <- dataclean(waternew,fulllist[5],fulltime)
#       watertypedata <- calculation(watertypedata0)}
#     if ( input$borough=="BRONX"& input$year == 2013 ){
#       watertypedata0 <- dataclean(waternew,fulllist[1],fulltime[1])
#       watertypedata <- calculation(watertypedata0)}
#     if ( input$borough=="BROOKLYN"& input$year == 2013 ){
#       watertypedata0 <- dataclean(waternew,fulllist[2],fulltime[1])
#       watertypedata <- calculation(watertypedata0)}
#     if ( input$borough=="MANHATTAN"& input$year == 2013 ){
#       watertypedata0 <- dataclean(waternew,fulllist[3],fulltime[1])
#       watertypedata <- calculation(watertypedata0)}
#     if ( input$borough=="QUEENS"& input$year == 2013 ){
#       watertypedata0 <- dataclean(waternew,fulllist[4],fulltime[1])
#       watertypedata <- calculation(watertypedata0)}
#     if ( input$borough=="STATEN ISLAND"& input$year == 2013 ){
#       watertypedata0 <- dataclean(waternew,fulllist[5],fulltime[1])
#       watertypedata <- calculation(watertypedata0)}
#     if ( input$borough=="BRONX"& input$year == 2014 ){
#       watertypedata0 <- dataclean(waternew,fulllist[1],fulltime[2])
#       watertypedata <- calculation(watertypedata0)}
#     if ( input$borough=="BROOKLYN"& input$year == 2014 ){
#       watertypedata0 <- dataclean(waternew,fulllist[2],fulltime[2])
#       watertypedata <- calculation(watertypedata0)}
#     if ( input$borough=="MANHATTAN"& input$year == 2014 ){
#       watertypedata0 <- dataclean(waternew,fulllist[3],fulltime[2])
#       watertypedata <- calculation(watertypedata0)}
#     if ( input$borough=="QUEENS"& input$year == 2014 ){
#       watertypedata0 <- dataclean(waternew,fulllist[4],fulltime[2])
#       watertypedata <- calculation(watertypedata0)}
#     if ( input$borough=="STATEN ISLAND"& input$year == 2014 ){
#       watertypedata0 <- dataclean(waternew,fulllist[5],fulltime[2])
#       watertypedata <- calculation(watertypedata0)}
#     if ( input$borough=="BRONX"& input$year == 2015 ){
#       watertypedata0 <- dataclean(waternew,fulllist[1],fulltime[3])
#       watertypedata <- calculation(watertypedata0)}
#     if ( input$borough=="BROOKLYN"& input$year == 2015 ){
#       watertypedata0 <- dataclean(waternew,fulllist[2],fulltime[3])
#       watertypedata <- calculation(watertypedata0)}
#     if ( input$borough=="MANHATTAN"& input$year == 2015 ){
#       watertypedata0 <- dataclean(waternew,fulllist[3],fulltime[3])
#       watertypedata <- calculation(watertypedata0)}
#     if ( input$borough=="QUEENS"& input$year == 2015 ){
#       watertypedata0 <- dataclean(waternew,fulllist[4],fulltime[3])
#       watertypedata <- calculation(watertypedata0)}
#     if ( input$borough=="STATEN ISLAND"& input$year == 2015 ){
#       watertypedata0 <- dataclean(waternew,fulllist[5],fulltime[3])
#       watertypedata <- calculation(watertypedata0)}
#     piechart(watertypedata)
# 
#             },bg="transparent")
#   
  output$Map <- renderLeaflet({
    if (input$year==4){waterdendata <- dataclean(waternew,fulllist,fulltime)}
    if (input$year==3){waterdendata <- dataclean(waternew,fulllist,fulltime[3])}
    if (input$year==2){waterdendata <- dataclean(waternew,fulllist,fulltime[2])}
    if (input$year==1){waterdendata <- dataclean(waternew,fulllist,fulltime[1])}
    leaflet(waterdendata) %>% addTiles() %>% addProviderTiles("Stamen.TonerLite") %>% 
        setView(lng = -73.9857, lat = 40.7577, zoom = 12)%>%
        addCircleMarkers(radius=6, fillOpacity = 0.5, popup = paste(waterdendata$Date),
                         clusterOptions = markerClusterOptions())
  })
})


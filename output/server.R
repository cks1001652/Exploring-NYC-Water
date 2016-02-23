library(shiny)
library(dplyr)
library(plyr)
library(data.table)
library(wordcloud)
library(plotly)
library(zoo)
library(rCharts)
library(leaflet)
# call function from previous code
system.time(source(file = "~/Github/project2-cycle2-8/output/part1.R"))
# data clean


#Call function and data
system.time(source(file = "~/Github/project2-cycle2-8/output/part1.R"))

shinyServer(function(input, output) {
  output$piechart <- renderPlotly({
    watertypedata0 <- calculation(dataclean(waternew,fulllist[as.numeric(input$borough)],fulltime[as.numeric(input$year)]))
        q <- plot_ly(type='pie',values=watertypedata0[,4],labels=watertypedata0[,1])%>%
      layout(paper_bgcolor='rgba(0,0,0,0)',plot_bgcolor='rgba(0,0,0,0)',title='Complaint Types Proportion')
        q

                     })
    
  output$baseMap  <- renderMap({
    baseMap <- Leaflet$new()
    baseMap$setView(c(40.7577,-73.9857), 10)
    baseMap$tileLayer(provider = "Stamen.TonerLite")
    baseMap
  })
  
  output$heatMap <- renderUI({
    watermap <- waternew1[waternew1[,3]==input$year,]
    watermap <- as.data.table(watermap)
    watermap <- watermap[(Latitude != ""), .(count = .N), by=.(Latitude, Longitude)]
    j <- paste0("[",watermap[,Latitude], ",", watermap[,Longitude], ",", watermap[,count], "]", collapse=",")
    j <- paste0("[",j,"]")
    tags$body(tags$script(HTML(sprintf("
                                var addressPoints = %s
if (typeof heat === typeof undefined) {
            heat = L.heatLayer(addressPoints)
            heat.addTo(map)
          } else {
            heat.setOptions()
            heat.setLatLngs(addressPoints)
          }"
                                       , j))))
  }) 
})


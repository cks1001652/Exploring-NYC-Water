setwd("~/ADS PROJECT 2 - My stuff/My_Shiny_2_ADS")
library(shiny)
library(dplyr)
library(data.table)
library(plyr)
library(rCharts)

# Read in data
shiny2_YAY <- readRDS("shiny2_YAY.Rds")
#####

require(rCharts)
shinyServer(function(input, output) {
  output$myChart <- renderChart({
    names(shiny2_YAY) = gsub("\\.", "", names(shiny2_YAY))
    p1 <- rPlot(input$x, input$y, data = shiny2_YAY, color = "Borough", 
                type = 'point')
    p1$addParams(dom = 'myChart')
    return(p1)
  })
})

setwd("~/ADS PROJECT 2 - My stuff/My_Shiny_ADS")
library(datasets)
library(shiny)

final_shiny <- readRDS("final_shiny.Rds")

# Define a server for the Shiny app
shinyServer(function(input, output) {
  
  # Fill in the spot we created for a plot
  output$duplicatePlot <- renderPlot({
    
    # Render a barplot
    barplot(final_shiny[,input$borough],
            main=input$borough,
            col = topo.colors(12),
            ylab="Number of Duplicate Complaints",
            xlab="Year", ylim=c(0,max(final_shiny)))
    })
  })

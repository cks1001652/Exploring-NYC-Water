library(shiny)
shiny2_stacked <- readRDS("shiny2_stacked.Rds")

require(rCharts)
shinyServer(function(input, output) {
  output$myChart <- renderChart({
    shiny2 = as.data.frame(shiny2_stacked)
    p6 <- nPlot(Frequency ~ Borough, group = 'Type', data = shiny2, 
                type = input$type, dom = 'myChart', width = 800)
    p6$chart(color = c('green', 'brown'), stacked = input$stack)
    
    p6$yAxis(tickFormat = "#! function(d) {return d3.format(',.2f')(d)} !#")
    
    return(p6)
  })
})

require(rCharts)
library(shiny)
shinyUI(pageWithSidebar(
  headerPanel("Lots of Good Stuff!"),
  
  sidebarPanel(
    selectInput(inputId = "x",
                label = "Choose X",
                choices = c('Frequency2015', 'Frequency2014', 'Frequency2013'),
                selected = "Frequency2015"),
    selectInput(inputId = "y",
                label = "Choose Y",
                choices = c('Duplicates', 'NotDuplicates', 'TotalFrequency'),
                selected = "Duplicates")
  ),
  mainPanel(
    showOutput("myChart", "polycharts")
  )
))
        
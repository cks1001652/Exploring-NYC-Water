require(rCharts)
shinyUI(pageWithSidebar(
  headerPanel("Lots of Good Stuff!"),
  
  sidebarPanel(
    selectInput(inputId = "x",
                label = "Choose X",
                choices = c('2015Frequency', '2014Frequency', '2013Frequency'),
                selected = "2015Frequency"),
    selectInput(inputId = "y",
                label = "Choose Y",
                choices = c('Duplicates', 'NotDuplicates', 'TotalFrequency'),
                selected = "Duplicates")
  ),
  mainPanel(
    showOutput("myChart", "polycharts")
  )
))
        
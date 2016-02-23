require(rCharts)
shinyUI(pageWithSidebar(
  headerPanel("Duplicate Heat/Hot Water Requests Submitted by Borough"),
  
  sidebarPanel(
    selectInput(inputId = "type",
                label = "Choose Chart Type",
                choices = c("multiBarChart", "multiBarHorizontalChart"),
                selected = "multiBarChart"),
    checkboxInput(inputId = "stack",
                  label = strong("Stack Bars?"),
                  value = FALSE)
  ),
  mainPanel(
    showOutput("myChart", "nvd3")
  )
))



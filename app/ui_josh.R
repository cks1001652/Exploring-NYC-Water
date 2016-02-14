shinyUI(fluidPage(theme = "style.css",
  
  titlePanel("Water Project"),
  tags$body(
    sidebarLayout(position = "right",
      sidebarPanel("sidebar panel"),
      mainPanel("main panel")
    )
  )
))
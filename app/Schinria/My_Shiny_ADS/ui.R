library(shiny)

# Define the overall UI
shinyUI(
  
  # Use a fluid Bootstrap layout
  fluidPage(    
    
    # Give the page a title
    titlePanel("Duplicate Heat/Hot Water Complaints By Year"),
    
    # Generate a row with a sidebar
    sidebarLayout(      
      
      # Define the sidebar with one input
      sidebarPanel(
        selectInput("borough", "Borough:", 
                    choices=colnames(final_shiny)),
        hr(),
        helpText("Boroughs of NYC that had complaints filed through 311 Service Requests")
      ),
      
      # Create a spot for the barplot
      mainPanel(
        plotOutput("duplicatePlot")  
      )
      
    )
  )
)
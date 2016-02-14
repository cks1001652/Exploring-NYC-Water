shinyUI(navbarPage("Exploring NYC's Water", theme = "style.css",
  #tags$body(
#################### Start of a Menu Item ####################  
    tabPanel("Overview",
      # Sidebar with a selector input for neighborhood
      sidebarLayout(
        sidebarPanel(
  
        ),
        # Show main panel
        mainPanel(
          #h3(code(textOutput("text1"))),
          
        )
      )      
    ),
#################### End of the Menu Item ####################

#################### Start Josh's Menu Item ####################
    tabPanel("Water Quality",  
      # Sidebar with a selector input for neighborhood
      sidebarLayout(position="right",
        sidebarPanel(
  
        ),
        # Show main panel
        mainPanel(
          #h3(code(textOutput("text1"))),
          tabsetPanel(type="pill",
            # Panel 1 is a bubble chart showing descriptors
            tabPanel("Reported Water Quality"), 
            # Panel 2 is a line chart comparing water quality
            tabPanel("Sampled Water Quality"),
            # Panel 3 is a map showing illness
            tabPanel("Illness", leafletOutput("mymap"))
          )
        )
      )
    )
#################### End of Josh's Menu Item ####################
    
  #)
))
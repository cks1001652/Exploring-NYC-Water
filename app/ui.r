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
          conditionalPanel(condition="input.conditionedPanels==1",
            helpText("View the various descriptions of individual reported problems with NYC Water"),
            br(),
            sliderInput("desc_range", 
              label = "Range of Number of Descriptors",
              min = 0, max = 13, value = c(0, 13))
          ),
          conditionalPanel(condition="input.conditionedPanels==2",
            helpText("Choose a complaint description to see correlation with sampled water"),
            br(),
            selectInput("complaint_desc", 
              label = "Choose a description",
              choices = list("All", "Chemical Taste", "Clear with Insects/Worms", "Clear w/ Particles", "Cloudy Water", "Metallic Taste/Odor", "Musty Taste/Odor", "Milky Water", "Oil in Water", "Sewer Taste/Odor", "Unknown Taste"),
              selected = "All complaints")
          ),
          conditionalPanel(condition="input.conditionedPanels==3",
            helpText("Cluster Graph of Reported Illness due to Drinking Water")
          )
        ),
        # Show main panel
        mainPanel(
          tabsetPanel(type="pill",
            # Panel 1 is a bubble chart showing descriptors
            tabPanel("Reported Water Quality", br(), tags$div(class="descrip_text", textOutput("descrip_text")), br(), tags$div(class="descrip_plot", plotOutput("descrip_plot")), value=1), 
            # Panel 2 is a line chart comparing water quality
            tabPanel("Sampled Water Quality", br(), tags$div(class="descrip_text", textOutput("sample_text")), br(), plotlyOutput("sample_plot"), value=2),
            # Panel 3 is a map showing illness
            tabPanel("Illness", br(), leafletOutput("ill_map"), value=3),
            id = "conditionedPanels"
          ) 
        )
      )
    )
#################### End of Josh's Menu Item ####################
    
  #)
))
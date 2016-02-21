library(shiny)
library(leaflet)

shinyUI(
  fluidPage(
    fluidRow(
      column(3,
             h3("Resolution Time"),
             sidebarPanel(width = 12,
                          
                          conditionalPanel(condition = "input.conditionedPanels == 1",
                                           selectInput("cases", "Case Status:", 
                                                       choices = list( "Open" = 1, "Closed" = 2), selected = 1)),
                          
                          conditionalPanel(condition = "input.conditionedPanels == 2 ",
                                           selectInput("time", "Timeline by Boroughs:", 
                                                       choices = list("All Boroughs" = 1,
                                                                      "BRONX " = 2,
                                                                      "BROOKLYN" = 3,
                                                                      "MANHATTAN" = 4,
                                                                      "QUEENS" = 5,
                                                                      "STATEN ISLAND" = 6),selected = 1),
                                           selectInput("compare", "Between-Boroughs Comparison:", 
                                                       choices = list("NONE" = 1,
                                                                      "BRONX " = 2, 
                                                                      "BROOKLYN" = 3,
                                                                      "MANHATTAN" = 4,
                                                                      "QUEENS" = 5,
                                                                      "STATEN ISLAND" = 6),selected = 1),
                                           
                                           selectInput("type", "Complaint.Type Timeline:", 
                                                       choices = list("DrinkingWater" = 1,
                                                                      "HEAT/HOT WATER" = 2, 
                                                                      "Water System" = 3,
                                                                      "Water Leak" = 4), selected = 1),
                                           
                                           selectInput("com", "Between-Boroughs Comparison:", 
                                                       choices = list("NONE" = 0,
                                                                      "DrinkingWater" = 1,
                                                                      "HEAT/HOT WATER" = 2, 
                                                                      "Water System" = 3,
                                                                      "Water Leak" = 4), selected = 0)),
                          
                          conditionalPanel(condition = "input.conditionedPanels == 3",
                                           selectInput("status", "Time Spent:", 
                                                       choices = list("By Boroughs" = 1,
                                                                      "By ComplaintType" = 2), selected = 1))
                          
        
                          )),
      
      column(9,mainPanel(width = 11,tabsetPanel(id = "conditionedPanels",
                                                
                                                tabPanel("Summary",
                                                         fluidRow(column(12,plotlyOutput("case1", width="400px",height="400px")),
                                                                  column(6,plotlyOutput("case2", width="350px",height="350px")),
                                                                  column(6,plotlyOutput("case3", width="350px",height="350px"))),value = 1),
                                                
                                                tabPanel("Timeline",
                                                         dygraphOutput("dygraph", width="800px",height="300px"),
                                                         dygraphOutput("dygraph2", width="800px",height="300px"), value = 2), 
                                                
                                                tabPanel("Time Spent",
                                                         plotlyOutput("plot", width="800px",height="500px"),
                                                         tableOutput("view"), value = 3),
                                                
                                                tabPanel("Map", leafletOutput("map", width="800px",height="500px"))

                                                ))))))




library(rCharts)
library(shiny)
shinyUI(
  fluidPage(navbarPage("Exploring NYC's Water", theme = "style.css",
                       tabPanel("sda"),
                       navbarMenu("Overview",
                                  tabPanel("Basic Information",
                                           fluidRow(
                                             column(4,sidebarPanel(width=10,helpText("We disply the proportion of the Complaints type and Year it happened"),
                                                          selectInput("year","Choose a Year to display",
                                                                      choices = list("2013"=1,"2014"=2,"2015"=3),
                                                                      selected = 1),
                                                          selectInput("borough","Choose a Borough to display",
                                                                      choices = list("BRONX"=1,"BROOKLYN"=2,"MANHATTAN"=3,"QUEENS"=4,"STATEN ISLAND"=5),
                                                                      selected = 1)
                                                          )),
                                             column(8,mainPanel(width=12,plotlyOutput('piechart',height="600px")
                                                                
                                                                ))
                                             )),

                                  tabPanel("Density Map",
                                    sidebarPanel(width=4,helpText("We disply the Density/Heat Map of the Complaints in each Year"),
                                                          selectInput("year","Choose a Year to display",
                                                                      choices = list("2013"=1,"2014"=2,"2015"=3),
                                                                      selected =1)
                                                      ),
                                    mainPanel(width=8,chartOutput("baseMap", "leaflet"),
                                              tags$style('.leaflet {height: 500px;}'),
                                              tags$head(tags$script(src="http://leaflet.github.io/Leaflet.heat/dist/leaflet-heat.js")),
                                              uiOutput('heatMap')
                                              )
                                         )),
                       tabPanel("sad")
    )
  )
)







# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# shinyUI(fluidPage(navbarPage("Exploring NYC's Water", theme = "style.css",
# #                    tabPanel("Overview",
# #                             sidebarLayout(position="left",
# #                                           sidebarPanel(),
# #                                           mainPanel()
# #                                           )
# #                             ),
#                    navbarMenu("Complaint Types",
#                               tabPanel("Basic Plots",
#                                        mainPanel(width=12,plotOutput('piechart')),
#                                        
#                                                      
# #                                                      mainPanel(width=12,plotOutput('piechart'))                                                  
#                                                      
#                                        )
# #                               tabPanel("Map"),
# #                               tabPanel("3D")
#                               )
#                    )
#         ))
#                    
#                    
# # tabPanel("test1",
# # sidebarPanel(width=3,
# #    conditionalPanel(condition = "input.conditionedPanels == 1",
# #                    selectInput("borough", "Choose a Borough to display",
# #                                choices = list("BRONX"=1,"BROOKLYN"=2,"MANHATTAN"=3,"QUEENS"=4,"STATEN ISLAND"=5),
# #                                selected = 1)),
# #    conditionalPanel(condistion='input.conditionedPanels == 2',
# #                     selectInput("year","Choose a Year",
# #                                 choices = list("2015"=1,"2014"=2,"2013"=3),
# #                                 selected = 1))
# #   
# #             ),
# # 
# # mainPanel(width=9,
# #           
# #           )
library(shiny)
library(ggplot2)
library(dplyr)
library(plotly)
require(lubridate)
library(dygraphs)
library(xts)
library(leaflet)

##
A <- readRDS("~/Desktop/ONE.Rds")
FIVE <- readRDS("~/Desktop/FIVE.Rds")
THREE <- readRDS("~/Desktop/THREE.Rds")

C <- data.frame(Borough = A$Borough[A$Status == "Closed"], 
                Complaint.Type = A$Complaint.Type[A$Status == "Closed"],Days = A$Days[A$Status == "Closed"])

G <- data.frame(Borough = A$Borough[A$Status == "Open"], Complaint.Type = A$Complaint.Type[A$Status == "Open"])

P <- data.frame(Borough = A$Borough[A$Status == "Closed"], Complaint.Type = A$Complaint.Type[A$Status == "Closed"])

#shinyserver
shinyServer(
  function(input, output) {
    
    output$dygraph <- renderDygraph({
      data <- switch(input$time, 
                   "1" = FIVE[,1],
                   "2" = FIVE[,2],
                   "3" = FIVE[,3],
                   "4" = FIVE[,4],
                   "5" = FIVE[,5],
                   "6" = FIVE[,6])
      
      data2 <- switch(input$compare, 
                    "1" = NULL,
                    "2" = FIVE[,2],
                    "3" = FIVE[,3],
                    "4" = FIVE[,4],
                    "5" = FIVE[,5],
                    "6" = FIVE[,6])
  
      data3 <- cbind(data,data2)
      
      name <- paste(names(data),"    ", names(data2))
      dygraph(data3, main = name) %>% dyRangeSelector()

      })
    
    output$dygraph2 <- renderDygraph({
      
      data <- switch(input$type, 
                     "1" = THREE[,1],
                     "2" = THREE[,2],
                     "3" = THREE[,3],
                     "4" = THREE[,4])

      data2 <- switch(input$com, 
                      "0" = NULL,
                      "1" = THREE[,1],
                      "2" = THREE[,2],
                      "3" = THREE[,3],
                      "4" = THREE[,4])
      
      data3 <- cbind(data,data2)
      
      name <- paste(names(data),"    ", names(data2))
      
      dygraph(data3, main = name) %>% dyRangeSelector()
      
    })
    
    output$plot <- renderPlotly({
      
      if (input$status == 1) {
        
        x <- list(
          showticklabels = F
        )
        
        y <- list(
          range = c(-2,12)
        )
        
        plot_ly(C, x = Borough, y = Days, color = Borough, type = "box", boxmean = T) %>% 
          layout(xaxis = x, yaxis = y, title = "Resolution Time by Boroughs")
        
      }
      
      else {
        
        x <- list(
          showticklabels = F
        )
        
        z <- list(
          range = c(-5,55)
        )
        
        plot_ly(C, x = Complaint.Type, y = Days, color = Complaint.Type, type = "box", boxmean = T) %>% 
          layout(xaxis = x, yaxis = z, title = "Resolution Time by Boroughs")
      }
      
    })
    
    
    output$view <- renderTable({
      
      summary <- data.frame(tapply(
        A$Days[A$Status == "Closed"], list(A$Complaint.Type[A$Status == "Closed"], 
                                           A$Borough[A$Status == "Closed"]), mean, na.rm=TRUE))
      head(summary, n = 8)
  
      })
    
    
    
    output$case1 <- renderPlotly({
      
      plot_ly(A, values = c(length(A$Status[A$Status == "Open"]),length(A$Status[A$Status == "Closed"])), 
              labels=c("Open","Closed"), type="pie")

      })
    
    output$case2 <- renderPlotly({  
  
      if(input$cases == 1) {
        
        Borough <- data.frame(summary(A$Borough[A$Status == "Open"]))
        value <- c(Borough[,1])
        name <- c(rownames(Borough))
        plot_ly(values = value, labels = c(name),type="pie", showlegend = F) %>% 
          layout(title = "Open cases by Borough") 
        
      }
      else {
        
        Borough <- data.frame(summary(A$Borough[A$Status == "Closed"]))
        value <- c(Borough[,1])
        name <- c(rownames(Borough))
        plot_ly(values = value, labels = c(name),type="pie", showlegend = F) %>% 
          layout(title = "Closed cases by Borough") 
        
      } 
      
      })
    
    output$case3 <- renderPlotly({  
      
      if(input$cases == 1) {

        Type <- data.frame(summary(A$Complaint.Type[A$Status == "Open"]))
        value <- c(Type[,1])
        name <- c(rownames(Type))
        plot_ly(values = value, labels = c(name),type="pie", showlegend = F) %>% 
          layout(title = "Open cases by Complaint.Type") 

      }
      else{
 
        Type <- data.frame(summary(A$Complaint.Type[A$Status == "Closed"]))
        value <- c(Type[,1])
        name <- c(rownames(Type))
        plot_ly(values = value, labels = c(name),type="pie" ,showlegend = F) %>% 
          layout(title = "Closed cases by Complaint.Type") 
        
      } 
      
      })
    
    output$map <- renderLeaflet({
      
      leaflet(na.omit(A)) %>% addTiles() %>% addProviderTiles("CartoDB.Positron") %>% 
        setView(lng = -73.9857, lat = 40.7577, zoom = 12) %>% 
        addCircleMarkers(radius=6, fillOpacity = 0.5, popup = paste(A$Days),
                         clusterOptions = markerClusterOptions())
      
    })
})
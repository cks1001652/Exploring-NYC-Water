# setwd("/Users/Josh/Documents/Spring 2016/DataScience/Project2/project2-cycle2-8/")
library(shiny)
# 
library(plyr)
library(dplyr)

library(data.table)
library(wordcloud)

library(plotly)
library(zoo)
library(leaflet)



# Read in data
water <- readRDS("../data/data_4.Rds")
water$Created.Date <- NULL
water$Resolution.Action.Updated.Date <- NULL


################### Josh's Data ####################

water_qual <- readRDS("../data/water_quality.rds")
# https://data.cityofnewyork.us/Environment/Drinking-Water-Quality-Distribution-Monitoring-Dat/bkwf-xfky
water_qual_Turbid <- aggregate(water_qual$Turbidity, list(water_qual$Date), mean)
water_qual_Turbid <- rename(water_qual_Turbid, c("Group.1"="Date", "x"="Turbidity"))
water_qual_Turbid$Date <- format(as.yearmon(water_qual_Turbid$Date, "%m/%d/%Y"), "%m")
water_qual_Turbid <- aggregate(water_qual_Turbid$Turbidity, list(water_qual_Turbid$Date), mean)
water_qual_Turbid <- rename(water_qual_Turbid, c("Group.1"="Date", "x"="Turbidity"))
water_qual_Turbid$Date <- mapvalues(water_qual_Turbid$Date, from = water_qual_Turbid$Date, c("Jan", "Feb", "Mar", "April", "May", "June", "July", "Aug", "Sep", "Oct", "Nov", "Dec"))

water_qual_Chlorine <- aggregate(water_qual$Chlorine, list(water_qual$Date), mean)
water_qual_Chlorine <- rename(water_qual_Chlorine, c("Group.1"="Date", "x"="Chlorine"))
water_qual_Chlorine$Date <- format(as.yearmon(water_qual_Chlorine$Date, "%m/%d/%Y"), "%m")
water_qual_Chlorine <- aggregate(water_qual_Chlorine$Chlorine, list(water_qual_Chlorine$Date), mean)
water_qual_Chlorine <- rename(water_qual_Chlorine, c("Group.1"="Date", "x"="Chlorine"))
water_qual_Chlorine$Date <- mapvalues(water_qual_Chlorine$Date, from = water_qual_Chlorine$Date, c("Jan", "Feb", "Mar", "April", "May", "June", "July", "Aug", "Sep", "Oct", "Nov", "Dec"))


drink_water <- filter(water, water$Complaint.Type == "Drinking Water")
quality_water <- filter(water, water$Complaint.Type == "Water Quality")

quality_water$Descriptor <- mapvalues(quality_water$Descriptor, from = c(unique(quality_water$Descriptor)), to=c("Chlorine Taste/Odor", "Other", "Cloudy Water", "Other Water Problem", "Milky Water", "Unknown Taste", "Metallic Taste/Odor", "Musty Taste/Odor", "Clear w/ Particles", "Chemical Taste", "Sewer Taste/Odor", "Oil in Water", "Other", "Clear with Insects/Worms"))

rep_q_water <- quality_water
rep_q_water <- rep_q_water[grepl("2015", rep_q_water$Date),]
rep_q_water$Date <- (format(as.yearmon(rep_q_water$Date, "%Y-%m-%d"), "%m"))

# Main data table

rep_q_water_table <- as.data.frame(table(rep_q_water$Date, rep_q_water$Descriptor))
rep_q_water_table <- rename(rep_q_water_table, c("Var1"="Date", "Var2"="Descriptor", "Freq"="Number"))
# Total data table
#rep_q_water_table_monthly <- aggregate(rep_q_water_table$Number, list(rep_q_water_table$Date), sum)
#rep_q_water_table_monthly$Group.1 <- mapvalues(rep_q_water_table_monthly$Group.1, from = rep_q_water_table_monthly$Group.1, c("Jan", "Feb", "Mar", "April", "May", "June", "July", "Aug", "Sep", "Oct", "Nov", "Dec"))


source(file = "../app/Global.R")

#################### End of Josh's Data ####################

shinyServer(function(input, output) {

################### Josh's Output ####################
  output$ill_map <- renderLeaflet({
    if(input$ill_year == "All"){
      drink_water2 <- drink_water
    } else {
      drink_water2 <- drink_water[grepl(input$ill_year, drink_water$Date),]
    } 
    
    
    leaflet(na.omit(drink_water2)) %>% addTiles() %>% addProviderTiles("CartoDB.DarkMatter") %>%setView(lng = -73.9857, lat = 40.7577, zoom = 12) %>% addCircleMarkers(radius=6, fillOpacity = 0.5, popup = paste("Location: ", drink_water2$Incident.Address), clusterOptions = markerClusterOptions())
  })
  
  # Make the wordcloud drawing predictable during a session
  wordcloud_rep <- repeatable(wordcloud)

  output$descrip_plot <- renderPlot({
    # min.freq = input$freq, max.words=input$max,
    df <- as.data.frame(table(quality_water$Descriptor))
    par(bg="#f5f5f5")
    wordcloud_rep(df$Var1, df$Freq, min.freq = input$desc_range[1], max.words=input$desc_range[2], scale=c(3,1), random.order = TRUE, random.color=TRUE, rot.per=.3,
                  colors=brewer.pal(8, "Dark2"))
  })
  
  output$descrip_text = renderText({
      paste("Viewing ", input$desc_range[1], " to ", max.words=input$desc_range[2], "descriptors")
  })

  output$sample_text = renderText({
      paste("Graph of ", input$complaint_desc, " Complaints in 2015")
  })

  output$ill_text = renderText({
      paste(input$ill_year, "Cluster Graph of Reported Illness")
  })

  output$sample_plot = renderPlotly({
    x_axis <- list(
      title = "Months in 2015"
    )
    y_axis <- list(
      title = "Turbidity in NTU"
    )
    ay <- list(
      title="Number of Complaints",
      overlaying = "y",
      side = "right"
    )
    
    if(input$complaint_desc == "All"){
      rep_q_water_table2 <- rep_q_water_table
    } else {
      rep_q_water_table2 <- rep_q_water_table[rep_q_water_table$Descriptor== input$complaint_desc,]
    }
    #rep_q_water_table2
    # Total data table
    rep_q_water_table_monthly <- aggregate(rep_q_water_table2$Number, list(rep_q_water_table2$Date), sum)
    rep_q_water_table_monthly$Group.1 <- mapvalues(rep_q_water_table_monthly$Group.1, from = rep_q_water_table_monthly$Group.1, c("Jan", "Feb", "Mar", "April", "May", "June", "July", "Aug", "Sep", "Oct", "Nov", "Dec"))  
    
    
    p<- plot_ly(water_qual_Turbid, x =Date, y =Turbidity, name = "Turbidity Level", colors=brewer.pal(3, "BrBG"), text=paste("Turbidity:", Turbidity, " (NTU)")) %>%
    add_trace(rep_q_water_table_monthly, x=rep_q_water_table_monthly$Group.1, y = rep_q_water_table_monthly$x, name = "NYC Resident Complaints", yaxis = "y2", text=paste("Num of complaints:", rep_q_water_table_monthly$x))
    layout(p, xaxis = x_axis, yaxis=y_axis, yaxis2 = ay)
    
  })


  
################### End of Josh's Output ####################
################### Start Richard's Output###################
output$piechart <- renderPlotly({
#   detach("package:plyr",unload=T)
  watertypedata0 <- calculation(dataclean(waternew,fulllist[as.numeric(input$borough)],fulltime[as.numeric(input$year)]))
  q <- plot_ly(type='pie',values=watertypedata0[,4],labels=watertypedata0[,1])%>%
    layout(paper_bgcolor='rgba(0,0,0,0)',plot_bgcolor='rgba(0,0,0,0)',title='Complaint Types Proportion')
  q
#   library(plyr)
})

output$baseMap  <- renderMap({
  baseMap <- Leaflet$new()
  baseMap$setView(c(40.7577,-73.9857), 10)
  baseMap$tileLayer(provider = "Stamen.TonerLite")
  baseMap
})

output$heatMap <- renderUI({
  
  if (input$mapyear == 3 ){
    watermap <- map3}
  #     
  else if (input$mapyear == 2 ){
    watermap <- map2}
  #       
  else {watermap <- map1}
  
  
  watermap1 <- as.data.table(watermap)
  watermap2 <- watermap1[(Latitude != ""), .(count = .N), by=.(Latitude, Longitude)]
  j <- paste0("[",watermap2[,Latitude], ",", watermap2[,Longitude], ",", watermap2[,count], "]", collapse=",")
  j <- paste0("[",j,"]")
  tags$body(tags$script(HTML(sprintf("
                                var addressPoints = %s
if (typeof heat === typeof undefined) {
            heat = L.heatLayer(addressPoints)
            heat.addTo(map)
          } else {
            heat.setOptions()
            heat.setLatLngs(addressPoints)
          }
                                         </script>"
                                     , j))))
  
  
}) 
################## End Richard's Output##############
})
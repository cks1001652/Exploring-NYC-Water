setwd("/Users/Josh/Documents/Spring 2016/DataScience/Project2/project2-cycle2-8/")
library(shiny)
library(dplyr)
library(data.table)
library(wordcloud)
library(plyr)
library(plotly)
library(zoo)
library(leaflet)

# Read in data
water <- readRDS("data/data_4.Rds")
water$Created.Date <- NULL
water$Resolution.Action.Updated.Date <- NULL

#################### Josh's Data ####################
water_qual <- readRDS("data/water_quality.rds")
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

#################### End of Josh's Data ####################

shinyServer(function(input, output) {

#################### Josh's Output ####################
  output$ill_map <- renderLeaflet({
    leaflet(drink_water) %>% addTiles() %>% addProviderTiles("CartoDB.DarkMatter") %>%setView(lng = -73.9857, lat = 40.7577, zoom = 12) %>% addCircleMarkers(radius=6, fillOpacity = 0.5, popup = ~as.character(Date), clusterOptions = markerClusterOptions())
  })
  
  # Make the wordcloud drawing predictable during a session
  wordcloud_rep <- repeatable(wordcloud)

  output$descrip_plot <- renderPlot({
    # min.freq = input$freq, max.words=input$max,
    df <- as.data.frame(table(quality_water$Descriptor))
    par(bg="#f5f5f5")
    wordcloud_rep(df$Var1, df$Freq, min.freq = input$desc_range[1], max.words=input$desc_range[2], scale=c(2.5,.5), random.order = TRUE, random.color=TRUE, rot.per=.15,
                  colors=brewer.pal(11, "BrBG"))
  })
  
  output$descrip_text = renderText({
      paste("Viewing ", input$desc_range[1], " to ", max.words=input$desc_range[2], "descriptors")
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
    
    if(input$complaint_desc == "All Complaints"){
      rep_q_water_table2 <- rep_q_water_table
    } else {
      rep_q_water_table2 <- rep_q_water_table[rep_q_water_table$Descriptor== input$complaint_desc,]
    }
    rep_q_water_table2
    # Total data table
    rep_q_water_table_monthly <- aggregate(rep_q_water_table2$Number, list(rep_q_water_table2$Date), sum)
    rep_q_water_table_monthly$Group.1 <- mapvalues(rep_q_water_table_monthly$Group.1, from = rep_q_water_table_monthly$Group.1, c("Jan", "Feb", "Mar", "April", "May", "June", "July", "Aug", "Sep", "Oct", "Nov", "Dec"))  
    
    
    p<- plot_ly(water_qual_Turbid, x =Date, y =Turbidity, name = "Turbidity Level", colors=brewer.pal(3, "BrBG"), text=paste("Turbidity:", Turbidity, " (NTU)")) %>%
    add_trace(rep_q_water_table_monthly, x=rep_q_water_table_monthly$Group.1, y = rep_q_water_table_monthly$x, name = "NYC Resident Complaints", yaxis = "y2", text=paste("Num of complaints:", rep_q_water_table_monthly$x))
    layout(p, xaxis = x_axis, yaxis=y_axis, yaxis2 = ay)
    
  })


  
#################### End of Josh's Output ####################

})
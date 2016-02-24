library(plyr)
library(dplyr)
library(zoo)
library(dplyr)
library(data.table)
library(wordcloud)
library(plotly)
library(leaflet)
library(rCharts)

library(ggplot2)
require(lubridate)
library(dygraphs)
library(xts)

# library(data.table)
# library(ggplot2)
# library(plotrix)
# library(RColorBrewer)
# library(scales)
# library(rCharts)
# library(zoo)
# water <- readRDS("~/Github/project2-cycle2-8/data/data_4.Rds")
# waterr <- water
# waterr$Created.Date <- NULL
# waterr$Resolution.Action.Updated.Date <- NULL
# waterr$Date <- format(as.yearmon(waterr$Date, "%Y-%m-%d"), "%Y")
# waterr$Date <- as.factor(waterr$Date)
# 
# waternew <- data.frame(c(waterr[,c("Complaint.Type","Borough","Date")]))
# saveRDS(waternew,"pie.rds")

# waternew1 <- data.frame(c(waterr[,c("Latitude","Longitude","Date")]))
# waternew1 <- na.omit(waternew1)
# waternew1[,3] <- as.numeric(waternew1[,3])
# waternew1[waternew1[,3]==2013,3] = 1
# waternew1[waternew1[,3]==2014,3] = 2
# waternew1[waternew1[,3]==2015,3] = 3
# 

#read data
waternew <- readRDS("data/pie.rds")
map1 <- readRDS("data/map1.rds")
map2 <- readRDS("data/map2.rds")
map3 <- readRDS("data/map3.rds")

#dataclean function

#function for calculation
calculation <- function(dataset){
  data.total <- dataset%>%
    dplyr::summarise(complaint.total=n())
  
  
  data.count <- dataset%>%
    group_by(Complaint.Type)%>%
    dplyr::summarise(complaint.count=n())
  data.total <- rep(data.total$complaint.total,each=nrow(data.count))
  data.count <- cbind(data.count,data.total)
  data.count <- data.count%>%
    mutate(Proportion=complaint.count/data.total*100)
  data.count[,4] <- round(data.count[,4],digit=2)
  return(data.count)
}
dataclean <- function(dataset,bor,dat){
  dataset1 <- dataset%>%
    filter(Date %in% dat)%>%
    filter(Borough %in% bor)
  return(dataset1)
}


fulllist <- c("BRONX","BROOKLYN","MANHATTAN","QUEENS","STATEN ISLAND")
fulltime <- c(2013,2014,2015)


###########################

#xiaoyu data
A <- readRDS("data/ONE.Rds")
FIVE <- readRDS("data/FIVE.Rds")
THREE <- readRDS("data/THREE.Rds")

C <- data.frame(Borough = A$Borough[A$Status == "Closed"], 
                Complaint.Type = A$Complaint.Type[A$Status == "Closed"],Days = A$Days[A$Status == "Closed"])

## error 
# final_shiny <- readRDS("data/final_shiny.rds")
# shiny2_stacked <- readRDS("data/shiny2_stacked.rds")


# Read in data
water <- readRDS("data/data_4.Rds")
water$Created.Date <- NULL
water$Resolution.Action.Updated.Date <- NULL

#################### Data ####################
water_qual_Turbid <- readRDS("data/turbid.RDS")
water_qual_Chlorine <- readRDS("data/chlorine.RDS")
# https://data.cityofnewyork.us/Environment/Drinking-Water-Quality-Distribution-Monitoring-Dat/bkwf-xfky
#water_qual_Turbid <- aggregate(water_qual$Turbidity, list(water_qual$Date), mean)
#water_qual_Turbid <- plyr::rename(water_qual_Turbid, c("Group.1"="Date", "x"="Turbidity"))
#water_qual_Turbid$Date <- format(as.yearmon(water_qual_Turbid$Date, "%m/%d/%Y"), "%m")
#water_qual_Turbid <- aggregate(water_qual_Turbid$Turbidity, list(water_qual_Turbid$Date), mean)
#water_qual_Turbid <- plyr::rename(water_qual_Turbid, c("Group.1"="Date", "x"="Turbidity"))
#water_qual_Turbid$Date <- mapvalues(water_qual_Turbid$Date, from = water_qual_Turbid$Date, c("Jan", "Feb", "Mar", "April", "May", "June", "July", "Aug", "Sep", "Oct", "Nov", "Dec"))

#water_qual_Chlorine <- aggregate(water_qual$Chlorine, list(water_qual$Date), mean)
#water_qual_Chlorine <- plyr::rename(water_qual_Chlorine, c("Group.1"="Date", "x"="Chlorine"))
#water_qual_Chlorine$Date <- format(as.yearmon(water_qual_Chlorine$Date, "%m/%d/%Y"), "%m")
#water_qual_Chlorine <- aggregate(water_qual_Chlorine$Chlorine, list(water_qual_Chlorine$Date), mean)
#water_qual_Chlorine <- plyr::rename(water_qual_Chlorine, c("Group.1"="Date", "x"="Chlorine"))
#water_qual_Chlorine$Date <- mapvalues(water_qual_Chlorine$Date, from = water_qual_Chlorine$Date, c("Jan", "Feb", "Mar", "April", "May", "June", "July", "Aug", "Sep", "Oct", "Nov", "Dec"))


drink_water <- filter(water, water$Complaint.Type == "Drinking Water")
quality_water <- filter(water, water$Complaint.Type == "Water Quality")

quality_water$Descriptor <- mapvalues(quality_water$Descriptor, from = c(unique(quality_water$Descriptor)), to=c("Chlorine Taste/Odor", "Other", "Cloudy Water", "Other Water Problem", "Milky Water", "Unknown Taste", "Metallic Taste/Odor", "Musty Taste/Odor", "Clear w/ Particles", "Chemical Taste", "Sewer Taste/Odor", "Oil in Water", "Other", "Clear with Insects/Worms"))

rep_q_water <- quality_water
rep_q_water <- rep_q_water[grepl("2015", rep_q_water$Date),]
rep_q_water$Date <- (format(as.yearmon(rep_q_water$Date, "%Y-%m-%d"), "%m"))

# Main data table
rep_q_water_table <- as.data.frame(table(rep_q_water$Date, rep_q_water$Descriptor))
rep_q_water_table <- plyr::rename(rep_q_water_table, c("Var1"="Date", "Var2"="Descriptor", "Freq"="Number"))

final_shiny_1 <- readRDS("data/final_shiny.rds")

duplicates <- final_shiny_1[,1]
year <- c("2014","2015")
bor1 <- data.frame(year,duplicates)

duplicates <- final_shiny_1[,2]
year <- c("2014","2015")
bor2 <- data.frame(year,duplicates)

duplicates <- final_shiny_1[,3]
year <- c("2014","2015")
bor3 <- data.frame(year,duplicates)

duplicates <- final_shiny_1[,4]
year <- c("2014","2015")
bor4 <- data.frame(year,duplicates)

duplicates <- final_shiny_1[,5]
year <- c("2014","2015")
bor5 <- data.frame(year,duplicates)


shiny2_stacked_1 <- readRDS("data/shiny2_stacked.Rds")


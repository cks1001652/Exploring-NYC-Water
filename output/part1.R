library(dplyr)
library(data.table)
# library(ggplot2)
# library(plotrix)
# library(RColorBrewer)
# library(scales)
library(rCharts)

water <- readRDS("~/Github/project2-cycle2-8/data/data_4.Rds")
waterr <- water
waterr$Created.Date <- NULL
waterr$Resolution.Action.Updated.Date <- NULL
waterr$Date <- format(as.yearmon(waterr$Date, "%Y-%m-%d"), "%Y")
waterr$Date <- as.factor(waterr$Date)

waternew <- data.frame(c(waterr[,c("Complaint.Type","Borough","Date")]))
waternew1 <- data.frame(c(waterr[,c("Latitude","Longitude","Date")]))
waternew1 <- na.omit(waternew1)
waternew1[,3] <- as.numeric(waternew1[,3])
waternew1[waternew1[,3]==2013,3] = 1
waternew1[waternew1[,3]==2014,3] = 2
waternew1[waternew1[,3]==2015,3] = 3


 
#dataclean function
dataclean <- function(dataset,bor,dat){
  dataset1 <- dataset%>%
    filter(Date %in% dat)%>%
    filter(Borough %in% bor)
  return(dataset1)
}

fulllist <- c("BRONX","BROOKLYN","MANHATTAN","QUEENS","STATEN ISLAND")
fulltime <- c(2013,2014,2015)


###########################
#function for calculation
calculation <- function(dataset){
  data.total <- dataset%>%
    summarise(complaint.total=n())
  
  
  data.count <- dataset%>%
    group_by(Complaint.Type)%>%
    summarise(complaint.count=n())
  data.total <- rep(data.total$complaint.total,each=nrow(data.count))
  data.count <- cbind(data.count,data.total)
  data.count <- data.count%>%
    mutate(Proportion=complaint.count/data.total*100)
  data.count[,4] <- round(data.count[,4],digit=2)
  return(data.count)
}

 


  
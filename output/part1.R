library(dplyr)
library(data.table)
library(ggplot2)
library(plotrix)
library(RColorBrewer)
library(scales)
getwd()
##############################
#data manipulation
system.time(raw <- readRDS("/Users/cheeseloveicecream/GitHub/project2-cycle2-8/data/data_4.rds"))

data <- data.frame(c(raw[,c("Complaint.Type","Borough","Latitude","Longitude","Date")]))
data$Date <- format(as.yearmon(data$Date, "%Y-%m-%d"), "%Y")
data$Date <- as.factor(data$Date)
#dataclean function
dataclean <- function(dataset,bor,dat){
  dataset1 <- dataset%>%
    filter(Borough%in%bor,Date%in%dat)
  return(dataset1)
}
fulllist <- c("BRONX","BROOKLYN","MANHATTAN","QUEENS","STATEN ISLAND")
fulltime <- c(2013,2014,2015)
#sigle borough all year
data_1 <- dataclean(data,fulllist[1],fulltime)
data_2 <- dataclean(data,fulllist[2],fulltime)
data_3 <- dataclean(data,fulllist[3],fulltime)
data_4 <- dataclean(data,fulllist[4],fulltime)
data_5 <- dataclean(data,fulllist[5],fulltime)
#two boroughs all year
data_12 <- dataclean(data,fulllist[c(1,2)],fulltime)
data_13 <- dataclean(data,fulllist[c(1,3)],fulltime)
data_14 <- dataclean(data,fulllist[c(1,4)],fulltime)
data_15 <- dataclean(data,fulllist[c(1,5)],fulltime)
data_23 <- dataclean(data,fulllist[c(2,3)],fulltime)
data_24 <- dataclean(data,fulllist[c(2,4)],fulltime)
data_25 <- dataclean(data,fulllist[c(2,5)],fulltime)
data_34 <- dataclean(data,fulllist[c(3,4)],fulltime)
data_35 <- dataclean(data,fulllist[c(3,5)],fulltime)
data_45 <- dataclean(data,fulllist[c(4,5)],fulltime)
#three boroughs all year
data_123 <- dataclean(data,fulllist[c(1,2,3)],fulltime)
data_124 <- dataclean(data,fulllist[c(1,2,4)],fulltime)
data_125 <- dataclean(data,fulllist[c(1,2,5)],fulltime)
data_134 <- dataclean(data,fulllist[c(1,3,4)],fulltime)
data_135 <- dataclean(data,fulllist[c(1,3,5)],fulltime)
data_145 <- dataclean(data,fulllist[c(1,4,5)],fulltime)
data_234 <- dataclean(data,fulllist[c(2,3,4)],fulltime)
data_235 <- dataclean(data,fulllist[c(2,3,5)],fulltime)
data_245 <- dataclean(data,fulllist[c(2,4,5)],fulltime)
data_345 <- dataclean(data,fulllist[c(3,4,5)],fulltime)
#four boroughs all year
data_2345 <- dataclean(data,fulllist[-1],fulltime)
data_1345 <- dataclean(data,fulllist[-2],fulltime)
data_1245 <- dataclean(data,fulllist[-3],fulltime)
data_1235 <- dataclean(data,fulllist[-4],fulltime)
data_1234 <- dataclean(data,fulllist[-5],fulltime)
#all boroughs all year
data_all <- dataclean(data,fulllist,fulltime)
#########################

###########################
#function for calculation
calculation <- function(dataset){
  data.total <- dataset%>%
    summarise(complaint.total=n())
  data.total <- rep(data.total$complaint.total,each=8)
  
  data.count <- dataset%>%
    group_by(Complaint.Type)%>%
    summarise(complaint.count=n())
  
  data.count <- cbind(data.count,data.total)
  data.count <- data.count%>%
    mutate(Proportion=complaint.count/data.total*100)
  data.count[,4] <- round(data.count[,4],digit=2)
  return(data.count)
}
##calcualtion result
data_all_count <- calculation(dataset = data_all)
data_1_count <- calculation(dataset=data_1)
data_2_count <- calculation(dataset = data_2)
data_3_count <- calculation(dataset = data_3)
data_4_count <- calculation(dataset = data_4)
data_5_count <- calculation(dataset = data_5)
data_12_count <- calculation(dataset=data_12)
data_13_count <- calculation(dataset = data_13)
data_14_count <- calculation(dataset = data_14)
data_15_count <- calculation(dataset = data_15)
data_23_count <- calculation(dataset = data_23)
data_24_count <- calculation(dataset=data_24)
data_25_count <- calculation(dataset = data_25)
data_34_count <- calculation(dataset = data_34)
data_35_count <- calculation(dataset = data_35)
data_45_count <- calculation(dataset = data_45)
data_123_count <- calculation(dataset=data_123)
data_124_count <- calculation(dataset = data_124)
data_125_count <- calculation(dataset = data_125)
data_134_count <- calculation(dataset = data_134)
data_135_count <- calculation(dataset = data_135)
data_145_count <- calculation(dataset=data_145)
data_234_count <- calculation(dataset = data_234)
data_235_count <- calculation(dataset = data_235)
data_245_count <- calculation(dataset = data_245)
data_345_count <- calculation(dataset = data_345)
data_2345_count <- calculation(dataset=data_2345)
data_1345_count <- calculation(dataset = data_1345)
data_1245_count <- calculation(dataset = data_1245)
data_1235_count <- calculation(dataset = data_1235)
data_1234_count <- calculation(dataset = data_1234)

####################################
#function for plot

piechart <- function(dataset){
#   attach(dataset)
  y.breaks <- cumsum(Proportion) - Proportion/2
  p <- ggplot(dataset,aes(x=1,y=dataset[,4],fill=Complaint.Type))+
    geom_bar(stat="identity",color='black')+
#     geom_text(aes(y= Proportion[3]*a1,label=percent(Proportion[3]/100)),size=4)+
#     geom_text(aes(y= (Proportion[6]*a2),label=percent(Proportion[6]/100)),size=4)+
#     geom_text(aes(y= (Proportion[8]*a3),label=percent(Proportion[8]/100)),size=4)+
        ggtitle("Complaint Types Proportion")+
    coord_polar(theta = 'y')+
    theme(axis.ticks=element_blank(),  # the axis ticks
          axis.title=element_blank(),  # the axis labels
          axis.text.y=element_blank(),
          axis.text.x=element_blank()
    )
  
  return(p)
}
#plotting

piechart(dataset = data_1_count)
piechart(dataset = data_2_count)
piechart(dataset = data_3_count)
piechart(dataset = data_4_count)
piechart(dataset = data_5_count)
######################################
#Histogram function & plot

histo <- function(dataset,col){
  reorder_size <- function(x) {
    factor(x, levels = names(sort(decreasing = T,table(x))))
  }
  p <- ggplot(dataset,aes(reorder_size(dataset$Complaint.Type)))+
    geom_bar(fill=col,position='dodge')+
    ggtitle(paste("Borough:",levels(dataset[,2]),sep=" "))+
    xlab("")+
    ylab("Numbers of Complaints")+
    scale_y_continuous(limits = c(0, 125000))
  return(p)  
}

histo(dataset = data_1,col = "#56B4E9")
histo(dataset = data_2,col = "#56B4E8")
histo(dataset = data_3,col = "#56B4E7")
histo(dataset = data_4,col = "#56B4E6")
histo(dataset = data_5,col = "#56B4E5")

histo(dataset = data_12,col = "#56B4E9")
histo(dataset = data_13,col = "#56B4E8")
histo(dataset = data_14,col = "#56B4E7")
histo(dataset = data_15,col = "#56B4E6")
histo(dataset = data_23,col = "#56B4E5")
histo(dataset = data_24,col = "#56B4E9")
histo(dataset = data_25,col = "#56B4E8")
histo(dataset = data_34,col = "#56B4E7")
histo(dataset = data_35,col = "#56B4E6")
histo(dataset = data_45,col = "#56B4E5")

histo(dataset = data_123,col = "#56B4E9")
histo(dataset = data_124,col = "#56B4E8")
histo(dataset = data_125,col = "#56B4E7")
histo(dataset = data_134,col = "#56B4E6")
histo(dataset = data_135,col = "#56B4E5")
histo(dataset = data_145,col = "#56B4E9")
histo(dataset = data_234,col = "#56B4E8")
histo(dataset = data_235,col = "#56B4E7")
histo(dataset = data_245,col = "#56B4E6")
histo(dataset = data_345,col = "#56B4E5")

histo(dataset = data_2345,col = "#56B4E9")
histo(dataset = data_1345,col = "#56B4E8")
histo(dataset = data_1245,col = "#56B4E7")
histo(dataset = data_1235,col = "#56B4E6")
histo(dataset = data_1234,col = "#56B4E5")


















  
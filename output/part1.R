library(dplyr)
library(data.table)
library(ggplot2)
library(plotrix)
library(RColorBrewer)
library(scales)
getwd()
system.time(raw <- readRDS("data/data_4.rds"))

data <- data.frame(c(raw[,c("Complaint.Type","Borough","Latitude","Longitude","Date")]))
data_bronx <- data%>%
  filter(Borough=='BRONX')
data_brooklyn <-data%>%
  filter(Borough=='BROOKLYN')
data_manhattan <- data%>%
  filter(Borough=='MANHATTAN')
data_queens <- data%>%
  filter(Borough=='QUEENS')
data_staten_island <- data%>%
  filter(Borough=='STATEN ISLAND')

#total data
data.total <- data%>%
  summarise(complaint.total=n())
data.total <- rep(data.total$complaint.total,each=8)

data.count <- data%>%
  group_by(Complaint.Type)%>%
  summarise(complaint.count=n())

data.count <- cbind(data.count,data.total)
data.count <- data.count%>%
  mutate(value=complaint.count/data.total*100)
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
#calcualtion result
data_count <- calculation(dataset = data)
data_bronx_count <- calculation(dataset=data_bronx)
data_brooklyn_count <- calculation(dataset = data_brooklyn)
data_manhattan_count <- calculation(dataset = data_manhattan)
data_queens_count <- calculation(dataset = data_queens)
data_staten_island_count <- calculation(dataset = data_staten_island)

#function for plot
piechart <- function(dataset){
  dataset[,4] <- round(dataset[,4],digit=2)
  lbls <- c("Bottled \n","Drinking \n ","Heat/Hot Water\n ","Standing\n Water\n "," Water\n Conservation\n ","Water\n Leak \n "," Water\nQuality \n ","Water System \n ")
  perlabels <- paste(dataset[,4], "%", sep="")
  slices <- dataset[,2]
  cols <- brewer.pal(8,"Set1")
  par(mfrow=c(1,1)) 
  pie3D(slices, radius = 1.5, shade = 0.8, theta = 0.8, start = -0.1, border = "white",
        col = cols, main = "Pie Chart of Complaint Types", 
        labels = perlabels,labelrad = 1.2, labelcex = 1.3)
  legend('topleft',c("Bottled Water","Drinking Water ","Heat/Hot Water ","Standing Water "," Water Conservation  ","Water Leak "," Water Quality ","Water System  "),fill=cols,cex=0.4)
}
piechart <- function(dataset,a1,a2,a3){
  attach(dataset)
  y.breaks <- cumsum(Proportion) - Proportion/2
  p <- ggplot(dataset,aes(x=1,y=dataset[,4],fill=Complaint.Type))+
    geom_bar(stat="identity",color='black')+
    geom_text(aes(y= Proportion[3]*a1,label=percent(Proportion[3]/100)),size=4)+
    geom_text(aes(y= (Proportion[6]*a2),label=percent(Proportion[6]/100)),size=4)+
    geom_text(aes(y= (Proportion[8]*a3),label=percent(Proportion[8]/100)),size=4)+
        ggtitle("Complaint Types Proportion")+
    coord_polar(theta = 'y')+
    theme(axis.ticks=element_blank(),  # the axis ticks
          axis.title=element_blank(),  # the axis labels
          axis.text.y=element_blank(),
          axis.text.x=element_blank()
#           plot.margin=rep(unit(0, "lines"),4),
#           axis.text.x=element_text(color='black'))
#   +
#     scale_y_continuous(
#       breaks=y.breaks,   # where to place the labels
#       labels=Complaint.Type # the labels
    )
  
  return(p)
}
#plotting

piechart(dataset = data_bronx_count,a1 = 0.5,a2 = 6.7,a3=5)
piechart(dataset = data_brooklyn_count,a1 = 0.6,a2 = 5.3,a3=3.3)
piechart(dataset = data_manhattan_count,a1 = 0.54,a2 = 7.5,a3=3.5)
piechart(dataset = data_queens_count,a1 = 0.5,a2 = 7.5,a3=1.77)
piechart(dataset = data_staten_island_count,a1 = 0.5,a2 = 7,a3=1)

# piechart(dataset = data.count)
# # prepare for the pie chart
# data.count[,4] <- round(data.count[,4],digit=2)
# lbls <- c("Bottled Water: ","Drinking Water: ","Heat/Hot Water: ","Standing Water: ","Water Conservation: ","Water Leak: ","Water Quality: ","Water Quality: ")
# perlabels <- paste(lbls, data.count[,4], "%", sep="")
# slices <- data.count[,2]
# cols <- brewer.pal(8,"Set1")
# # Plot the pie chart
# par(mfrow=c(1,1)) 
# # png(filename = "figs/Eng.png", width = 680, height = 480)
# pie3D(slices, radius = 1.2, shade = 0.8, theta = 0.8, start = -0.1, border = "white",
#       col = cols, main = "Pie Chart of Complaint Types", 
#       labels = perlabels,labelrad = 1.5, labelcex = 1.3)
# #dev.copy(png, "figs/Eng.png")
# dev.off()
# 


















#histogram
# Prepare for the histogram/bar
hist <- raw[,c("Complaint.Type","Borough")]
# Histogram plot one 
p1 <- ggplot(hist,aes(Borough,fill=Complaint.Type))  
p1 + geom_bar(position="stack")+
  ggtitle("Different Complaints in Different Borough")+
  xlab("Borough")+
  ylab("Numbers of Complaints")



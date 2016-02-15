library(dplyr)
library(data.table)
library(ggplot2)
library(plotrix)
library(RColorBrewer)
library(ggmap)
getwd()
setwd("/Users/cheeseloveicecream/GitHub/project2-cycle2-8")
system.time(raw <- readRDS("/Users/cheeseloveicecream/GitHub/project2-cycle2-8/data/data_4.rds"))

data <- data.frame(c(raw[,c("Complaint.Type","Incident.Zip","Incident.Address","City","Borough","Latitude","Longitude","Location")]))
data <- tbl_df(data)
data.total <- data%>%
  summarise(complaint.total=n())
data.total <- rep(data.total$complaint.total,each=8)

data.count <- data%>%
  group_by(Complaint.Type)%>%
  summarise(complaint.count=n())

data.count <- cbind(data.count,data.total)
data.count <- data.count%>%
  mutate(value=complaint.count/data.total*100)
data.count[1,]
# prepare for the pie chart
data.count[,4] <- round(data.count[,4],digit=2)
lbls <- c("Bottled Water: ","Drinking Water: ","Heat/Hot Water: ","Standing Water: ","Water Conservation: ","Water Leak: ","Water Quality: ","Water Quality: ")
perlabels <- paste(lbls, data.count[,4], "%", sep="")
slices <- data.count[,2]
cols <- brewer.pal(8,"Set1")
# Plot the pie chart
par(mfrow=c(1,1)) 
# png(filename = "figs/Eng.png", width = 680, height = 480)
pie3D(slices, radius = 1.2, shade = 0.8, theta = 0.8, start = -0.1, border = "white",
      col = cols, main = "Pie Chart of Complaint Types", 
      labels = perlabels,labelrad = 1.5, labelcex = 1.3)
#dev.copy(png, "figs/Eng.png")
dev.off()

#histogram
# Prepare for the histogram/bar
hist <- raw[,c("Complaint.Type","Borough","Incident.Zip","City")]
# Histogram plot one 
p1 <- ggplot(hist,aes(Borough,fill=Complaint.Type))  
p1 + geom_bar(position="stack")+
  ggtitle("Different Complaints in Different Borough")+
  xlab("Borough")+
  ylab("Numbers of Complaints")

# Histogram plot two
# p2 <- ggplot(hist,aes(City,fill=Complaint.Type))  
# p2 + geom_bar(position="stack")+
#   ggtitle("Different Complaints in Different City")+
#   xlab("City")+
#   ylab("Numbers of Complaints")

#map
houston <- get_map("new york", zoom = 13)
HoustonMap <- ggmap(houston, extent = "device", legend = "topleft")
HoustonMap +
  stat_density2d(
    aes(x = lon, y = lat, fill = ..level..,  alpha = ..level..),
    size = 2,  data = violent_crimes,
    geom = "polygon"
  )
overlay <- stat_density2d(
  aes(x = lon, y = lat, fill = ..level.., alpha = ..level..),
   geom = "polygon",
  data = violent_crimes
)
HoustonMap + overlay + inset(
  grob = ggplotGrob(ggplot() + overlay + theme_inset()),
  xmin = -95.35836, xmax = Inf, ymin = -Inf, ymax = 29.75062
)

qmap('houston', zoom = 13)


 gglocator(2)
# only violent crimes
violent_crimes <- subset(crime,offense != "auto theft" & offense != "theft" & offense != "burglary")
# order violent crimes
violent_crimes$offense <- factor(violent_crimes$offense,levels = c("robbery", "aggravated assault", "rape", "murder"))
# restrict to downtown
violent_crimes <- subset(violent_crimes,-95.39681 <= lon & lon <= -95.34188 &29.73631 <= lat & lat <=  29.78400)
theme_set(theme_bw(16))
HoustonMap <- qmap("houston", zoom = 14, color = "bw", legend = "topleft")
HoustonMap +
  geom_point(aes(x = lon, y = lat, colour = offense, size = offense),
             data = violent_crimes)
HoustonMap +
  stat_bin2d(
    aes(x = lon, y = lat, colour = offense, fill = offense),
    size = .5, bins = 30, alpha = 1/2,
    data = violent_crimes
  )


houston <- get_map(location = "houston", zoom = 14, color = "bw",
                   source = "osm")
HoustonMap <- ggmap(houston, base_layer = ggplot(aes(x = lon, y = lat),
                                                 data = violent_crimes))
HoustonMap +
  stat_density2d(aes(x = lon, y = lat, fill = ..level.., alpha = ..level..), geom = "polygon",
                 data = violent_crimes) +
  scale_fill_gradient(low = "black", high = "red") +
  facet_wrap(~ day)

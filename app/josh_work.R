library(plotly)
library(zoo)


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

rep_q_water <- quality_water
rep_q_water <- rep_q_water[grepl("2015", rep_q_water$Date),]
rep_q_water$Date <- (format(as.yearmon(rep_q_water$Date, "%Y-%m-%d"), "%m"))

# Main data table
rep_q_water_table <- as.data.frame(table(rep_q_water$Date, rep_q_water$Descriptor))
rep_q_water_table <- rename(rep_q_water_table, c("Var1"="Date", "Var2"="Descriptor", "Freq"="Number"))

# Total data table
rep_q_water_table_monthly <- aggregate(rep_q_water_table$Number, list(rep_q_water_table$Date), sum)
rep_q_water_table_monthly$Group.1 <- mapvalues(rep_q_water_table_monthly$Group.1, from = rep_q_water_table_monthly$Group.1, c("Jan", "Feb", "Mar", "April", "May", "June", "July", "Aug", "Sep", "Oct", "Nov", "Dec"))

# By complaint type

x_axis <- list(
  title = "Months in 2015"
  #range=c("Jan", "Feb", "Mar", "April", "May", "June", "July", "Aug", "Sep", "Oct", "Nov", "Dec")
  #titlefont = f
)
y_axis <- list(
  title = "Turbidity in NTU"
  #titlefont = f
)
ay <- list(
  title="Number of Complaints",
  overlaying = "y",
  side = "right"
)

plot_ly(water_qual_Turbid, x =Date, y =Turbidity, name = "Turbidity Level", colors=brewer.pal(3, "BrBG"), text=paste("Turbidity:", Turbidity, " (NTU)")) %>%
add_trace(rep_q_water_table_monthly, x=rep_q_water_table_monthly$Group.1, y = rep_q_water_table_monthly$x, name = "NYC Resident Complaints", yaxis = "y2", text=paste("Num of complaints:", rep_q_water_table_monthly$x)) %>%
layout(xaxis = x_axis, yaxis=y_axis, yaxis2 = ay)


#main-svg backgorund 
# subplot xy fill

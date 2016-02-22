setwd("~/ADS PROJECT 2 - My stuff/My_Shiny_2_ADS")
library(shiny)
library(dplyr)
library(data.table)
library(plyr)
library(rCharts)

# Read in data
water <- readRDS("data_5.Rds")
names(water)

shinyvars2 <- c("Resolution.Description","Borough")
shiny2 <- water[shinyvars2]
View(shiny2)

shiny2$Type <- ifelse(grepl("duplicate", shiny2$Resolution.Description),"Duplicate","Not Duplicate")

shiny2$Duplicate <- ifelse(grepl("duplicate", shiny2$Resolution.Description),1,0)
shiny2$Not.Duplicate <- ifelse(grepl("duplicate", shiny2$Resolution.Description),0,1)

levels(shiny2$Borough) <- as.factor(c("Bronx","Brooklyn","Manhattan","Queens","Staten Island",NA))
shiny2 <- na.omit(shiny2)

shiny2_duplicates_bronx <- filter(shiny2, shiny2$Borough=="Bronx" & shiny2$Duplicate==1 & shiny2$Type=="Duplicate")
shiny2_freq_dup_bronx <- aggregate(shiny2_duplicates_bronx$Duplicate, list(Borough = shiny2_duplicates_bronx$Borough, Type = shiny2_duplicates_bronx$Type), sum)
shiny2_freq_dup_bronx <- rename(shiny2_freq_dup_bronx, c("x"="Frequency"))

shiny2_nduplicates_bronx <- filter(shiny2, shiny2$Borough=="Bronx" & shiny2$Not.Duplicate==1 & shiny2$Type=="Not Duplicate")
shiny2_freq_ndup_bronx <- aggregate(shiny2_nduplicates_bronx$Not.Duplicate, list(Borough = shiny2_nduplicates_bronx$Borough, Type = shiny2_nduplicates_bronx$Type), sum)
shiny2_freq_ndup_bronx <- rename(shiny2_freq_ndup_bronx, c("x"="Frequency"))

shiny2_duplicates_brooklyn <- filter(shiny2, shiny2$Borough=="Brooklyn" & shiny2$Duplicate==1 & shiny2$Type=="Duplicate")
shiny2_freq_dup_brooklyn <- aggregate(shiny2_duplicates_brooklyn$Duplicate, list(Borough = shiny2_duplicates_brooklyn$Borough, Type = shiny2_duplicates_brooklyn$Type), sum)
shiny2_freq_dup_brooklyn <- rename(shiny2_freq_dup_brooklyn, c("x"="Frequency"))

shiny2_nduplicates_brooklyn <- filter(shiny2, shiny2$Borough=="Brooklyn" & shiny2$Not.Duplicate==1 & shiny2$Type=="Not Duplicate")
shiny2_freq_ndup_brooklyn <- aggregate(shiny2_nduplicates_brooklyn$Not.Duplicate, list(Borough = shiny2_nduplicates_brooklyn$Borough, Type = shiny2_nduplicates_brooklyn$Type), sum)
shiny2_freq_ndup_brooklyn <- rename(shiny2_freq_ndup_brooklyn, c("x"="Frequency"))

shiny2_duplicates_manhattan <- filter(shiny2, shiny2$Borough=="Manhattan" & shiny2$Duplicate==1 & shiny2$Type=="Duplicate")
shiny2_freq_dup_manhattan <- aggregate(shiny2_duplicates_manhattan$Duplicate, list(Borough = shiny2_duplicates_manhattan$Borough, Type = shiny2_duplicates_manhattan$Type), sum)
shiny2_freq_dup_manhattan <- rename(shiny2_freq_dup_manhattan, c("x"="Frequency"))

shiny2_nduplicates_manhattan <- filter(shiny2, shiny2$Borough=="Manhattan" & shiny2$Not.Duplicate==1 & shiny2$Type=="Not Duplicate")
shiny2_freq_ndup_manhattan <- aggregate(shiny2_nduplicates_manhattan$Not.Duplicate, list(Borough = shiny2_nduplicates_manhattan$Borough, Type = shiny2_nduplicates_manhattan$Type), sum)
shiny2_freq_ndup_manhattan <- rename(shiny2_freq_ndup_manhattan, c("x"="Frequency"))

shiny2_duplicates_queens <- filter(shiny2, shiny2$Borough=="Queens" & shiny2$Duplicate==1 & shiny2$Type=="Duplicate")
shiny2_freq_dup_queens <- aggregate(shiny2_duplicates_queens$Duplicate, list(Borough = shiny2_duplicates_queens$Borough, Type = shiny2_duplicates_queens$Type), sum)
shiny2_freq_dup_queens <- rename(shiny2_freq_dup_queens, c("x"="Frequency"))

shiny2_nduplicates_queens <- filter(shiny2, shiny2$Borough=="Queens" & shiny2$Not.Duplicate==1 & shiny2$Type=="Not Duplicate")
shiny2_freq_ndup_queens <- aggregate(shiny2_nduplicates_queens$Not.Duplicate, list(Borough = shiny2_nduplicates_queens$Borough, Type = shiny2_nduplicates_queens$Type), sum)
shiny2_freq_ndup_queens <- rename(shiny2_freq_ndup_queens, c("x"="Frequency"))

shiny2_duplicates_staten <- filter(shiny2, shiny2$Borough=="Staten Island" & shiny2$Duplicate==1 & shiny2$Type=="Duplicate")
shiny2_freq_dup_staten <- aggregate(shiny2_duplicates_staten$Duplicate, list(Borough = shiny2_duplicates_staten$Borough, Type = shiny2_duplicates_staten$Type), sum)
shiny2_freq_dup_staten <- rename(shiny2_freq_dup_staten, c("x"="Frequency"))

shiny2_nduplicates_staten <- filter(shiny2, shiny2$Borough=="Staten Island" & shiny2$Not.Duplicate==1 & shiny2$Type=="Not Duplicate")
shiny2_freq_ndup_staten <- aggregate(shiny2_nduplicates_staten$Not.Duplicate, list(Borough = shiny2_nduplicates_staten$Borough, Type = shiny2_nduplicates_staten$Type), sum)
shiny2_freq_ndup_staten <- rename(shiny2_freq_ndup_staten, c("x"="Frequency"))


shiny2_stacked <- join_all(list(shiny2_freq_dup_bronx,
                                shiny2_freq_ndup_bronx,
                                shiny2_freq_dup_brooklyn,
                                shiny2_freq_ndup_brooklyn,
                                shiny2_freq_dup_queens,
                                shiny2_freq_ndup_queens,
                                shiny2_freq_dup_manhattan,
                                shiny2_freq_ndup_manhattan,
                                shiny2_freq_dup_staten,
                                shiny2_freq_ndup_staten),
                          type = 'full')

shiny2_stacked

saveRDS(shiny2_stacked, file="shiny2_stacked.Rds")
#####

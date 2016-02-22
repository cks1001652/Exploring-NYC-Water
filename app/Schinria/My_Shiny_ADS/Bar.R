setwd("~/ADS PROJECT 2 - My stuff/My_Shiny_ADS")
library(datasets)
library(shiny)
library(data.table)
library(dplyr)

#####################
sub_orig <- readRDS("data_5.rds")
shinyvars <- c("Resolution.Description","Borough", "Date")
shiny1 <- sub_orig[shinyvars]
shiny1$Date <- as.Date(shiny1$Date, "%Y-%m-%d")
shiny1$Date <- format(shiny1$Date, '%Y')
shiny1 <- na.omit(shiny1)
shiny1$Duplicate <- ifelse(grepl("duplicate", shiny1$Resolution.Description),1,0)
shiny1 <- filter(shiny1, shiny1$Duplicate == 1)
shiny1 <- shiny1[, c(2,3,4)]
shiny.df <- aggregate(shiny1$Duplicate, list(Borough = shiny1$Borough, Year = shiny1$Date),sum)
colnames(shiny.df)[3] <- "Frequency"
View(shiny.df)
#Final data frame prep for shiny
final_shiny <- data.frame(c('17867','31241'), c('11240','25408'),c('12210','23468'),
                          c('5710','10402'), c('283','541'))

rownames(final_shiny) <-  c("2014","2015")
colnames(final_shiny) <- c("Bronx","Brooklyn","Manhattan","Queens","Staten Island")

final_shiny$Bronx <- as.numeric(paste(final_shiny$Bronx))
final_shiny$Brooklyn <- as.numeric(paste(final_shiny$Brooklyn))
final_shiny$Manhattan <- as.numeric(paste(final_shiny$Manhattan))
final_shiny$Queens <- as.numeric(paste(final_shiny$Queens))
final_shiny$`Staten Island` <- as.numeric(paste(final_shiny$`Staten Island`))

final_shiny <- as.matrix(final_shiny)

saveRDS(final_shiny, file="final_shiny.Rds")

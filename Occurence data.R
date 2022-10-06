
rm(list=ls())

## required libraries
library(tidyverse)
library(data.table)
library(dplyr)

## set directory to the family
setwd("~/Desktop/Fish project/aquamaps/family/Acanthuridae")

## For loop for occurence data 
file_list <- list.files(pattern = "*.csv")
data_list <- vector("list", "length" = length(file_list))

for (i in seq_along(file_list)) {
  
  
  filename = file_list[[i]]
  
  # Read data in
  df <- read.csv(file_list[[i]], header = F, sep= ",", skip=6, colClasses=c("NULL",NA,"NULL","NULL"))
  df <- distinct(df)
  
  
  # Extract species name from filename
  df$species = gsub(".csv", "", filename)
  
  # Add year to data_list
  data_list[[i]] <- df  
  
}

temp.occurence <- do.call(rbind, data_list)

##name headers
temp.occurence<- setNames(temp.occurence, c("Latitude","Species"))

##remove text found in some species
occurence<-temp.occurence[!grepl("CenterLat", temp.occurence$Latitude),]


##write as a csv - might not be useful
write.csv(occurence,"~/Desktop/Fish project/aquamaps/family/Occurence csv\\acanthuridaeoccurence.csv")



## associate to latitudes 

temp.lat5 <- filter(occurence, Latitude == 5.25 | Latitude == -5.25 | Latitude ==5.75 | Latitude ==-5.75)

temp.lat5$Latitude = as.numeric(as.character(temp.lat5$Latitude))

lat5 <-temp.lat5%>% 
  mutate_if(is.numeric, trunc)
lat5$absLatitude = abs(lat5$Latitude)
lat5<- subset( lat5, select = -Latitude )
lat5 <-distinct(lat5)
lat5


#try with a variable b 

for (b in 0:179) {
  ## associate to latitudes 
  
  temp.latb <- filter(occurence, trunc(abs(occurence$CenterLat)) ==  b) }
# temp.lat5$Latitude = as.numeric(as.character(temp.lat5$Latitude))

latb <-temp.latb%>% 
  mutate_if(is.numeric, trunc)
latb$absLat = abs(latb$CenterLat)
latb<- subset( latb, select = -CenterLat )
latb <-distinct(latb)
latdf<-merge(df1,latb)

## repeat for the range in a loop? 
##number of species per lat
#count(latb)

## repeat for the range in a loop? 
##number of species per lat
count(lat5)

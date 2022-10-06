# sumbp.R
## script written to summarise the breakpoint data and create a 
## forest plot to compare the overall results.
## The idea is to assess whether or not there is a pattern in the 
## breakpoint of 11 different fish families in their gm 
## based morphological disparity (or variance around the mean shape)
## through different latitudes.
## by dr and jd 04-2021

## reset instances
rm(list=ls()) 

## Loading libraries 

library(Matrix)
library(metafor)

## setting the working directory
setwd("~/Desktop/Fish project/models/brokenstick values")

## loading, looking and attaching in the brake point modeling summary data 
sumdat<-read.csv("sumbp3.csv", header = T, stringsAsFactors = T)
#head(sumdat)
## remove rows with unused arguments 
#sumdat <- sumdat[-c(12,13,14),]

## *** the follwing lines need to be used carefully 
## line 31 removes blennidae from the data, & line 33 turns bleeniidae into all 0s (instead of NA) when we want to keep it
## line 36 removed pleuronectidae for being an outlier. We do not always want this though, so be careful

# remove temp - it shuldnt be there..
sumdat <- sumdat[-c(12),]
# remove blennidae for having no break...
sumdat <- sumdat[-c(2),]
# OR make all blennidae NA in to 0s... 
#sumdat[is.na(sumdat)] <- 0
#sumdat <- sumdat[-c(7),] ## no longer needed when 0s are included
# remove pleuronectidae for being far away...
sumdat <- sumdat[-c(6),]

attach(sumdat)

# Assessing the mean of the breakpoints for all families
#remove pleuronectidae from the mean 
#sumdat2 <- sumdat[-6,]
#mbp<-round(mean(na.omit(sumdat$mainbp)),0)
mbp <- 31.65 ## mean when including all
mbp <-30.97 ## mean excluding pleuronectidae and blenniidae

## Setting the summary data into an rma object so that we can make 
## forest plot out of it
z.smbp<-rma(yi=mainbp, sei=mainerr, data = "sumdat", 
            slab = paste(sumdat$family),digit=3)

## initiate forest plot as per the following website
## https://www.metafor-project.org/doku.php/metafor
forest(z.smbp, at=c(10, 20, 30, 40, 50), xlim=c(-70,90),pch = 20,
     ilab=cbind(round(sumdat$adj_r2,2),sumdat$N_lats,round(sumdat$deg.freedom,0),format(sumdat$p.val,scientific = T)),
     ilab.xpos=c(-40,-30,-20,-10), cex=1, header = "Fish family",
     xlab="Latitude", mlab="", refline = c(mbp-5,mbp,mbp+5))

## text to annotate the produced plot with the proper headings
op <- par(cex=1, font=2)
text(c(-40,-30,-20,-10), 11, c("AdjR2", "N","DF","P-val"))
par(op)

## Below tries to do the same but much more clumsily and so commented out

#forest.default(sumdat$bp1, sei=sumdat$sebp1, at=c(0,10,20,30,40,50),
#               annotate = T, refline = mbp, xlim = c(-95,95),
#               xlab = "Latitude", slab = paste(sumdat$family), 
#               ilab=cbind(sumdat$N, sumdat$Nperlat, sumdat$maxLat, sumdat$percentx),
#               ilab.xpos=c(-50,-35,-20,-4), cex=1, header = "Fish family")
#op <- par(cex=0.75, font=2)
#text(c(-50,-35,-20,-4), 13, c("N", "N/Lat","maxLat","%inM"))
#par(op)

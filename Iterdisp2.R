# iterdisp.R 
# Script designed to use a .TPS file and model the disparity (GM based morphological 
# variance) of a group along some provided gradient based soley on the number 
# of individuals occurring in that group along the gradient. Thus, it effectively assesses 
# is a group exhibits more or less disparity along a gradient as expected from the 
# number of individuals within the group alone. 

# The script requires .TPS file of the group (here family of fishes) and the number 
# of individuals (here species) that actually occur at each gradient level (here latitude).
# For comparison, it also requires the actual disparity to have been calculated which 
# has can be done in another script (actualdisp-bylat) and saved to a .csv file.

# the script loads the .TPS file first, then the .csv. It manipulates the CSV to get
# the actual number of individuals at each level and performs a permutation iteration
# to caluculate the amount of disparity at each level based on a ramdom sample of 
# individuals of that number. The overall modelled disparity can take some time to calculate
# (should be somehow parallelized) and then both the real and modelled disparity are 
# plotted with 95% CI. Disparity that falls outside the 95% modelled distribution
# likely indicate that the actual distribution is substantially different from that 
# based on the variantion within the group alone. 

# written by dr and jd Oct 2020

# re-setting all instances
rm(list=ls()) 

#
{library(rgl)
library(ape)
library(geomorph)
#library(doParallel)
library(foreach)}
#loading required libraries

setwd("~/Desktop/Fish project/Landmarks/TPS files")
# setting working directory


rawdat<-readland.tps(file.choose(),specID ="ID", readcurves = F, warnmsg = T, negNA=TRUE)
rawdat <- estimate.missing(rawdat,method="TPS")
# dialog box based file loading
# reading landmarks in from .TPS file

adf<-read.csv(file.choose(),header = T, as.is = T, na.string = "NA")
# dialog box based file loading .csv
adf[is.na(adf)] <- 0 # sets NAs to 0

numlat<-(rev(adf$numspp)) # reverses the order of numspp per lat
totspp<-dim(rawdat)[3]  # gets the total number of species from TPS file 

disres<-matrix(NA, nrow=length(numlat), ncol=4) # sets empty result matrix
colnames(disres)<-c('mean','lowe','highe','sd') # renames the columns

for (a in 1:length(numlat)) {
# foreach (a = 1:length(numlat), .combine=c, .export="disres" ) %dopar% { 
# Initialising the loop to resample the data

sppnum<-numlat[a] # this sets the number of species (spp) to use at given lat

if (choose(totspp,sppnum)>=1000) iter<-1000 else iter<-choose(totspp,sppnum)
# sets the number of permutations to run
# There are totspp species in all. At each step, assess whether the possible 
# number different combination of species numbers (sppnum) can be made from 
# the totspp (so, totspp choose X where X = sppnum). If this value is > 1000 
# then, just use 1000, othewise use totspp choose sppnum.

discal<-vector(mode = "numeric", length = iter)
# An empty vector where the results of the disparty values can be dumped

for (i in 1:iter) {
if (sppnum==0) discal[i]<-0 else {
randspp<-sample(seq(totspp), sppnum, replace=F)
nwdat<-rawdat[,,randspp]
tempgpa<-gpagen(nwdat,PrinAxes = T, print.progress = T)
#plot(tempgpa)
temppsv<-tempgpa$coords
discal[i]<-morphol.disparity(temppsv~1, groups = NULL, partial=F, iter=1, data = NULL,print.progress = T)
}
}
#loop iterating through the dispartity calculation but randomising the 
#species used. This is how the null hypothesis curve is generated.

if (discal==0) disres[a,]<-0 else {
# if no discal is caluculated because of NA/0 then set the output result to all 0
# otherwise  
disres[a,1]<-mean(discal)
disres[a,4]<-sd(discal)
e<-qnorm(0.975)*disres[a,4]/sqrt(numlat[a])
disres[a,2]<-disres[a,1]-e
disres[a,3]<-disres[a,1]+e
# filling the disres array with the iteration calculations
}
}
#larger loop running over all lats

lats<-seq(0,length(numlat)-1,1) # set sequence for new lats
disres<-cbind(rev(lats),disres,rev(adf$disparity)) 
# binding the reversed lats and reverserd real disparity to the results

colnames(disres)[1] <- "lats"
colnames(disres)[6]<-"disp"
# renaming the appropriate columns

disdf<-as.data.frame(disres)
# Put results into new data.frame and attaching the variable for accessibility
#library(tidyverse)
#disdf <- disdf %>% filter(lats>18)
#clean disdf (for pleuronectidae ONLY)
attach(disdf)
####### Plotting section

par(mai=c(0.9,1,0.1,0.2))

#Set graphing window

plot(lats, (rev(mean*1000)), pch=19, cex = 0.5, col="black", xaxt="n", 
     yaxt="n", frame.plot=F, xlab="+/- Degree Latitude", 
     ylab="Morphological disparity X 1000", cex.lab=1.7, las=1, xlim=c(18, 80), ylim = c(0,15))
#Plotting the mean of the modelld data

ytick<-seq(0, 15, by=1)
axis(1, lwd=3, tcl=0.25, cex.axis=1.5, xlim=c(18,80))
axis(2, at=ytick, lwd=3, tcl=0.25, cex.axis=1.5, ylim = c(0,33), las=1)
#Adding the axes to the plots seperately

lines(lats, (rev(lowe*1000)) , col = "red", lwd=2.0, lty=3)
lines(lats, (rev(highe*1000)) , col = "red", lwd=2.0, lty=3)
polygon(c(lats,rev(lats)), c(rev(highe*1000),(lowe*1000)),col=rgb(1, 0, 0,0.15), border=NA)
#adding the confidence 95% confidence areas around the modelled data

points(lats, rev(disp*1000) , pch=19, cex=0.6, col = "dodgerblue")
lines(lats, rev(disp*1000) , col = "dodgerblue", lwd=2.0, lty=1)
#plotting the actual disparity calculated previously in actualdisp-bylat.R

## change directory

setwd("~/Desktop/Fish project/results/null2")
write.csv(disdf, "disdfpleuronectidae_v2.txt")


#END

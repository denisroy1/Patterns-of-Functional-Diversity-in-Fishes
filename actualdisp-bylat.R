## GPA for fish families by latitude
## This proram reads in a file that contains the path and name of several
## csv files that contain the names of the actiual species that occur +/-
## every degree of latitude (from and including 0). Once read in it will use
## use this list to open each csv file sequentially.

## This script also reads in the TPS file made of all the species within the same family
## of fish, whose ID fields are those of all fish in the csv files. So both list csvs
## and the TPS files are read. 

## the script then performs a loop to opne each csv file and subsets the
## TPS file to take only the listed species at each lat. It then calculates 
## the procrostes coords and alignes the species used and calculates the 
## subsetted TPS morphological diversity. This latter is saved in a df 
## "realmd" that can be written to a .csv for import to other scritps.

## written by JD and DR Sept 2020

# reset all instances 
rm(list=ls())

## load libraries
library(rgl)
library(ape)
library(geomorph)

## Open dialog box to select list file of csv files for path and name access
## list file should be .txt not csv as csv automatically converts names to factors. 
## Result will be a dataframe with all the species lat csv
## files and the paths to be used 
setwd("~/Desktop/Fish project/Paths")
famlat<-read.table(file.choose(), header=T, as.is = T, sep=",")
attach(famlat) # can allow direct access to variables                           
Lnum<-length(lat) # get the length of the number of files to open

## seting directory to retrieve tps file
#setwd("/Users/denis/Dropbox/Morvla/")

## Reading landmarks from .TPS file
filein<-file.choose()
rawdat<-readland.tps(filein,specID ="ID", readcurves = F, warnmsg = T)

## Set empty dataframe to store results 
realmd = data.frame(matrix(vector(), 0, 3,
                       dimnames=list(c(), c("lat", "numspp", "disparity"))),
                stringsAsFactors=F)

## Loop that will get and open each csv file to retrieve the list on species
## at each latitude
for (a in 1:Lnum) {
latnum <- read.csv(famlat[a,], header = T) #reads the csv file
if (length(latnum[,1])<=1) next  # condition that enounters empty or single 
# species lats (cannot calculate disparity with less than 2 species)
temdat<-rawdat[,,latnum$species]  # subsample the TPS file for the list of individuals in 
# the csv 
temgpa<-gpagen(temdat,PrinAxes = T, print.progress = T)  # Perform procrustes alignement
plot(temgpa)  # plot the concensus
tempsv<-temgpa$coords # extract coords for morphdiv analyses
realmd[a,1]<-latnum$absLat[1]  # set results to show latitute
realmd[a,2]<-length(latnum[,1]) # set result to show number of species at lat
# set result to show disparity at lat from just the correc species
realmd[a,3]<-morphol.disparity(tempsv~1, groups = NULL, partial=F, iter=999, data = NULL,print.progress = T)
}

## The realmd data frome now contains the real morphological diversity 
## calculated at each lat which we can compare to the permutated one

# Quick plot of disparity by lat 
plot(realmd$lat,realmd$disparity) 

#create the file to store output
outfile<-gsub(".TPS",".amd",basename(filein),ignore.case = T) 

# writing results to outfile with a .amd extension
write.csv(realmd, file=outfile, append=F)

## END

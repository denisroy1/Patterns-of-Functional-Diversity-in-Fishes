
##################################################################
#### this script generates a brokenstick model and estimates  ####
####               breakpoints for the disp models            ####
####                Written by JD and DR 2021                 ####
####                         Version 4                        ####
##################################################################

## reset instances
rm(list=ls()) 
## load/install required packages
library(mcp)
#install.packages("brokenstick")
library(brokenstick)
library(segmented)
library(lme4)
library(tidyverse)
library(Epi)

## load in the disp data 
setwd("~/Desktop/Fish project/results/null2")
##read in txt file with lat and disparity
{sparidae <- read.csv("disdfsparidae.txt")
  labridae <- read.csv("disdflabridae.txt")
  blenniidae <- read.csv("disdfblenniidae.txt")
  acanthuridae <- read.csv("disdfAcanthuridae.txt")
  scombridae <- read.csv("disdfscombridae.txt")
  pomacentridae <- read.csv("disdfpomacentridae.txt")
  lutjanidae <- read.csv("disdflutjanidae.txt")
  pleuronectidae <- read.csv("disdfpleuronectidae_v2.txt")
  chaetodontidae <- read.csv("disdfchaetodontidae.txt")
  gobiidae <- read.csv("disdfgobiidae.txt")
  pomacanthidae <- read.csv("disdfpomacanthidae.txt")
}
# sets variable to specific family
fam <- blenniidae
## remove 0s 
#fam <- fam %>% filter(disp >0)
## plot disp to see trends and breakpoints
plot(disp ~ lats, data=fam, col="firebrick", pch = 19,  
     xlab="Dependent Variable",ylab="Response Variable")

#### broken stick ####
## find break point
lin.mod <- lm(disp~lats, fam) # define model
selgmented(lin.mod,type = "bic", seg.Z = ~lats,Kmax = 5)# see how many breakpoints best fits the data using bic
#sc<-seg.control(n.boot=50,fix.npsi = 2)
segmented.mod <- segmented(lin.mod,psi = c(34))##model the broken stick with the correct number of breaks
summary(segmented.mod) # the summary shows the break point + std error
confint(segmented.mod)# get confidence interval around breakpoint
anova(segmented.mod) ## p-val

plot(segmented.mod, add=T) # plot the broken stick model
plot(segmented.mod, add=T, conf.level=0.95, shade=T,col='black',lwd=2) # include confidence interval

#### linear model - blennidae ONLY  ####
newx <- seq(min(fam$lats),max(fam$lats),by = 0.05)
conf_interval <- predict(lin.mod, newdata=data.frame(lats=newx), interval="confidence",
                         level = 0.95)
#matlines(newx, conf_interval[,2:3], col = "blue", lty=1,bg= 2:5)
matshade(newx, conf_interval, col = "gray", lty=1)
abline(lin.mod,col='black',lwd=2)
summary(lin.mod)
#################################

### standard and complete plot
# reset the graph

#plot(disp ~ lats, data=fam, col="firebrick", pch = 19,  
#     xlab="Dependent Variable",ylab="Response Variable", 
#     ylim= c(0,0.01))

plot(disp ~ lats, data=fam, col="firebrick", pch = 19,  
     xlab="Dependent Variable",ylab="Response Variable", 
     yaxt="none",ylim= c(0,0.01))
axis(2,seq(0,0.01,0.005))

# plot piecewise fcn, highlight breakpoint
{plot(segmented.mod,add=T,link=F,lwd=2,col=9, lty=c(1,2,3))
  points(segmented.mod,col="blue", link=F)}

# with the confidence interval 
{plot(segmented.mod,add=T,link=F,lwd=2,col=9, lty=c(1,3,2),conf.level=.95,shade = T)
  points(segmented.mod,col="blue", link=F)}

## OR looking at effects using is=True -> see help for details
plot(segmented.mod, conf.level=.95, is=TRUE, isV=FALSE, col=2, shade = TRUE)

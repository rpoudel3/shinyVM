rm(list = ls())
library(dplyr)
library(class)
library(caret)
library(shiny)
library(Metrics)
library(scales)
library(RColorBrewer)
library(grid)
library(ggplot2)
library(ggthemes)
library(shiny)
library(shinythemes)
library(lattice)
library(reshape2)
library(GGally)
library(ppcor)



#setwd("~/Desktop/Git/shinyVM/")

fetal_data<- read.table("fetal-heart-disease.csv",header=TRUE,sep=',')

features<-read.table("features.csv",header=TRUE,sep=',')
  
feature.list <- list("LB" = "LB",
                     "AC"="AC","FM"="FM",
                     "UC"="UC","ASTV"="ASTV",
                     "mSTV"="mSTV","ALTV"="ALTV",
                     "mLTV"="mLTV","DL"="DL",
                     "DS"="DS","DP"="DP","Width"="Width",
                     "Min"="Min","Max"="Max",
                     "Nmax"="Mmax","Nzeros"="Nzeros","Mode"="Mode","Mean"="Mean","Median"="Median",
                     "Variance"="Variance","Tendency"="Tendency","CLASS"="CLASS")
                     

#Change the class of all the columns to numeric
fetal_data<- as.data.frame(apply(fetal_data, 2, as.numeric))

# remove na/missing values
fetal_data<-na.omit(fetal_data)

fetal_data$NSP <- factor(fetal_data$NSP, levels = c(1,2,3), labels = c("normal", "suspect","pathologic"))



#cancer_data1<-scale(cancer_data1[,1:35])








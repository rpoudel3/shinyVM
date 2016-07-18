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


source("plotlyGraphWidget.R")

#setwd("/Users/rashmipoudel/Desktop/Git/shinyVM/project/App_1/cluster")

cancer_data1 <- read.table("/Users/rashmipoudel/Desktop/Git/shinyVM/project/sample-apps/App_1/fetal-heart-disease.csv",header=TRUE,sep=',')

feature.list <- list("b" = "b", "e" ="e",
                     "LBE"= "LBE","LB" = "LB",
                     "AC"="AC","FM"="FM",
                     "UC"="UC","ASTV"="ASTV",
                     "mSTV"="mSTV","ALTV"="ALTV",
                     "mLTV"="mLTV","DL"="DL",
                     "DS"="DS","DP"="DP","DR"="DR","Width"="Width",
                     "Min"="Min","Max"="Max",
                     "Nmax"="Mmax","Nzeros"="Nzeros","Mode"="Mode","Median"="Median",
                     "Variance"="Variance","Tendency"="Tendency","A"="A","B"="B","C"="C",
                     "D"="D","SH"="SH","AD"="AD","DE"="DE",
                     "LD"="LD",
                     "FS"="FS","SUSP"="SUSP","CLASS"="CLASS")
                     

#Change the class of all the columns to numeric
cancer_data1<- as.data.frame(apply(cancer_data1, 2, as.numeric))

# remove na/missing values
cancer_data1<-na.omit(cancer_data1)

cancer_data1$NSP <- factor(cancer_data1$NSP, levels = c(1,2,3), labels = c("normal", "suspect","pathologic"))

#cancer_data1<-scale(cancer_data1[,1:35])








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
library(plotly)
library(ggthemes)



setwd("/Users/rashmipoudel/Desktop/Git/shinyVM/project/sample-apps/cluster")

cancer_data <- read.table("fetal-heart-disease.csv",header=TRUE,sep=',')

feature.list <- list("b" = "start instant", "e" ="end instant",
                     "LBE"= "baseline value","LB" = "baseline value",
                     "AC"="accelerations","FM"="foetal movement",
                     "UC"="uterine contractions","ASTV"="abnormal short term variability",
                     "mSTV"="mean value of short term variability","ALTV"=" abnormal long term variability",
                     "mLTV"="mean value of long term variability","DL"="light decelerations","DL"="light decelerations",
                     "DS"="severe decelerations","DP"="prolongued decelerations","DR-repetitive decelerations","Width"="histogram width",
                     "Min"="low freq. of the histogram","Max"="high freq. of the histogram","Max"="high freq. of the histogram",
                     "Nmax"="number of histogram peaks","Nzeros"="number of histogram zeros","Mode"="histogram mode","Median"="histogram median",
                     "Variance"="histogram variance","Tendency"="histogram tendency","A"="calm sleep","B"="REM sleep","C"="calm vigilance",
                     "D"="active vigilance","SH"="shift pattern","AD"="accelerative_decelerative pattern","DE"="decelerative pattern",
                     "LD"="largely decelerative pattern",
                     "FS"="flat-sinusoidal pattern","SUSP"="suspect pattern","CLASS"="Class code")
                     

#Change the class of all the columns to numeric
cancer_data<- as.data.frame(apply(cancer_data, 2, as.numeric))

# remove na/missing values
cancer_data<-na.omit(cancer_data)

cancer_data$NSP <- factor(cancer_data$NSP, levels = c(1,2,3), labels = c("normal", "suspect","pathologic"))








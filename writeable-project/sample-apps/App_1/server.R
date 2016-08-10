library(shiny)
library(nnet)
library(psych)
library(randomForest)
library(ggplot2)

palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
          "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))

# Define server logic required to draw a histogram
shinyServer(function(input, output,session) {
  output$contents <- renderTable({
    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, it will be a data frame with 'name',
    # 'size', 'type', and 'datapath' columns. The 'datapath'
    # column will contain the local filenames where the data can
    # be found.
    
    inFile <- input$file
    
    if (is.null(inFile))
      return(NULL)
    
    read.table(inFile$datapath, header = input$header,
             sep = input$sep, quote = input$quote,stringsAsFactors = input$stringAsFactors)
  })
  data<-reactive({
    
    file1<-input$file
    if(is.null(file1)){return()}
    read.table(file=file1$datapath,sep=input$sep, header=input$header,
               stringAsFactors=input$stringAsFactors)
  })
  
  output$filedf<-renderTable({
    if(is.null(data())){ return ()}
    input$file
  })
  
  output$sum<-renderTable({
    
    if(is.null(data())){return()}
    summary(data())
  })
  output$table<-renderTable({
    
    if(is.null(data())){return()}
    data()
  })
  output$tb<-renderUI({
    
    #if(is.null(data()))
      #h5("Powered by",tags$img(src="welcome.png",heigth=200,width=200))
    #else
      tabsetPanel(tabPanel("About file",tableOutput("filedf")),tabPanel("Data",tableOutput("table")),
                  tabPanel("Data Summary",verbatimTextOutput("sum")))

  })
  selectedData <- reactive({
    fetal_data[, c(input$xcol, input$ycol)]
  })
  
  clusters <- reactive({
    kmeans(selectedData(), input$clusters)
  })
  

  output$plot2<- renderPlot({
    colm<-as.numeric(input$var)
    g <- ggplot(data=fetal_data)
    g + geom_histogram(aes(x=fetal_data[,colm], fill=fetal_data$NSP),binwidth=5,position="identity") 
    #hist(fetal_data[,colm],include.lowest=TRUE,l=input$bins+1)
  })
  output$plot3<- renderPlot({
    colm<-as.numeric(input$var)
    g <- ggplot(data=fetal_data)
    g + geom_density(aes(x=fetal_data[,colm], fill=fetal_data$NSP), alpha=1)
  
  })
  
  output$corplot <- renderPlot({
      corrplot(cor(fetal_data[,1:21]))
    
  })
  
  output$caption<-renderText({
    switch(input$plot.type,
           "boxplot" 	= 	"Boxplot",
           "histogram" =	"Histogram",
           "density" 	=	"Density plot",
           "bar" 		=	"Bar graph")
  })
  

  output$plot1 <- renderPlot({
    par(mar = c(5.1, 4.1, 0, 1))
    plot(selectedData(),
         col = clusters()$cluster,
         pch = 20, cex = 3)
    points(clusters()$centers, pch = 4, cex = 4, lwd = 4)
  })
  
  
  output$summary <- renderPrint({
    summary(fetal_data)
  })
  
  output$view <- renderTable({
    set.seed(62433)
    fetal_data[sample(nrow(fetal_data), size = input$obs),]
  })
  
  output$mytable1<-renderDataTable({
    fetal_data[, input$show_vars, drop = FALSE]
  })
  output$mytable2 = renderDataTable({
    features
  })
  algorithmInput <- reactive(input$algorithm)
  
  output$results_regression<-renderPrint({
    logisticPseudoR2s <- function(LogModel) {
      dev <- LogModel$deviance 
      nullDev <- LogModel$null.deviance 
      modelN <-  length(LogModel$fitted.values)
      R.l <-  1 -  dev / nullDev
      R.cs <- 1- exp ( -(nullDev - dev) / modelN)
      R.n <- R.cs / ( 1 - ( exp (-(nullDev / modelN))))
      cat("Pseudo R^2 for logistic regression\n")
      cat("Hosmer and Lemeshow R^2  ", round(R.l, 3), "\n")
      cat("Cox and Snell R^2        ", round(R.cs, 3), "\n")
      cat("Nagelkerke R^2           ", round(R.n, 3),    "\n")
    }
    
    d2_attrib<-fetal_data[,1:22]
    
    fa4_all_vm <- principal(d2_attrib, nfactors =4, rotate = "varimax")
    fa4_all_vm  
    
    # Can predict with the PCs, sometimes get a better result or 
    # understanding of the data
    #NB: component scores are standard scores (mean=0, sd = 1) of the standardized input
    rotation4 <- data.frame(fa4_all_vm$score, class=fetal_data[,"NSP"])
    logisticMod <- multinom(class ~  PC1 + PC2 + PC3 + PC4, data = rotation4)
    summary(logisticMod) 
    
  })
  
  
  output$results <- renderPrint({
    
    
    # split in training testing datasets
    trainIndex <- sample(nrow(fetal_data), size = nrow(fetal_data)*input$slidertrainsplit)
    training = fetal_data[trainIndex,]
    testing = fetal_data[-trainIndex,]
    
    # apply selected classification algorithm
    if(algorithmInput()=="Logistic Regression") {
      
      # print classification parameters
      print("Algorithm selected: Logistic Regression")
      print(paste("Training set: ", input$slidertrainsplit*100, "%", sep = ""))
      print(paste("Testing set: ", (1-input$slidertrainsplit)*100, "%", sep = ""))
      
     
      
      # Here we use fewer PCs so we can see some structure in the data:
      # Variables that are correlated share a PC
      d2_attrib<-fetal_data[,1:22]
      
      
      
      # Can predict with the PCs, sometimes get a better result or 
      # understanding of the data
      #NB: component scores are standard scores (mean=0, sd = 1) of the standardized input
      #rotation4 <- data.frame(fa4_all_vm$score, class=fetal_data[,"NSP"])
      #logisticMod <- multinom(class ~  PC1 + PC2 + PC3 + PC4, data = rotation4)
      #summary(logisticMod) #AIC: 782.51, Nagelkerke R^2 0.345 
      #logisticPseudoR2s(logisticMod)
      
      #library(rpart)
      #set.seed(62433)
      model <-multinom(NSP ~ UC+AC+ASTV+MSTV+MLTV+ALTV+DP+Mode+Mean+Median , data= fetal_data)
      #model<-multinom(NSP~LB+AC+FM+UC+ASTV+MSTV+ALTV+MLTV+DL+DS+DP+Width+Min+Max+Nmax
                      #+Nzeros+Mode+Mean+Median+Variance+Tendency,data=fetal_data)
      # test rpart model
      pred <- predict(model, testing, type  = "class")
      
      xtab<-table(predicted = pred, reference = testing$NSP)
      
      # print model
      summary(model)
      
      confusionMatrix(xtab)
      
    } else if(algorithmInput()=="randomForest") {
      
      # print classification parameters
      print("Algorithm selected: randomForest")
      print(paste("Training set: ", input$slidertrainsplit*100, "%", sep = ""))
      print(paste("Testing set: ", (1-input$slidertrainsplit)*100, "%", sep = ""))
      
      # build randomForest model
     
      set.seed(62433)
      model <- randomForest(NSP ~ . , data=fetal_data, importance=TRUE)
      
      print (importance(model, type=1))
        
   
      
      # test randomForest model
      pred <- predict(model, testing, type  = "class")
      xtab<-table(predicted = pred, reference = testing$NSP)
      
      # print model
      summary(model)
      
      confusionMatrix(xtab)
      #precision <- posPredValue(predicted = pred, reference = testing$NSP)
      #precision
      #recall <- sensitivity(predicted = pred, reference = testing$NSP)
      #recall
      #F1 <- (2 * precision * recall) / (precision + recall)
      #F1
    
    } else if(algorithmInput()=="lda") {
      
      
      # print classification parameters
      print("Algorithm selected: lda")
      print(paste("Training set: ", input$slidertrainsplit*100, "%", sep = ""))
      print(paste("Testing set: ", (1-input$slidertrainsplit)*100, "%", sep = ""))
      
      # build lda model
      #library(MASS)
      set.seed(62433)
      model <- lda(NSP~ . , data= fetal_data)
      
      # test lda model
      pred <- predict(model, testing, type  = "class")
      print(table(predicted = pred$class, reference = testing$Species))
      
      # print model
      summary(model)      
      
    }  else{
      print("Error no Algorithm selected")
    }
    
  }) 

  
})

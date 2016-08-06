library(shiny)

palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
          "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))

# Define server logic required to draw a histogram
shinyServer(function(input, output,session) {
  dmeths = c("euclidean", "manhattan"
            )
  cmeths = c("ward.D", "ward.D2",
             "single", "complete", "average", "mcquitty",
             "median", "centroid")

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
      corrplot(cor(fetal_data[,1:22]))
    
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
  
  output$mytable1= renderDataTable({
    library(ggplot2)
    fetal_data[, input$show_vars, drop = FALSE]
  })
  output$mytable2 = renderDataTable({
    features
  })
  algorithmInput <- reactive(input$algorithm)
  
  output$results <- renderPrint({
    
    
    # split in training testing datasets
    trainIndex <- sample(nrow(fetal_data), size = nrow(fetal_data)*input$slidertrainsplit)
    training = fetal_data[trainIndex,]
    testing = fetal_data[-trainIndex,]
    
    # apply selected classification algorithm
    if(algorithmInput()=="PCA") {
      
      # print classification parameters
      print("Algorithm selected: rpart")
      print(paste("Training set: ", input$slidertrainsplit*100, "%", sep = ""))
      print(paste("Testing set: ", (1-input$slidertrainsplit)*100, "%", sep = ""))
      
      # build rpart model
      library(rpart)
      set.seed(62433)
      model <- rpart(NSP ~ . , data= fetal_data)
      
      # test rpart model
      pred <- predict(model, testing, type  = "class")
      print(table(predicted = pred, reference = testing$NSP))
      
      # print model
      summary(model)
      
    } else if(algorithmInput()=="randomForest") {
      
      # print classification parameters
      print("Algorithm selected: randomForest")
      print(paste("Training set: ", input$slidertrainsplit*100, "%", sep = ""))
      print(paste("Testing set: ", (1-input$slidertrainsplit)*100, "%", sep = ""))
      
      # build randomForest model
      library(randomForest)
      set.seed(62433)
      model <- randomForest(NSP ~ . , data=fetal_data)
      
      # test randomForest model
      pred <- predict(model, testing, type  = "class")
      print(table(predicted = pred, reference = testing$NSP))
      
      # print model
      summary(model)
      
      
    } else if(algorithmInput()=="lda") {
      
      
      # print classification parameters
      print("Algorithm selected: lda")
      print(paste("Training set: ", input$slidertrainsplit*100, "%", sep = ""))
      print(paste("Testing set: ", (1-input$slidertrainsplit)*100, "%", sep = ""))
      
      # build lda model
      library(MASS)
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

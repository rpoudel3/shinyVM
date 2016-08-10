# server.R

library(shiny)

shinyServer(function(input, output) {
  
  filedata <- reactive({
    infile <- input$file1
    if (is.null(infile)){
      return(NULL)      
    }
    read.csv(infile$datapath)
  })
  
  output$ui.action <- renderUI({
    if (is.null(filedata())) return()
    actionButton("action", "Run regression")
  })
  
  output$dependent <- renderUI({
    df <- filedata()
    if (is.null(df)) return(NULL)
    items=names(df)
    names(items)=items
    selectInput("dependent","Now select ONE variable as dependent variable from:",items)
  })
  
  
  output$independents <- renderUI({
    df <- filedata()
    if (is.null(df)) return(NULL)
    items=names(df)
    names(items)=items
    selectInput("independents","Also select ONE or MANY independent variables in the box below. You can change your selection several times:",items,multiple=TRUE)
  })
  
  output$sum<-renderTable({
    
    if(is.null(df())){return()}
    summary(df())
  })
  output$table<-renderTable({
    
    if(is.null(df())){return()}
    df()
  })
  
  output$contents <- renderPrint({
    if (is.null(input$action)) return()
    if (input$action==0) return()
    isolate({
      df <- filedata()
      if (is.null(df)) return(NULL)
      fmla <- as.formula(paste(input$dependent," ~ ",paste(input$independents,collapse="+")))
      summary(lm(fmla,data=df))
    })
  })
  
  
}) 
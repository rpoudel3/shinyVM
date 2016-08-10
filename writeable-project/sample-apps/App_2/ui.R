library(shiny)
library(shinythemes)

shinyUI(fluidPage("",theme = shinytheme("united"),
  titlePanel(" Data Analysis using R/Shiny"),
  sidebarLayout(
    sidebarPanel(
      p("Please upload a CSV formatted file with your data."),
      fileInput('file1', label='Click button below to select the file in your computer.',
                accept=c('text/csv', 
                         'text/comma-separated-values,text/plain', 
                         '.csv')),
      checkboxInput(inputId='header', label='Header', value=TRUE),
      checkboxInput(inputId='stringAsFactors','stringAsFactors', FALSE),
      br(),
      radioButtons(inputId='sep', label="Separator",choices=
                     c(Comma=',',
                       Semicolon=';',
                       Tab='\t'), selected=','),
      
      tags$hr(),
      uiOutput("dependent"),
      uiOutput("independents"),
      tags$hr(),
      uiOutput('ui.action') # instead of conditionalPanel
    ),
    mainPanel(
      tabsetPanel(
      
        tabPanel("Regression Output",
                 verbatimTextOutput('contents')),
        tabPanel('Data Table',
                 dataTableOutput("table")),
        tabPanel("Statistical Measures",
                 verbatimTextOutput("sum"))
      
  
      )
    )
  )
))

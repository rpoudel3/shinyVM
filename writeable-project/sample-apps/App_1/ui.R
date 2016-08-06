library(corrplot)
shinyUI(navbarPage("",theme = shinytheme("united"),
                   tabPanel("Data Description",
                            headerPanel('Data Exploration'),
                            sidebarPanel(
                              checkboxGroupInput('show_vars', 
                                                 'Columns in fetal_heart to show:', 
                                                 names(fetal_data),
                                                 selected = names(fetal_data)),
                              helpText("For the Fetal Health data, we can select variables
                                       to show in the table")
                            ),
                            mainPanel(
                              tabsetPanel(
                                tabPanel('Data Table',
                                         dataTableOutput("mytable1")),
                                tabPanel('Feature Description',
                                         dataTableOutput("mytable2"))
                              )
                            )
                            
                   ),
                   
                   tabPanel("Correlation",
                            sidebarPanel(
                              helpText("Fetal State(NSP) is moderately correlated with Acceleration(AC), prolonged deceleration(DP),
                                       abnormal short term variability(ASTV) amd abnormal long term variability (ALTV)")
                            ),
                            mainPanel(
                            
                            plotOutput("corplot", height=600)
                            )
                   ),
    
                   tabPanel("Statistical Measures of Variables",
                                     verbatimTextOutput("summary")
                   ),
                   
                   tabPanel("Plots",
                            headerPanel("Variable Selection"),
                            sidebarPanel(
                            selectInput("var","1.Select the variable for the dataset",choices= c("LB"=1,"AC"=2,"FM"=3,"UC"=4,
                                        "ASTV"=5, "MSTV"=6,"ALTV"=7,"MLTV"=8,"DL"=9,"DS"=10,"DP"=11,"Width"=12,"Min"=13,"Max"=14,
                                        "Nmax"=15,"Nzeros"=16,"Mode"=17,"Mean"=18,"Median"=19,"Variance"=20,"Tendency"=21)),
                            br(),
                            sliderInput("bins","2.Select the number of bins for histogram", min=5, max=25,value=10)
                          
      
                            ),
                            mainPanel(
                              tabsetPanel(
                                tabPanel("Histogram",
                                         plotOutput("plot2")),
                                tabPanel("Density Plots",
                                           plotOutput("plot3"))
                              )
                            )

                   ),

                   tabPanel("Clustering",
                              headerPanel('Fetal Health k-means clustering'),
                              sidebarPanel(
                                selectInput('xcol', 'X Variable', names(fetal_data)),
                                selectInput('ycol', 'Y Variable', names(fetal_data)),
                                selected=names(fetal_data[[2]]),
                                numericInput('clusters', 'Cluster count', 3,
                                             min = 1, max = 9)
                              ),
                              mainPanel(
                                plotOutput("plot1")
                              )

                   ),
                   
                   tabPanel("Classification",
                              headerPanel("Fetal Heart Classification"),
                              
                              sidebarPanel(
                                
                                numericInput("obs", "Number of observations to view:", 5), 
                                
                                sliderInput("slidertrainsplit",
                                            "Proportion of Training observations",
                                            min = 0, max = 1, value = 0.7, step = 0.1),
                                
                                selectInput("algorithm", "Choose a Classification algorithm:", 
                                            choices = c("PCA", "randomForest"))
                                
                              ),
                              
                              # Show the some example of observations, a summary of the dataset 
                              # and the results on the model
                              mainPanel(
                                
                                p("This App shows the application of 3 different classification algorithms (rpart, randomForest and lda) to the iris dataset."),
            
                                p("Lastly it trains a classification algorithm chosen by the user on the sidepar panel, splitting the iris dataset
                                  in training and testing sets based on the chosen proportion chosen on the sidebar (by defuault 70% training 30% testing)."),
                                h2("Results"),
                                verbatimTextOutput("results")
                              )
                   )
))
shinyUI(navbarPage("",
                   tabPanel("Feature Descriptions",
                            fluidRow(
                              column(10,
                                     includeMarkdown("features.rmd")
                              )
                            )
                   ),
                   
                  
                            
                   
                   tabPanel("Clustering",
                              headerPanel('Fetal Heatlh k-means clustering'),
                              sidebarPanel(
                                selectInput('xcol', 'X Variable', names(cancer_data1)),
                                selectInput('ycol', 'Y Variable', names(cancer_data1),
                                            selected=names(cancer_data1)[[2]]),
                                numericInput('clusters', 'Cluster count', 3,
                                             min = 1, max = 9)
                              ),
                              mainPanel(
                                plotOutput('plot1')
                              )
                            )
                            
                   
))
shinyUI(navbarPage("",
                   tabPanel("Visualize Features",
                            fluidRow(                           
                              column(4, selectInput("featureDisplay_x", 
                                                    label = h3("X-Axis Feature"), 
                                                    choices = feature.list,
                                                    selected = feature.list[1])),
                              column(4, selectInput("featureDisplay_y", 
                                                    label = h3("Y-Axis Feature"), 
                                                    choices = feature.list,
                                                    selected = feature.list[2]))
                              
                            ),
                            fluidRow(
                              column(4,
                                     graphOutput("distPlotA")
                              ),                              
                              column(4,
                                     graphOutput("distPlotB")      
                              ),
                              column(4,
                                     graphOutput("ScatterPlot")
                              )
                            )
                            
                            
                   ),
                   
                   tabPanel("Feature Descriptions",
                            fluidRow(
                              column(10,
                                     includeMarkdown("features.rmd")
                              )
                            )
                            
                   )
                   
))
library(leaflet)
library("shiny")
library(shinyWidgets)

navbarPage("NYC Garden Distribution", id = "nav",
           
           tabPanel("By Location",
                    div(class = "outer",
                        
                        tags$head(
                          # Include our custom CSS
                          includeCSS("style.css"),
                          includeScript("gomap.js")
                        ),
                        
                        leafletOutput("map", width = "100%", height = "100%"),

                        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                      draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                                      width = 330, height = "auto",
                                      
                                      h2("Select Location"),
                                      
                                      pickerInput("borough", "Select Borough:", choices = c("Manhattan", "Bronx", "Brooklyn", "Queens", "Staten Island"), selected = "Manhattan", multiple = TRUE, options = list(placeholder = 'select borough')),
                        ),
                        
                        tags$div(id = "cite",
                                 'Data compiled for ', tags$em('NYC Garden Distribution'))
                    )
                    ), 
                    
              tabPanel("Demographic Characteristics",
                       h2("Demographic Characteristics by Location"),
                       hr(),
                       reactableOutput("table")
              ),
      
         conditionalPanel("false", icon("crosshair"))
)
                                      
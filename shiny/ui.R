library(leaflet)

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
                                      
                                      selectInput("borough", "Select Borough:", borough_choices, selected = "Manhattan"),
                                      selectInput("community_board", "Select Community Board:", board_choices)
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
                                      
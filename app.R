library(flexdashboard)
library(shiny)
library(leaflet)
library(plotly)
library(tidyverse)

# Read in data
garden =
  read_csv("./data/final_df.csv") %>%
  group_by(community_board) %>%
  select(community_board, borough, overall_pop, race_white:college_higher, garden_name:longitude)

garden_num = 
  garden %>% 
  drop_na(garden_name) %>% 
  group_by(community_board) %>% 
  summarize(garden_num = n())

garden_tidy = 
  left_join(garden, garden_num, by = "community_board")


leafIcons <- icons(
  iconUrl = ifelse(garden_tidy$size > 0.55,
                   "http://leafletjs.com/examples/custom-icons/leaf-green.png",
                   "http://leafletjs.com/examples/custom-icons/leaf-green.png"
  ),
  iconWidth = 10, iconHeight = 20,
  iconAnchorX = 22, iconAnchorY = 94,
)

borough_choices = garden_tidy %>% distinct(borough) %>% pull()
board_choices = garden_tidy %>% distinct(community_board) %>% pull()

# Define UI

ui = fluidPage(
  uiOutput("borough"),
  leafletOutput("map")
)

server = function(input, output, session){
  
  output$borough = renderUI({
    
    choices = as.character(unique(garden_tidy$borough))
    selectInput(inputId = "borough", label = "Select Borough:", choices = choices, selected = "Manhattan")
    
  })
  
  output$map = renderLeaflet({
    
    BOROUGH = input$borough
    
    if(BOROUGH != 'All'){
      garden_tidy2 = garden_tidy[garden_tidy$borough == BOROUGH, ]
    }else{
      garden_tidy2 = garden_tidy
    } 
    
    garden_tidy2 =
      leaflet(garden_tidy2) %>%
      addProviderTiles(providers$CartoDB.Positron) %>% 
      addMarkers(~longitude, ~latitude, icon = leafIcons,
                 popup = paste("<b>", garden_tidy$garden_name, "</b><br>",
                              garden_tidy$borough, "</b><br>",
                              garden_tidy$size, " acres"))
    return(garden_tidy2)
  })
}

shinyApp(ui = ui, server = server)
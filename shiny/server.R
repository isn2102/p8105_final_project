library(shiny)
library(shinyjs)
library(leaflet)
library(tidyverse)
library(plotly)

shinyServer(function(input, output, session){
  
  ####
  output$table <- renderReactable({
    reactable(age_tables, groupBy = "Borough",highlight = TRUE, searchable = TRUE, striped = FALSE, fullWidth = FALSE, showSortIcon = FALSE, 
              theme = reactableTheme(
                borderColor = "#DBF0E6",
                highlightColor = "#D1E9DE"), 
              defaultColDef = colDef(
                align = "center",
                minWidth = 100),
              columns = list(
                'Community Board' = colDef(),
                "0 to 17 years" = colDef(aggregate = "mean", format = colFormat(digits = 2, suffix = "%")),
                "18 to 24 years" = colDef(aggregate = "mean", format = colFormat(digits = 2, suffix = "%")),
                "25 to 44 years" = colDef(aggregate = "mean", format = colFormat(digits = 2, suffix = "%")),
                "45 to 64 years" = colDef(aggregate = "mean", format = colFormat(digits = 2, suffix = "%")),
                "64 plus" = colDef(aggregate = "mean", format = colFormat(digits = 2, suffix = "%"))))
  })
  
  ### MAPS
  
  # Set base map
  output$map = renderLeaflet({
  
    garden_tidy %>% 
      leaflet() %>% 
      addProviderTiles(providers$CartoDB.Positron) %>% 
      setView( lat = 40.7, lng = -74 , zoom = 10)
  })
  
  # Select borough
  selectedborough = reactive({
    garden_tidy[garden_tidy$borough %in% input$borough, ]
  })
    
   observe({
     
     leafletProxy("map", data = selectedborough()) %>% 
       addMarkers(lng = selectedborough() %>% pull(longitude), 
                  lat = selectedborough() %>% pull(latitude), 
                  icon = leafIcons,
                  clusterOptions = markerClusterOptions(),
                  popup = paste("<b>", selectedborough() %>% pull(garden_name), "</b><br>",
                                selectedborough() %>% pull(borough), "</b><br>",
                                selectedborough() %>% pull(size), " acres")
       )
   })
})
    

  
  
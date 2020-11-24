library(shiny)
library(shinyjs)
library(leaflet)
library(tidyverse)
library(plotly)

shinyServer(function(input, output){
  
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
  
  output$map = renderLeaflet({
    
      leaflet() %>% 
        addProviderTiles(providers$CartoDB.Positron) %>% 
        addMarkers(data = garden_tidy,
                  lng = ~longitude, 
                  lat = ~latitude, 
                  group = "Manhattan",
                  icon = leafIcons,
                  clusterOptions = markerClusterOptions(),
                  popup = paste("<b>", garden_tidy$garden_name, "</b><br>",
                                 garden_tidy$borough, "</b><br>",
                                 garden_tidy$size, " acres"))
  })
})
  
  
  
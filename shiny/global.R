library(tidyverse)
library(readxl)
library(reactable)

# Read in data
garden =
  read_csv("./final_df.csv") %>%
  group_by(community_board) %>%
  select(community_board, borough, overall_pop, race_white:college_higher, garden_name:longitude)

garden_num = 
  garden %>% 
  drop_na(garden_name) %>% 
  group_by(community_board) %>% 
  summarize(garden_num = n())

garden_tidy = 
  left_join(garden, garden_num, by = "community_board")

# Leaf icons
leafIcons <- icons(
  iconUrl = ifelse(garden_tidy$size > 0.55,
                   "http://leafletjs.com/examples/custom-icons/leaf-green.png",
                   "http://leafletjs.com/examples/custom-icons/leaf-green.png"
  ),
  iconWidth = 10, iconHeight = 20,
  iconAnchorX = 22, iconAnchorY = 94,
)

# Age table for shiny
age_tables =
  garden_tidy %>% 
  select(borough, community_board, age0to17:age65plus) %>% 
  distinct()

colnames(age_tables) = c("Borough", "Community Board", "0 to 17 years", "18 to 24 years", "25 to 44 years", "45 to 64 years", "64 plus")


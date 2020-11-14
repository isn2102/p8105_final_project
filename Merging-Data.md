Data Cleaning and Merging
================
11/13/20

### Authors

  - Isabel Nelson (isn2102)
  - Sushupta Vijapur (smv2138)
  - Kelley Lou (kl3181)

<!-- end list -->

``` r
library(tidyverse)
library(readxl)
```

Reading in multiple data sources

[NYC Greenthumb Community
Gardens](https://data.cityofnewyork.us/Environment/NYC-Greenthumb-Community-Gardens/ajxm-kzmj)

``` r
gardens = 
  read_csv("./data/nyc_community_gardens.csv") %>% 
  janitor::clean_names() %>% 
  mutate(
    community_board = replace(community_board, community_board == "N/A", NA)
  ) %>% 
  relocate(community_board) %>% 
  select(-prop_id,-census_tract, -bin, -bbl, -nta)
```

    ## Parsed with column specification:
    ## cols(
    ##   PropID = col_character(),
    ##   Boro = col_character(),
    ##   `Community Board` = col_character(),
    ##   `Council District` = col_double(),
    ##   `Garden Name` = col_character(),
    ##   Address = col_character(),
    ##   Size = col_double(),
    ##   Jurisdiction = col_character(),
    ##   NeighborhoodName = col_character(),
    ##   `Cross Streets` = col_character(),
    ##   Latitude = col_double(),
    ##   Longitude = col_double(),
    ##   Postcode = col_double(),
    ##   `Census Tract` = col_double(),
    ##   BIN = col_double(),
    ##   BBL = col_double(),
    ##   NTA = col_character()
    ## )

Community board is not a unique identifier here….

Demographic and Community data

ID Borough Name 0 City NYC 1 NYC Manhattan (M) 2 NYC Bronx (x) 3 NYC
Brooklyn (B) 4 NYC Queens (Q) 5 NYC Staten Island (R)

``` r
demo = 
  read_xlsx("./data/health_profiles.xlsx",
  sheet = "CHP_all_data", skip = 1) %>% 
  janitor::clean_names() %>% 
  slice(-(1:6)) %>% 
  slice_head(n = 59) %>% 
  mutate(
    id = str_replace(id, "^1", "M"),
    id = str_replace(id, "^2", "X"),
    id = str_replace(id, "^3", "B"),
    id = str_replace(id, "^4", "Q"),
    id = str_replace(id, "^5", "R"),
    gentrification = replace(gentrification, gentrification == "n/a", NA),
    avertable_death = replace(avertable_death, avertable_death == "n/a", NA),
    avertable_death = replace(avertable_death, avertable_death == "^", NA)
  ) %>% 
  rename(community_board = id, not_complete_hs = edu_did_not_complete_hs, hs_some_college = edu_hs_grad_some_college, college_higher = edu_college_degree_and_higher) %>% 
  select(community_board:age65plus, on_time_hs_grad, not_complete_hs, hs_some_college, college_higher, poverty, unemployment, rent_burden, gentrification,
         avertable_death, assault_hosp)
```

    ## New names:
    ## * lower_95CL -> lower_95CL...16
    ## * upper_95CL -> upper_95CL...17
    ## * NYC_Comparison -> NYC_Comparison...18
    ## * lower_95CL -> lower_95CL...20
    ## * upper_95CL -> upper_95CL...21
    ## * ...

``` r
garden_demo = left_join(gardens, demo, by = "community_board")
```

[Revised property value
notices](https://data.cityofnewyork.us/City-Government/Revised-Notice-of-Property-Value-RNOPV-/8vgb-zm6e)

``` r
property = 
  read_csv("./data/property_values.csv") %>% 
  janitor::clean_names() %>% 
  relocate(community_board, borough) %>% 
  drop_na(community_board) %>% 
  mutate(
    comm_board = case_when(
      borough == "MANHATTAN" ~ "M",
      borough == "BRONX" ~ "X",
      borough == "BROOKLYN" ~ "B",
      borough == "QUEENS" ~ "Q",
      borough == "STATEN IS" ~ "R"
    )
  ) %>% 
   relocate(community_board, borough, comm_board)
```

    ## Parsed with column specification:
    ## cols(
    ##   .default = col_double(),
    ##   `MAILED DATE` = col_character(),
    ##   EASE = col_logical(),
    ##   NAME = col_character(),
    ##   `Address 1` = col_character(),
    ##   `Address 2` = col_character(),
    ##   `Address 3` = col_character(),
    ##   `City, State, Zip` = col_character(),
    ##   Country = col_logical(),
    ##   `BLD Class` = col_character(),
    ##   `RC 1` = col_character(),
    ##   RC2 = col_character(),
    ##   RC3 = col_logical(),
    ##   RC4 = col_logical(),
    ##   RC5 = col_logical(),
    ##   Borough = col_character(),
    ##   NTA = col_character()
    ## )

    ## See spec(...) for full column specifications.

[NYC
OpenData](https://data.cityofnewyork.us/City-Government/Participatory-Budgeting-Project-Tracker/qm5f-frjb)

``` r
budget = 
  read_csv("./data/budget_tracker.csv") %>% 
  janitor::clean_names() %>% 
  drop_na(community_board) %>% 
  mutate(
    comm_board = case_when(
      borough == "MANHATTAN" ~ "M",
      borough == "BRONX" ~ "X",
      borough == "BROOKLYN" ~ "B",
      borough == "QUEENS" ~ "Q",
      borough == "STATEN IS" ~ "R"
    ),
  comm_board = ifelse(is.na(community_board), NA, community_board) 
  ) %>% 
  relocate(community_board, borough, comm_board)
```

    ## Parsed with column specification:
    ## cols(
    ##   .default = col_character(),
    ##   `Vote Year` = col_double(),
    ##   `Ballot Price` = col_double(),
    ##   `Subproject Cost` = col_double(),
    ##   `Brooklyn Borough President Funding` = col_double(),
    ##   `Total Appropriated` = col_double(),
    ##   `Number of Subprojects` = col_double(),
    ##   Postcode = col_double(),
    ##   `Community Board` = col_double(),
    ##   `Census Tract` = col_double(),
    ##   BIN = col_double(),
    ##   BBL = col_double()
    ## )

    ## See spec(...) for full column specifications.

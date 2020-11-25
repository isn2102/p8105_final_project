Data Cleaning and Merging
================
11/13/20

``` r
library(tidyverse)
library(readxl)
```

**Borough Codes**

  - 1 - Manhattan (M)
  - 2 - Bronx (x)
  - 3 - Brooklyn (B)
  - 4 - Queens (Q)
  - 5 - Staten Island (R)

### [NYC Greenthumb Community Gardens](https://data.cityofnewyork.us/Environment/NYC-Greenthumb-Community-Gardens/ajxm-kzmj)

**Cleaning and tidying garden data**

``` r
gardens = 
  read_csv("./data/nyc_community_gardens.csv") %>% 
  janitor::clean_names() %>% 
  mutate(
    community_board = replace(community_board, community_board == "N/A", NA)
  ) %>% 
  drop_na(community_board) %>% 
  relocate(community_board) %>% 
  select(-prop_id,-census_tract, -bin, -bbl, -nta, -council_district, -cross_streets, -jurisdiction, -postcode)
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

### Demographic and Community data

**Cleaning and tidying demographic data**

``` r
demo = 
  read_xlsx("./data/health_profiles.xlsx",
  sheet = "CHP_all_data", skip = 1) %>% 
  janitor::clean_names() %>% 
  slice(-(1:6)) %>% 
  slice_head(n = 59) %>% 
  mutate(
    id_spatial = id, 
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
  select(id_spatial, community_board:age65plus, on_time_hs_grad, not_complete_hs, hs_some_college, college_higher, poverty, rent_burden, obesity, hypertension, life_expectancy, self_rep_health)
```

    ## New names:
    ## * lower_95CL -> lower_95CL...16
    ## * upper_95CL -> upper_95CL...17
    ## * NYC_Comparison -> NYC_Comparison...18
    ## * lower_95CL -> lower_95CL...20
    ## * upper_95CL -> upper_95CL...21
    ## * ...

### [Revised property value notices](https://data.cityofnewyork.us/City-Government/Revised-Notice-of-Property-Value-RNOPV-/8vgb-zm6e)

**Cleaning and tidying property data**

``` r
property = 
  read_csv("./data/property_values.csv") %>% 
  janitor::clean_names() %>% drop_na(community_board) %>% 
  rename(old_community_board = community_board) %>% 
  mutate(
    boro_letter = case_when(
      borough == "MANHATTAN" ~ "M",
      borough == "BRONX" ~ "X",
      borough == "BROOKLYN" ~ "B",
      borough == "QUEENS" ~ "Q",
      borough == "STATEN IS" ~ "R"
    ),
    board_num = ifelse(nchar(old_community_board) == 1, paste0(0, old_community_board), old_community_board)
  ) %>% 
  unite("community_board", boro_letter, board_num, sep = "") %>% 
  relocate(community_board, old_community_board, borough) %>% 
  select(community_board, original_market_value, revised_market_value)
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

**Grouping values by community board**

``` r
property_tidy = 
  property %>% 
  group_by(community_board) %>% 
  summarize(
    avg_org_value = mean(original_market_value, na.rm = TRUE),
    avg_rev_value = mean(revised_market_value, na.rm = TRUE)
  )
```

    ## `summarise()` ungrouping output (override with `.groups` argument)

**Questions:**

  - Check to see how different mean and median are

### [NYC OpenData](https://data.cityofnewyork.us/City-Government/Participatory-Budgeting-Project-Tracker/qm5f-frjb)

**Cleaning and tidying budget data**

``` r
budget = 
  read_csv("./data/budget_tracker.csv") %>% 
  janitor::clean_names() %>% drop_na(community_board) %>% 
  rename(old_community_board = community_board) %>% 
  mutate(
    boro_letter = case_when(
      borough == "MANHATTAN" ~ "M",
      borough == "BRONX" ~ "X",
      borough == "BROOKLYN" ~ "B",
      borough == "QUEENS" ~ "Q",
      borough == "STATEN IS" ~ "R"
    ),
    board_num = ifelse(nchar(old_community_board) == 1, paste0(0, old_community_board), old_community_board)
  ) %>% 
  unite("community_board", boro_letter, board_num, sep = "") %>% 
  relocate(community_board, old_community_board, borough) %>% 
  select(community_board, vote_year, total_appropriated)
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

**Grouping values by community board**

``` r
budget_tidy = 
  budget %>% 
  group_by(community_board) %>% 
  summarize(
    avg_tot_appropriated = mean(total_appropriated, na.rm = TRUE)
  )
```

    ## `summarise()` ungrouping output (override with `.groups` argument)

### Merging 1:

``` r
final_tidy1 =
  left_join(demo, gardens, by = "community_board") %>% 
  left_join(., property_tidy, by = "community_board") %>% 
  left_join(., budget_tidy, by = "community_board")
```

### Calculate number of gardens per community board

``` r
num_gardens <-
  final_tidy1 %>% 
  drop_na(garden_name) %>% 
  group_by(community_board) %>% 
  summarize(garden_num = n())
```

    ## `summarise()` ungrouping output (override with `.groups` argument)

``` r
unique_comboard <-
  final_tidy1 %>% 
  distinct(community_board, .keep_all = TRUE)
```

### Merging 2:

``` r
final_tidy <-
  left_join(unique_comboard, num_gardens, by = "community_board") %>% 
  replace_na(list(garden_num = 0)) 

write_csv(final_tidy, "./data/final_df.csv")
write_csv(final_tidy1, "./data/final_df_main.csv")
```

**Notes:**

  - This dataset contains 531 observations (the number of gardens in the
    garden dataset).

  - I grouped the the property value variables and budgeting information
    variables by community board so there was 1 observations per
    community board in the “property\_tidy” and “budget\_tidy”
    dataframes

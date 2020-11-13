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
```

    ## -- Attaching packages ---------------------------------------------------------------------------------------------------------------------------------------------------- tidyverse 1.3.0 --

    ## v ggplot2 3.3.2     v purrr   0.3.4
    ## v tibble  3.0.3     v dplyr   1.0.2
    ## v tidyr   1.1.2     v stringr 1.4.0
    ## v readr   1.3.1     v forcats 0.5.0

    ## -- Conflicts ------------------------------------------------------------------------------------------------------------------------------------------------------- tidyverse_conflicts() --
    ## x dplyr::filter() masks stats::filter()
    ## x dplyr::lag()    masks stats::lag()

``` r
library(readxl)
```

Reading in multiple data sources

[NYC Greenthumb Community
Gardens](https://data.cityofnewyork.us/Environment/NYC-Greenthumb-Community-Gardens/ajxm-kzmj)

``` r
gardens = 
  read_csv("./data/nyc_community_gardens.csv") %>% 
  janitor::clean_names() %>% 
  drop_na(community_board) %>% 
  relocate(community_board)
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

``` r
table(gardens$community_board)
```

    ## 
    ## B01 B02 B03 B04 B05 B06 B07 B08 B09 B11 B12 B13 B14 B16 B17 B18 BK4 M01 M02 M03 
    ##  16  16  48  13  52  15   3  14   4   3   3   5   4  22   4   2   1   1   3  43 
    ## M04 M07 M08 M09 M10 M11 M12 N/A Q01 Q02 Q03 Q04 Q05 Q06 Q07 Q08 Q09 Q10 Q11 Q12 
    ##   6   5   1  13  29  36  12   5   2   1   3   2   2   2   1   1   1   1   1  11 
    ## Q13 Q14 R01 R03 X01 X02 X03 X04 X05 X06 X07 X08 X09 X10 X11 X12 
    ##   2   3   3   1  24   7  20  20   7  20   7   1   7   2   1   4

Demographic and Community data

``` r
demo = 
  read_xlsx("./data/health_profiles.xlsx",
  sheet = "CHP_all_data", skip = 1) %>% 
  janitor::clean_names()
```

    ## New names:
    ## * lower_95CL -> lower_95CL...16
    ## * upper_95CL -> upper_95CL...17
    ## * NYC_Comparison -> NYC_Comparison...18
    ## * lower_95CL -> lower_95CL...20
    ## * upper_95CL -> upper_95CL...21
    ## * ...

[Revised property value
notices](https://data.cityofnewyork.us/City-Government/Revised-Notice-of-Property-Value-RNOPV-/8vgb-zm6e)

``` r
property = 
  read_csv("./data/property_values.csv") %>% 
  janitor::clean_names() %>% 
  relocate(community_board) %>% 
  drop_na(community_board)
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
  relocate(community_board) %>% 
  drop_na(community_board)
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

Data Cleaning and Merging
================
11/13/20

``` r
library(tidyverse)
```

    ## -- Attaching packages ------------------------------------------------ tidyverse 1.3.0 --

    ## v ggplot2 3.3.2     v purrr   0.3.4
    ## v tibble  3.0.3     v dplyr   1.0.2
    ## v tidyr   1.1.2     v stringr 1.4.0
    ## v readr   1.3.1     v forcats 0.5.0

    ## -- Conflicts --------------------------------------------------- tidyverse_conflicts() --
    ## x dplyr::filter() masks stats::filter()
    ## x dplyr::lag()    masks stats::lag()

``` r
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
  relocate(community_board) %>% 
  select(-prop_id,-census_tract, -bin, -bbl, -nta, -boro)
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
  select(community_board, lot, tax_class, original_market_value, revised_market_value)
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
    avg_rev_value = mean(revised_market_value, na.rm = TRUE),
    avg_lot = mean(lot, na.rm = TRUE),
    median_tax_class = median(tax_class, na.rm = TRUE)
  )
```

    ## `summarise()` ungrouping output (override with `.groups` argument)

**Questions:**

  - Should we take the mean or median of \# of tax class? We could also
    round to nearest whole number after taking the mean

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
  select(community_board, project:subproject_cost, total_appropriated, number_of_subprojects, status_summary)
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
    avg_ballot_price = mean(ballot_price, na.rm = TRUE),
    avg_subproj_cost = mean(subproject_cost, na.rm = TRUE),
    avg_tot_appropriated = mean(total_appropriated, na.rm = TRUE),
    median_num_subproj = median(number_of_subprojects, na.rm = TRUE)
  )
```

    ## `summarise()` ungrouping output (override with `.groups` argument)

**Questions:**

  - Should we take the mean or median of \# of subprojects? We could
    also round to nearest whole number after taking the mean

### Merging method 1:

``` r
with_grouping =
  left_join(gardens, demo, by = "community_board") %>% 
  left_join(., property_tidy, by = "community_board") %>% 
  left_join(., budget_tidy, by = "community_board")

# To see how many times a community board appears 
table(with_grouping$community_board)
```

    ## 
    ## B01 B02 B03 B04 B05 B06 B07 B08 B09 B11 B12 B13 B14 B16 B17 B18 BK4 M01 M02 M03 
    ##  16  16  48  13  52  15   3  14   4   3   3   5   4  22   4   2   1   1   3  43 
    ## M04 M07 M08 M09 M10 M11 M12 Q01 Q02 Q03 Q04 Q05 Q06 Q07 Q08 Q09 Q10 Q11 Q12 Q13 
    ##   6   5   1  13  29  36  12   2   1   3   2   2   2   1   1   1   1   1  11   2 
    ## Q14 R01 R03 X01 X02 X03 X04 X05 X06 X07 X08 X09 X10 X11 X12 
    ##   3   3   1  24   7  20  20   7  20   7   1   7   2   1   4

**Notes:**

  - This dataset contains 536 observations (the number of gardens in the
    garden dataset).

  - I grouped the the property value variables and budgeting information
    variables by community board so there was 1 observations per
    community board in the “property\_tidy” and “budget\_tidy”
    dataframes

  - Let me know if anything looks off here

### Merging method 2:

``` r
without_grouping = 
  left_join(gardens, demo, by = "community_board") %>% 
  left_join(., property, by = "community_board") %>% 
  left_join(., budget, by = "community_board")

# To see how many times a community board appears 
table(without_grouping$community_board)
```

    ## 
    ##    B01    B02    B03    B04    B05    B06    B07    B08    B09    B11    B12 
    ## 226656  49200 113280   3276   5252 111000  12240   4508   1040   7161   7455 
    ##    B13    B14    B16    B17    B18    BK4    M01    M02    M03    M04    M07 
    ##   5580   7008    726   7560    614      1   1612   2658   7353  42300  68400 
    ##    M08    M09    M10    M11    M12    Q01    Q02    Q03    Q04    Q05    Q06 
    ##  23199   2275   2436 257580   5616   6448   1863    834   1568   5700   7200 
    ##    Q07    Q08    Q09    Q10    Q11    Q12    Q13    Q14    R01    R03    X01 
    ##  10816    251   2100    253   4290  40040   8856  15327   5814    659   9672 
    ##    X02    X03    X04    X05    X06    X07    X08    X09    X10    X11    X12 
    ##    385    340   1600    280   9000    784    645    483    264    108    396

**Notes:**

  - This dataset contains over 1 million records because no grouping was
    done for the budget or property datasets

  - This dataset contains over 1 million records because no grouping was
    done for the budget or property datasets

  - Personally, I think that this creates a lot of extraneous
    information in our dataset. Since our project is aimed at looking at
    individual gardens, not properties or specific budgeting projects,
    I’m not sure this merging method makes sense

  - **Isabel**, please correct me if I interpreted how you wanted to
    merge incorrectly.

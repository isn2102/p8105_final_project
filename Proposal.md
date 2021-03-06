Proposal
================
11/5/2020

### Authors

  - Isabel Nelson (isn2102)
  - Sushupta Vijapur (smv2138)
  - Kelley Lou (kl3181)

### Project Title

**Community Gardens in New York City: planting the seed of urban
growth**

### Background

With its reputation as the “concrete jungle,” New York City is known for
its towering skyscrapers and bustling streets. However it also has a
long and vibrant history of urban agriculture and green space
cultivation. After the economic crisis and disinvestment in the 1970s,
many areas of the city saw a surge in abandoned buildings and vacant
lots that were turned over to the city through foreclosure. The activist
group Green Guerillas saw the opportunity to reinvest in their
neighborhood and reclaim these lots as green spaces for the community.
This grew into a larger movement of community gardeners, with the city
leasing lots to community gardens and providing support through the
creation of the GreenThumb program in 1978. Despite the gardens’
successes as important cultural and community institutions, there was
continual pressure from the city to turn gardens into housing
developments. Over the years, community members and organizations have
come together to fight for, preserve, and develop new gardens for the
wider community despite these pressures.

There are now over 500 community gardens throughout New York City. These
gardens provide a sense of ownership and stability in the rapidly
changing city. They offer residents a calm escape, a space to come
together with community members to solve local problems, and a
connection to local food production. In addition to the value they bring
to individuals, community gardens have embedded themselves in the fabric
of New York City neighborhoods and have impacted areas as diverse as
property values, community activism, and health.

This project aims to further explore the relationship between community
gardens and the people and fabric of NYC neighborhoods by asking four
main questions: 1. How are community gardens distributed throughout the
city? 2. How are the locations of gardens related to certain demographic
characteristics? 3. What is the relationship between community gardens
and economic investment? 4. What is the relationship between community
gardens and select health conditions?

**Sources**

  - <https://www.jstor.org/stable/41147766>
  - <https://www.jstor.org/stable/30033906>
  - <https://nyccgc.org/about/history/>
  - <https://www.nycgovparks.org/about/history/community-gardens/movement>
  - <http://www.greenguerillas.org/history>
  - <https://en.wikipedia.org/wiki/Community_gardens_in_New_York_City>

### Intended Products + Website Flow

**Website pages:**

  - Landing page with Title, authors, introduction, research questions,
    citations (written above), and the map of community gardens (plotly)
      - Map will be using leaflet and will show the location of
        individual gardens, with information on each when you hover  
      - Map will also include visual distribution (or small side graph)
        of a variable for number of community gardens in each community
        board / district  
  - Page about economic investment (dashboard)
      - Map of distribution of gardens and maps showing median income,
        gentrifying status, property values, helpful neighbors, and
        participatory budget projects  
      - Possibly also small graphs showing above variables  
      - Results from spatial regression or cluster identification to
        assess the relationship between these variables and community
        gardens  
  - Page about health outcomes (dashboard)
      - Map of distribution of gardens and maps showing self-reported
        health, obesity, diabetes, htn, psychiatric hospitalization,
        premature mortality, life expectancy  
      - Possibly also small graphs showing these variables  
      - Results from spatial regression or cluster identification to
        assess the relationship between these variables and community
        gardens  
  - Report page
      - Recap of the background info on the landing page  
      - full description of analytic methods  
      - write up of results from analyses  
      - visualizations found on the other pages  
      - plots showing basic demographic characteristics of each
        neighborhood: age distribution, race distribution, population
        size, education distribution

**Analysis**  
1\. Spatial dependence of gardens (clusters statistically significant /
not normally distributed)  
2\. Spatial regression model for economic indicators (choose one or
two)  
\- Can use property values by interpolating and summarizing at community
board level, or median income/gentrification value for each community
board, or create a composite variable for average participatory
budgeting amount per location  
\- Adjust for covariates: race, age  
3\. Spatial regression model for health indicators (choose one or two)  
\- Can use the value for each community board  
\- Adjust for covariates: race, age, income

### Data Sources

  - Primary data source will be [NYC Greenthumb Community
    Gardens](https://data.cityofnewyork.us/Environment/NYC-Greenthumb-Community-Gardens/ajxm-kzmj)

  - Demographic & health data by community board from
    [nyc.gov](https://communityprofiles.planning.nyc.gov/)

  - Property value data from [Revised property value
    notices](https://data.cityofnewyork.us/City-Government/Revised-Notice-of-Property-Value-RNOPV-/8vgb-zm6e)

  - Participatory budgeting project tracker from [NYC
    OpenData](https://data.cityofnewyork.us/City-Government/Participatory-Budgeting-Project-Tracker/qm5f-frjb)

  - If needed for additional neighborhood demographic data:
    [NYU](https://furmancenter.org/neighborhoods)

### Timeline

  - November 7: Proposal
  - November 13: Project review meeting
  - November 14-20: Work on the report
  - November 21-27: Work on the webpage and screencast
  - November 28-December 5: Edit and finalize report, webpage and
    screencast, complete peer assessment
  - December 6-10: Prep for in class presentation/discussion\!

### Questions

### Planned Analyses / Visualizations / Coding Challenges

We plan to provide a leaflet map overlaying the location of the gardens
throughout the boroughs in New York. We also hope to show a few other
plots through shiny or a dashboard to help visualize the distribution of
gardens and the relationship to the other variables of interest. These
variables include the size of the community gardens and whether they
have any relationship to boroughs and/or other geographic markers across
the city. Furthermore, in the data source looking across community
districts (<https://communityprofiles.planning.nyc.gov/>), there is a
variable that assesses the accessibility to parks. We are also
potentially interested in looking at park accessibility by key
demographic and geographic variables. Analyses will include regression
models to assess if number of community gardens in a certain location is
associated with property values / median incomes and other demographic
variables. Further association between investment from the city for
local projects with gardens will be explored.

We anticipate there may be coding challenges when we merge datasets. If
the data is not coded consistently or with similar variables, it may be
difficult to combine the datasets that we need in order to answer our
research questions. We also anticipate there may be challenges with
missing data in certain key variables, which we will have to deal with
the in data cleaning/tidying phase of the project.

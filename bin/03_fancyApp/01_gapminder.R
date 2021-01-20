library(shiny)
library(dslabs)
library(dplyr)
library(tidyr)  # just to use drop_na()
library(ggplot2)
library(DT)

data("gapminder")

# Preprocessing ----

# Doing preprocessing before any Shiny-specific code

west <- c(
  "Western Europe",
  "Northern Europe",
  "Southern Europe",
  "Northern America",
  "Australia and New Zealand"
)

gapminder <- gapminder %>%
  mutate(
    region_group = case_when(
      region %in% west ~ "The West",
      region %in% c("Eastern Asia", "South-Eastern Asia") ~ "East Asia",
      region %in% c("Caribbean", "Central America", "South America") ~ "Latin America",
      continent == "Africa" &
        region != "Northern Africa" ~ "Sub-Saharan Africa",
      TRUE ~ "Others"
    )
  ) %>%
  # Simply dropping any NaNs
  drop_na() %>%
  # Adding columns
  mutate(gpd_per_capita = gdp / population) %>%
  mutate(population_in_millions = population / 10 ^ 6)


# Shiny ----

ui <- fluidPage(
  titlePanel("World Health & Economic Data - Gapminder"),
  sidebarLayout(
    sidebarPanel(
      sliderInput(
        inputId = "yearInput",
        label = "Year",
        min = 1962,
        max = 2013,
        value = c(1970, 2011),
        sep = ""
      ),
      selectInput(
        inputId = "countryInput",
        label = "Country",
        choices = c("Morocco", "Spain", "United States", "Indonesia")
      )
    ),
    mainPanel(plotOutput("coolplot"),
              br(), br(),  # linebreaks for formatting purposes
              DTOutput("results"))
  )
)

server <- function(input, output, session) {
  # Creating reactive output for coolplot
  output$coolplot <- renderPlot({

    gapminder %>%
      # Filtering based on the interactive input
      filter(year >= input$yearInput[1],
             year <= input$yearInput[2],
             country == input$countryInput) %>% 
      ggplot(aes(x = year,
                 y = life_expectancy,
                 col = region_group,
                 size = population_in_millions)) + 
      geom_point(alpha = 0.8)
  })
  
  # Creating reactive output for results table
  output$results <- renderDT({
    
    filtered <-
      gapminder %>%
      filter(year >= input$yearInput[1],
             year <= input$yearInput[2],
             country == input$countryInput)
    
    filtered
  })
}

# Must always be the last line in order to run the Shiny App
shinyApp(ui, server)

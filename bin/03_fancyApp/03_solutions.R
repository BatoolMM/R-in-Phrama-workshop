library(shiny)
library(dslabs)
library(dplyr)
library(tidyr)  # just to use drop_na()
library(ggplot2)

data("gapminder")

# Doing preprocessing before any Shiny-specific code
west <- c("Western Europe","Northern Europe","Southern Europe",
          "Northern America","Australia and New Zealand")

gapminder <- gapminder %>%
  mutate(region_group = case_when(
    region %in% west ~ "The West",
    region %in% c("Eastern Asia", "South-Eastern Asia") ~ "East Asia",
    region %in% c("Caribbean", "Central America", "South America") ~ "Latin America",
    continent == "Africa" & region != "Northern Africa" ~ "Sub-Saharan Africa",
    TRUE ~ "Others")) %>%
  # Simply dropping any NaNs
  drop_na() %>%
  mutate(gpd_per_capita = gdp/population) %>%
  mutate(population_in_millions = population/10^6)

ui <- fluidPage(
  titlePanel("World Health & Economic Data - Gapminder"),
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId = "yearInput", label = "Year", 
                  min = min(gapminder$year), max = max(gapminder$year), 
                  value = c(1970, 2011),
                  sep = ""
      ),
      # Using selectizeInput for multiple = TRUE because of verstatile UI
      selectizeInput(inputId = "countryInput", label = "Country",
                  choices = gapminder$country,
                  multiple=TRUE,
                  options = list(
                    'plugins' = list('remove_button'))
      ),
      selectInput("metricInput", "Metric",
                  choices = c("infant_mortality", "life_expectancy", "gpd_per_capita")
      ),
      # Placing table in sidebarPanel
      tableOutput("results")
    ),
    mainPanel(
      plotOutput("coolplot"),
      br(), br()
    )
  )
)

server <- function(input, output, session) {
  # Defining filtered dataframe outside renders
  filtered <- reactive({
    # To stop errors popping up in app if nothing is chosen by default
    if (is.null(input$countryInput) || is.null(input$yearInput)) {
      return(NULL)
    }
    gapminder %>%
    # Filter based on the interactive input 
    filter(year >= input$yearInput[1],
           year <= input$yearInput[2],
           country %in% input$countryInput
    )
  })
  
  # Create reactive output for coolplot
  output$coolplot <- renderPlot({
    if (is.null(input$countryInput) || is.null(input$yearInput)) {
      return(NULL)
    }
    ggplot(filtered(), 
           # aes_string allows us to change the y-label based on reactive metricInput
           aes_string(x = "year", y = input$metricInput, col = "country", 
               size = "population_in_millions")) +
      geom_point(alpha = 0.8)
  })
  # create reactive output for results table
  output$results <- renderTable({
    # inputMetric has a default but the creation of the object depends on countryInput
    if (is.null(input$countryInput)){
      return(NULL)
    }
    filtered() %>%
      # Only show specific cols in the table
      select("country", "year", input$metricInput)
  })
}

shinyApp(ui, server)

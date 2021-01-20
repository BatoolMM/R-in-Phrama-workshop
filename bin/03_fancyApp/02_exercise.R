library(shiny)
library(dslabs)
library(dplyr)
library(tidyr)  # just to use drop_na()
library(ggplot2)

data("gapminder")

# Doing preprocessing before any Shiny-specific code
west <- c("Western Europe","Northern Europe","Southern Europe",
          "Northern America","Australia and New Zealand")

# Instruction_1: Pipe gapminder
gapminder <- gapminder ___
  mutate(region_group = case_when(
    region %in% west ~ "The West",
    region %in% c("Eastern Asia", "South-Eastern Asia") ~ "East Asia",
    region %in% c("Caribbean", "Central America", "South America") ~ "Latin America",
    continent == "Africa" & region != "Northern Africa" ~ "Sub-Saharan Africa",
    TRUE ~ "Others")) %>%
  # Instruction_2: Simply drop any NaNs
  _______() %>%
  mutate(gpd_per_capita = gdp/population) %>%
  # Instruction_3: add a column called popluation_in_millions to the gapminder dataframe
  ______(population_in_millions = population/10^6)

ui <- fluidPage(
  titlePanel("World Health & Economic Data - Gapminder"),
  sidebarLayout(
    sidebarPanel(
      # Instruction_4: Create an interactive slider 
      ___________(inputId = "yearInput", label = "Year", 
                  min = min(gapminder$year), max = max(gapminder$year), 
                  value = c(1970, 2011),
                  sep = ""
      ),
      # Instruction_5: Allow for multiple inputs
      selectizeInput(inputId = "countryInput", label = "Country",
                     choices = gapminder$country,
                     ________=____,
                     options = list(
                       'plugins' = list('remove_button'))
      ),
      # Instruction_6: set 'metricInput' as the inputId 
      selectInput(______ = "___________", label = "Metric",
                  choices = c("infant_mortality", "life_expectancy", "gpd_per_capita")
      ),
      # Instruction_7: place this table under the plot instead of the slider
      tableOutput("results")
    ),
    mainPanel(
      plotOutput("coolplot"),
      br(), br()
    )
  )
)

server <- function(input, output, session) {
  # Instruction_8: Ensure that 'filtered' is definied as a reactive input
  filtered <- ________({
    if (is.null(input$countryInput) || is.null(input$yearInput)) {
      return(NULL)
    }
    gapminder %>%
      filter(year >= input$yearInput[1],
             year <= input$yearInput[2],
             country %in% input$countryInput
      )
  })
  # Instruction_9: Wrap ggplot in a function which will re-render the plot each time that a related reactive input is changed 
  output$coolplot <- __________({
    if (is.null(input$countryInput) || is.null(input$yearInput)) {
      return(NULL)
    }
    ggplot(filtered(), 
           aes_string(x = "year", y = input$metricInput, col = "country", 
                      size = "population_in_millions")) +
      geom_point(alpha = 0.8)
  })
  # Instruction_10: Relate the renderTable to the 'results' table defined in the input
  output$_______ <- renderTable({
    if (is.null(input$countryInput)){
      return(NULL)
    }
    filtered() %>%
      select("country", "year", input$metricInput)
  })
}

shinyApp(ui, server)

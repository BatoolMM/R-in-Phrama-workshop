# Reactive output with two tabs

library(shiny)
library(ggplot2)
library(HistData)
library(dplyr)

data("Cholera")

ui <- fluidPage(titlePanel("1849 London Cholera epidemic"),
                
                tabsetPanel(
                  tabPanel("Histogram", fluid = TRUE,
                           sidebarLayout(
                             sidebarPanel(
                               sliderInput(
                                 inputId = "histogram_bin_count",
                                 label = "Number of bins:",
                                 min = 1,
                                 max = 50,
                                 value = 30
                               )
                             ),
                             mainPanel(plotOutput(outputId = "histPlot"))
                           )),
                  
                  tabPanel("Scatter", fluid = TRUE,
                           sidebarLayout(
                             sidebarPanel(
                               radioButtons(
                                 inputId = "waterInput",
                                 label = "Water",
                                 choices = unique(Cholera$water),
                                 selected = "Battersea",
                                 inline = TRUE
                               )
                             ),
                             mainPanel(plotOutput(outputId = "scatterPlot"))
                           ))
                ))

server <- function(input, output) {
  
  output$histPlot <- renderPlot({
    ggplot(Cholera, aes(cholera_drate, fill = ..x..)) +
      geom_histogram(bins = input$histogram_bin_count) +
      scale_fill_gradient("Legend", low = "blue", high = "red") +
      xlab("Death rate/10,000") + 
      ggtitle("Distribution of cholera death rates in London districts")
  })
  
  output$scatterPlot <- renderPlot({
   Cholera %>%
      filter(water %in% input$waterInput) %>%
      ggplot(aes(houses, cholera_drate, size = elevation)) +
      geom_point() + 
      xlab("Number of houses in district") + 
      ylab("Death rate/10,000")
  
  })
  
}


shinyApp(ui = ui, server = server)

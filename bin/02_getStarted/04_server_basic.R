# Making a plot which does not reference any reactive input

# Cholera data description: https://rdrr.io/cran/HistData/man/Cholera.html

library(shiny)
library(ggplot2)
library(HistData)

data("Cholera")

ui <- fluidPage(# App title ----
                titlePanel("Hello Shiny"),
                
                # Sidebar layout with input and output definitions ----
                sidebarLayout(
                  # Sidebar panel for inputs ----
                  sidebarPanel(
                    # Input: Slider for the number of bins ----
                    sliderInput(
                      inputId = "bins",
                      label = "Number of bins:",
                      min = 1,
                      max = 50,
                      value = 30
                    )
                    
                  ),
                  
                  # Main panel for displaying outputs ----
                  mainPanel(
                    # Output: Histogram ----
                    plotOutput(outputId = "histPlot"),
                    br(),
                    plotOutput(outputId = "boxPlot")
                  )
                ))

server <- function(input, output) {
  output$histPlot <- renderPlot({
    ggplot(Cholera, aes(cholera_drate, fill = ..x..)) +  
      geom_histogram() + 
      scale_fill_gradient("Legend", low = "blue", high = "red")
  })
  output$boxPlot <- renderPlot({
    ggplot(Cholera, aes(water, cholera_drate)) + geom_boxplot()
  })
}

shinyApp(ui = ui, server = server)


## Poll question:
# 
# 1. Why aren't the plots changing when input is changed?

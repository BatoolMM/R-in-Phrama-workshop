library(shiny)

ui <- fluidPage(# App title ----
                titlePanel("Hello Shiny"),
                
                # Sidebar layout with input and output definitions ----
                sidebarLayout(
                  # Sidebar panel for inputs ----
                  sidebarPanel(
                    # Input: Dropdown for waiting time ----
                    selectInput(
                      inputId = "waiting",
                      label = "Waiting Time",
                      choices = c(70, 75, 80, 85, 90)
                    ),
                    
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
                    # Embedding a local image - Store images in a "www" folder
                    img(
                      src = "rstudio.png",
                      height = 28,
                      width = 80
                    ),
                    br(),
                    br(),
                    "Results will go here"
                  )
                ))

server <- function(input, output) {
}

shinyApp(ui = ui, server = server)


# Exercises:
# 
# 1. Modify the default value of the slider to 25
# 2. Give a default value to the waiting time dropdown menu
#     - run ?selectInput for help
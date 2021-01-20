library(shiny)

ui <- fluidPage(
  # App title ----
  titlePanel("Hello Shiny"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    position = "right",
    
    sidebarPanel("Place inputs here"),
    
    mainPanel("Results will go here")
  )
)

server <- function(input, output) {
}

shinyApp(ui = ui, server = server)

# Exercises:
#
# 1. Move the sidebar to the right. If nothing happens, can you guess why?
# 2. Change the title to something of your choice
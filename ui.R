library(shiny)

ui <- fluidPage(
  headerPanel("Linio - Comparador de precios"),
  sliderInput(inputId = "num", label = "Escoja el precio",
              value = 25, min = 1, max = 100),
  
  plotOutput(outputId = "hist")
)

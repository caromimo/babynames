# Tutorial for building a Shiny App
# Thank you Lisa Lendway for your tutorial
# https://www.youtube.com/watch?v=ak_NJCVrJXY
# Code below is just me following her tutorial

remove(list=ls())

library(shiny)
library(ggplot2)
library(magrittr)
library(babynames)

# ui portion

ui <- fluidPage(
  textInput(
    inputId = "name",
    label = "Name:",
    value = "",
    placeholder = "e.g., Lisa"
  ),
  selectInput(
    inputId = "sex",
    label = "Sex:",
    choices = list(Female = "F",
                   Male = "M")
  ),
  sliderInput(
    inputId = "year",
    label = "Year Range:",
    min = min(babynames$year),
    max = max(babynames$year),
    value = c(min(babynames$year),
              max(babynames$year)),
    sep = ""
  ),
  submitButton(
    text = "Make my plot"
  ),
  plotOutput(outputId = "nameplot")
)

# server portion

server <- function(input, output) {
  output$nameplot <- renderPlot(
    babynames %>%
      filter(sex == input$sex,
             name == input$name) %>%
      ggplot(aes(x = year,
                 y = n)) +
      geom_line() + 
      scale_x_continuous(limits = input$year) +
      theme_minimal()
  )
}

# App portion

shinyApp(ui = ui, server = server)

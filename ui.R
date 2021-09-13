# Data Products
# Coursera 9/7/2021
# Week 4 Project - A. Ridgway
# ui.r file for shiny app: Weather Events


library(shiny)

# Define UI for application that draws a wordcloud
shinyUI(fluidPage(

    # Application title
    titlePanel("US Weather Events 2019"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            p("Application shows graphically the most common weather events for a selected state. The data tab lists information about the weather events."),
            hr(),
            selectInput("state", "Choose a state:",
                        choices =states),
            hr(),
            submitButton("Submit")
            ),
        

        # Show a plot of the generated plot
        mainPanel(
            tabsetPanel(type = "tabs", 
                        tabPanel("Word Cloud", br(), wordcloud2Output("wordcloud")),
                        tabPanel("Data", br(),p("Data from https://www.ncei.noaa.gov for 2019"),br(),h3(textOutput("text")),br(), DT::dataTableOutput("table")) 
                        )
            
        )
    )
))

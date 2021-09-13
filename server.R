# Data Products
# Coursera 9/7/2021
# Week 4 Project - A. Ridgway
# server.r file for shiny app: Weather Events
 
library(shiny)

# Define server logic required to draw wordcloud
shinyServer(function(input, output) {
    dfiltered <- reactive({
        state <- input$state
        plot_data<-data_fn(data,state)
    })
    
    datamatrix<- reactive({
        cloud_text<- dfiltered() %>% select(event) 
        #cloud_text<- dfiltered() %>% select(event) %>% mutate(events=str_trim(str_to_lower(event))) %>% select(events) 
        corp<-corp_fn(cloud_text)
        dm<-matrix_fn(corp)
    })
    
    output$wordcloud <- renderWordcloud2({wordcloud2(data=datamatrix(),size=1,shape="circle",ellipticity=0.65) })
    
    output$text<-renderText({paste("Selected State:",input$state)})
    
    output$table <- DT::renderDataTable(DT::datatable({ 
        dfiltered()[,c(1:6)]
    }))
    
        
})

library(shiny)
library(ggplot2)
library(forcats)
library(scales)
#library(plotly)
#library(repmis) #loads data from DropBox
library(anytime)
library(dplyr)




### Data alojada en DropBox


#ecommerce <- reactive({source_data("https://www.dropbox.com/s/vde35nfjhybfvr7/ecommerce.csv?raw=1")})



#str(ecommerce())



server <- function(input, output) {
  
  
  
  
  ########
  
  
  #ecommerce <- read.csv("D:\\RCoursera\\r-s-l\\base-de-datos\\ecommerce-bd\\2017-09-11-ecommerce-bd.csv",
  #                      as.is = TRUE) #PC
  
  
  
  ecommerce <- read.csv("D:\\rls\\tvs-comparativo\\base-de-datos\\ecommerce-bd\\2017-09-11-ecommerce-bd.csv",
                        as.is = TRUE) #LAPTOP
  
  
  ecommerce$fecha <- anydate(ecommerce$fecha, asUTC = FALSE, useR = FALSE)
  
  
  ### Reactive data
  
  
  fechas_vector <-reactive({
    
    c(input$dateRange[1], input$dateRange[2])
    
  })
  
  
  
  
  ecommerce_fechas <- reactive({
    
    filter(ecommerce, fecha >= fechas_vector()[1], fecha <= fechas_vector()[2])                       
    
  })
  
  
  
  ecommerce_ripley <- reactive({
    
    
    ecommerce %>%
      group_by(ecommerce) %>%
      filter(ecommerce == "Ripley",
             fecha >= fechas_vector()[1], fecha <= fechas_vector()[2]) %>%
      summarise(precio.actual = sum(precio.actual, na.rm = TRUE))
    
    
  })
  
  
  
  
  ecommerce_ripley_categorias <- reactive({
    
    
    ecommerce %>%
      group_by(ecommerce, categoria) %>%
      filter(ecommerce == "Ripley",
             fecha >= fechas_vector()[1], fecha <= fechas_vector()[2]) %>%
      summarise(precio.actual = sum(precio.actual, na.rm = TRUE))
    
    
  })
  
  
  
  
  ########
  
  
  
  
  
  
  
  
  output$dateRangeText  <- renderText({
    
    paste("input$dateRange is", 
          paste(as.character(input$dateRange), collapse = " to "))
  })
  
  
  
  
  output$ripley_plot <- renderPlot({
    
    ggplot(ecommerce_ripley(), aes(ecommerce, precio.actual)) +
      geom_col(fill = "#9966ff", colour = "#b3b3b3") +
      geom_text(aes(label=scales::comma(precio.actual)), vjust=-0.5) +
      theme_ipsum(grid="Y") +
      labs(title = "Ripley - Total", y = "Precio actual en S/.") +
      scale_y_comma(limits=c(0,150000000))
      
    
  })
  
  
  
  
  output$ripley_categorias_plot <- renderPlot({
    
    ggplot(ecommerce_ripley_categorias(), aes(fct_reorder(categoria, precio.actual), precio.actual, fill=categoria)) +
      geom_col() +
      geom_text(aes(label=scales::comma(precio.actual)), hjust=-0.2) +
      theme_ipsum(grid="X") +
      theme(legend.position="none") +
      labs(title = "Ripley - Total", x = "", y = "Precio actual en S/.") +
      scale_y_comma(limits = c(0, 20000000)) +
      coord_flip()
    
    
    
  })
  
  

   
  output$tbl = DT::renderDataTable({
    
    ecommerce_fechas() 
      
      
  })
    
}


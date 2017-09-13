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
  
  
  ecommerce <- read.csv("D:\\RCoursera\\r-s-l\\base-de-datos\\ecommerce-bd\\2017-09-13-ecommerce-bd.csv",
                       as.is = TRUE) #PC
  
  
  
  #ecommerce <- read.csv("D:\\rls\\tvs-comparativo\\base-de-datos\\ecommerce-bd\\2017-09-13-ecommerce-bd.csv",
   #                     as.is = TRUE) #LAPTOP
  
  
  ecommerce$fecha <- anydate(ecommerce$fecha, asUTC = FALSE, useR = FALSE)
  
  
  ### Reactive data
  
  
  fechas_vector <-reactive({
    
    c(input$dateRange[1], input$dateRange[2])
    
  })
  
  
  
  
  ecommerce_fechas <- reactive({
    
    filter(ecommerce, fecha >= fechas_vector()[1], fecha <= fechas_vector()[2])                       
    
  })
  
  
  
  ecommerce_totales <- reactive({
    
    
    ecommerce %>%
      group_by(ecommerce) %>%
      filter(fecha >= fechas_vector()[1], fecha <= fechas_vector()[2]) %>%
      summarise(precio.actual = sum(precio.actual, na.rm = TRUE))
    
    
  })
  
  
  
  
  ecommerce_categorias <- reactive({
    
    
    ecommerce %>%
      group_by(ecommerce, categoria) %>%
      filter(ecommerce == input$ecommerce_selected,
             fecha >= fechas_vector()[1], fecha <= fechas_vector()[2]) %>%
      summarise(precio.actual = sum(precio.actual, na.rm = TRUE))
    
    
  })
  
  
  
  
  ecommerce_boxplot <- reactive({
    
    
    ecommerce %>%
    group_by(ecommerce, categoria) %>%
    summarise(precio.actual = sum(precio.actual, na.rm = TRUE))
  
  
  })
  
  
  
  
  
  
  ########
  
  
  
  
  
  
  
  
  output$dateRangeText  <- renderText({
    
    paste("input$dateRange is", 
          paste(as.character(input$dateRange), collapse = " to "))
  })
  
  
  
  
  output$ecommerce_totales_plot <- renderPlot({
    
    ggplot(ecommerce_totales(), aes(ecommerce, precio.actual, fill=ecommerce)) +
      geom_col() +
      scale_fill_manual(values = c("Ripley" = "#0D0C0C", "Falabella" = "#289512")) +
      geom_text(aes(label=scales::comma(precio.actual)), vjust=-0.5) +
      theme_ipsum(grid="Y") +
      labs(title = "Ecommerce Perú - Totales", y = "Precio actual en S/.") +
      scale_y_comma(limits=c(0,500000000))
      
    
  })
  
  
  
  
  output$categorias_plot <- renderPlot({
    
    ggplot(ecommerce_categorias(), aes(fct_reorder(categoria, precio.actual), precio.actual, fill=categoria)) +
      geom_col() +
      geom_text(aes(label=scales::comma(precio.actual)), hjust=-0.2) +
      theme_ipsum(grid="X") +
      theme(legend.position="none") +
      labs(x = "", y = "Precio actual en S/.") +
      scale_y_comma(limits = c(0, 20000000)) +
      coord_flip() +
      ggtitle(paste(input$ecommerce_selected," - Categorias"))
    
    
    
  })
  
  

   
  output$tbl = DT::renderDataTable({
    
    ecommerce_fechas() 
      
      
  })
  
  
  
  output$tbl_boxplot = DT::renderDataTable({
    
    ecommerce_boxplot() 
    
    
  })
  
  
  
  output$boxplot <- renderPlotly({
    
    plot_ly(ecommerce_boxplot(), y = ~precio.actual, color = ~ecommerce, type = "box")
  
    })
  
    
}


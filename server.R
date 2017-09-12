library(tidyverse)
library(scales)
library(shiny)
library(plotly)

#library(repmis) #loads data from DropBox
#library(forcats)
library(anytime)
library(dplyr)




### Data alojada en DropBox


#ecommerce <- reactive({source_data("https://www.dropbox.com/s/vde35nfjhybfvr7/ecommerce.csv?raw=1")})



#str(ecommerce())



server <- function(input, output) {
  
  
  
  
  ########
  
  
  ecommerce <- read.csv("D:\\RCoursera\\r-s-l\\base-de-datos\\ecommerce-bd\\2017-09-11-ecommerce-bd.csv",
                        as.is = TRUE)
  
  
  ecommerce$fecha <- anydate(ecommerce$fecha, asUTC = FALSE, useR = FALSE)
  
  
  
  
  fechas_vector <-reactive({
    
    c(input$dateRange[1], input$dateRange[2])
    
  })
  
  
  
  
  ecommerce_fechas <- reactive({
    
    filter(ecommerce, fecha >= fechas_vector()[1], fecha <= fechas_vector()[2])                       
    
  })
  
  
  
  
  
  ########
  
  
  
  
  
  
  
  
  output$dateRangeText  <- renderText({
    
    paste("input$dateRange is", 
          paste(as.character(input$dateRange), collapse = " to "))
  })
  
  
  
# 
# 
#   output$plot1<- renderPlot({
# 
#     ecommerce.ripley <- ecommerce() %>%
#       filter(ecommerce == "Ripley",
#              fecha >= input$dateRange[1] & fecha <= input$dateRange[2]) %>%
#       group_by(categoria) %>%
#       summarise(precio.actual = sum(precio.actual, na.rm = T)) %>%
#       mutate(categoria=factor(categoria, levels=categoria))
# 
# 
# 
# 
#     ggplot(ecommerce.ripley,
#            #aes(fct_reorder(categoria, precio.actual, .desc = FALSE), precio.actual, fill = categoria)) +
#            aes(categoria, precio.actual, fill = categoria)) +
#            geom_col() +
#       labs(x="Categoría", y="Precio actual S/.",
#            title="Ripley - Totales por categoría",
#            subtitle="",
#            caption="Brought to you by the letter 'g'") +
#       # #scale_color_ipsum() +
#       theme_ipsum_rc(grid="X") +
#       scale_fill_ipsum() +
#       geom_text(aes(label=scales::comma(precio.actual)), hjust=0, nudge_y=2000) +
#       scale_y_comma(limits = c(0,1000000)) +
#       coord_flip()
# 
#   })
# 
# 
# 
#   output$plot2 <- renderPlot({
# 
#     ecommerce2 <- ecommerce() %>%
#       filter(ecommerce == input$ecommerce) %>%
#       group_by(categoria) %>%
#       summarise(precio.actual = sum(precio.actual, na.rm = T)) %>%
#       mutate(categoria=factor(categoria, levels=categoria))
# 
# 
# 
# 
#     ggplot(ecommerce2,
#            aes(fct_reorder(categoria, precio.actual, .desc = FALSE), precio.actual, fill = categoria)) +
#       geom_col() +
#       labs(x="Categoría", y="Precio actual S/.",
#            subtitle="",
#            caption="Brought to you by the letter 'g'") +
#       # #scale_color_ipsum() +
#       theme_ipsum_rc(grid="X") +
#       scale_fill_ipsum() +
#       geom_text(aes(label=scales::comma(precio.actual)), hjust=0, nudge_y=2000) +
#       scale_y_comma(limits = c(0,10000000)) +
#       coord_flip() +
#       ggtitle(paste(input$ecommerce, "Totales por categoría", sep = " - "))
# 
#   })

  ### PROBANDO DATA RANGE

  #AQUI
  # 
  # ecommerce_datarange <- ecommerce() %>%
  #                        filter(fecha >= input$dateRange[1] & fecha <= input$dateRange[2])
  # 
  # 
  output$tbl = DT::renderDataTable({
    
    ecommerce_fechas() 
      
      
  })
    
}


library(shiny)
library(plotly)
library(dplyr)
library(repmis)
library(formattable)




### Data alojada en DropBox




tvs <- reactive({source_data("https://www.dropbox.com/s/1jhmyinvyshtms3/2017-04-29-total-tvs.csv?raw=1")})







server <- function(input, output) {
  
  
  output$plot <- renderPlotly({
    
    
    tvs.rango <- tvs() %>%
      group_by(periodo, ecommerce, rango) %>%
      summarise(cantidad = length(rango))
    
    
    
    
    
    tvs.rango$periodo <- factor(tvs.rango$periodo, levels = c(2017,2016),
                                ordered = T)
    
    
    
    tvs.rango$ecommerce <- factor(tvs.rango$ecommerce, levels = c("linio",
                                                                  "ripley",
                                                                  "falabella"),
                                  ordered = T)
    
    
    
    
    
    tvs.rango$rango <- factor(tvs.rango$rango, levels = c("< S/.500",
                                                          "S/.500 -\r\n S/.1500",
                                                          "S/.1500 -\r\n S/.2500",
                                                          "S/.2500 -\r\n S/.3500",
                                                          "S/.3500 -\r\n S/.4500",
                                                          "> S/.4,500"),
                              ordered = T)
    
    
    
    
    
    ggplotly(ggplot(tvs.rango, aes(x = rango, y = cantidad, fill = ecommerce)) +
               geom_bar(stat = "identity") + 
               scale_fill_manual("ecommerce",
                                 values = c("linio" = "#FF5500","ripley" = "#802D69","falabella" = "#BED800")) +
               facet_grid(~ periodo) +
               theme_bw() +
               coord_flip() +
               #theme_ipsum_rc(grid = "X") +
               theme(axis.text.x = element_text(colour="grey10",size=10,hjust=.5,vjust=.5,face="plain"),
                     axis.text.y = element_text(colour="grey10",size=10,hjust=1,vjust=0,face="plain"),  
                     axis.title.x = element_text(colour="grey40",size=16,angle=0,hjust=.5,vjust=0,face="plain"),
                     axis.title.y = element_text(colour="grey40",size=16,angle=90,hjust=.5,vjust=.5,face="plain"),
                     plot.title = element_text(size = 24,vjust=4, face="bold"),
                     plot.subtitle = element_text(vjust=2, size = 16),
                     plot.caption = element_text(vjust=2, size = 16),
                     panel.border = element_rect(colour = "white"),
                     legend.position = "none",
                     strip.text = element_text(size = 18, hjust = 0.01, vjust = -0.5),
                     strip.background = element_rect(colour = "white", fill = "white"),
                     panel.grid.major.y = element_blank(),
                     panel.grid.minor.y = element_blank()) +
               #geom_text(aes(label=cantidad), hjust=-0.25, size = 4) +
               ylim(0, 300) +
               labs(title = "", subtitle = "", caption = "",
                    x = "", y = ""))
    
  })
  
  
  
  output$table <- renderDataTable({tvs()},
    options = list(lengthMenu = c(5, 30, nrow(tvs())), pageLength = 15))
  
  
}



# output$tvstotales <- renderValueBox({
#   # The downloadRate is the number of rows in pkgData since
#   # either startTime or maxAgeSecs ago, whichever is later.
#   # tvs.cantidad <- tvs()  %>%
#   #                 group_by(periodo, ecommerce) %>%
#   #                 summarise(cantidad = length(marca))
#   # 
#   
#   totales <- 100
#   
#   valueBox(
#     value = formatC(totales, digits = 1, format = "f"),
#     subtitle = "Total TVs",
#     icon = icon("area-chart")
#   )
# })

# 
# # 
# teles <- reactiveValues(a = 123)
# 
# output$vbox <- renderValueBox({
# 
#   
# 
#   valueBox(
#     "Title",
#     teles(),
#     icon = icon("television")
#   )
# })
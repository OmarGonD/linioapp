library(shiny)
library(shinydashboard)
library(plotly)
library(formattable)
library(DT)
library(hrbrthemes)







header <- dashboardHeader(title = 'Ripley.com Dashboard',
                          tags$li(class = "dropdown",
                                  tags$a(href="http://simple.ripley.com.pe/", target="_blank", 
                                         tags$img(height = "22px", alt="Ripley Peru", src="ripley-logo.png")
                                  )
                          )
)






sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Categorias", tabName = "Categorias", icon = icon("th"),
             badgeLabel = "new", badgeColor = "green")
  )
)



body <- dashboardBody(
  tabItems(
    tabItem(tabName = "resumen",
            fluidRow(
              box(width = 2, actionButton("count", "Count")),
              infoBoxOutput("ibox"),
              valueBoxOutput("vbox")
            )
            
    ),
    tabItem(tabName = "dashboard",
            dateRangeInput('dateRange',
                           label = 'Seleccione fechas',
                           start = Sys.Date() - 10, end = Sys.Date(),
                           language = 'es', separator = " al "),
            column(6,
                   #verbatimTextOutput("dateText"),
                   #verbatimTextOutput("dateText2"),
                   verbatimTextOutput("dateRangeText")
                   #verbatimTextOutput("dateRangeText2")
            ),
            
            verbatimTextOutput("event"),
            br(),
            br(),
            plotOutput(outputId = "ecommerce_totales_plot", height = "400px"),
            br(),
            br(),
            selectInput("ecommerce_selected", "Elija un Ecommerce:",
                        list("Ripley", "Falabella")
                        ),
            plotOutput(outputId = "categorias_plot", height = "500px"),
            br(),
            br()
            
    ),
    
    tabItem(tabName = "Categorias",
            h2("Ecommerce - Categorias - Boxplots"),
            plotlyOutput("boxplot"),
            br(),
            br(),
            #DT::dataTableOutput('tbl')
            DT::dataTableOutput('tbl_boxplot')
    )
  )
)



# Put them together into a dashboardPage
dashboardPage(skin = "purple",
  header,
  sidebar,
  body
)
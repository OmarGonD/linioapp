library(shiny)
library(shinydashboard)
library(plotly)
library(formattable)







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
    menuItem("Widgets", icon = icon("th"), tabName = "widgets",
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
            plotlyOutput("plot"),
            verbatimTextOutput("event")
    ),
    
    tabItem(tabName = "widgets",
            h2("Widgets tab content"),
            dataTableOutput('table')
    )
  )
)



# Put them together into a dashboardPage
dashboardPage(skin = "purple",
  header,
  sidebar,
  body
)
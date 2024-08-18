library(shinydashboard)
library(readr)

ui <- dashboardPage(
  dashboardHeader(title = "Sleep Work Tracker"),
  dashboardSidebar(
    sidebarMenu(
      #menuItem("Welcome", tabName = "Welcome", icon = icon("dashboard")),
      menuItem("Step 1: Data Uploading", tabName = "Data", icon = icon("dashboard")),
      menuItem("Step 2: Visualizations", tabName = "Viz", icon = icon("dashboard")),
      menuItem("Step 3: Efficiency Prediction", tabName = "Prediction", icon = icon("dashboard"))
    )
  ),
  dashboardBody(
    tabItems(
      
      # tabItem(tabName = "Welcome",
      #         tags$head(tags$style(HTML("
      #                       #welcomeTitle {font-size: 30px;}
      #                    #introText {font-size: 20px;}
      #           .step {font-weight: bold; margin-bottom: 10px;}"))),
      #         h1("Vote365 Data Analysis Portal", id = "welcomeTitle"),
      #         tags$br(),
      #         tags$br(),
      #         tags$br(),
      #         shiny::uiOutput("introText")
      # ),
      
      
      # --------------Data Uploading--------------------
      tabItem(tabName = "Data",
              h2("Step 1: Data Uploading"),
              fluidRow(
                box(width = 3, style = "height: 500px;", 
                    # Input: Select a file ----
                    fileInput("file1", "Upload a CSV File",
                              multiple = TRUE,
                              accept = c("text/csv",
                                         "text/comma-separated-values,text/plain",
                                         ".csv")),
                    
                    # Input: Checkbox if file has header ----
                    checkboxInput("header", "Header", TRUE),
                    
                    # Input: Select separator ----
                    radioButtons("sep", "Separator",
                                 choices = c(Space = " ",
                                             Comma = ",",
                                             Semicolon = ";",
                                             Tab = "\t"),
                                 selected = " "),
                    
                    # Input: Select quotes ----
                    radioButtons("quote", "Quote",
                                 choices = c(None = "",
                                             "Double Quote" = '"',
                                             "Single Quote" = "'"),
                                 selected = '"')
                ),
                
                box(width = 9,  style = "height: 500px;",
                    verbatimTextOutput("uploadInfo"),
                    div(style = "overflow-y: scroll; max-height: 400px; max-width: 900px;",
                        tableOutput("contents"))
                )
                
              )
      ),
      
      # --------------Visualizations--------------------
      tabItem(tabName = "Viz", # TODO: allow one to zoom in, if there's a large timespan
              h2("Step 2: Visualizations"),
              h4("The bottom row indicates the sleep periods, and the top row indicates the work periods. Both are on the scale of 1-5.\nIn the top row, 0 is colored black, indicating periods of not doing work."),
              fluidRow(
                box(title = "Sleep/Work Timeline", solidHeader = TRUE, status = "primary",
                    width = 20, style = "height: 280px;",
                    plotOutput("timeline", height = 250)#,
                    #downloadButton("download_timeline", "Download this Plot")
                )
              ),

      ), 
      
      # --------------Prediction--------------------
      tabItem(tabName = "Prediction",
              h2("Step 3: Work Efficiency Prediction After Sleep Session"),
              h3("Fill in the following parameters to get the prediction of work efficiency after the sleep session."),
              
              fluidRow(
                # TODO: give option of the time of day of sleep session
                # column(width = 4, sliderInput("whensleep", "Select the date range:",
                #                               min = as.Date("1000-01-01"),
                #                               max = as.Date("3000-01-01"),
                #                               value = c(as.Date("2022-06-01"), as.Date("2022-08-16")),
                #                               timeFormat = "%Y-%m-%d")),
                column(width = 4, numericInput("sleeplength", "How long is the sleep session in minutes?",
                                               value = 25, min = 1, max = 720,
                                               width = '100%')),
                column(width = 4, numericInput("sleepquality", "What was the quality of the sleep session on the scale of 1-5?",
                                               value = 3, min = 1, max = 5,
                                               width = '100%'))
              ),
              
              verbatimTextOutput("workEfficiencyPred")
              
      )
      
    )
    
  )
)


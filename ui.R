# ui.R
#### infomation ####
# author:           Ren Ye
# organization:     ERI@N
# email:            renye.china@gmail.com
# github:           https://github.com/ron1818/EIRP.git
# date of creation: 2015/09/04

#### description ####
# Shiny Dashboard for Nemobot Project

####header ####
header<-dashboardHeader(
  title = "Nemobot Dashboard",
  # dynamic message
  dropdownMenuOutput("messageMenu"),
  # dynamic notification
  dropdownMenuOutput("notificationMenu"),
  # dynamic task
  dropdownMenuOutput("taskMenu")
)

#### sidebar ####
sidebar<-dashboardSidebar(
  sidebarMenu(
    sidebarSearchForm(textId = "searchText", buttonId = "searchButton",
                      label = "Search..."),
    menuItem("Login", tabName = "dblogin", icon = icon("user")),
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Resouce", tabName = "resource", icon = icon("bolt")),
    menuItem("Weather", tabName = "weather", icon = icon("cloud")),
    menuItem('Power',tabName='power',icon=icon('plug')),
    menuItem('Navigation',tabName='navigation',icon=icon('globe')),
    menuItem('Health',tabName='health',icon=icon('medkit')),
    # menuItem("Widgets", tabName = "widgets", icon = icon("th-large")),
    menuItem("RawData", tabName = "rawdata", icon = icon("database")),
    menuItem("ReadMe", tabName = "readme", icon = icon("info")),
    menuItem("Credit", tabName = "credit", icon = icon("flask"))
  )
)

#### body ####
body<-dashboardBody(
  tabItems(
    #login tab
    tabItem(tabName = 'dblogin',
            fluidRow(
              box(
                title='Database login',
                status='info',
                solidHeader = TRUE,
                collapsible = TRUE,
                # mysql database login
                textInput('sqluser','User',Sys.info()['user']),
                passwordInput('sqlpassword','Password',''),
                textInput('sqldbname','Database','nemobot'),
                textInput('sqlhost','Host','localhost'),
                submitButton('Login',icon('sign-in'))
                #actionButton('sqllogoutButton', 'Logout')
              ),
              box(
                title='Database login result',
                status = 'info',
                "Database Status:",
                verbatimTextOutput('sqlstatus'),
                "Database Summary:",
                textOutput('sqlsummary')
              )
            ),
            fluidRow(
              box(
                title='MySQL Console',
                status='success',
                verbatimTextOutput('sqlqueryout'),
                textInput('sqlqueryin','SQL Query',''),
                submitButton('',icon('arrow-up'))
              )
            )
    ),

    # dashboard tab content
    tabItem(tabName = "dashboard",
            # time and date
            fluidRow(
              box(
                title='Refresh Rate (second)',
                status='info',
                solidHeader = TRUE,
                collapsible = TRUE,
                # refresh rate
                sliderInput('DashboardRefreshrate','',min=1,max=60,
                            value=5,round=TRUE)
              ),

              infoBoxOutput('sys_time'),
              infoBoxOutput('GPS_time')

              # box(
              #   title='Time',
              #   status='info',
              #   solidHeader = TRUE,
              #   textOutput('GPS_time'), br(),
              #   textOutput('sys_time')
              # )
            ),
            #  row show GPS time, date and position
            fluidRow(
              # A dynamic valueBox for GPS Position
              infoBoxOutput("GPSPositionlatitude"),
              infoBoxOutput("GPSPositionlongitude"),
              infoBoxOutput("GPSPositionaltitude")
            ),
            #  row to show weather data
            fluidRow(
              # A dynamic valueBox for temperature
              valueBoxOutput('temperatureBox'),
              # # A dynamic valueBox for wind
              # valueBoxOutput('windBox'),
              # A dynamic valueBox for humidity
              valueBoxOutput('humidityBox'),
              # A dynamic valueBox for pressure
              valueBoxOutput('pressureBox')
            ),
            #  row to show battery
            fluidRow(
              # A dynamic valueBox for battery capacity data
              valueBoxOutput('capacityBox'),
              # A dynamic valueBox for chargning rate data
              valueBoxOutput('chargingBox'),
              # A dynamic valueBox for discharging rate data
              valueBoxOutput('dischargingBox')
            ),
            #  row to show resource monitor
            fluidRow(
              # A dynamic valueBox for wave data
              valueBoxOutput('WaveBox'),
              # A dynamic valueBox for tidal data
              valueBoxOutput('tidalBox'),
              # A dynamic valueBox for solar data
              valueBoxOutput('solarBox')
            )

    ),

    # resource tab content
    tabItem(tabName = "resource",
            h2("Resource Monitoring")
    ),

    # navigation tab content
    tabItem(tabName = "navigation",
            h2("Current Position"),
            fluidRow(
              # GPS coordinates
              box(title='GPS Coordinates',
                  status = 'info',
                  solidHeader = TRUE,
                  collapsible = TRUE,
                  textOutput('GPScoordinates'))
            ),

            leafletOutput('mymap')
    )
  )
)

ui <- dashboardPage(header, sidebar, body)

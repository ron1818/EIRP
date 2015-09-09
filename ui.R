# ui.R
#### infomation ####
# author:           Ren Ye
# organization:     ERI@N
# email:            renye.china@gmail.com
# github:           https://github.com/ron1818/EIRP.git
# date of creation: 2015/09/04

#### description ####
# Shiny Dashboard for Nemobot Project

textInputsmall<-function (inputId, label, value = "",...)
{
  div(style="display:inline-block",
      tags$label(label, `for` = inputId),
      tags$input(id = inputId, type = "text", value = value,...))
}

passwordInputsmall<-function (inputId, label, value = "",...)
{
  div(style="display:inline-block",
      tags$label(label, `for` = inputId),
      tags$input(id = inputId, type = "password", value = value,...))
}


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
                title='Database Login',
                status='info',
                solidHeader = TRUE,
                collapsible = TRUE,

                # mysql database login
                # textInput('sqluser','User: ', 'renye'),
                # passwordInput('sqlpassword','Password: ','renye'),
                # textInput('sqlhost','Host: ','localhost'),
                # textInput('sqldbname','Database: ','nemobot'),
                textInputsmall('sqluser','User: ',class='input-small'),
                passwordInputsmall('sqlpassword','Password: ',class='input-small'),
                textInputsmall('sqlhost','Host: ','localhost',class='input-small'),
                textInputsmall('sqldbname','Database: ','nemobot',class='input-small'),
                br(), # insert a break
                # actionButton('sqlloginbutton','Login',icon('sign-in')),
                # actionButton('sqlresetbutton','Reset',icon('undo')),
                # actionButton('sqllogoutbutton','Logout',icon('sign-out'))
                div(style='display:inline-block',
                    actionButton('sqlloginbutton','Login',icon('sign-in'))),
                div(style='display:inline-block',
                    actionButton('sqlresetbutton','Reset',icon('undo'))),
                div(style='display:inline-block',
                    actionButton('sqllogoutbutton','Logout',icon('sign-out')))
              ),
              box(
                title='Login Status',
                status = 'success',
                solidHeader = TRUE,
                collapsible = TRUE,

                #tableOutput('out'),
                "Database Status:",
                verbatimTextOutput('sqlstatus'),
                "Database Summary:",
                tableOutput('sqlsummary')
              )
            ),
            fluidRow(
              box(width=12,
                  title='MySQL Console',
                  status = 'primary',
                  tableOutput('sqlqueryout'),
                  textInput('sqlqueryin','SQL Query',''),
                  actionButton('sqlquerybutton','Run',icon('arrow-up'))
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

# add the components together to generate ui function
ui <- dashboardPage(header, sidebar, body)

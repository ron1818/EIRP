# server.R
#### infomation ####
# author:           Ren Ye
# organization:     ERI@N
# email:            renye.china@gmail.com
# github:           https://github.com/ron1818/EIRP.git
# date of creation: 2015/09/04

#### description ####
# Shiny Dashboard for Nemobot Project


# input a set of messages, the data frame should be dynamically updating
messageData <- data.frame(
  from = c("Admininstrator", "New User", "Support", 'Sales Dept.', ' New User', 'Support'),
  message = c(
    "Sales are steady this month.",
    "How do I register?",
    "The new server is ready.",
    "Sales are steady this month.",
    "How do I register?",
    "The new server is ready."
  ),
  time=c('13:45','2014-12-01',NA,NA,NA,'2014-01-01'),
  stringsAsFactors = FALSE
)

notificationData<-data.frame(
  text=c(
    "5 new users today",
    "12 items delivered",
    "Server load at 86%"
  ),
  status=c('success','warning','danger'),
  stringsAsFactors = FALSE
)

taskData<-data.frame(
  value=c(90,17,75,80),
  color=c('green','aqua','yellow','red'),
  task=c('Documentation','project','deployment','overall'),
  stringsAsFactors = FALSE
)

# system time function, retrieve system time
system.time.text<-function() format(Sys.time(), "%a %d/%m/%y %H:%M:%S")

# GPS data function, retrieve GPS data
GPS.retrieve<-function()
{
  # put your SQL command here

  # data frame to store the retrieved data
   return(data.frame(
    time='Fri 04/09/15 10:25:12',
    latitude=1.359167, #degree, N +ve, S -ve
    altitude=20, #m
    longitude=103.989444, #degree, E +ve, W -ve
    speed=0, # m/s
    stringsAsFactors = FALSE
   ))
}

# weather data function, retrieve weather data
weather.retrieve<-function()
{
  # put your SQL command here

  # data frame to store the retrieved data
   return(data.frame(
    wind.speed=0, #m/s
    wind.direction=180, # degree
    temperature=27, # celsius
    humidity=75, # %
    pressure=1013.25, #mPa
    stringsAsFactors = FALSE
   ))
}

# battery data function, retrieve battery data
battery.retrieve<-function()
{
  # put your SQL command here

  # data frame to store the retrieved data
   return(data.frame(
    capacity=25, #Ah
    charging=15, #rate, watt
    discharging=5, # rate, watt
    voltage=12, #volt
    stringsAsFactors = FALSE
   ))
}


#### server function, main function ####
server <- function(input, output, session) {
#### header output, msg, noti, tsk ####
  # for messages
  output$messageMenu <- renderMenu({
    # Code to generate each of the messageItems here, in a list. This assumes
    # that messageData is a data frame with two columns, 'from' and 'message'.
    msgs <- apply(messageData, 1, function(row) {
      messageItem(from = row[["from"]], message = row[["message"]])
    })

    dropdownMenu(type = "messages", .list = msgs)
  })

  output$notificationMenu <- renderMenu({
    # Code to generate each of the messageItems here, in a list. This assumes
    # that messageData is a data frame with two columns, 'from' and 'message'.
    notifications <- apply(notificationData, 1, function(row) {
      notificationItem(text = row[["text"]], status = row[["status"]])
    })

    dropdownMenu(type = "notification", .list = notifications)
  })

  output$taskMenu <- renderMenu({
    # Code to generate each of the messageItems here, in a list. This assumes
    # that messageData is a data frame with two columns, 'from' and 'message'.
    tasks <- apply(taskData, 1, function(row) {
      taskItem(value = row[["value"]], color = row[["color"]], text=row[['task']])
    })

    dropdownMenu(type = "tasks", .list = tasks)
  })

#### GPS data ####
  # for GPS data
  # # gps time and system time
  # output$GPS_time<-renderText({
  #   invalidateLater(max(1000,input$DashboardRefreshrate*1000),session)
  #   paste('GPS Time:', GPS.retrieve()$time)
  # })
#
  # output$sys_time<-renderText({
  #   invalidateLater(max(1000,input$DashboardRefreshrate*1000),session)
  #   paste('System Time:',system.time.text())
  # })

   # gps time and system time
   output$GPS_time<-renderInfoBox({
     invalidateLater(max(1000,input$DashboardRefreshrate*1000),session)
     infoBox('GPS Time', GPS.retrieve()$time, icon=icon('clock-o'),color = 'olive')
   })

   output$sys_time<-renderInfoBox({
     invalidateLater(max(1000,input$DashboardRefreshrate*1000),session)
     infoBox('System Time',system.time.text(),icon=icon('clock-o'),color = 'olive')
   })

  # gps latitude
  output$GPSPositionlatitude<-renderInfoBox({
    invalidateLater(max(1000,input$DashboardRefreshrate*1000),session)
    GPS.latitude<-GPS.retrieve()$latitude
    infoBox(
      'Latitude', ifelse(GPS.latitude>0,paste0(GPS.latitude,'N'),paste0(-GPS.latitude,'S')), icon=icon('globe')
    )
  })

  # gps longitude
  output$GPSPositionlongitude<-renderInfoBox({
    invalidateLater(max(1000,input$DashboardRefreshrate*1000),session)
    GPS.longitude<-GPS.retrieve()$longitude
    infoBox(
            'Longitude', ifelse(GPS.longitude>0,paste0(GPS.longitude,'E'),paste0(-GPS.longitude,'W')), icon=icon('globe')
    )
  })

  # gps altitude
  output$GPSPositionaltitude<-renderInfoBox({
    invalidateLater(max(1000,input$DashboardRefreshrate*1000),session)
    GPS.altitude<-GPS.retrieve()$altitude
    infoBox(
      'Altitude', paste0(GPS.altitude, 'm'), icon=icon('globe')
    )
  })

  output$GPScoordinates<-renderText({
    invalidateLater(max(1000,input$DashboardRefreshrate*1000),session)
    GPS.longitude<-GPS.retrieve()$longitude
    GPS.latitude<-GPS.retrieve()$latitude
    GPS.altitude<-GPS.retrieve()$altitude
    paste('Latitude:',GPS.latitude,'Longitude:',GPS.longitude,'Altitude:',GPS.altitude)
  })

#### Weather data ####
  # temperature
  output$temperatureBox<-renderValueBox({
    invalidateLater(max(1000,input$DashboardRefreshrate*1000),session)
    weather.temperature<-weather.retrieve()$temperature
    valueBox(weather.temperature, 'Temperature (celsius)',icon=icon('cloud'),color='green')
  })
  # humidity
  output$humidityBox<-renderValueBox({
    invalidateLater(max(1000,input$DashboardRefreshrate*1000),session)
    weather.humidity<-weather.retrieve()$humidity
    valueBox(weather.humidity, 'Humidity (%)',icon=icon('cloud'),color='green')
  })
  # pressure
  output$pressureBox<-renderValueBox({
    invalidateLater(max(1000,input$DashboardRefreshrate*1000),session)
    weather.pressure<-weather.retrieve()$pressure
    valueBox(weather.pressure, 'Pressure (mPa)',icon=icon('cloud'),color='green')
  })

#### Battery data ####
  # capacity
  output$capacityBox<-renderValueBox({
    invalidateLater(max(1000,input$DashboardRefreshrate*1000),session)
    battery.capacity<-battery.retrieve()$capacity
    valueBox(battery.capacity, 'Capacity (Ah)',icon=icon('plug'),color='purple')
  })
  # charging
  output$chargingBox<-renderValueBox({
    invalidateLater(max(1000,input$DashboardRefreshrate*1000),session)
    battery.charging<-battery.retrieve()$charging
    valueBox(battery.charging, 'Charging Rate (W)',icon=icon('plug'),color='purple')
  })
  # discharging
  output$dischargingBox<-renderValueBox({
    invalidateLater(max(1000,input$DashboardRefreshrate*1000),session)
    battery.discharging<-battery.retrieve()$discharging
    valueBox(battery.discharging, 'Discharging Rate (W)',icon=icon('plug'),color='purple')
  })

#### Map data ####
  # map
  output$mymap<-renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addProviderTiles("Esri.WorldImagery",
                       options = providerTileOptions(noWrap = TRUE)
      )%>%
      addMarkers(lng=GPS.retrieve()$longitude,lat=GPS.retrieve()$latitude,popup='Nemobot Position')
  })
}

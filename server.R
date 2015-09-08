# server.R
#### infomation ####
# author:           Ren Ye
# organization:     ERI@N
# email:            renye.china@gmail.com
# github:           https://github.com/ron1818/EIRP.git
# date of creation: 2015/09/04

#### description ####
# Shiny Dashboard for Nemobot Project




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

#### login database ####
  output$sqlstatus<-renderPrint({
    con<-dbConnect(MySQL(),
                   user=input$sqluser,password=input$sqlpassword,host=input$sqlhost,dbname=input$sqldbname)
    summary(con)
  })

  output$sqlsummary<-renderPrint({
    # query
    rs <- dbSendQuery(con, "SHOW TABLES;")
    data <- fetch(rs)
    huh <- dbHasCompleted(rs)
    #dbClearResult(rs)
  })

  output$sqlqueryout<-renderPrint({
    # command
    rs <- dbSendQuery(con, input$sqlqueryin)
    data <- fetch(rs)
    huh <- dbHasCompleted(rs)
    #dbClearResult(rs)
  })

}

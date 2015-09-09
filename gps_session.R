# gps session
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

# weather session
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

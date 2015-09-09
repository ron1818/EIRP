# battery_session
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

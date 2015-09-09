#navigation session
# map
output$mymap<-renderLeaflet({
  leaflet() %>%
    addTiles() %>%
    addProviderTiles("Esri.WorldImagery",
                     options = providerTileOptions(noWrap = TRUE)
    )%>%
    addMarkers(lng=GPS.retrieve()$longitude,lat=GPS.retrieve()$latitude,popup='Nemobot Position')
})

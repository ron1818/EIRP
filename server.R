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
  #### database ####
  # load database
  source('database_session.R',local=TRUE)
  #### header output, msg, noti, tsk ####
  source('header_session.R',local=TRUE)
  #### GPS data ####
  source('gps_session.R',local=TRUE)
  #### Weather data ####
  source('weather_session.R',local=TRUE)
  #### Battery data ####
  source('battery_session.R',local=TRUE)
  #### Map data ####
  source('navigation_session.R',local=TRUE)

}

#global.R
#### infomation ####
# author:           Ren Ye
# organization:     ERI@N
# email:            renye.china@gmail.com
# github:           https://github.com/ron1818/EIRP.git
# date of creation: 2015/09/04

#### description ####
# Shiny Dashboard for Nemobot Project

# packages
library(shiny)
library(shinydashboard)
library(leaflet)
library(RMySQL)

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
system.time.text<-function()
  format(Sys.time(), "%a %d/%m/%y %H:%M:%S")

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

fn.sql.print<-function(user,password,host,database){
 return(paste0(user,":",password,"@",host,"(",database,")"))
}
# check and open sql database
fn.sql.login<-function(user,password,host,database){
  # check whether the host name contain a port number
  if(length(grep(':',host))>0){ # cannot find a : in the host name
    tmp<-strsplit(host,':')[[1]]
    hostname<-tmp[1]
    port=tmp[2]
  }else{
    hostname=host
    port=3306 #default port name
  }

  # try to connect
  con <- dbConnect(MySQL(),
                   user=user,
                   password=password,
                   dbname=database,
                   host=hostname,
                   port=port)
  # #close database on exit
  # on.exit(dbDisconnect(con))
  # # check error handler
  # if(class(error.handler$value)=='MySQLConnection'){
  #   status='Connected'
  #   msg='Connected to the MySQL server'
  # }else{
  #   remove(con)
  #   status='Disconnected'
  #   msg=error.handler$value
  # }

  return(con)
}

# use tryCatch to locate error and warning
# under development
tryCatch.W.E <- function(expr)
{
  W <- NULL
  w.handler <- function(w){ # warning handler
    W <<- w
    invokeRestart("muffleWarning")
  }
  list(value = withCallingHandlers(tryCatch(expr, error = function(e) e),
                                   warning = w.handler),
       warning = W)
}

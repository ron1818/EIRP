#database retrieval
# use RMySQL package

#### infomation ####
# author:           Ren Ye
# organization:     ERI@N
# email:            renye.china@gmail.com
# github:           https://github.com/ron1818/EIRP.git
# date of creation: 2015/09/04

#### description ####
# database retrieval for Nemobot Project

library(RMySQL)

# database information
USER='renye'
PASSWORD='renye2'
HOST='localhost'
PORT=3306
DB='employees'

# open database
try(
con<-dbConnect(MySQL(),
                 user=USER, password=PASSWORD,port=PORT,
                 dbname=DB, host=HOST),
silent = TRUE
)
#close database on exit
on.exit(dbDisconnect(con))

# query
rs <- dbSendQuery(con, "SELECT * FROM salaries WHERE from_date BETWEEN DATE('2000-01-01') AND DATE('2000-02-29');")
data <- fetch(rs, n=10)
huh <- dbHasCompleted(rs)
dbClearResult(rs)




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

a<-tryCatch.W.E(con<-dbConnect(MySQL(),
                       user=USER, password=PASSWORD,port=PORT,
                       dbname=DB, host=HOST))

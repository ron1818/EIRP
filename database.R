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
PASSWORD='renye'
HOST='localhost'
DB='employees'

# open database
con <- dbConnect(MySQL(),
                 user=USER, password=PASSWORD,
                 dbname=DB, host=HOST)
#close database on exit
on.exit(dbDisconnect(con))

# query
rs <- dbSendQuery(con, "SELECT * FROM salaries WHERE from_date BETWEEN DATE('2000-01-01') AND DATE('2000-02-29');")
data <- fetch(rs, n=10)
huh <- dbHasCompleted(rs)
dbClearResult(rs)

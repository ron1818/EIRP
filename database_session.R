
# database session
# initialize connection
con <- reactiveValues(conn=NULL,table=NULL,text=NULL)

#on.exit(dbDisconnect(con$conn))

# actionbutton sql reset
# remove all fields
# remove con$table but retain con$conn --> connection is not lost
observeEvent(input$sqlresetbutton,{
  #con$conn<-NULL # reset
  con$table<-NULL
  con$text<-fn.sql.print('NA','NA','NA','NA')
  updateTextInput(session, 'sqluser','User: ', '')
  updateTextInput(session, 'sqlpassword','Password: ', '')
  updateTextInput(session, 'sqlhost','Host: ', '')
  updateTextInput(session, 'sqldbname','Database:', '')
})

# actionbutton sql login
# connect to sql with the function fn.sql.login in global.R
observeEvent(input$sqlloginbutton,{
  con$conn<-fn.sql.login(input$sqluser,input$sqlpassword,input$sqlhost,input$sqldbname)
  con$table<-data.frame(input$sqluser,input$sqlpassword,input$sqlhost,input$sqldbname)
  con$text<-fn.sql.print(input$sqluser,input$sqlpassword,input$sqlhost,input$sqldbname)
})

# actionbutton sql logout
# disconnect the mysql server
observeEvent(input$sqllogoutbutton,{
  dbDisconnect(con$conn)
  con$conn<-NULL
})

# output$out <- renderTable({
#   con$table
# })

# print database status
output$sqlstatus<-renderText({
  if(!is.null(con$conn))
    print('MySQL database connected')
  else
    print('MySQL database disconnected')
})

# print database summary
output$sqlsummary<-renderTable({
  if(!is.null(con$conn)){
    rs <- dbSendQuery(con$conn, "SHOW TABLES;")
    tablelist <- fetch(rs)
    #huh <- dbHasCompleted(rs)
    #dbClearResult(rs)
    return(tablelist)
  }
  else
    return(NULL)
})

# query console
query<-reactiveValues(data=NULL)
observeEvent(input$sqlquerybutton,{
  rs<-dbSendQuery(con$conn, input$sqlqueryin)
  query$data<-fetch(rs,limit=10)
  # clear input region
  updateTextInput(session, 'sqlqueryin','SQL Query',NA)
})

output$sqlqueryout<-renderTable({
  if(!is.null(query$data))
    return(query$data)
  else
    return(NULL)
})


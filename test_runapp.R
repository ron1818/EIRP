runApp(
  list(ui = pageWithSidebar(
    headerPanel("My data table"),
    sidebarPanel(h5("Enter input"),
                 # mysql database login
                 textInput('sqluser','User: ', 'renye'),
                 passwordInput('sqlpassword','Password: ','renye'),
                 textInput('sqlhost','Host: ','localhost'),
                 textInput('sqldbname','Database: ','nemobot'),
                 br(), # insert a break
                 div(style='display:inline-block',
                     actionButton('sqllogin','Login',icon('sign-in'))),
                 div(style='display:inline-block',
                     actionButton('sqlreset','Reset',icon('undo'))),
                 div(style='display:inline-block',
                     actionButton('sqllogout','Logout',icon('sign-out')))),

                 mainPanel(tableOutput("out"),
                           verbatimTextOutput('info'),
                           tableOutput('showtable')
                          )
    ),

    server = function(input,output,session){
      con <- reactiveValues(conn=NULL,table=NULL,text=NULL)

      # actionbutton sql reset
      observeEvent(input$sqlreset,{
          #con$conn<-NULL # reset
          con$table<-NULL
          con$text<-fn.sql.print('NA','NA','NA','NA')
          updateTextInput(session, 'sqluser','User: ', '')
          updateTextInput(session, 'sqlpassword','Password: ', '')
          updateTextInput(session, 'sqlhost','Host: ', '')
          updateTextInput(session, 'sqldbname','Database:', '')
      })

      observeEvent(input$sqllogin,{
        con$conn<-fn.sql.login(input$sqluser,input$sqlpassword,input$sqlhost,input$sqldbname)
          con$table<-data.frame(input$sqluser,input$sqlpassword,input$sqlhost,input$sqldbname)
          con$text<-fn.sql.print(input$sqluser,input$sqlpassword,input$sqlhost,input$sqldbname)
      })

      observeEvent(input$sqllogout,{
        dbDisconnect(con$conn)
        con$conn<-NULL
      })

      output$out <- renderTable({
        con$table
      })

      output$info<- renderText({
        if(!is.null(con$conn))
          print('database connected')
        else
          print('database disconnected')
      })

      output$showtable<- renderTable({
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


    })
  )


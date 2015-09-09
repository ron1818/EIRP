#headpanel session
  # for messages
  output$messageMenu <- renderMenu({
    # Code to generate each of the messageItems here, in a list. This assumes
    # that messageData is a data frame with two columns, 'from' and 'message'.
    msgs <- apply(messageData, 1, function(row) {
      messageItem(from = row[["from"]], message = row[["message"]])
    })

    dropdownMenu(type = "messages", .list = msgs)
  })

  output$notificationMenu <- renderMenu({
    # Code to generate each of the messageItems here, in a list. This assumes
    # that messageData is a data frame with two columns, 'from' and 'message'.
    notifications <- apply(notificationData, 1, function(row) {
      notificationItem(text = row[["text"]], status = row[["status"]])
    })

    dropdownMenu(type = "notification", .list = notifications)
  })

  output$taskMenu <- renderMenu({
    # Code to generate each of the messageItems here, in a list. This assumes
    # that messageData is a data frame with two columns, 'from' and 'message'.
    tasks <- apply(taskData, 1, function(row) {
      taskItem(value = row[["value"]], color = row[["color"]], text=row[['task']])
    })

    dropdownMenu(type = "tasks", .list = tasks)
  })

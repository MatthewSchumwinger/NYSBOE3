library(shiny)
# library(data.table)



# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  #-------------------------------- 
  # per-session processing
  #--------------------------------
  
  
  #-------------------------------- 
  # user-responsive processing
  #--------------------------------

  ## DATA TABLES 
  
  # Filter data based on selections
  output$table_filers <- DT::renderDataTable(DT::datatable({
    df <- filers 
    if (input$COMMITTEE_TYPE != "All") {
      df <- df[df$COMMITTEE_TYPE == input$COMMITTEE_TYPE,]
    }
    if (input$FILER_TYPE != "All") {
      df <- df[df$FILER_TYPE == input$FILER_TYPE, ]
    }
    if (input$STATUS != "All") {
      df <- df[df$STATUS == input$STATUS, ]
    }
    df
  },
  filter = "top"))
  
  output$table_trans <- DT::renderDataTable(DT::datatable({
    
    df <- trans 
    if (input$E_YEAR != "All") {
      df <- df[df$E_YEAR == input$E_YEAR,]
    }
    if (input$CONTRIB_CODE_20 != "All") {
      df <- df[df$CONTRIB_CODE_20 == input$CONTRIB_CODE_20, ]
    }
    if (input$TRANSACTION_CODE != "All") {
      df <- df[df$TRANSACTION_CODE == input$TRANSACTION_CODE, ]
    }

    df <- df[ , t_cols, with = FALSE]
    df
    },
    filter = "top",
    # options = list(searching = FALSE)
    options = list(searching = TRUE)
    ))
  
  output$table_flaggedA <- DT::renderDataTable(DT::datatable({
    df <- flaggedA 

    if (input$IN_TRANSACTION_CODE != "All") {
      df <- df[df$IN_TRANSACTION_CODE == input$IN_TRANSACTION_CODE, ]
    }
    
    df
  },
  filter = "top",
  # options = list(searching = FALSE)
  options = list(searching = TRUE)
  ))
  
  output$table_flaggedB <- DT::renderDataTable(DT::datatable({
    df <- flaggedB 

    if (input$IN_TRANSACTION_CODE != "All") {
      df <- df[df$IN_TRANSACTION_CODE == input$IN_TRANSACTION_CODE, ]
    }
    
    # df <- df[ , t_cols, with = FALSE]
    df
  },
  filter = "top",
  # options = list(searching = FALSE)
  options = list(searching = TRUE)
  ))

  # Show the first "n" observations
  output$trans_view <- renderPrint({
    # rec <- trans[input$t_rownum,]
    rec <- trans[tID == input$tID]
    str(rec)
  },
  width = 90)
  
  
  # download filtered data
  output$downloadData_filers <- downloadHandler(
    filename = function() {
      paste('filers-subset-', Sys.Date(), '.csv', sep='')
    },
    content = function(con) {
      s = as.numeric(input$table_filers_rows_all)
      write.csv(filers[s], con)
    }
  )
  
  output$downloadData_trans <- downloadHandler(
    filename = function() {
      paste('trans-subset-', Sys.Date(), '.csv', sep='')
    },
    content = function(con) {
      s = as.numeric(input$table_trans_rows_all)
      write.csv(trans[s], con)
    }
  )
  
  output$downloadData_flaggedA <- downloadHandler(
    filename = function() {
      paste('flaggedA-subset-', Sys.Date(), '.csv', sep='')
    },
    content = function(con) {
      s = as.numeric(input$table_flaggedA_rows_all)
      write.csv(flaggedA[s], con)
    }
  )
  
  output$downloadData_flaggedB <- downloadHandler(
    filename = function() {
      paste('flaggedB-subset-', Sys.Date(), '.csv', sep='')
    },
    content = function(con) {
      s = as.numeric(input$table_flaggedB_rows_all)
      write.csv(flaggedB[s], con)
    }
  )
  
  })

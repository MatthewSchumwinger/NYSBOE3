library(shiny)

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
    
    # df <- df[ , cols] 
    df
  }))
  
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
    
    # df <- df[ , cols] 
    df
  }))
}
)
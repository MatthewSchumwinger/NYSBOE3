library(shiny)

mycite <- tags$div(id = "cite", 
                   p('Data from the', a(href = "http://www.elections.ny.gov", 
                                        "NYBOE."), "Developed by",
                     a(href = 'https://biglakedata.com', 'Big Lake Data LLC.')))

shinyUI(navbarPage(
  
  # tags$head(includeScript("google-analytics.js")),
  
  title = "NYSBOE Data Explorer",
  id = "nav",
  theme = "my_style.css",
  
  tabPanel("Filers",
           
           fluidPage(
             titlePanel("Filers"),
             
             # Create a new Row in the UI for selectInputs
             fluidRow(
               column(4,
                      selectInput("FILER_TYPE",
                                  "Filer type:",
                                  c("All",
                                    l_filer_type))
               ),
               column(4,
                      selectInput("STATUS",
                                  "Status:",
                                  c("All",
                                    l_status))
               ),
               column(4,
                      selectInput("COMMITTEE_TYPE",
                                  "Committee type:",
                                  c("All",
                                    l_COMMITTEE_TYPE))
               )),
             # Create a new row for the table.
             fluidRow(
               DT::dataTableOutput("table_filers")
             )
           ),
           mycite
  ),
  
  tabPanel("Transactions",
           
           fluidPage(
             titlePanel("Transactions"),
             h5("(for election years 2008, 2010, 2012, 2014)"),
             
             # Create a new Row in the UI for selectInputs
             fluidRow(
               column(4,
                      selectInput("TRANSACTION_CODE",
                                  "Transaction code:",
                                  c("All",
                                    l_TRANSACTION_CODE))
               ),
               column(4,
                      selectInput("CONTRIB_CODE_20",
                                  "Contributor Code:",
                                  c("All",
                                    l_Contrib_Code_20))
               ),
               column(4,
                      selectInput("E_YEAR",
                                  "E_Year:",
                                  c("All",
                                    l_E_YEAR))
               )
             ),
             # Create a new row for the table.
             fluidRow(
               DT::dataTableOutput("table_trans")
             ),
             
             mycite
           )
  ),
  tabPanel("Documentation",
           fluidRow(
             column(12,
                    pre(includeText("data/data_docs/CODES.TXT"))
             ),
             column(12,
                    pre(includeText("data/data_docs/EFSSCHED.TXT"))
             )
           )
  )
  
)
)

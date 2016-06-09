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
             titlePanel("All Filers"),
             
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
             titlePanel("All Transactions"),
             # h5("(for election years 2008, 2010, 2012, 2014)"),
             h5("(for all election years)"),

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

  navbarMenu("Flagged Set A",
    tabPanel("data",
             
             fluidPage(
               titlePanel("Flagged Set A"),
               h5("(for all election years)"),
               
               # Create a new Row in the UI for selectInputs
               fluidRow(
                 column(4,
                        selectInput("IN_TRANSACTION_CODE",
                                    "IN Transaction code:",
                                    c("All",
                                      l_IN_TRANSACTION_CODE))
                 )),

               # Create a new row for the table.
               fluidRow(
                 DT::dataTableOutput("table_flaggedA")
               ),
               
               mycite
             )
    ),
    
    tabPanel("Summary",
             img(src='summaryA.pdf', width = "100%")

    )
  ),
  
  navbarMenu("Flagged Set B",
             tabPanel("data",
                      
                      fluidPage(
                        titlePanel("Flagged Set B"),
                        h5("(for all election years)"),
                        
                        # Create a new Row in the UI for selectInputs
                        # fluidRow(
                        #   column(4,
                        #          selectInput("IN_TRANSACTION_CODE",
                        #                      "IN Transaction code:",
                        #                      c("All",
                        #                        l_IN_TRANSACTION_CODE))
                        #   )),

                        # Create a new row for the table.
                        fluidRow(
                          DT::dataTableOutput("table_flaggedB")
                        ),
                        
                        mycite
                      )
             ),
             
             tabPanel("Summary",
                      img(src='summaryB.pdf', width = "100%")
                      
             )
  ),
  
  tabPanel("Detailed Transaction View",
           fluidPage(
             sidebarLayout(
               sidebarPanel(
                 numericInput("t_rownum", "Row # of transaction record to view:", 1),

                 helpText("Note: the row # is the left-most column on the
                        'Transactions' tab.")
               ),
               mainPanel(
                 h4("Full Transaction Record"),
                 verbatimTextOutput("trans_view")
               )
             )
             )
           ),

  tabPanel("Documentation",
           fluidRow(
             h4("Transactions dataset"),
             column(12,
                    pre(includeText("data/data_docs/EFSSCHED.TXT"))
             ),
             h4("Filers dataset"),
             column(12,
                    pre(includeText("data/data_docs/CODES.TXT"))
             )
           )
  )
  
)
)

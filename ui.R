library(shiny)

mycite <- tags$div(id = "cite", align = "right",
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
           downloadButton('downloadData_filers', 'Download filtered data', class = "download"),
           mycite
  ),

  tabPanel("Transactions",

           fluidPage(
             titlePanel("Transactions"),
             h5("(for election years 2008, 2010, 2012, 2014, 2016)"),
             # h5("(for all election years)"),

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
             
             downloadButton('downloadData_trans', 'Download filtered data', class = "download"),

             mycite
           )
  ),

  navbarMenu("Flagged Set A",
    tabPanel("data",
             
             fluidPage(
               titlePanel("Flagged Set A: the 'Sugarman Standard'"),
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
               
               downloadButton('downloadData_flaggedA', 'Download filtered data', class = "download"),
               
               mycite
             )
    ),
    
    tabPanel("summary",
             img(src='summaryA.pdf', width = "100%")
    ),
    tabPanel("notes to data structure",
             img(src='summaryA-2.pdf', width = "100%")
    )
  ),
  
  navbarMenu("Flagged Set B",
             tabPanel("data",
                      
                      fluidPage(
                        titlePanel("Flagged Set B: Bird's filtering steps"),
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
                        
                        downloadButton('downloadData_flaggedB', 'Download filtered data', class = "download"),
                        
                        mycite
                      )
             ),
             
             tabPanel("summary",
                      img(src='summaryB.pdf', width = "100%")
             )
  ),
  
  tabPanel("Detailed Transaction View",
           fluidPage(
             sidebarLayout(
               sidebarPanel(
                 numericInput("tID", "tID of transaction record to view:", 1),

                 helpText("Note: the tID is the left-most column on the
                        transactions datasets.")
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
  ),
  
  tabPanel("warm-to-hot finder",
           
           fluidPage(
             titlePanel("potential outgoing `hot` pass-through transactions"),
             h5("(Outgoing 'F' or 'H' transaction codes for election years 2008, 2010, 2012, 2014, 2016)"),
             
             
             # Create a new Row in the UI for selectInputs
             fluidRow(
               column(4,
                      numericInput("targetID", "tID of incoming `warm` contribution transaction (transaction code 'A','B','C','D','E', or 'G') :", 1)
               ),
               column(4,
                      numericInput("amount_range", "% +/- variance from `warm` transaction AMOUNT_70:", 1)
               ),
               column(4,
                      numericInput("date_range", "range of days before/after `warm` transaction DATE1_10:", 1)
               )
             ),
             # Create a new row for the table.
             fluidRow(
               DT::dataTableOutput("table_hot")
             ),
             
             # downloadButton('downloadtable_hot', 'Download data', class = "download"),
             
             mycite
           )
           

  )
  
)
)

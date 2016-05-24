library(shiny)
# library(leaflet)
# library(ggplot2)
# library(dplyr)

source("munge.R")

#-----------------------------------------


# mytheme <- theme_bw() +
#   theme(axis.title = element_blank(),
#         panel.border = element_blank(),
#         panel.grid = element_blank(),
#         axis.ticks.x = element_blank(),
#         text = element_text(family = "Helvetica")
#   )

mycite <- tags$div(id = "cite", 
                   p('Data from the', a(href = "http://www.elections.ny.gov", 
                       "NYBOE."), "Developed by",
                     a(href = 'https://biglakedata.com', 'Big Lake Data LLC.')))
#-----------------------------------------
ui <- navbarPage(
  
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




server <- function(input, output, session) {
  
  #-------------------------------- 
  # per-session processing
  #--------------------------------
  

  
  #-------------------------------- 
  # user-responsive processing
  #--------------------------------
  
  # output$trend <- renderPlot({
  #   yearly <- filter(crimes@data, group == input$group) %>% group_by(year) %>% 
  #     summarise( 
  #       # land_use = "all",
  #       total = n_distinct(INCIDENT_N)
  #       # FTEs = sum(jobs, na.rm =T)
  #     ) 
  #   yearly$select <- yearly$year == input$year 
  #   p <- ggplot2::ggplot(data = yearly, aes(x = year, y = total, fill = select)) + 
  #     geom_bar(stat="identity", width = 0.75) +
  #     ggtitle(paste(yearly[yearly$year == input$year, ]$total, input$group, 
  #                   "\nincidents in", input$year)) +
  #     scale_fill_manual(values = c("gray", "#0033FF")) +
  #     guides(fill = FALSE) +
  #     scale_y_continuous(name = "Incidents") +
  #     mytheme +
  #     scale_x_discrete(breaks = c(2005, 2010, 2015)) +
  #     theme(axis.title.x = element_blank())
  #   p
  # })
  
  
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


shinyApp(ui = ui, server = server)
library(shiny)


# Define UI for dataset viewer app ----
ui <- fluidPage(theme = shinytheme("slate"),
 
  sidebarLayout(
    sidebarPanel(
      fileInput("file1", "Choose CSV File",
                accept = c(
                  "text/csv",
                  "text/comma-separated-values,text/plain",
                  ".csv")
      ),
      actionButton("do", "Monitor")
      ),
    mainPanel(
      tabsetPanel(
        tabPanel("Table", tableOutput("contents")),
        tabPanel("Plots", plotOutput("plot")),
        tabPanel("About Project", htmlOutput("about")),
        tabPanel("Contacts", textOutput("contact")),
        
      
    )
  )
)
)

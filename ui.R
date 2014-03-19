library(shiny)

shinyUI(pageWithSidebar(
  
  headerPanel("Project-1"),
  
  sidebarPanel(
    tags$textarea(id="inputText",rows=5,cols=2,placeholder="Enter Genes"),
    fileInput('file1','Choose Excel File',
               accept=c('text/csv','text/comma-separted-values','text/plain','.csv','.xls','.xlsx')),
    conditionalPanel(
      condition = "output.contents",
      downloadButton('downloadData','Download'))
    ),
  mainPanel(
    textOutput('version'),
    tableOutput('contents'),
    verbatimTextOutput('summary'),
    conditionalPanel(
      condition = "output.contents==null || output.contents.length == 0",
      wellPanel(
        p("Here goes the help text")
        )
      )
    )
))

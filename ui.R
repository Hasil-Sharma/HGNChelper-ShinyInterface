library(shiny)

shinyUI(pageWithSidebar(
  
  headerPanel("Project-1"),
  
  sidebarPanel(
    textInput('text','Text Input',value=NULL),
    fileInput('file1','Choose Excel File',
               accept=c('text/csv','text/comma-separted-values','text/plain','.csv','.xls','.xlsx')),
    conditionalPanel(
      condition = "output.contents",
      downloadButton('downloadData','Download'))
    ),
  mainPanel(
    textOutput('version'),
    tableOutput('contents'),
    conditionalPanel(
      condition = "output.contents",
      verbatimTextOutput('summary.row')
    )
    )
  
))

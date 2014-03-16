library(shiny)
library(gdata)
library(HGNChelper)

shinyServer(function(input, output){
  react <-reactive({
    inFile <- input$file1
    if(!is.null(inFile)){
    data <- read.xls(inFile$datapath,header=FALSE)
    res <- checkGeneSymbols(as.vector(data$V1))
    }
  })

  versionGen <- reactive({
    paste("Using HGNC database current as of: ", 
          file.info(system.file(package="HGNChelper", 
          "data/hgnc.table.rda"))$mtime)
  })

  summaryGen <- reactive({
#     paste("Number of Genes checked:",nrow(react()),
#           "Number of invalid genes found:",sum(react()$Approved),
#           "Number of invalid genes corrected:",
#           sum(!react()$Approved & !is.na(react()$Suggested.Symbol))
#           )
      row <- paste("Number of Genes checked:",nrow(react()))
      approved <- paste("Number of invalid genes found:",sum(react()$Approved))
      as.data.frame(row,approved)
  })
  output$contents <- renderTable(head(react()))
  output$version <- renderText(versionGen())
  output$summary <- renderPrint(summaryGen())

  output$downloadData <- downloadHandler(
    filename = function(){ paste('output','.csv',sep='')},
    content = function(file){
      write.csv(react()[,3],file,quote=FALSE,row.names=FALSE,col.names=FALSE)
    }
  )
})
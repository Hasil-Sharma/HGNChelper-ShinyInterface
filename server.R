library(shiny)
library(gdata)
library(HGNChelper)

shinyServer(function(input, output){
  react <-function(input=NULL){
    inFile <- input$file1

    if(!is.null(inFile)){
    data <- read.xls(inFile$datapath,header=FALSE)
    data <- as.vector(data$V1)
    }
    else{
      if(!(input$inputText=="")){
        data <- input$inputText
        data <- gsub(' ','',data)
        data <- unlist(strsplit(data,split=c('\n')))
        data <- data[data != ""]
      }
      else{
        return (NULL)
      }
    }
    res <- checkGeneSymbols(data)
    row <- paste("Number of Genes Checked: ",nrow(res))
    approved <- paste("Number of invalid genes found:",sum(res$Approved))
    corrected <- paste("Number of invalid genes corrected: ", 
                       sum(!res$Approved & !is.na(res$Suggested.Symbol)))
    return(list(res=res,summary=c(row,approved,corrected)))
  }

  versionGen <- reactive({
    paste("Using HGNC database current as of: ", 
          file.info(system.file(package="HGNChelper", 
          "data/hgnc.table.rda"))$mtime)
  })

  
  data <- reactive({react(input)})
  output$contents <- renderTable({head(data()$res)})
  output$version <- renderText(versionGen())
  output$summary <- renderPrint(cat(data()$summary,sep="\n"))

  output$downloadData <- downloadHandler(
    filename = function(){ paste('output',Sys.Date(),'.csv',sep='')},
    content = function(file){
      write.csv(data(),file,quote=FALSE,row.names=FALSE,col.names=FALSE)
    }
  )
})

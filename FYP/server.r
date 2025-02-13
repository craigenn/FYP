options(shiny.maxRequestSize=30*1024^2)
#memory.limit(size = 56000)
# Define server logic ----
server <- function(input, output) {
  
  output$contents <- renderTable({
    #make it only flag malicous red background
    model <- h2o.loadModel("StackedEnsemble")
    #model <- h2o.loadModel("StackedEnsemble_model_R_1645044782253_793")
    file <- input$file1
    ext <- tools::file_ext(file$datapath)
    
    req(file)
    validate(need(ext == "csv", "Please upload a csv file"))
    
    
    mydf <- read.csv(file$datapath)
   # mydf$Class <- as.factor(df$Class)
    
    packets_h20 <- as.h2o(mydf)
   # packets_h20$Class <- as.factor(packets_h20$Class)
    
    
  pred <- h2o.predict(model, packets_h20)
  predoutput <- as.data.frame(pred)
  total <- cbind(mydf, predoutput)
  columns <- c('X_index' , 'X_type', 'X_source.layers.frame.frame.time', 'X_source.layers.ip.ip.addr', 'X_source.layers.ip.ip.dst')
  #library(data.table)
  newtotal <- total[total$predict == "1", ]
  newtotal2 <- newtotal[, columns]
  table(newtotal2)
  
   
    })
  
  output$plot <- renderPlot({
    
    
    
    model <- h2o.loadModel("StackedEnsemble")
    file <- input$file1
    ext <- tools::file_ext(file$datapath)
    
    req(file)
    validate(need(ext == "csv", "Please upload a csv file"))
    
    
    mydf <- read.csv(file$datapath)
   
    
    packets_h20 <- as.h2o(mydf)
  #  packets_h20$Class <- as.factor(packets_h20$Class)
    
    
    pred <- h2o.predict(model, packets_h20)
  #  perf <- h2o.performance(model, pred[,3])
  #  plot(perf)
   
    predoutput <- as.data.frame(pred[1:2])
    
    plot(predoutput)
    
  })
  output$about <- renderText({
    "<h1> this is a test </h1>"
  })
  
  observeEvent(input$do, {
    session$sendCustomMessage(type = 'testmessage',
                              message = 'Thank you for clicking')
  })
  
  predictor <- function(input,output){
    model <- h2o.loadModel("StackedEnsemble")
    file <- input$file1
    ext <- tools::file_ext(file$datapath)
    
    req(file)
    validate(need(ext == "csv", "Please upload a csv file"))
    
    
    mydf <- read.csv(file$datapath)
    mydf$Class <- as.factor(df$Class)
    
    packets_h20 <- as.h2o(mydf)
    packets_h20$Class <- as.factor(packets_h20$Class)
    
    
    pred <- h2o.predict(model)
  }
   

    
  }

  

library(h2o)
h2o.init(nthreads = 4)
model <- h2o.loadModel("StackedEnsemble")
#file <- input$file1
#ext <- tools::file_ext(file$datapath)

#req(file)
#validate(need(ext == "csv", "Please upload a csv file"))


mydf <- read.csv("packetlist.csv")
# mydf$Class <- as.factor(df$Class)

packets_h20 <- as.h2o(mydf)
#packets_h20$Class <- as.factor(packets_h20$Class)


pred <- h2o.predict(model, packets_h20)
predoutput <- as.data.frame(pred)

total <- cbind(mydf, predoutput)
columns <- c('X_index' , 'X_type', 'X_source.layers.frame.frame.time', 'X_source.layers.ip.ip.addr', 'X_source.layers.ip.ip.dst')
#library(data.table)
newtotal <- total[total$predict == "1", ]
newtotal2 <- newtotal[, columns]
table(newtotal2)

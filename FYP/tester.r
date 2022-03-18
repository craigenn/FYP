library(h2o)
h2o.init(nthreads = 4)
model <- h2o.loadModel("StackedEnsemble2")
model2 <- h2o.loadModel("StackedEnsemble")
#file <- input$file1
#ext <- tools::file_ext(file$datapath)

#req(file)
#validate(need(ext == "csv", "Please upload a csv file"))


mydf <- read.csv("testtclass.csv")
# mydf$Class <- as.factor(df$Class)

packets_h20 <- as.h2o(mydf)
#packets_h20$Class <- as.factor(packets_h20$Class)


pred <- h2o.predict(model, packets_h20)
pred2 <- h2o.predict(model2, packets_h20)
h2o.explain(model2, packets_h20)
h2o.confusionMatrix(model2, packets_h20)
predoutput <- as.data.frame(pred)
predoutput2 <- as.data.frame(pred2)

total <- cbind(mydf, predoutput)
total2 <- cbind(mydf, predoutput2)
columns <- c('X_index' , 'X_type', 'X_source.layers.frame.frame.time', 'X_source.layers.ip.ip.addr', 'X_source.layers.ip.ip.dst')
#library(data.table)
newtotal <- total[total$predict == "1", ]
newtotal3 <- total2[total2$predict == "1", ]
newtotal2 <- newtotal[, columns]
newtotal4 <- newtotal3[, columns]
View(newtotal2)

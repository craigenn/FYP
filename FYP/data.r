setwd("~/BrunelOnedrive/OneDrive - Brunel University London/Brunelwork/fyp/FYP")
install.packages("jsonlite")
library(jsonlite)
#json <- read_json("iwishidk.json")
#mydf <- read.csv("packetlistclass.csv")

install.packages("h2o")
library(h2o)

#dataset
mydf <- read.csv("packetlistclass.csv")
mydf$Class <- as.factor(df$Class)
#mydf2 <- read.csv("packetlistcensor.csv")

#remove class id column
packets <- mydf[,-1]

#start h20 cluster instance
h2o.init(nthreads = 2)


#convert input into h20frame
packets_h20 <- as.h2o(mydf)
packets_h20$Class <- as.factor(packets_h20$Class)
packetclassless <- as.h2o(packets)

#take a look at the h20 frame
h2o.describe(packets_h20)

#Split data into train and test
y <- "Class"

df_splits <- h2o.splitFrame(data = packets_h20, ratios = 0.50, seed = 1)
train <- df_splits[[1]]
test <- df_splits[[2]]
x <- setdiff(names(train), y)

train[, y] <- as.factor(train[, y])
test[, y] <- as.factor(test[, y])

#number of cv folds
nfolds <-5

# Train & Cross-validate a GBM
my_gbm <- h2o.gbm(x = x,
                  y = y,
                  training_frame = train,
                  distribution = "bernoulli",
                  ntrees = 10,
                  max_depth = 3,
                  min_rows = 2,
                  learn_rate = 0.2,
                  nfolds = nfolds,
                  keep_cross_validation_predictions = TRUE,
                  seed = 1)

# Train & Cross-validate a RF
my_rf <- h2o.randomForest(x = x,
                          y = y,
                          training_frame = train,
                          ntrees = 50,
                          nfolds = nfolds,
                          keep_cross_validation_predictions = TRUE,
                          seed = 1)




# Train a stacked ensemble using the GBM and RF above
ensemble <- h2o.stackedEnsemble(x = x,
                                y = y,
                                training_frame = train,
                                base_models = list(my_gbm, my_rf))



# Eval ensemble performance on a test set
perf <- h2o.performance(ensemble, newdata = test)

# Compare to base learner performance on the test set
perf_gbm_test <- h2o.performance(my_gbm, newdata = test)
perf_rf_test <- h2o.performance(my_rf, newdata = test)
baselearner_best_auc_test <- max(h2o.auc(perf_gbm_test), h2o.auc(perf_rf_test))
ensemble_auc_test <- h2o.auc(perf)
print(sprintf("Best Base-learner Test AUC:  %s", baselearner_best_auc_test))
print(sprintf("Ensemble Test AUC:  %s", ensemble_auc_test))


# Generate predictions on a test set (if neccessary)
pred <- h2o.predict(ensemble, newdata = test)


h2o.auc(perf_gbm_test)
h2o.explain(ensemble, test)
h2o.saveModel(my_gbm, path = getwd(), force = TRUE)
h2o.saveModel(my_rf, path = getwd(), force = TRUE)
h2o.saveModel(ensemble, path = getwd(), force = TRUE)

h2o.shutdown()





'#NN in h2o
h2o_nn <- h2o.deeplearning(x = 2:154,
                           y = 1,
                           training_frame = packets_h20,
                           nfolds = 5
                           )
h2o.performance(h2o_nn)

h2o.shutdown()
'
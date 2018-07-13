library(h2o)
h2o.init()
df <- h2o.importFile("http://s3.amazonaws.com/h2o-public-test-data/smalldata/prostate/prostate.csv.zip")
df[,"CAPSULE"] <- as.factor(df[,"CAPSULE"])
model_fit <- h2o.gbm(x = 3:8, y = 2, training_frame = df, nfolds = 5, seed = 1)

# AUC of cross-validated holdout predictions
h2o.auc(model_fit, xval = TRUE)
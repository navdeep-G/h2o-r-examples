library(h2o)
h2o.init()

# H2O Cross-validated K-means example
prosPath <- system.file("extdata", "prostate.csv", package="h2o")
prostate.hex <- h2o.uploadFile(path = prosPath)
fit <- h2o.kmeans(training_frame = prostate.hex,
                  k = 10,
                  x = c("AGE", "RACE", "VOL", "GLEASON"),
                  nfolds = 5,  #If you want to specify folds directly, then use "fold_column" arg
                  keep_cross_validation_predictions = TRUE)

# This is where list of cv preds are stored (one element per fold):
fit@model[["cross_validation_predictions"]]

# However you most likely want a single-column frame including all cv preds
cvpreds <- h2o.getFrame(fit@model[["cross_validation_holdout_predictions_frame_id"]][["name"]])
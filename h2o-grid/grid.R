library(h2o)

h2o.init()

# Import a sample binary outcome dataset into H2O
data <- h2o.importFile("https://s3.amazonaws.com/erin-data/higgs/higgs_train_10k.csv")
test <- h2o.importFile("https://s3.amazonaws.com/erin-data/higgs/higgs_test_5k.csv")

# Identify predictors and response
y <- "response"
x <- setdiff(names(data), y)

# For binary classification, response should be a factor
data[,y] <- as.factor(data[,y])
test[,y] <- as.factor(test[,y])

# Split data into train & validation
ss <- h2o.splitFrame(data, seed = 1)
train <- ss[[1]]
valid <- ss[[2]]

# GBM hyperparamters
gbm_params1 <- list(learn_rate = c(0.01, 0.1),
                    max_depth = c(3, 5, 9),
                    sample_rate = c(0.8, 1.0),
                    col_sample_rate = c(0.2, 0.5, 1.0))

# Train and validate a cartesian grid of GBMs
gbm_grid1 <- h2o.grid("gbm", x = x, y = y,
                      grid_id = "gbm_grid1",
                      training_frame = train,
                      validation_frame = valid,
                      ntrees = 100,
                      seed = 1,
                      hyper_params = gbm_params1)

# Get the grid results, sorted by validation AUC
gbm_gridperf1 <- h2o.getGrid(grid_id = "gbm_grid1",
                             sort_by = "auc",
                             decreasing = TRUE)
print(gbm_gridperf1)

# Grab the top GBM model, chosen by validation AUC
best_gbm1 <- h2o.getModel(gbm_gridperf1@model_ids[[1]])

# Now let's evaluate the model performance on a test set
# so we get an honest estimate of top model performance
best_gbm_perf1 <- h2o.performance(model = best_gbm1,
                                  newdata = test)
h2o.auc(best_gbm_perf1)  # 0.7781932

# Look at the hyperparamters for the best model
print(best_gbm1@model[["model_summary"]])

# Use same data as above

#Random Grid

# GBM hyperparamters (bigger grid than above)
gbm_params2 <- list(learn_rate = seq(0.01, 0.1, 0.01),
                    max_depth = seq(2, 10, 1),
                    sample_rate = seq(0.5, 1.0, 0.1),
                    col_sample_rate = seq(0.1, 1.0, 0.1))
search_criteria <- list(strategy = "RandomDiscrete", max_models = 36, seed = 1)

# Train and validate a random grid of GBMs
gbm_grid2 <- h2o.grid("gbm", x = x, y = y,
                      grid_id = "gbm_grid2",
                      training_frame = train,
                      validation_frame = valid,
                      ntrees = 100,
                      seed = 1,
                      hyper_params = gbm_params2,
                      search_criteria = search_criteria)

gbm_gridperf2 <- h2o.getGrid(grid_id = "gbm_grid2",
                             sort_by = "auc",
                             decreasing = TRUE)
print(gbm_gridperf2)

# Grab the top GBM model, chosen by validation AUC
best_gbm2 <- h2o.getModel(gbm_gridperf2@model_ids[[1]])

# Now let's evaluate the model performance on a test set
# so we get an honest estimate of top model performance
best_gbm_perf2 <- h2o.performance(model = best_gbm2,
                                  newdata = test)
h2o.auc(best_gbm_perf2)  # 0.7811332

# Look at the hyperparamters for the best model
print(best_gbm2@model[["model_summary"]])
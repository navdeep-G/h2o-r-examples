library(h2o)
h2o.init()

# Import the cars dataset.
cars <- h2o.importFile("https://s3.amazonaws.com/h2o-public-test-data/smalldata/junit/cars_20mpg.csv")

# Convert the response column to a factor
cars["economy_20mpg"] <- as.factor(cars["economy_20mpg"])

# Set the predictor names and the response column name
predictors <- c("displacement","power","weight","acceleration","year")
response <- "economy_20mpg"

# Split the data into training and validation sets, and split
# a piece off to demonstrate adding new data with checkpointing.
# In a real world scenario, however, you would not have your
# new data at this point.
cars.split <- h2o.splitFrame(data = cars,ratios = c(0.7, 0.15), seed = 1234)
train <- cars.split[[1]]
valid <- cars.split[[2]]
new_data <- cars.split[[3]]

# Build the first GBM model, specifying the model_id so you can
# indicate which model to use when you want to continue training.
# We will use 5 trees to start off with and then build an additional
# 45 trees with checkpointing.
gbm <- h2o.gbm(model_id = 'gbm',
               x = predictors,
               y = response,
               training_frame = train,
               validation_frame = valid,
               ntrees = 5,
               seed = 1234)

print(h2o.mean_per_class_error(gbm, valid=TRUE))
print(h2o.logloss(gbm, valid=TRUE))

# Checkpoint on the same dataset. This shows how to train an additional
# 45 trees on top of the first 5. To do this, set ntrees equal to 50.
gbm_continued <- h2o.gbm(model_id = 'gbm_continued',
                         x = predictors,
                         y = response,
                         training_frame = train,
                         validation_frame = valid,
                         checkpoint = 'gbm',
                         ntrees = 50,
                         seed = 1234)

print(h2o.mean_per_class_error(gbm_continued, valid=TRUE))
print(h2o.logloss(gbm_continued, valid=TRUE))
print(improvement_gbm <- h2o.logloss(gbm, valid=TRUE) - h2o.logloss(gbm_continued, valid=TRUE))

# See how the variable importance changes between the original model
# trained on 5 trees and the checkpointed model that adds 45 more trees
h2o.varimp(gbm)

# Train a GBM with cross validation (nfolds=3)
gbm_cv <- h2o.gbm(model_id = 'gbm_cv',
                  x = predictors,
                  y = response,
                  training_frame = train,
                  validation_frame = valid,
                  distribution = 'multinomial',
                  ntrees = 5,
                  nfolds = 3)

# Recall that cross validation is not supported for checkpointing.
# Add 2 more trees to the GBM without cross validation.
gbm_nocv_checkpoint = h2o.gbm(model_id = 'gbm_nocv_checkpoint',
                              x = predictors,
                              y = response,
                              training_frame = train,
                              validation_frame = valid,
                              checkpoint = 'gbm_cv',
                              distribution = 'multinomial',
                              ntrees = (5 + 2),
                              seed = 1234)

# Logloss on cross validation hold out does not change on checkpointed model
h2o.logloss(gbm_cv, xval = TRUE) == h2o.logloss(gbm_nocv_checkpoint, xval = TRUE)
True

# Logloss on training and validation data changes as more trees are added (checkpointed model)
print(h2o.logloss(gbm_cv, valid=TRUE))

# Validation Logloss for GBM with Checkpointing
print(h2o.logloss(gbm_nocv_checkpoint, valid=TRUE))
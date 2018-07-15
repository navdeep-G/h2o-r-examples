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

# Build the first DRF model, specifying the model_id so you can
# indicate which model to use when you want to continue training.
# We will use 1 tree to start off with and then build an additional
# 9 trees with checkpointing.
drf <- h2o.randomForest(model_id = 'drf',
                        x = predictors,
                        y = response,
                        training_frame = train,
                        validation_frame = valid,
                        ntrees = 1,
                        seed = 1234)

print(h2o.mean_per_class_error(drf, valid=TRUE))
print(h2o.logloss(drf, valid=TRUE))

# Checkpoint on the same dataset. This shows how to train an additional
# 9 trees on top of the first 1. To do this, set ntrees equal to 10.
drf_continued <- h2o.randomForest(model_id = 'drf_continued',
                                  x = predictors,
                                  y = response,
                                  training_frame = train,
                                  validation_frame = valid,
                                  checkpoint = 'drf',
                                  ntrees = 10,
                                  seed = 1234)

print(h2o.mean_per_class_error(drf_continued, valid=TRUE))

print(h2o.logloss(drf_continued, valid=TRUE))
print(improvement_drf <- h2o.logloss(drf, valid=TRUE) - h2o.logloss(drf_continued, valid=TRUE))

# Checkpoint on a new dataset. Notice that to train on new data,
# you set training_frame to new_data (not train) and leave the
# same dataset to use for validation.

drf_newdata <- h2o.randomForest(model_id = 'drf_newdata',
                              x = predictors,
                              y = response,
                              training_frame = new_data,
                              validation_frame = valid,
                              checkpoint = 'drf',
                              ntrees = 15,
                              seed = 1234)

print(h2o.mean_per_class_error(drf_newdata, valid=TRUE))
print(h2o.logloss(drf_newdata, valid=TRUE))
print(improvement_drf <- h2o.logloss(drf, valid=TRUE) - h2o.logloss(drf_newdata, valid=TRUE))

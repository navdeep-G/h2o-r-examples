library(h2o)
h2o.init()

# Import the mnist dataset
mnist_original <- h2o.importFile("https://s3.amazonaws.com/h2o-public-test-data/bigdata/laptop/mnist/test.csv.gz")

# The last column, C785, is the target that lists whether the
# handwritten digit was a 0,1,2,3,4,5,6,7,8, or 9. Before we
# set the variables for our predictors and target, we will
# convert our target column from type int to type enum.
mnist_original[,785] <- as.factor(mnist_original[,785])
predictors <- c(1:784)
target <- c(785)

# Split the data into training and validation sets, and split
# a piece off to demonstrate adding new data with checkpointing.
# In a real world scenario, however, you would not have your
# new data at this point.
mnist_original.split <- h2o.splitFrame(data = mnist_original,ratios = c(0.7, 0.15), seed = 1234)
train <- mnist_original.split[[1]]
valid <- mnist_original.split[[2]]
new_data <- mnist_original.split[[3]]

# Build the first deep learning model, specifying the model_id so you
# can indicate which model to use when you want to continue training.
# We will use 4 epochs to start off with and then build an additional
# 16 epochs with checkpointing.
dl <- h2o.deeplearning(model_id = 'dl',
                       x = predictors,
                       y = target,
                       training_frame = train,
                       validation_frame = valid,
                       distribution = 'multinomial',
                       epochs = 4,
                       activation = 'RectifierWithDropout',
                       hidden_dropout_ratios = c(0,0),
                       seed = 1234)

print(h2o.mean_per_class_error(dl, valid=TRUE))
print(h2o.logloss(dl, valid=TRUE))
  
# Checkpoint on the same dataset. This shows how to train an additional
# 16 epochs on top of the first 4. To do this, set epochs equal to 20 (not 16).
# This example also changes the list of hidden dropout ratios.
dl_checkpoint1 <- h2o.deeplearning(model_id = 'dl_checkpoint1',
                                   x = predictors,
                                   y = target,
                                   training_frame = train,
                                   checkpoint = 'dl',
                                   validation_frame = valid,
                                   distribution = 'multinomial',
                                   epochs = 20,
                                   activation = 'RectifierWithDropout',
                                   hidden_dropout_ratios = c(0,0.5),
                                   seed = 1234)
  
  
print(h2o.mean_per_class_error(dl_checkpoint1, valid=TRUE))
print(h2o.logloss(dl_checkpoint1, valid=TRUE))
print(improvement_dl <- h2o.logloss(dl, valid=TRUE) - h2o.logloss(dl_checkpoint1, valid=TRUE))


# Checkpoint on a new dataset. Notice that to train on new data,
# you set training_frame to new_data (not train) and leave the
# same dataset to use for validation.
dl_checkpoint2 <- h2o.deeplearning(model_id = 'dl_checkpoint2',
                                   x = predictors,
                                   y = target,
                                   training_frame = new_data,
                                   checkpoint = 'dl',
                                   validation_frame = valid,
                                   distribution = 'multinomial',
                                   epochs = 15,
                                   activation = 'RectifierWithDropout',
                                   hidden_dropout_ratios = c(0,0),
                                   seed = 1234)
  
print(h2o.mean_per_class_error(dl_checkpoint2, valid=TRUE))
print(h2o.logloss(dl_checkpoint2, valid=TRUE))
print(improvement_dl <- h2o.logloss(dl, valid=TRUE) - h2o.logloss(dl_checkpoint2, valid=TRUE))

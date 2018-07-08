#Splitting Datasets into Training/Testing/Validating
#This example shows how to split a single dataset into two datasets, one used for training and the other used for testing.

#Note that when splitting frames, H2O does not give an exact split. It’s designed to be efficient on big data 
#using a probabilistic splitting method rather than an exact split. For example, when specifying a 0.75/0.25 split, 
#H2O will produce a test/train split with an expected value of 0.75/0.25 rather than exactly 0.75/0.25. On small 
#datasets, the sizes of the resulting splits will deviate from the expected value more than on big data, where 
#they will be very close to exact.

library(h2o)
h2o.init()

# Import the prostate dataset
prostate.hex <- h2o.importFile(path = "https://raw.github.com/h2oai/h2o/master/smalldata/logreg/prostate.csv", destination_frame = "prostate.hex")
print(dim(prostate.hex))

# Split dataset giving the training dataset 75% of the data
prostate.split <- h2o.splitFrame(data=prostate.hex, ratios=0.75)
print(dim(prostate.split[[1]]))
print(dim(prostate.split[[2]]))

# Create a training set from the 1st dataset in the split
prostate.train <- prostate.split[[1]]

# Create a testing set from the 2nd dataset in the split
prostate.test <- prostate.split[[2]]

# Generate a GLM model using the training dataset. x represesnts the predictor column, and y represents the target index.
prostate.glm <- h2o.glm(y = "CAPSULE", x = c("AGE", "RACE", "PSA", "DCAPS"), training_frame=prostate.train, family="binomial", nfolds=10, alpha=0.5)

# Predict using the GLM model and the testing dataset
pred = h2o.predict(object=prostate.glm, newdata=prostate.test)

# View a summary of the prediction with a probability of TRUE
summary(pred$p1, exact_quantiles=TRUE)
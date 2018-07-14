# build the model
model <- h2o.deeplearning(params)

# save the model
model_path <- h2o.saveModel(object=model, path=getwd(), force=TRUE)

print(model_path)
#/tmp/mymodel/DeepLearning_model_R_1441838096933

# load the model
saved_model <- h2o.loadModel(model_path)
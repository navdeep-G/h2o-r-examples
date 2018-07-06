library(h2o)
iris.hex <- as.h2o(iris)
iris.gbm <- h2o.gbm(y="Species", training_frame=iris.hex, model_id="irisgbm")
h2o.download_pojo(model=iris.gbm, path="/path/to/export/to", get_genmodel_jar = TRUE)
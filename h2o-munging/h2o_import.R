library(h2o)
h2o.init()
#Uploading a File
#Unlike the import function, which is a parallelized reader, the upload function is a push from the 
#client to the server. The specified path must be a client-side path. This is not scalable and is only 
#intended for smaller data sizes. The client pushes the data from a local filesystem (for example, on your 
#machine where R or Python is running) to H2O. For big-data operations, you don’t want the data stored on or 
#flowing through the client.

#Note: When parsing a data file containing timestamps that do not include a timezone, the timestamps will be interpreted as UTC (GMT). You can override the parsing timezone using the following:
  
#R: h2o.setTimezone("America/Los Angeles")
irisPath <- "../smalldata/iris/iris_wheader.csv"
iris.hex <- h2o.uploadFile(path = irisPath, destination_frame = "iris.hex")

#Importing a File
#Unlike the upload function, which is a push from the client to the server, the import function is a 
#parallelized reader and pulls information from the server from a location specified by the client. 
#The path is a server-side path. This is a fast, scalable, highly optimized way to read data. 
#H2O pulls the data from a data store and initiates the data transfer as a read operation.

#Refer to the Supported File Formats topic to ensure that you are using a supported file type.
  
# R: h2o.setTimezone("America/Los Angeles")

# To import airlines file from H2O’s package:
irisPath <- "https://s3.amazonaws.com/h2o-airlines-unpacked/allyears2k.csv"
iris.hex <- h2o.importFile(path = irisPath, destination_frame = "iris.hex")

# To import from S3:
airlinesURL <- "https://s3.amazonaws.com/h2o-airlines-unpacked/allyears2k.csv"
airlines.hex <- h2o.importFile(path = airlinesURL, destination_frame = "airlines.hex")

# To import from HDFS, you must include the node name:
airlinesURL <- "hdfs://node-1:/user/smalldata/airlines/allyears2k_headers.zip"
airlines.hex <- h2o.importFile(path = airlinesURL, destination_frame = "airlines.hex")

#Importing Multiple Files
#The importFolder (R)/import_file (Python) function can be used to import multiple files by 
#specifying a directory and a pattern. Example patterns include:
  
#pattern="/A/.*/iris_.*": Import all files that have the pattern /A/.*/iris_.* in the specified directory.
#pattern="/A/iris_.*": Import all files that have the pattern /A/iris_.* in the specified directory.
#pattern="/A/B/iris_.*": Import all files that have the pattern /A/B/iris_.* in the specified directory.
#pattern="iris_.*": Import all files that have the pattern iris_.* in the specified directory.

# To import all .csv files from the prostate_folder directory:
prosPath <- system.file("extdata", "prostate_folder", package = "h2o")
prostate_pattern.hex <- h2o.importFolder(path = prosPath, pattern = ".*.csv", destination_frame = "prostate.hex")
class(prostate_pattern.hex)
summary(prostate_pattern.hex)
library(h2o)
h2o.init()

#Combining Columns from Two Datasets
#The cbind function allows you to combine datasets by adding columns from one dataset into another. 
#Note that when using cbind, the two datasets must have the same number of rows. In addition, if the 
#datasets contain common column names, H2O will append the joined column with 0.

# Create two simple, two-column R data frames by inputting values, ensuring that both have a common column (in this case, "fruit").
left <- data.frame(fruit = c('apple','orange','banana','lemon','strawberry','blueberry'), color = c('red','orange','yellow','yellow','red','blue'))
right <- data.frame(fruit = c('apple','orange','banana','lemon','strawberry','watermelon'), citrus = c(FALSE, TRUE, FALSE, TRUE, FALSE, FALSE))

# Create the H2O data frames from the inputted data.
l.hex <- as.h2o(left)
print(l.hex)

r.hex <- as.h2o(right)
print(r.hex)

# Combine the l.hex and r.hex datasets into a single dataset.
#The columns from r.hex will be appended to the right side of the final dataset. In addition, 
#because both datasets include a "fruit" column, H2O will append the second "fruit" column name with "0".
#Note that this is different than ``merge``, which combines data from two commonly named columns in two datasets.
columns.hex <- h2o.cbind(l.hex, r.hex)
print(columns.hex)

#Combining Rows from Two Datasets
#You can use the rbind function to combine two similar datasets into a single large dataset. 
#This can be used, for example, to create a larger dataset by combining data from a validation dataset 
#with its training or testing dataset.

# Note that when using rbind, the two datasets must have the same set of columns.
# Import an existing training dataset
ecg1Path <- "http://h2o-public-test-data.s3.amazonaws.com/smalldata/anomaly/ecg_discord_train.csv"
ecg1.hex <- h2o.importFile(path=ecg1Path, destination_frame="ecg1.hex")
print(dim(ecg1.hex))

# Import an existing testing dataset
ecg2Path <- "http://h2o-public-test-data.s3.amazonaws.com/smalldata/anomaly/ecg_discord_test.csv"
ecg2.hex <- h2o.importFile(path=ecg2Path, destination_frame="ecg2.hex")
print(dim(ecg2.hex))

# Combine the two datasets into a single, larger dataset
ecgCombine.hex <- h2o.rbind(ecg1.hex, ecg2.hex)
print(dim(ecgCombine.hex))
#Slicing Columns/Rows
#H2O lazily slices out columns/rows of data and will only materialize a shared copy upon some type 
#of triggering IO. This example shows how to slice columns from a frame of data.

#Slicing columns
library(h2o)
h2o.init()
path <- "http://h2o-public-test-data.s3.amazonaws.com/smalldata/iris/iris_wheader.csv"
df <- h2o.importFile(path)
print(df)

# slice 1 column by index
c1 <- df[,1]
print(c1)

# slice 1 column by name
c1_1 <- df[, "petal_len"]
print(c1_1)

# slice cols by vector of indexes
cols <- df[, 1:4]
print(cols)

# slice cols by vector of names
cols_1 <- df[, c("sepal_len", "sepal_wid", "petal_len", "petal_wid")]
print(cols_1)

#Slicing rows
path <- "http://h2o-public-test-data.s3.amazonaws.com/smalldata/iris/iris_wheader.csv"
df <- h2o.importFile(path)

# Slice 1 row by index.
c1 <- df[15,]
print(c1)

# Slice a range of rows.
c1_1 <- df[25:49,]
print(c1_1)

# Slice using a boolean mask. The output dataset will include rows with a sepal length less than 4.6.
mask <- df[,"sepal_len"] < 4.6
cols <- df[mask,]
print(cols)

# Filter out rows that contain missing values in a column. Note the use of '!' to perform a logical not.
mask <- is.na(df[,"sepal_len"])
cols <- df[!mask,]
print(cols)
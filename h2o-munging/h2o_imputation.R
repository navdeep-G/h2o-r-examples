library(h2o)
h2o.init()
#Fill NAs
#Use this function to fill in NA values in a sequential manner up to a specified limit. 
#When using this function, you will specify whether the method to fill the NAs should go forward 
#(default) or backward , whether the NAs should be filled along rows (default) or columns, and the 
#maximum number of consecutive NAs to fill (defaults to 1).

# Create a random data frame with 6 rows and 2 columns.
# Specify that no more than 70% of the values are NAs.
fr.with.nas = h2o.createFrame(categorical_fraction=0.0,
                              missing_fraction=0.7,
                              rows=6,
                              cols=2,
                              seed=123)
fr.with.nas

# Forward fill a row. In R, the values for axis are 1 (row-wise) and 2 (column-wise)
fr <- h2o.fillna(fr.with.nas, "forward", axis=1, maxlen=1L)
fr

#Imputing Data
#The impute function allows you to perform in-place imputation by filling missing values with aggregates 
#computed on the “na.rm’d” vector. Additionally, you can also perform imputation based on groupings of 
#columns from within the dataset. These columns can be passed by index or by column name to the by parameter. 
#Note that if a factor column is supplied, then the method must be mode.

#Upload the Airlines dataset
filePath <- "https://s3.amazonaws.com/h2o-airlines-unpacked/allyears2k.csv"
air <- h2o.importFile(filePath, "air")
print(dim(air))


#Show the number of rows with NA.
print(numNAs <- sum(is.na(air$DepTime)))

DepTime_mean <- mean(air$DepTime, na.rm = TRUE)
print(DepTime_mean)

#Mean impute the DepTime column
h2o.impute(air, "DepTime", method = "mean")

#Revert the imputations
air <- h2o.importFile(filePath, "air")

#Impute the column using a grouping based on the Origin and Distance
#If the Origin and Distance produce groupings of NAs, then no imputation will be done (NAs will result).
h2o.impute(air, "DepTime", method = "mean", by = c("Dest"))

#Revert the imputations
air <- h2o.importFile(filePath, "air")

#Impute a factor column by the most common factor in that column
h2o.impute(air, "TailNum", method = "mode")

#Revert imputations
air <- h2o.importFile(filePath, "air")

#Impute a factor column using a grouping based on the Month
h2o.impute(air, "TailNum", method = "mode", by=c("Month"))

#Replacing Values in a Frame
#This example shows how to replace numeric values in a frame of data.
# Note that it is currently not possible to replace categorical value in a column

#Upload the iris dataset
path <- "http://h2o-public-test-data.s3.amazonaws.com/smalldata/iris/iris_wheader.csv"
df <- h2o.importFile(path)

#Replace a single numerical datum. Note that columns and rows start at 0,
#so in the example below, the value in the 15th row and 3rd column will be set to 2.0.
df[14,2] <- 2.0

#Replace a whole column. The example below multiplies all values in the second column by 3.
df[,1] <- 3*df[,1]

#Replace by row mask. The example below searches for value less than 4.4 in the
#sepal_len column and replaces those values with 4.6.
df[df[,"sepal_len"] <- 4.6, "sepal_len"] <- 4.6

#Replace using ifelse. Similar to the previous example,
#this replaces values less than 4.6 with 4.6.
df[,"sepal_len"] <- h2o.ifelse(df[,"sepal_len"] < 4.4, 4.6, df[,"sepal_len"])

#Replace missing values with 0
df[is.na(df[,"sepal_len"]), "sepal_len"] <- 0

#Alternative with ifelse
df[,"sepal_len"] <- h2o.ifelse(is.na(df[,"sepal_len"]), 0, df[,"sepal_len"]



#Sorting Columns
#Use the arrange function in R to create a new frame that is sorted by column(s) in ascending (default) or 
#descending order. Note that when using sort, the original frame cannot contain any string columns.

#If only one column is specified in the sort, then the final results are sorted according to that one single 
#column either in ascending (default) or in descending order. However, if you specify more than one column in 
#the sort, then H2O performs as described below:
  
#  Assuming two columns, X (first column) and Y (second column):
  
#  H2O will sort on the first specified column, so in the case of [0,1], the X column will be sorted first. Similarly, in the case of [1,0], the Y column will be sorted first.
#H2O will sort on subsequent columns in the order they are specified, but only on those rows that have the same values as the first sorted column. No sorting will be done on subsequent columns if the values are not also duplicated in the first sorted column.

# Currently, this function only supports `all.x = TRUE`. All other permutations will fail.
library(h2o)
h2o.init()

# Import the smallIntFloats dataset
X <- h2o.importFile("https://s3.amazonaws.com/h2o-public-test-data/smalldata/synthetic/smallIntFloats.csv.zip")
X

# Sort on the first column only in ascending order (default)
X_sorted1 <- h2o.arrange(X,C1)
X_sorted1

# Sort on both columns in descending order, specifying to sort on C1 first
X_sorted2 <- h2o.arrange(X, desc(C1),desc(C10))
X_sorted2

# Sort on the second column in descending order
X_sorted3 <- h2o.arrange(X, desc(C10))
X_sorted3
#Pivoting Tables
#Use this function to pivot tables. This is performed by designating three columns: index, column, and value. 
#Index is the column where pivoted rows should be aligned on; column represents the column to pivot; and value
# specifies the values of the pivoted table. For cases with multiple indexes for a column label, the aggregation 
# method is to pick the first occurrence in the data frame.

library(h2o)
h2o.init()

# Create a simple data frame by inputting values
data <- data.frame(colorID = c('1','2','3','3','1','4'),
                   value = c('red','orange','yellow','yellow','red','blue'),
                   amount = c('4','2','4','3','6','3'))
df <- as.h2o(data)

# View the dataset
df

# Pivot the table on the colorID column and aligned on the amount column
df2 <- h2o.pivot(df,index="amount",column="colorID",value="value")
df2
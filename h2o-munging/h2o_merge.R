#Merging Two Datasets
#You can use the merge function to combine two datasets that share a common column name. By default, all columns 
#in common are used as the merge key; uncommon will be ignored. Also, if you want to use only a subset of the columns 
#in common, rename the other columns so the columns are unique in the merged result.

#Note that in order for a merge to work in multinode clusters, one of the datasets must be small enough to exist 
#in every node.

# Currently, this function only supports `all.x = TRUE`. All other permutations will fail.
library(h2o)
h2o.init()

# Create two simple, two-column R data frames by inputting values, ensuring that both have a common column (in this case, "fruit").
left <- data.frame(fruit = c('apple','orange','banana','lemon','strawberry','blueberry'), color = c('red','orange','yellow','yellow','red','blue'))
right <- data.frame(fruit = c('apple','orange','banana','lemon','strawberry','watermelon'), citrus = c(FALSE, TRUE, FALSE, TRUE, FALSE, FALSE))

# Create the H2O data frames from the inputted data.
l.hex <- as.h2o(left)
print(l.hex)

r.hex <- as.h2o(right)
print(r.hex)

# Merge the data frames. The result is a single dataset with three columns.
left.hex <- h2o.merge(l.hex, r.hex, all.x = TRUE)
print(left.hex)
#Group By
#The group_by function allows you to group one or more columns and apply a function to the result. Specifically, 
#the group_by function performs the following actions on an H2O Frame:
    #splits the data into groups based on some criteria
    #applies a function to each group independently
    #combines the results into an H2OFrame
#The result is a new H2OFrame with columns equivalent to the number of groups created. The returned groups are sorted by the natural group-by column sort.

#The group_by function accepts the following parameters:

#H2O Frame: This specifies the H2OFrame that you want the group by operation to be performed on.
#by: The by option can take a list of columns if you want to group by more than one column to compute the summary.
#gb.control: In R, the gb.control option specifies how to handle NA values in the dataset as well as how to name output columns. Note that to specify a list of column names in the gb.control list, you must add the col.names argument.
#nrow: Specify the name of the generated column.
#na.methods, which controls treatment of NA values during the calculation. It can be one of:
#  all (default): any NAs are used in the calculation as-is; which usually results in the final result being NA too.
#ignore: NA entries are not included in calculations, but the total number of entries is taken as the total number of rows. For example, mean([1, 2, 3, nan], na="ignore") will produce 1.5.
#rm: entries are skipped during the calculations, reducing the total effective count of entries. For example, mean([1, 2, 3, nan], na="rm") will produce 2.
#Note: If a list smaller than the number of columns groups is supplied, then the list will be padded by ignore.

#In addition to the above parameters, any number of the following aggregations can be chained together in the group_by function:
  
#count: Count the number of rows in each group of a GroupBy object.
#max: Calculate the maximum of each column specified in col for each group of a GroupBy object.
#mean: Calculate the mean of each column specified in col for each group of a GroupBy object.
#min: Calculate the minimum of each column specified in col for each group of a GroupBy object.
#mode: Calculate the mode of each column specified in col for each group of a GroupBy object.
#sd: Calculate the standard deviation of each column specified in col for each group of a GroupBy object.
#ss: Calculate the sum of squares of each column specified in col for each group of a GroupBy object.
#sum: Calculate the sum of each column specified in col for each group of a GroupBy object.
#var: Calculate the variance of each column specified in col for each group of a GroupBy object.
#If no arguments are given to the aggregation (e.g., max() in grouped.sum(col="X1", na="all").mean(col="X5", na="all").max()), then it is assumed that the aggregation should apply to all columns except the GroupBy columns.
#Note that once the aggregation operations are complete, calling the GroupBy object with a new set of 
#aggregations will yield no effect. You must generate a new GroupBy object in order to apply a new aggregation 
#on it. In addition, certain aggregations are only defined for numerical or categorical columns. An error will 
#be thrown for calling aggregation on the wrong data types.

library(h2o)
h2o.init()

# Import the airlines data set and display a summary.
airlinesURL <- "https://s3.amazonaws.com/h2o-airlines-unpacked/allyears2k.csv"
airlines.hex <- h2o.importFile(path = airlinesURL, destination_frame = "airlines.hex")
summary(airlines.hex)

# Find number of flights by airport
originFlights <- h2o.group_by(data = airlines.hex, by = "Origin", nrow("Origin"), gb.control=list(na.methods="rm"))
originFlights.R <- as.data.frame(originFlights)
originFlights.R

# Find number of flights per month
flightsByMonth <- h2o.group_by(data = airlines.hex, by = "Month", nrow("Month"), gb.control=list(na.methods="rm"))
flightsByMonth.R <- as.data.frame(flightsByMonth)
flightsByMonth.R

# Find the number of flights in a given month based on the origin
cols <- c("Origin","Month")
flightsByOriginMonth <- h2o.group_by(data=airlines.hex, by=cols, nrow("NumberOfFlights"), gb.control=list(na.methods="rm"))
flightsByOriginMonth.R <- as.data.frame(flightsByOriginMonth)
flightsByOriginMonth.R

# Find months with the highest cancellation ratio
which(colnames(airlines.hex)=="Cancelled")
cancellationsByMonth <- h2o.group_by(data = airlines.hex, by = "Month", sum("Cancelled"), gb.control=list(na.methods="rm"))
cancellation_rate <- cancellationsByMonth$sum_Cancelled/flightsByMonth$nrow_Month
rates_table <- h2o.cbind(flightsByMonth$Month,cancellation_rate)
rates_table.R <- as.data.frame(rates_table)
rates_table.R

# Use group_by with multiple columns. Summarize the destination, arrival delays, and departure delays for an origin
cols <- c("Dest", "IsArrDelayed", "IsDepDelayed")
originFlights <- h2o.group_by(data = airlines.hex[c("Origin",cols)], by = "Origin", sum(cols),gb.control = list(na.methods = "ignore", col.names = NULL))
# Note a warning because col.names null
res <- h2o.cbind(lapply(cols, function(x){h2o.group_by(airlines.hex,by="Origin",sum(x))}))[,c(1,2,4,6)]
res
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
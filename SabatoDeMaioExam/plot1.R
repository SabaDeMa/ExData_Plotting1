# This part is the same for all plot[i].R
# Packages
library(lubridate)
library(dplyr)
# Code
data <- read.table("household_power_consumption.txt",
                   sep = ";",
                   header = TRUE,
                   stringsAsFactors = FALSE)
data1 <- tbl_df(data)
names <- c("Date", "Time", "GAP", "GRP", "Volt", "GI", "SubM1", "SubM2", "SubM3")
colnames(data1) <- names
data1$Date <- paste(data1$Date, data1$Time)
data1 <- select(data1, -Time)
data1$Date <- dmy_hms( data1$Date)

data2 <- na.omit(
				filter(data1, Date > as.POSIXct("2007-01-31 24:00:00", tz = "UTC" ),
					   Date <= as.POSIXct("2007-02-03 00:00:00", tz = "UTC") )
					   )

data2[ , 2:8] <- apply(data2[,2:8], 2, function(x) as.numeric(as.character(x)))

# PLOT 1
png("plot1.png", height = 480, width = 480, units = "px")
par (mar = c(5,5,5,2))

hist(data2$GAP,
		col = "Red",
		xlab = "Global Active Power (Kilowatts)",
		ylab = "Frequency",
		main= "Global Active Power")

dev.off()

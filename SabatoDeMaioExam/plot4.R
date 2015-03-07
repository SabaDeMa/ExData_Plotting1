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
				filter(data1,
				Date > as.POSIXct("2007-01-31 24:00:00", tz = "UTC" ),
				Date <= as.POSIXct("2007-02-03 00:00:00", tz = "UTC")
					)
				)

data2[ , 2:8] <- apply(data2[,2:8], 2, function(x) as.numeric(as.character(x)))

# Set figures
png("plot4.png", height = 480, width = 480, units = "px")
par( mfcol=c(2,2) )

# 1
plot(data2$GAP,
     type = "l",
     xlab = "",
     col = "Black",
     ylab = "Global Active Power (Kilowatts)",
     xaxt = "n",
     cex.lab = 0.7
)

days <- c(	weekdays(data2$Date[1], abbreviate = TRUE),
			weekdays(data2$Date[nrow(data2)/2], abbreviate = TRUE),
			weekdays(data2$Date[nrow(data2)], abbreviate = TRUE)
			)

axis( 1,  at = c(1, nrow(data2)/2 , nrow(data2)) , labels = days )

# 2

plot(data2$SubM1,   col = "Black",
                    type = "l",
                    ylab = "Energy sub metering",
                    xaxt = "n",
                    xlab = "",
                    main= "",
                    cex.lab = 0.8)

lines(data2$SubM2, col = "Red")
lines(data2$SubM3, col = "Blue")
legelem <- c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3")

legend(       "topright",
              legelem,
              lty = 1,
              lwd = 1.5,
              col = c("Black","Red", "Blue"),
              cex = 0.8,
              bty = "n"
              )

axis( 1,  at = c(1, nrow(data2)/2 , nrow(data2)) , labels = days )

# 3

plot(		data2$Volt,
			type = "l",
			ylab = "Voltage",
			cex.lab = 0.8,
			xlab = "datetime",
     		xaxt = "n",)
axis( 1,  at = c(1, nrow(data2)/2 , nrow(data2)) , labels = days )

# 4

plot(		data2$GRP,
			type = "l",
			ylab = "Global_Reactive_Power",
			cex.lab = 0.8,
     		xaxt = "n",
     		xlab = "datetime")
axis( 1,  at = c(1, nrow(data2)/2 , nrow(data2)) , labels = days )
     
     
dev.off()


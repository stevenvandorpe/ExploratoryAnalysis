## Load sample data
#data <- read.table("sample.csv", sep=";", header=T)

##Load actual data
data <- read.table("actualdata.csv", sep=";", header=T)

##Rename some columns
library(dplyr);
data <- rename(data, sub2= Sub_metering_2, sub3 = Sub_metering_3)
data <- rename(data, sub1= Sub_metering_1)

## Handling missing values
data[data == '?'] <- NA

##Make a new col with data +time combined
data$datetime <- as.POSIXct(paste(data$Date, data$Time), format="%d/%m/%Y %H:%M:%S")

##Draw graphs
par(mfrow=c(2,2))
hist(data$Global_active_power, col='red')
plot(data$datetime, data$Global_active_power, type="n")                
lines(data$datetime, data$Global_active_power)
plot(data$datetime, data$sub1, type="n")                
lines(data$datetime, data$sub1, col='green')
lines(data$datetime, data$sub2, col='blue')
lines(data$datetime, data$sub3, col='orange')
plot(data$datetime, data$Global_reactive_power, type="n")                
lines(data$datetime, data$Global_reactive_power)

##Write png file
dev.copy(png,file='finaloutput.png'); dev.off()

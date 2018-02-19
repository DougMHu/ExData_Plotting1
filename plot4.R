# Download dataset from UCI Machine Learning Repository if haven't already
if (!file.exists('../datasets')) {
	dir.create('../datasets')
}
if (!file.exists('../datasets/household-power-consumption.zip')) {
	fileURL <- "https://archive.ics.uci.edu/ml/machine-learning-databases/00235/household_power_consumption.zip"
	download.file(fileURL, destfile='../datasets/household-power-consumption.zip')#, method='curl')
	list.files('../datasets')
	dateDownloaded <- date()
}

# Extract zip file if haven't already
if (!file.exists('../datasets/household-power-consumption')) {
	extractedFile <- unzip('../datasets/household-power-consumption.zip', exdir='../datasets/household-power-consumption')
} else {
	extractedFile <- '../datasets/household-power-consumption/household_power_consumption.txt'
}

# Parse text file and only read data from 2007-02-01 to 2007-02-02
header <- read.table(extractedFile, nrows=1, sep=';', header=FALSE, stringsAsFactors=FALSE)
powerData <- read.table(extractedFile, skip=66636, nrows=2880, sep=';', header=TRUE, na.strings='?')
colnames(powerData) <- unlist(header)
powerData$Date = as.Date(powerData$Date, format='%d/%m/%Y')
powerData$Datetime <- as.POSIXct(paste(powerData$Date, powerData$Time), format="%Y-%m-%d %H:%M:%S")
# head(powerData)
# tail(powerData)
# typeof(powerData$Datetime)

# Setup a grid of plots
png(file='plot4.png')
par(mfcol=c(2,2))#, mar=c(4,4,4,1))

# Plot a time series of Global Active Power
plot(powerData$Datetime, powerData$Global_active_power, type='l', xlab='', ylab='Global Active Power')

# Plot a time series of sub meter values, including legend
with(powerData, {
	plot(Datetime, Sub_metering_1, type='l', xlab='', ylab='Energy sub metering', col='black')
	lines(Datetime, Sub_metering_2, type='l', xlab='', ylab='Energy sub metering', col='red')
	lines(Datetime, Sub_metering_3, type='l', xlab='', ylab='Energy sub metering', col='blue')
	legend('topright', lty = c(1, 1, 1), col=c('black', 'red', 'blue'), legend=c('Sub_metering_1', 'Sub_metering_2', 'Sub_metering_3'), bty='n')
	})

# Plot a time series of Voltage
with (powerData, {
	plot(Datetime, Voltage, type='l', xlab='datetime', ylab='Voltage')
	})

# Plot a time series of Global Reactive Power
with (powerData, {
	plot(Datetime, Global_reactive_power, type='l', xlab='datetime')
	})

dev.off()

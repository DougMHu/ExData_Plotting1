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

# Plot a histogram
png(file='plot1.png')
hist(powerData$Global_active_power, main='Global Active Power', xlab='Global Active Power (kilowatts)', col='red')
dev.off()

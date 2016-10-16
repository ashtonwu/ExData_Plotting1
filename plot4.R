#Author: Ashton Wu
#Date: 2016-10-16
#Desc: Downloads the data set on Electric power consumption from the UCI Machine Learning Repository.
# The data is then used to create a plot.

###################################
#This section reads the data into a data frame called "hpc". It is exactly the same for plot1 to plot4.

library(downloader)

#Check if data set files exist. If not, download and unzip them into /UCI HAR Dataset
if(!file.exists("./UCI EPC Dataset.zip")){
  fileUrl = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download(fileUrl, dest="UCI EPC Dataset.zip", mode="wb")
  unzip("UCI EPC Dataset.zip")
}

#Read txt file as lines to only pull the required data of interest
con = file("household_power_consumption.txt",open="r")
line = readLines(con)
#Only interested in data from 2007-02-01 to 2007-02-02
subset = line[grep("^(1|2)/2/2007;",line)]
#Read subset data as data frame
hpc = read.table(textConnection(subset), sep=";", na.strings="?")
#Set column names to the original column names in the txt file
colnames(hpc) = unlist(strsplit(line[1],";"))
#Convert Date and Time variables to one Date/Time column
hpc$datetime = strptime(paste(hpc$Date, hpc$Time), "%d/%m/%Y %H:%M:%S")
#close connection
close(con)

###################################


#Open PNG graphics device for plot4
png(width=480, height=480, file="plot4.png")

#Final image will be a 2x2 set of 4 graphs
par(mfrow=c(2,2))

#Create all four graphs from the hpc data frame
with(hpc, {
  
  #First graph - Global Active Power line graph
  plot(datetime, Global_active_power, type="l", xlab="", ylab="Global Active Power")
  
  #Second graph - Voltage line graph
  plot(datetime, Voltage, type="l")
  
  #Third graph - Same as plot3, 3 line graphs of the energy sub metereing values
  plot(datetime, Sub_metering_1, type="l", xlab="", ylab="Energy sub metering")
  lines(datetime, Sub_metering_2, col="red")
  lines(datetime, Sub_metering_3, col="blue")
  legend("topright", lty=c(1,1,1), col=c("black","red","blue"), legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), bty="n")
  
  #Fourth graph - Global Reactive Power line graph
  plot(datetime, Global_reactive_power, type="l")
}
)

#Close device
dev.off()

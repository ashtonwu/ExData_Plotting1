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

#Open PNG graphics device for plot3
png(width=480, height=480, file="plot3.png")

#Create 3 line graphs of the energy sub metering values on the same plot
with(hpc, {
  #Create initial plot with proper x any y labels, along with the line graph of sub_metering_1
  plot(datetime, Sub_metering_1, type="l", xlab="", ylab="Energy sub metering")
  #Create the second line graph as the colour red
  lines(datetime, Sub_metering_2, col="red")
  #Create the third line graph as the colour blue
  lines(datetime, Sub_metering_3, col="blue")
  #Create the legend at the topright of the graph
  legend("topright", lty=c(1,1,1), col=c("black","red","blue"), legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
}
)

#Close device
dev.off()

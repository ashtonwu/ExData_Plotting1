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

#Open PNG graphics device for plot2
png(width=480, height=480, file="plot2.png")

#Create time-series line graph of Global Active Power
plot(hpc$datetime #x values
     , hpc$Global_active_power #y values
     , type="l" #Line graph
     , xlab="" #Remove x-axis label
     , ylab="Global Active Power (kilowatts)" #Set y-axis label
)
#Close device
dev.off()

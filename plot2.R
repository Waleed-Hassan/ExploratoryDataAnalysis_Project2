# Load the package
options(gsubfn.engine = "R")
library(sqldf)

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
 
SCC <- readRDS("Source_Classification_Code.rds")

colnames(NEI)
head(NEI)
 
# Use the NEI data set

result <- sqldf("select year, sum(Emissions) TotalEmission from NEI  where fips = '24510' group by year")


# Prepare output PNG file
png(filename= "Plot2.png", height= 480, width= 480)

plot(result$year ,result$TotalEmission,  type = "n" ,
     ylab   = "Total PM2.5 Emission in the Baltimore City, Maryland ",
     xlab   = "Year" )
lines(result$year ,result$TotalEmission, type="l" , col = "black") 
legend("topright", lty=c(1,1,1) ,
       lwd=c(2.5,2.5,2.5),
       col = "black" ,
       xjust = 1,  legend = "total PM2.5 Emission")

# Close file
dev.off()
 

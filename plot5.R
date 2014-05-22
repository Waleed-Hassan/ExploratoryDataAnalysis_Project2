# Load the package
options(gsubfn.engine = "R")
library(sqldf)
library(ggplot2)
## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
   
#Subset only vehicle related entries of SCC data frame
#Vectorize only the   levels with SCC numbers related to vehicle
SCC_vehicle <- SCC[(grepl("vehicle", SCC$SCC.Level.Three, ignore.case=TRUE) | 
                      grepl("motor", SCC$SCC.Level.Three, ignore.case=TRUE)),]
  
#Subset NEI based on SCC numbers related to vehicle and drop unused levels
NEI_vehicle <- subset(NEI, SCC %in% SCC_vehicle$SCC)

# Use the NEI data set
result <- sqldf("select year , sum(Emissions) TotalEmission from NEI_vehicle  where fips = '24510' group by year")
png(filename= "Plot5.png", height= 480, width= 780)

qplot(year , TotalEmission , data =result) + geom_smooth()
 

# Close file
dev.off()

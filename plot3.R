# Load the package
options(gsubfn.engine = "R")
library(sqldf)

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
 
SCC <- readRDS("Source_Classification_Code.rds")

colnames(NEI)
head(NEI)
 
# Use the NEI data set

result <- sqldf("select year, type , sum(Emissions) TotalEmission from NEI  where fips = '24510' group by year , type order by type , year")
png(filename= "Plot3.png", height= 480, width= 780)

qplot(year , TotalEmission , data =result  ,facets =.~type, binwidth = 2) + geom_smooth()
 

# Close file
dev.off()

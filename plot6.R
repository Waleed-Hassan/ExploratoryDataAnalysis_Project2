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

#get all years
years <- sqldf("select DISTINCT  year from NEI group by year order by year ")
 
#get cumulative and Delta Emission per year
CumulativeResultBaltimore = data.frame(year = integer(), TotalEmission = numeric())
CumulativeResultLosAngeles = data.frame(year = integer(), TotalEmission = numeric())
 
TotalEmissionBaltimore <- 0
TotalEmissionLosAngeles <- 0

for(i in years$year)
{
  query <- paste("select year , sum(Emissions) TotalEmission from NEI_vehicle  where fips = '24510' and year == ", as.character(i),sep='')
  tempResult <- sqldf(query)
  TotalEmissionBaltimore <- TotalEmissionBaltimore+ tempResult$TotalEmission
  tempResult[1,2] <- TotalEmissionBaltimore
  CumulativeResultBaltimore <- rbind(CumulativeResultBaltimore, tempResult[1,])
 
  query <- paste("select year , sum(Emissions) TotalEmission from NEI_vehicle  where fips = '06037' and year == ", as.character(i),sep='')
  tempResult <- sqldf(query)
  TotalEmissionLosAngeles <- TotalEmissionLosAngeles+ tempResult$TotalEmission
  tempResult[1,2] <- TotalEmissionLosAngeles
  CumulativeResultLosAngeles <- rbind(CumulativeResultLosAngeles, tempResult[1,])  
}
 
CumulativeResultBaltimore$City <- "Baltimore"
CumulativeResultLosAngeles$City <- "LosAngeles"

CumulativeResult  <- rbind(CumulativeResultBaltimore, CumulativeResultLosAngeles)  
 


png(filename= "Plot6.png", height= 480, width= 780)

qplot(year , TotalEmission , data =CumulativeResult ,facets =.~City , ylab="Cumulative Emission per year") + geom_smooth()

# Close file
dev.off()

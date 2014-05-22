# Load the package
options(gsubfn.engine = "R")
library(sqldf)
library(ggplot2)
## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
 
SCC <- readRDS("Source_Classification_Code.rds")

colnames(NEI)
head(NEI)
  
#Subset only coal related entries of SCC data frame
#Vectorize only the   levels with SCC numbers related to combustion (coal or Lignite)
SCC_coal_comb <- SCC[grepl("combustion", SCC$SCC.Level.One, ignore.case=TRUE) &
                         (grepl("coal", SCC$SCC.Level.Three, ignore.case=TRUE) | 
                          grepl("lignite", SCC$SCC.Level.Three, ignore.case=TRUE)),]
#Subset NEI based on SCC numbers related to coal or Lignite and drop unused levels
NEI_coal_comb <- subset(NEI, SCC %in% SCC_coal_comb$SCC)

# Use the NEI data set
result <- sqldf("select year , sum(Emissions) TotalEmission from NEI_coal_comb group by year")
png(filename= "Plot4.png", height= 480, width= 780)

qplot(year , TotalEmission , data =result) + geom_smooth()
 

# Close file
dev.off()

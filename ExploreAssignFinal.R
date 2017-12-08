## 0. Read data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## 0.1 Set print device
par(mfrow=c(4,1))

## 1. Total Emission
library(dplyr)
totem <- group_by(NEI, year)
totem <- summarise(totem, Emmision = sum(Emissions))
plot(totem$year, totem$Emmision)
lines(totem$year, totem$Emmision)

## 2. Total Emmision Baltimore
totba <- filter(NEI, fips == "24510")
totba <- group_by(totba, year)
totba <- summarise(totba, Emmision = sum(Emissions))
plot(totba$year, totba$Emmision)
lines(totba$year, totba$Emmision)

## 3. Baltimore per type
library(ggplot2)
baty <- filter(NEI, fips == "24510")
baty <- group_by(baty, year, type)
baty <- summarise(baty, Emission = sum(Emissions))
 ## Check class of type | print(str(baty$type)) | str(as.factor(baty$type))
batyplot <- qplot(baty$year, baty$Emission, data = baty, color = baty$type, geom=c('point','smooth'))
bayplot

##Write png file
dev.copy(png,file='BaltimorePerType.png'); dev.off()

## 4. Coal Combustion Emmission
 ## names(SCC)
coal <- filter(SCC, EI.Sector == 'Fuel Comb - Comm/Institutional - Coal'| SCC.Level.One == 'External Combustion Boilers' )
listcoal <- coal$SCC
SCCcoal <- filter(NEI, SCC %in% listcoal)
SCCcoal <- group_by(SCCcoal, year)
SCCcoal <- summarise(SCCcoal, Emissions = sum(Emissions))
plot(SCCcoal$year, SCCcoal$Emissions)
lines(SCCcoal$year, SCCcoal$Emissions)

## 5. Motor Vehicle Emission Baltimore vs California
motor <- filter(SCC,SCC.Level.Three == 'Motor Vehicles: SIC 371'| SCC.Level.Three == 'Motor Vehicle Fires' | SCC.Level.Three == 'Motorcycles (MC)')
listmotor <- motor$SCC
SCCmotorbal <- filter(NEI, SCC %in% listmotor & fips == "24510" )
SCCmotorbal <- group_by(SCCmotorbal, year)
SCCmotorbal <- summarise(SCCmotorbal, Emissions = sum(Emissions))
SCCmotorcal <- filter(NEI, SCC %in% listmotor & fips == "06037" )
SCCmotorcal <- group_by(SCCmotorcal, year)
SCCmotorcal <- summarise(SCCmotorcal, Emissions = sum(Emissions))
plot(SCCmotorcal$year, SCCmotorcal$Emissions, type = 'n', ylim = c(0,150))
lines(SCCmotorbal$year, SCCmotorbal$Emissions, col='blue')
lines(SCCmotorcal$year, SCCmotorcal$Emissions, col='red')
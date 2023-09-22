library(odbc)
library(DBI)
library(tidyverse)
library(lubridate)
library(readr)

#Read CSV files 
BOROUGH <- read_csv("BOROUGH.csv")
BUILDING_CLASS <- read_csv("BUILDING_CLASS.csv")
NEIGHBORHOOD <- read_csv("NEIGHBORHOOD.csv")
NYC_TRANSACTION_DATA <- read_csv("NYC_TRANSACTION_DATA.csv")

#Analyze my neighborhood FLUSHING-NORTH
#Summary 1: Average Price Per Square Foot with original data
df<-NYC_TRANSACTION_DATA %>%
  left_join(NEIGHBORHOOD,by="NEIGHBORHOOD_ID")%>%
  left_join(BOROUGH,by="BOROUGH_ID")%>%
  left_join(BUILDING_CLASS,by=c("BUILDING_CLASS_FINAL_ROLL"="BUILDING_CODE_ID"))%>%
  mutate(YEAR=year(SALE_DATE))%>%
  select(GROSS_SQUARE_FEET,SALE_PRICE,NEIGHBORHOOD_NAME,BOROUGH_NAME,YEAR,TYPE)%>%
  filter(NEIGHBORHOOD_NAME=="FLUSHING-NORTH",TYPE=="RESIDENTIAL")%>%
  group_by(YEAR)
summary1<-summarise(df,AVG_PRICEpersqft_NF=sum(SALE_PRICE)/sum(GROSS_SQUARE_FEET))

#Same excercise for neighborhood Astoria and DOUGLASTON

#Comparison for Average Price Per Square Foot among 3 neighborhoods
comparison <- merge(summary2, summary4, by = "YEAR")%>%
  merge(summary6, by = "YEAR")

#Plot for 3 neighborhoods - Average Price Per Square Foot 
ggplot()+geom_line(data=summary2,size=1,aes(x=YEAR,y=AVG_PRICEpersqft_NF,color="red"))+
  geom_line(data=summary4,size=1,aes(x=YEAR,y=AVG_PRICEpersqft_AS,color="blue"))+
  geom_line(data=summary6,size=1,aes(x=YEAR,y=AVG_PRICEpersqft_DO,color="yellow"))+
  scale_color_discrete(name="Neighborhood",labels=c("FLUSHING-NORTH","ASTORIA","DOUGLASTON"))+
  ggtitle("Average Price Per Square Foot") +
  xlab("Year") + ylab("AVG_PRICEpersqft")

BOROUGH <- read_csv("BOROUGH.csv")
BUILDING_CLASS <- read_csv("BUILDING_CLASS.csv")
NEIGHBORHOOD <- read_csv("NEIGHBORHOOD.csv")
NYC_TRANSACTION_DATA <- read_csv("NYC_TRANSACTION_DATA.csv")

#cleaned df for analysis 
df<-NYC_TRANSACTION_DATA %>%
  left_join(NEIGHBORHOOD,by="NEIGHBORHOOD_ID")%>%
  left_join(BOROUGH,by="BOROUGH_ID")%>%
  left_join(BUILDING_CLASS,by=c("BUILDING_CLASS_FINAL_ROLL"="BUILDING_CODE_ID"))%>%
  mutate(YEAR=year(SALE_DATE))%>%
  select(GROSS_SQUARE_FEET,SALE_PRICE, SALE_ID, NEIGHBORHOOD_NAME,BOROUGH_NAME,YEAR,TYPE,RESIDENTIAL_UNITS,COMMERCIAL_UNITS)%>%
  filter(GROSS_SQUARE_FEET > 0 & SALE_PRICE > 0)

#Total Units sold at FLUSHING-NORTH since 2009
dfFNTotalUnits <- df%>%
  filter(NEIGHBORHOOD_NAME=="FLUSHING-NORTH") %>% 
  subset(YEAR >= 2009)%>%
  summarise(TotalUnitsSold=sum(RESIDENTIAL_UNITS)+sum(COMMERCIAL_UNITS))
print(dfFNTotalUnits)

#mean sale price and gross square footage for FN residential 
dfFNResidential<- df%>% 
  filter(NEIGHBORHOOD_NAME=="FLUSHING-NORTH",TYPE=="RESIDENTIAL") %>% 
  subset(YEAR >= 2009)
summarise(dfFNResidential, meanSalesPrice=mean(SALE_PRICE), meanSQF=mean(GROSS_SQUARE_FEET))

summary(dfFNResidential$SALE_PRICE)
summary(dfFNResidential$GROSS_SQUARE_FEET)

#proportion of units sold
df_Q4 <- df %>%
  filter(NEIGHBORHOOD_NAME=="FLUSHING-NORTH") %>% 
  mutate(UnitTotal=COMMERCIAL_UNITS+RESIDENTIAL_UNITS)%>%
  subset(YEAR >= 2009)
# Calculate proportion of units by type of sale
summary_proportion <- df_Q4 %>% 
  group_by(TYPE) %>% 
  summarise(units = sum(UnitTotal))%>% 
  mutate(proportion = units / sum(units))
summary_proportion

#SD calculation
sd(dfFNResidential$SALE_PRICE)

#orrelation
cor(dfFNResidential[c(2,1)])

#Clustering
library(cluster)
library(dplyr)

KPIs <- df %>% 
  filter(TYPE=="RESIDENTIAL") %>% 
  subset(YEAR >= 2009)%>%
  group_by(NEIGHBORHOOD_NAME)%>%
  summarise(MedianSalePrice =median(SALE_PRICE), NumberOfSales=n_distinct(SALE_ID,na.rm = TRUE), SDforSales=sd(SALE_PRICE))
Zscore_KPIs <- scale(KPIs[c(-1)])%>%
  as.data.frame()
Zscore_KPIs[is.na(Zscore_KPIs)]<- 0

k <- kmeans(Zscore_KPIs, centers=3)
df_Cluster <- cbind(KPIs[,1],Zscore_KPIs, k$cluster)
ggplot(df_Cluster)+geom_point(mapping=aes(x=MedianSalePrice, y=NumberOfSales, size=SDforSales,color=factor(k$cluster))) + scale_color_manual(values = c("darkblue", "blue", "lightblue"))

#find my neighborhood's cluster
filter(df_Cluster, NEIGHBORHOOD_NAME=="FLUSHING-NORTH")

#t-test
#filtering data for two different neighborhoods (Flushing-North and Astoria), calculating the average sale prices for each year, and then 
#conducting a statistical test (t-test) to compare the average sale prices between the two neighborhoods, 
#aiming to determine if there is a significant difference in average sale prices between them.
df_NF8 <- df %>%
  filter(NEIGHBORHOOD_NAME=="FLUSHING-NORTH", TYPE=="RESIDENTIAL")%>% 
  subset(YEAR >= 2009)%>% 
  group_by(YEAR)%>% 
  summarise(AVGSales=mean(SALE_PRICE))

df_ASTORIA8 <- df %>%
  filter(NEIGHBORHOOD_NAME=="ASTORIA", TYPE=="RESIDENTIAL")%>% 
  subset(YEAR >= 2009)%>%
  group_by(YEAR)%>% 
  summarise(AVGSales=mean(SALE_PRICE))

t.test(x=df_NF8, y=df_ASTORIA8,alternative="two.sided", conf.level=.95)

###### Forecasting and Prediction ###########

#create time series 
df2<-df%>%
  select(GROSS_SQUARE_FEET,SALE_PRICE, SALE_ID, NEIGHBORHOOD_NAME,BOROUGH_NAME,YEAR,QUARTER,TYPE,RESIDENTIAL_UNITS,COMMERCIAL_UNITS)%>%
  filter(YEAR >= 2009)%>%
  mutate(t=(YEAR-2009)*4+QUARTER)%>%
  group_by(t)%>%
  summarise(SalesTotal=sum(SALE_PRICE))

# Time Series
ts.df2<-ts(df2$SalesTotal,start = c(2009,1),frequency=4)
ets(ts.df2)
plot(ts.df2)#define as no trend

ts.model<-ets(ts.df2)
forecast(ts.model,8)
accuracy(ts.model)

df2<-cbind(df2,c("Q1","Q2","Q3","Q4"))
names(df2)[3]<-"Quarter"

# Regression forecast
reg.df2<-lm(df2,formula=SalesTotal~t)
summary(reg.df2)
x<-data.frame(t=c(53,54,55,56,57,58,59,60),SalesTotal=c(0,0,0,0,0,0,0,0))
predict.lm(reg.df2,x,interval="confidence")

# Regression forecast with seasonality
reg.df2seasonality<-lm(df2,formula=SalesTotal~t+Quarter)
summary(reg.df2seasonality)
x<-data.frame(t=c(53,54,55,56,57,58,59,60),SalesTotal=c(0,0,0,0,0,0,0,0),Quarter=c("Q1","Q2","Q3","Q4","Q1","Q2","Q3","Q4"))
predict.lm(reg.df2seasonality,x,interval="confidence")

# Multiple regression forecast
df.dataforlm<-df %>%
  filter(YEAR >= 2011)%>%
  select(BUILDING_CLASS_FINAL_ROLL, RESIDENTIAL_UNITS, COMMERCIAL_UNITS, GROSS_SQUARE_FEET, SALE_DATE, YEAR_BUILT, SALE_PRICE)

df.dataforlm$BUILDING_CLASS_FINAL_ROLL <- as.factor(df.dataforlm$BUILDING_CLASS_FINAL_ROLL)

model3<-lm(formula=SALE_PRICE~.,data=df.dataforlm)
summary(model3)

# Calculate correlation matrix
cor_mat <- cor(df.dataforlm[c(-1,-5)])
print(cor_mat)



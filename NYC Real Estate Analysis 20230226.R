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

#Analyze my neighborhood FLUSHING-NORTH
#Summary 2: Average Price Per Square Foot with non-zero and non-NA data
df2<-df[df$GROSS_SQUARE_FEET > 0 & df$SALE_PRICE > 0,]%>%
  group_by(YEAR)
summary2<-summarise(df2,AVG_PRICEpersqft_NF=sum(SALE_PRICE)/sum(GROSS_SQUARE_FEET))

#Analyze neighborhood Astoria
#Summary 3: Average Price Per Square Foot with original data
df3<-NYC_TRANSACTION_DATA %>%
  left_join(NEIGHBORHOOD,by="NEIGHBORHOOD_ID")%>%
  left_join(BOROUGH,by="BOROUGH_ID")%>%
  left_join(BUILDING_CLASS,by=c("BUILDING_CLASS_FINAL_ROLL"="BUILDING_CODE_ID"))%>%
  mutate(YEAR=year(SALE_DATE))%>%
  select(GROSS_SQUARE_FEET,SALE_PRICE,NEIGHBORHOOD_NAME,BOROUGH_NAME,YEAR,TYPE)%>%
  filter(NEIGHBORHOOD_NAME=="ASTORIA",TYPE=="RESIDENTIAL")%>%
  group_by(YEAR)
summary3<-summarise(df3,AVG_PRICEpersqft_AS=sum(SALE_PRICE)/sum(GROSS_SQUARE_FEET))

#Analyze neighborhood Astoria
#Summary 4: Average Price Per Square Foot with non-zero and non-NA data
df4<-df3[df3$GROSS_SQUARE_FEET > 0 & df3$SALE_PRICE > 0,]%>%
  group_by(YEAR)
summary4<-summarise(df4,AVG_PRICEpersqft_AS=sum(SALE_PRICE)/sum(GROSS_SQUARE_FEET))

#Analyze neighborhood Douglaston
#Summary 5: Average Price Per Square Foot with original data
df5<-NYC_TRANSACTION_DATA %>%
  left_join(NEIGHBORHOOD,by="NEIGHBORHOOD_ID")%>%
  left_join(BOROUGH,by="BOROUGH_ID")%>%
  left_join(BUILDING_CLASS,by=c("BUILDING_CLASS_FINAL_ROLL"="BUILDING_CODE_ID"))%>%
  mutate(YEAR=year(SALE_DATE))%>%
  select(GROSS_SQUARE_FEET,SALE_PRICE,NEIGHBORHOOD_NAME,BOROUGH_NAME,YEAR,TYPE)%>%
  filter(NEIGHBORHOOD_NAME=="DOUGLASTON",TYPE=="RESIDENTIAL")%>%
  group_by(YEAR)
summary5<-summarise(df5,AVG_PRICEpersqft_DO=sum(SALE_PRICE)/sum(GROSS_SQUARE_FEET))

#Analyze neighborhood Douglaston
#Summary 6: Average Price Per Square Foot with non-zero and non-NA data
df6<-df5[df5$GROSS_SQUARE_FEET > 0 & df5$SALE_PRICE > 0,]%>%
  group_by(YEAR)
summary6<-summarise(df6,AVG_PRICEpersqft_DO=sum(SALE_PRICE)/sum(GROSS_SQUARE_FEET))

#Comparison for Average Price Per Square Foot among 3 neighborhoods
comparison <- merge(summary2, summary4, by = "YEAR")%>%
  merge(summary6, by = "YEAR")

#Plot for 3 neighborhoods
ggplot()+geom_line(data=summary2,size=1,aes(x=YEAR,y=AVG_PRICEpersqft_NF,color="red"))+
  geom_line(data=summary4,size=1,aes(x=YEAR,y=AVG_PRICEpersqft_AS,color="blue"))+
  geom_line(data=summary6,size=1,aes(x=YEAR,y=AVG_PRICEpersqft_DO,color="yellow"))+
  scale_color_discrete(name="Neighborhood",labels=c("FLUSHING-NORTH","ASTORIA","DOUGLASTON"))+
  ggtitle("Average Price Per Square Foot") +
  xlab("Year") + ylab("AVG_PRICEpersqft")



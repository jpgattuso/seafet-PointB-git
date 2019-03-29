library(ggplot2)
library(seacarb)
library(reshape2)
library(plyr)
library(zoo)
library(dplyr)
library(dygraphs)
library(xts)
library(lubridate)
library(scales)

### Attention skip 182 pour la periode du 2016-01-07 au 2016-03-08 (reprise le 2016-01-15 car anomalie avant)
### To be fast : change 3 times in the script the name of the read file (change just date) at l.13-38-51 and run the script

#Before to open a Raw file, please open it in Excel and add the number of deployment and save it.

p <- read.table("../../pCloud Sync/exp166_seafet/1b_seafet_pointB/pb_data/Individual_data/Raw_seaFET2_data_2019-01-07_2019-03-27.csv", skip=1,header=F, sep=",", dec=".", as.is=T)
# add the deployement column
p$deployment <- as.numeric(38)
colnames(p)  <- c("Serial num","date", "sampleNumber", "errorFlag", "phEXT","phINT","voltEXT","voltINT", "T_seaF", "humidity","T_int","deployment")
#colnames(p)  <- c("SerialNum","date","time","phINT","phEXT","T","voltINT","voltEXT","voltThermistor","voltSupply","no","currentSupply","humidity","V_5V","V_ISO","checksum","deployment")
head(p)
# #----------------- CONVERTIR DATE et HEURE -----------#
# decHour <- as.numeric(p$time)
# hour <- floor(decHour)
# head(hour)
# decMin <- (p$time - hour) * 60
# min <- floor(decMin)
# sec <- (decMin - min) * 60
# sec <- round(sec)
# sec1  <- paste("0",sec, sep="")
# p$time1 <- paste(hour, min, sec1, sep=":")
# p$date <- paste( p$date, p$time1, sep=" ")
# p$date<- as.POSIXct(strptime(p$date, format="%Y%j %H:%M:%S"), tz="UTC")
# head(p)
# tail(p)

# p <- p%>%
#   dplyr::mutate(date= ifelse(p$sampleNumber <= 38,  paste(p$date, ":00", sep=""), p$date ))
p$date <- mdy_hms(p$date)

#---------------- Selectionner les colonnes -------------
PERIODE <- p
PERIODE  <- PERIODE%>%select(date,phINT,phEXT,T_seaF,voltINT,voltEXT, humidity, T_int)
#PERIODE  <- PERIODE[,c(2,4:8, 10,13)]
#PERIODE <- subset(PERIODE, pHEXT > 7.9 & date > as.POSIXct("2012-05-31 10:00:00"))
head(PERIODE)
str(PERIODE)

#PERIODE  <- filter(PERIODE, date < "2015-03-12 23:00:00")
write.table(PERIODE,"../../pCloud Sync/exp166_seafet/1b_seafet_pointB/pb_data/Individual_data/seaFET2_data_2019-01-07_2019-03-27.csv",row.names=FALSE,sep=",",dec=".")

# mettre au format tall et renommer les colonnes du fichier SeaFET
PERIODE1<-melt(PERIODE, id.vars="date")
head(PERIODE1)

#---------------- Plot -------------
plot <- ggplot(PERIODE1) + geom_point(aes(x=date, y=value, color=variable),size=0.5) +
  facet_grid(variable~., scales="free_y") + 
  theme_bw()+ xlab("Time")+ylab("")+
  scale_x_datetime(breaks=date_breaks("1 day"), minor_breaks=date_breaks("1 day"), labels=date_format("%d %b %y")) +
  scale_colour_discrete(guide="none") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

print(plot)
ggsave("../../pCloud Sync/exp166_seafet/1b_seafet_pointB/pb_figures/Individual_figures/seaFET2_data_2019-01-07_2019-03-27.pdf",plot,height =20, units="cm")
#pmix(8, 8.01, 0.002560, 1e6, 0.0009090909, S=38, T=14, P=0, Pt=0, Sit=0, k1k2="x", 
 #    kf="x", ks="d", pHscale="T", b="u74", eos = "eos80", long = 1e+20, lat = 1e+20)

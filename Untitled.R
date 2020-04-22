#open data_dic
d <- read.table("../../pCloud Sync/exp153_carbonates_point_B/data/Data_DIC.csv", header=T, sep=",", dec=".", as.is=T)
d$date<- dmy(d$sampling_date, tz="UTC")

#open year file to have hour

h15 <- read.table("../../pCloud Sync/exp153_carbonates_point_B/data/STD_2015_20161005_hours.csv", header=T, sep=";", dec=".", as.is=T, skip =14)
h15$date<- dmy(h15$Date, tz="UTC")
h16 <- read.table("../../pCloud Sync/exp153_carbonates_point_B/data/STD_2016_20171218_hours.csv", header=T, sep=";", dec=".", as.is=T, skip =14)
h16$date<- ymd(h16$Date, tz="UTC")
h16 <- h16 %>%
  dplyr::select(-c(X,X.1,X.2))
h17 <- read.table("../../pCloud Sync/exp153_carbonates_point_B/data/STD_2017_20200120_hours.csv", header=T, sep=";", dec=".", as.is=T, skip =14)
h17$date<- ymd(h17$Date, tz="UTC")
h17 <- h17 %>%
  dplyr::select(-c(X,X.1,X.2,X.3))
h18 <- read.table("../../pCloud Sync/exp153_carbonates_point_B/data/STD_2018_20200120_hours.csv", header=T, sep=";", dec=".", as.is=T, skip =14)
h18$date<- ymd(h18$Date, tz="UTC")
h19 <- read.table("../../pCloud Sync/exp153_carbonates_point_B/data/STD_2019_20191216_hours.csv", header=T, sep=";", dec=".", as.is=T, skip =14)
h19$date<- ymd(h19$Date, tz="UTC")
h20 <- read.table("../../pCloud Sync/exp153_carbonates_point_B/data/STD_2020_20200331_hours.csv", header=T, sep=";", dec=".", as.is=T, skip =14)
h20$date<- ymd(h20$Date, tz="UTC")

#bind all years
h <- rbind(h15, h16,h17, h18, h19, h20)
#subset 0m 50m
h <- h%>%
  dplyr::filter(Depth == 1  |Depth ==50)%>%
  dplyr::mutate(depth = ifelse(Depth ==1, 0, Depth))

  
# left_joint time to put in data_dic
d <- left_join(d, h%>%dplyr::select(date, depth, Time), by=c("depth", "date"))
# paste date + time
d$datetime <- ymd_hms(paste0(d$date, d$Time, sep= " "))

# create a round hour in a new column in data_dic
d <- d%>%
  dplyr::mutate( datetime_round = ceiling_date(datetime, unit ="hours"))











# Pour maia, 
#local time to UTC from 1957 to 2014
#open data_dic
m <- read.table("../../pCloud Sync/exp153_carbonates_point_B/data/STD_all_20200330.csv", header=T, sep=";", dec=".",skip=14, as.is=T)

# add local time "09:00:00" for all dates
m$local_time <- "09:00:00"
# Link date + local time
m$datetime_local <- ymd_hms(paste0(m$Date, m$local_time, sep= " "))
# Tell to the data that this is French date and time
m$datetime_local  <- ymd_hms(m$datetime_local , tz="Europe/Paris")
# change data in UTC
m$datetime  <- with_tz(m$datetime_local, "UTC")
# creer une colonne "time" avec que le temps.
m$time <- strftime(m$datetime , format="%H:%M:%S")

write.table(m,"../../pCloud Sync/exp153_carbonates_point_B/data/STD_all_20200330_SA.csv",row.names=FALSE,sep=",",dec=".")












tidyr::unite(col="datetime" , Date, Time, sep = " ", remove = FALSE)
h$datetime <- ymd_hms(h$datetime, tz="UTC")

%>%
  lubridate::hms(h$Time, tz="UTC")
                time = as.POSIXc(Time, format="%H:%M:%S", tz="UTC" ))
  

h$time <- hms(h$Time, tz="UTC")
format(round(tt, units="hours"), format="%H:%M")
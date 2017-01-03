library(sp)
library(maptools)
library(leaflet)
library(RColorBrewer)
library(rgdal)
library(readr)
library(rmapshaper)

poly_masses<-readShapeSpatial("Polygone_masses_eau/PolygMasseDEauSouterraine.shp",proj4string=CRS("+init=epsg:2154"))
poly_masses<-spTransform(poly_masses,CRS("+init=epsg:4326"))

stations<-read.csv2("Stations/stations.csv",check.names = F)
stations_geo<-stations
coordinates(stations_geo)<- ~X_FICT_L93+Y_FICT_L93
proj4string(stations_geo) = CRS("+init=epsg:2154")
stations_geo<-spTransform(stations_geo,CRS("+init=epsg:4326"))

test<-over(x = stations_geo[1,],y=poly_masses)
test2<-over(poly_masses[poly_masses$CdPolygMas=="00000110",],stations_geo,returnList = T)[[1]]
test3<-over(x=stations_geo[stations_geo$CD_STATION=="06041X0022/S",],y=poly_masses)

test2<-test2[[1]]

?over

FrMap <- leaflet() %>% 
  addTiles() %>% 
  setView(2.432518,46.759552 , zoom = 12) %>% 
  addPolygons(data=poly_masses[poly_masses$CdPolygMas=="00000110",], stroke = FALSE, fillOpacity = 0.8,fillColor = "green") %>%
  addCircleMarkers(data=stations_geo[stations_geo$CD_STATION %in% test2$CD_STATION,],fillOpacity = 1) %>%
  addCircleMarkers(data=stations_geo[!stations_geo$CD_STATION %in% test2$CD_STATION,],popup=~CD_STATION)
FrMap

poly_masses_archives <- poly_masses
require(rmapshaper)
poly_masses_1 <- ms_simplify(poly_masses_archives[poly_masses_archives$Niveau==1],keep=0.1)

?ms_simplify

FrMap <- leaflet() %>% 
  addTiles() %>% 
  setView(2.432518,46.759552 , zoom = 6) %>% 
  addPolygons(data=poly_masses_1, stroke = FALSE, fillOpacity = 0.8,fillColor = "green",popup="test")
FrMap
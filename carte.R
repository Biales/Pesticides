library(sp)
library(maptools)
library(leaflet)
library(RColorBrewer)
library(rgdal)

poly_masses<-readShapeSpatial("Polygone_masses_eau/PolygMasseDEauSouterraine.shp",proj4string=CRS("+init=epsg:2154"))
poly_masses<-spTransform(poly_masses,CRS("+init=epsg:4326"))

FrMap <- leaflet() %>% 
  addTiles() %>% 
  setView(2.432518,46.759552 , zoom = 6) %>% 
  addPolygons(data=poly_masses[poly_masses$Niveau==2,], stroke = FALSE, fillOpacity = 0.8,fillColor = "green",popup="test")
FrMap
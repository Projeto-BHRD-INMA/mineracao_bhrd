######################################################
# PCI INMA 1º product
# exploratory analyses DNPM mine data
# Kele Rocha Firmiano
######################################################

# Some projections codes: ####
# sirgas: 
# +proj=longlat +ellps=GRS80 +towgs84=0,0,0 +no_defs

# wgs84: 
# +proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs

# Albers:
# +proj=aea +lat_1=-5 +lat_2=-42 +lat_0=-32 +lon_0=-60 +x_0=0 +y_0=0 +ellps=aust_SA +units=m +no_defs

# If it has already a different coordinate system, we need to transform the file to Albers
#largepol.albers <- spTransform(poligono, CRS("+proj=aea +lat_1=-5 +lat_2=-42 +lat_0=-32 +lon_0=-60 +x_0=0 +y_0=0 +ellps=aust_SA +units=m +no_defs "))
#crs(largepol.albers)

# Goal: standardizing the projections to WGS 84

# loading pck ####
library(rgdal)
library(raster)

# Loading shp file ####

mg_mine <- readOGR(dsn = "./data/MG_dnmp_7abr20", layer = "MG") 
es_mine <- readOGR(dsn = "./data/ES_dnmp_7abr20", layer = "ES")
bhrd_lim <- readOGR(dsn = "./data/BHRD_limites", layer = "bhrd_sirgas_dissol")
munic <- readOGR(dsn = "./data/BHRD_municipios", layer = "munic_BHRD_albers")

# Checking coordinate system ####
crs(mg_mine) # sirgas 2000
crs(es_mine) # sirgas 2000
crs(bhrd_lim)  # sirgas 2000
crs(munic) # Albers

# Reprojections ####
mg_mine_wgs84 <- spTransform(mg_mine, CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"))

es_mine_wgs84 <- spTransform(es_mine, CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"))

bhrd_lim_wgs84 <- spTransform(bhrd_lim, CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"))

munic_wgs84 <- spTransform(munic, CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"))

# Checking coordinate system ####
crs(mg_mine_wgs84) # ok
crs(es_mine_wgs84) # ok
crs(bhrd_lim_wgs84) # ok  
crs(munic_wgs84) # ok 

# Saving reprojections shapes ####
writeOGR(mg_mine_wgs84,"./outputs/reproj_shp", "mg_mine_wgs84", driver = "ESRI Shapefile", overwrite_layer = TRUE)

writeOGR(es_mine_wgs84,"./outputs/reproj_shp", "es_mine_wgs84", driver = "ESRI Shapefile", overwrite_layer = TRUE)

writeOGR(bhrd_lim_wgs84,"./outputs/reproj_shp", "bhrd_lim_wgs84", driver = "ESRI Shapefile", overwrite_layer = TRUE)

writeOGR(munic_wgs84,"./outputs/reproj_shp", "munic_wgs84", driver = "ESRI Shapefile", overwrite_layer = TRUE)

#testing the new shp saved ####
par(mfrow = c(2, 2), mar = c(5, 5, 4, 1))
mg <- readOGR(dsn = "./outputs/reproj_shp", layer = "mg_mine_wgs84")
plot(mg, axes = TRUE)

es <- readOGR(dsn = "./outputs/reproj_shp", layer = "es_mine_wgs84")
plot(es, axes = TRUE)

bhrd <- readOGR(dsn = "./outputs/reproj_shp", layer = "bhrd_lim_wgs84")
plot(bhrd, axes = TRUE)

munic <- readOGR(dsn = "./outputs/reproj_shp", layer = "munic_wgs84") # did not plot correctly the municipalities
plot(bhrd, axes = TRUE)
dev.off()

#########################################
# SPATIAL EXTRATION AND UNION IN R 
# Danielle de Oliveira Moreira
# Date: 31/03/2020                  
# Modified by Kele R. Firmiano in 01/04/20
########################################

# Loading packages ####
library(rgdal)
library(raster)
#library(maptools)
library(rgeos) # clip

# Loading shp file ####
mg <- readOGR(dsn = "./outputs/reproj_shp", layer = "mg_mine_wgs84")
es <- readOGR(dsn = "./outputs/reproj_shp", layer = "es_mine_wgs84")
bhrd <- readOGR(dsn = "./outputs/reproj_shp", layer = "bhrd_lim_wgs84")
munic <- readOGR(dsn = "./outputs/reproj_shp", layer = "munic_wgs84")

# Checking coordinate system ####
crs(mg) # wgs84
crs(es) # wgs84
crs(bhrd) # wgs84
crs(munic) # wgs84

# simple plots
par(mfrow = c(2, 2), mar = c(5, 5, 4, 1))
plot(mg , axes = TRUE, xlab = "mg_mine_wgs84")
plot(es, axes = TRUE, xlab = "es_mine_wgs84")
plot(bhrd, axes = TRUE, xlab = "bhrd_lim_wgs84")
plot(munic, axes = TRUE, xlab = "munic_wgs84")
dev.off()

plot(mg, col = 'blue')
plot(es, add = TRUE, col = 'red', axes = TRUE)

# Step 1: Clipping polygons
# clipping 
clip_mg_bhrd_lim <- gIntersection(mg, bhrd, byid = TRUE, drop_lower_td = TRUE)
clip_es_bhrd_lim <- gIntersection(es, bhrd, byid = TRUE, drop_lower_td = TRUE)

# check clip 
plot(clip_mg_bhrd_lim, col = 'blue')
plot(clip_es_bhrd_lim, add = TRUE, col = 'red', axes = TRUE)


# Step 2: Using BHRD limits to clip and union #### 
# It was necessary to allow R run without bugs
union_bhrd_mine_lim <- union(clip_mg_bhrd_lim, clip_es_bhrd_lim)

# check union
plot(union_bhrd_mine_lim, col = 'brown', xlab = "union_bhrd_mine_lim", axes = TRUE)

# Saving the new shp ####
writeOGR(union_bhrd_mine_lim, "./ouputs", "union_shp", driver = "ESRI Shapefile", overwrite_layer = TRUE)

#testing the new shp saved ####
union_lim <- readOGR(dsn = "./ouputs/union_shp", layer = "union_bhrd_mine_lim")

plot(union_lim, axes = TRUE, xlab = "union_bhrd_mine_lim")

# Using BHRD municipality to clip and union #### 
# It was necessary to allow R run without bugs
# Step 1: Clipping polygons
# clipping 
clip_mg_bhrd_munic <- gIntersection(mg, munic, byid = TRUE, drop_lower_td = TRUE)
clip_es_bhrd_munic <- gIntersection(es, munic, byid = TRUE, drop_lower_td = TRUE)

# check clip 
plot(clip_mg_bhrd_munic, col = 'green')
plot(clip_es_bhrd_munic, add = TRUE, col = 'orange', axes = TRUE)

# Step 2: union clipped polygons ####
union_bhrd_mine_munic <- union(clip_mg_bhrd_munic, clip_es_bhrd_munic)

# check union
plot(union_bhrd_mine_munic, col = 'pink', xlab = "union_bhrd_mine_lim", axes = TRUE)

# Saving the new shp ####
writeOGR(union_bhrd_mine_munic, "./ouputs", "union_shp", driver = "ESRI Shapefile", overwrite_layer = TRUE)

#testing the new shp saved ####
union_munic <- readOGR(dsn = "./ouputs/union_shp", layer = "union_bhrd_mine_munic")

plot(union_munic, axes = TRUE, xlab = "union_bhrd_mine_munic")

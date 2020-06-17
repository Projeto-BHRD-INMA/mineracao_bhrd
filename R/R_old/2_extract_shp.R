#########################################
# SPATIAL EXTRATION IN R 
# Danielle de Oliveira Moreira
# Date: 31/03/2020                  
# Modified by Kele R. Firmiano in 01/04/20
########################################

# Loading packages ####
library(rgdal)
library(raster)
library(rgeos) # clip

# Loading shp file ####

mg <-
  readOGR(dsn = "./outputs/reproj_shp",
          layer = "mg_mine_wgs84",
          encoding = 'UTF-8')
es <-
  readOGR(dsn = "./outputs/reproj_shp",
          layer = "es_mine_wgs84",
          encoding = 'UTF-8')
bhrd <-
  readOGR(dsn = "./outputs/reproj_shp",
          layer = "bhrd_lim_wgs84",
          encoding = 'UTF-8')
munic <-
  readOGR(dsn = "./outputs/reproj_shp",
          layer = "munic_wgs84",
          encoding = 'UTF-8')

# Checking coordinate system ####
crs(mg) 
crs(es) 
crs(bhrd) 
crs(munic) 

# simple plots
par(mfrow = c(2, 2), mar = c(5, 5, 4, 1))
plot(mg , axes = TRUE, xlab = "mg_mine_wgs84")
plot(es, axes = TRUE, xlab = "es_mine_wgs84")
plot(bhrd, axes = TRUE, xlab = "bhrd_lim_wgs84")
plot(munic, axes = TRUE, xlab = "munic_wgs84")
dev.off()

plot(mg, col = 'blue')
plot(es, add = TRUE, col = 'red', axes = TRUE)

# jeito 1 - usando a funçao crop do pacote raster. esse jeito corta direitinho e cria um SpatialPolygonDataFrame. mas UCs que estão dentro e fora dos limites se perdem aqui (olhar jeito 2). ####
crop_mg_bhrd_lim <- crop(mg, bhrd)
crop_es_bhrd_lim <- crop(es, bhrd)
crop_mg_bhrd_munic <- crop(mg, munic)
crop_es_bhrd_munic <- crop(es, munic)

# check clip jeito 1
plot(crop_mg_bhrd_lim, axes = TRUE, col = 'dark blue', border = 'dark blue')
plot(crop_es_bhrd_lim, add = TRUE, axes = TRUE, col = 'dark green', border = 'dark green')
plot(bhrd, add = TRUE, border = 'red')

plot(crop_mg_bhrd_munic, axes = TRUE, col = 'dark orange', border = 'dark orange')
plot(crop_es_bhrd_munic, add = TRUE, axes = TRUE, col = 'dark gray', border = 'dark gray')
plot(bhrd, add = TRUE, border = 'red')

# jeito 2 - Aqui o corte nao é tao exato: ele mantem as mines que estao dentro e fora dos limites da bacia. mas, necessitamos dos 2 jeitos para criar uma coluna com a diferença da área) ####
crop_mg_bhrd_lim_B <- mg[bhrd, ]
crop_es_bhrd_lim_B <- es[bhrd, ]
crop_mg_munic_lim_B <- mg[munic, ]
crop_es_munic_lim_B <- es[munic, ]

# check clip jeito 2
plot(crop_mg_bhrd_lim_B, axes = TRUE, col = 'dark blue', border = 'dark blue')
plot(crop_es_bhrd_lim_B, add = TRUE, axes = TRUE, col = 'dark green', border = 'dark green')
plot(bhrd, add = TRUE, border = 'black')

plot(crop_mg_munic_lim_B, axes = TRUE, col = 'dark orange', border = 'dark orange')
plot(crop_es_munic_lim_B, add = TRUE, axes = TRUE, col = 'dark gray', border = 'dark gray')
plot(bhrd, add = TRUE, border = 'black')

#calculando a diferença das áreas - usando a função area do pacote raster. ####
#primeiro calcular a área dos poligonos de cada arquivo e salvando uma coluna com a area de cada UC no dataframe de cada arquivo: 

crop_mg_bhrd_lim$AREA_HA <- area(crop_mg_bhrd_lim) 
crop_es_bhrd_lim$AREA_HA <- area(crop_es_bhrd_lim)
crop_mg_bhrd_munic$AREA_HA <- area(crop_mg_bhrd_munic)
crop_es_bhrd_munic$AREA_HA <- area(crop_es_bhrd_munic)

#salvando uma coluna com a diferença da area (do jeito de cortar que nao corta exato - area após corte exato):
crop_mg_bhrd_lim$dif_area <- (area(crop_mg_bhrd_lim_B) - area(crop_mg_bhrd_lim))
crop_es_bhrd_lim$dif_area <- (area(crop_es_bhrd_lim_B) - area(crop_es_bhrd_lim))
crop_mg_bhrd_munic$dif_area <- (area(crop_mg_munic_lim_B) - area(crop_mg_bhrd_munic))
crop_es_bhrd_munic$dif_area <- (area(crop_es_munic_lim_B) - area(crop_es_bhrd_munic))

#saving new (clipped) shapefiles ####
writeOGR(crop_mg_bhrd_lim,"./outputs/clip_shp", "crop_mg_bhrd_lim", driver = "ESRI Shapefile", overwrite_layer = TRUE)

writeOGR(crop_es_bhrd_lim,"./outputs/clip_shp", "crop_es_bhrd_lim", driver = "ESRI Shapefile", overwrite_layer = TRUE)

writeOGR(crop_mg_bhrd_munic,"./outputs/clip_shp", "crop_mg_bhrd_munic", driver = "ESRI Shapefile", overwrite_layer = TRUE)

writeOGR(crop_es_bhrd_munic,"./outputs/clip_shp", "crop_es_bhrd_munic", driver = "ESRI Shapefile", overwrite_layer = TRUE)

# Remove unecessary files ####
# good to get more space if you'll continue the analysis in the sequence
rm(mg)
rm(es)
rm(bhrd)
rm(munic)
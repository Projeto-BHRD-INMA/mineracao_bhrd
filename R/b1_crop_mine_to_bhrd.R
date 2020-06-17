#########################################
# CROP BRAZIL MINING DATA TO DOCE RIVER BASIN
# Kele R. Firmiano & Bruno M. Carvalho
# Date: 19/05/2020
########################################

library(raster)
library(rgdal)
library(rgeos)

# loading mining shapefile for Brazil (original datafrom DNPM, SIRGAS 2000, not projected)
dnpm_br <- readOGR(dsn = "./data/DNPM_Brasil",
                   layer = "BRASIL",
                   encoding = 'UTF-8')

# loading Rio Doce basin mask (original data from ANA, SIRGAS 2000, not projected)
mask_bhrd <- readOGR(dsn = "./data/BHRD_limites",
                     layer = "UPH_BHRD",
                     encoding = 'UTF-8')

# converting both to Albers
prj <- "+proj=aea +lat_1=-5 +lat_2=-42 +lat_0=-32 +lon_0=-60 +x_0=0 +y_0=0 +ellps=aust_SA +units=m +no_defs"
mask_bhrd <- spTransform(mask_bhrd, CRS(prj))
dnpm_br <- spTransform(dnpm_br, CRS(prj))

# selecting only mining areas from the Rio Doce basin
mine_bhrd <- dnpm_br[mask_bhrd, ]

# zero buffer to correct geometries
mine_bhrd <- gBuffer(mine_bhrd, byid = TRUE, width = 0)

# calculate areas in mask
mask_bhrd$area_m <- area(mask_bhrd)

# writing output files
writeOGR(mine_bhrd,
         dsn = "./outputs/b1_mine_bhrd_albers.shp",
         layer = "b1_mine_bhrd_albers",
         driver = "ESRI Shapefile",
         overwrite_layer = TRUE)

writeOGR(mask_bhrd,
         dsn = "./outputs/b1_mask_bhrd_albers.shp",
         layer = "b1_mask_bhrd_albers",
         driver = "ESRI Shapefile",
         overwrite_layer = TRUE)

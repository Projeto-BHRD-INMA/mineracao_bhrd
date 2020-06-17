#########################################
# CALCULATE MINING AREAS IN DOCE RIVER BASIN
# Kele R. Firmiano & Bruno M. Carvalho
# Date: 19/05/2020
########################################

library(raster)
library(rgdal)
library(dplyr)
library(data.table)

# load mining and mask shapefiles
mine_bhrd <- readOGR(dsn = "./outputs/b1_mine_bhrd_albers.shp",
                     layer = "b1_mine_bhrd_albers",
                     encoding = 'UTF-8')

mask_bhrd <- readOGR(dsn = "./outputs/b1_mask_bhrd_albers.shp",
                     layer = "b1_mask_bhrd_albers",
                     encoding = 'UTF-8')

# crop mining areas in each polygon of the mask
masks <- list()
cropped <- list()
for(i in 1:length(mask_bhrd)){
  masks[[i]] <- mask_bhrd[i,] #separando cada poligono de mask
  cropped[[i]] <- crop(mine_bhrd, masks[[i]]) #usando cada polígono de mask para cortar as areas de mineracao
  cropped[[i]]$UPH_SG <- rep(masks[[i]]$UPH_SG, length(cropped[[i]]))
  cropped[[i]]$UPH_NM <- rep(masks[[i]]$UPH_NM, length(cropped[[i]]))
  cropped[[i]]$UPH_CD <- rep(masks[[i]]$UPH_CD, length(cropped[[i]]))
  cropped[[i]]$area_m <- rep(masks[[i]]$area_m, length(cropped[[i]]))
  cropped[[i]]$areacalc <- area(cropped[[i]]) #area de cada poligono de mineracao na unidade definida em prj
}

# calculate mining areas (in ha) by FASE in each UPH
mine_fases <- list()
for(i in 1:length(cropped)){
  df <- data.frame(cropped[[i]])
  mine_fases[[i]] <- df %>%
    group_by(UPH_SG, UPH_NM, UPH_CD, area_m, FASE) %>%
    summarise(area_mine = sum(areacalc)) %>%
    mutate(percent_mine = round(area_mine/area_m, digits = 3))
}
mine_fases_df <- rbindlist(mine_fases)

# calculate mining areas (in ha) by SUBS in each UPH
mine_subs <- list()
for(i in 1:length(cropped)){
  df <- data.frame(cropped[[i]])
  mine_subs[[i]] <- df %>%
    group_by(UPH_SG, UPH_NM, UPH_CD, area_m, SUBS) %>%
    summarise(area_mine = sum(areacalc)) %>%
    mutate(percent_mine = round(area_mine/area_m, digits = 3))
}
mine_subs_df <- rbindlist(mine_subs)

# calculate total mining areas in each UPH
mine_total_df <- mine_fases_df %>%
  group_by(UPH_SG, UPH_NM, UPH_CD, area_m) %>%
  summarise(area_mine = sum(area_mine)) %>%
  mutate(percent_mine = round(area_mine/area_m, digits = 3))


# write outputs
write.csv(mine_fases_df,
          file = "./outputs/b2_mine_fases_UPH.csv",
          row.names = FALSE)

write.csv(mine_subs_df,
          file = "./outputs/b2_mine_subs_UPH.csv",
          row.names = FALSE)

write.csv(mine_total_df,
          file = "./outputs/b2_mine_total_UPH.csv",
          row.names = FALSE)

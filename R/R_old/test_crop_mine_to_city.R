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

###################################
# Need a loop

# extracting uf, municipality and zone informations ####
df.uf <- data.frame(munic$NOMEUF) # selecting uf
df.munic <- data.frame(munic$NOMEMUNIC) # selecting municipalities
df.reg <- data.frame(munic$NOMEMES) # selecting regions
df.munic.reg.uf <- cbind(df.munic, df.reg, df.uf) # combining all

# Extracting munic ####
# example: Colatina - ES
col <- c("Colatina")
ext.col <- munic[munic$NOMEMUNIC %in% col,]
writeOGR(ext.col,"./outputs/clip_reg_shp", "ext.col", driver = "ESRI Shapefile", overwrite_layer = TRUE)

# plots ####
plot(munic, axes = TRUE)
plot(ext.col, add = TRUE, col = "red", axes = TRUE)

# jeito 1 - corte exato ####
crop_col <- crop(es, ext.col)

# plots ####
plot(munic, axes = TRUE)
plot(crop_col, add = TRUE, col = "red", axes = TRUE)

# jeito 2 - corte nao exato: mantém minas dentro e fora dos limites do munic. ####
crop_col_B <- es[ext.col, ]

par(mfrow = c(2, 2), mar = c(5, 5, 4, 1))
plot(crop_col , axes = TRUE, xlab = "crop1")
plot(crop_col_B, axes = TRUE, xlab = "crop2")
dev.off()

#calculando a diferença das áreas - ####
crop_col$AREA_HA <- area(crop_col)
crop_col$dif_area <- (area(crop_col_B) - area(crop_col))

#saving new (clipped) shapefiles ####
writeOGR(crop_col,"./outputs", "crop_col", driver = "ESRI Shapefile", overwrite_layer = TRUE)
###################################

### Bruno: testando loops
library(dplyr)
library(data.table)

## primeiro para o ES
munic_es <- munic[munic$NOMEUF == "ESPIRITO SANTO", ]

# cortar as areas de mineraçao em cada municipio do ES
masks <- list()
cropped <- list()
for(i in 1:length(munic_es)){
  masks[[i]] <- munic_es[i,]
  cropped[[i]] <- crop(es, masks[[i]])
}

# adicionar campos aos shapefiles criados
# este loop teve que ficar separado porque nem todos os municipios tem areas de mineracao, p.ex. IBITIRAMA
for(i in 1:length(cropped)){
  cropped[[i]]$munic_id <- rep(masks[[i]]$MUNICDV, length(cropped[[i]])) #geocodigo do municipio
  cropped[[i]]$munic_name <- rep(as.character(masks[[i]]$NOMEMUNICP), length(cropped[[i]])) #nome do municipio
  cropped[[i]]$areacalc <- area(cropped[[i]]) #area de cada poligono de mineracao
}

# calcular areas de mineracao por FASE em cada municipio
mine_areas <- list()
for(i in 1:length(cropped)){
  df <- data.frame(cropped[[i]])
  mine_areas[[i]] <- df %>%
    group_by(munic_id, munic_name, FASE) %>%
    summarise(area_ha = round(sum(areacalc)/10000, digits = 3))
}

# gerar tabelas para o ES
mine_fases_ES <- rbindlist(mine_areas)
mine_total_ES <- mine_fases_ES %>%
  group_by(munic_id, munic_name) %>%
  summarise(area_mine = sum(area_ha))

write.csv(mine_fases_ES, file = "./outputs/mine_fases_ES.csv", row.names = FALSE)
write.csv(mine_total_ES, file = "./outputs/mine_total_ES.csv", row.names = FALSE)

## repetir tudo para MG (e cruzar os dedos)
munic_mg <- munic[munic$NOMEUF == "MINAS GERAIS", ]

# cortar as areas de mineraçao em cada municipio de MG
masks <- list()
cropped <- list()
for(i in 1:length(munic_mg)){
  masks[[i]] <- munic_mg[i,]
  cropped[[i]] <- crop(mg, masks[[i]])
}

# adicionar campos aos shapefiles criados
## AQUI DEU PROBLEMA - TEMOS QUE REPENSAR ESSE CORTE DOS MUNICIPIOS PELA EXTENSÃO DA BACIA.
for(i in 1:length(cropped)){
  cropped[[i]]$munic_id <- rep(masks[[i]]$MUNICDV, length(cropped[[i]])) #geocodigo do municipio
  cropped[[i]]$munic_name <- rep(as.character(masks[[i]]$NOMEMUNICP), length(cropped[[i]])) #nome do municipio
  cropped[[i]]$areacalc <- area(cropped[[i]]) #area de cada poligono de mineracao
}

# calcular areas de mineracao por FASE em cada municipio
mine_areas <- list()
for(i in 1:length(cropped)){
  df <- data.frame(cropped[[i]])
  mine_areas[[i]] <- df %>%
    group_by(munic_id, munic_name, FASE) %>%
    summarise(area_ha = round(sum(areacalc)/10000, digits = 3))
}

# gerar tabelas para MG
mine_fases_MG <- rbindlist(mine_areas)
mine_total_MG <- mine_fases_ES %>%
  group_by(munic_id, munic_name) %>%
  summarise(area_mine = sum(area_ha))

write.csv(mine_fases_MG, file = "./outputs/mine_fases_MG.csv", row.names = FALSE)
write.csv(mine_total_MG, file = "./outputs/mine_total_MG.csv", row.names = FALSE)

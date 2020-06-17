#############################
# Exploratory unidades de planejamento hídrico
# Kele R. Firmiano
# Data: 02/06/2020
#############################

# Loading packages ####
library(rgdal)
library(raster)
library(rgeos) # clip
library(maptools)
library(ggsn) # north arrow and a scale bar 
library(tmap)# legend
library(RColorBrewer) # colors
library(ggplot2)

# loading file ####
bhrd <-
  readOGR(dsn = "./outputs/b1_mask_bhrd_albers.shp", layer = "b1_mask_bhrd_albers", encoding = 'UTF-8')

# UPH ####
# unidades de planejamento hídrico - BHRD
# 501: Piranga (MG)
# 502: Piracicaba (MG)
# 503: Santo Antonio (MG)
# 504: Suaçuí Grande (MG)
# 505: Caratinga (MG)
# 506: Manhuaçu (MG) 
# 507: São José (ES)
# 508: Guandu (ES)
# 509: Santa Maria do Doce (ES)

# simple plots ####
col_bhrd <- brewer.pal(9, "Paired") # defining colors

par(mar = c(3, 2, 1, 2))

plot(
  bhrd,
  axes = TRUE,
  xlab = "Unidades de planejamento hídrico - BHRD",
  fill = T,
  col = col_bhrd)

# legend
uph <- c("Piranga (MG)", "Piracicaba (MG)", "Santo Antonio (MG)", "Suaçuí Grande (MG)", "Caratinga (MG)", "Manhuaçu (MG)", "São José (ES)", "Guandu (ES)", "Santa Maria do Doce (ES)")
class(uph)

legend(
  "bottomright",
  inset = .01,
  title = expression("UPH - BHRD"),
  legend = uph,
  fill = col_bhrd,
  horiz = FALSE,
  box.col = NA,
  cex = 0.5
)









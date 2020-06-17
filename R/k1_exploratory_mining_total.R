#############################
# Exploratory mine total
# Kele R. Firmiano
# Data: 01/06/2020
#############################
library(RColorBrewer) # colors

t_area <- read.csv("./outputs/b2_mine_total_UPH.csv", sep = ",", h = T)

perc <- (t_area$percent_mine*100) # proportion 

# UPH ####
# unidades de planejamento hídrico - BHRD
# 501: Piranga (MG)
# 502: Piracicaba (MG)
# 503: Santo Antonio (MG)
# 504: Suaçui Grande (MG)
# 505: Caratinga (MG)
# 506: Manhuaçu (MG) 
# 507: São José (ES)
# 508: Guandu (ES)
# 509: Santa Maria do Doce (ES)

uph <- c("Piranga", "Piracicaba", "Sto Antonio", "Suaçuí Grande", "Caratinga", "Manhuaçu", "São José", "Guandu", "Sta Mª do Doce") # label

# plot mine % 
col_bhrd <- brewer.pal(9, "Paired") # defining colors
#par(mar = c(10, 6, 3, 3))

barplot(perc, las = 1,ylim = c(0, 100), xlab = "Unidades de Planejamento Hídrico - BHRD", ylab = "Área de mineração (%)",  names.arg = uph, col = col_bhrd)


# plot area uph
sum(t_area$area_m/10000) # total area (ha)

#par(mar = c(6, 10, 3, 3))

area <- (t_area$area_m/10000) # area hectare

barplot(area, las = 1, xlab = "Unidades de Planejamento Hídrico - BHRD", ylab = "", names.arg = uph, col = col_bhrd)

title(ylab = "Área (ha)", line = 5)

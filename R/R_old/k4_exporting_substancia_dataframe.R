#############################
# Exporting fortamated substancia df to use in excel
# Kele R. Firmiano
# Data: 19/06/2020
#############################

# reading pck ####
library(plyr) # comibine df

subs <- read.csv("./outputs/b2_mine_subs_UPH.csv", sep = ",", h = T)

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

subs <- ddply(subs, 5) # organizing by fases

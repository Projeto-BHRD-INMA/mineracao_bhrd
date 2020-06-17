#############################
# Exploratory mine fases
# Kele R. Firmiano
# Data: 02/06/2020
#############################

# NEED REVIEW, NOT FINISHED ################

# reading pck ####
library(plyr) # comibine df
library(RColorBrewer) # colors

fases <- read.csv("./outputs/b2_mine_fases_UPH.csv", sep = ",", h = T)

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

# Setting df ####
uph_name <- c("Piranga","Piranga","Piranga","Piranga","Piranga","Piranga","Piranga","Piranga","Piranga","Piranga","Piranga","Piranga","Piracicaba","Piracicaba","Piracicaba","Piracicaba","Piracicaba","Piracicaba","Piracicaba","Piracicaba","Piracicaba","Piracicaba","Piracicaba","Sto Antonio","Sto Antonio","Sto Antonio","Sto Antonio","Sto Antonio","Sto Antonio","Sto Antonio","Sto Antonio","Sto Antonio","Sto Antonio","Sto Antonio","Sto Antonio","Suaçuí Grande","Suaçuí Grande","Suaçuí Grande","Suaçuí Grande","Suaçuí Grande","Suaçuí Grande","Suaçuí Grande","Suaçuí Grande","Suaçuí Grande","Suaçuí Grande","Suaçuí Grande","Suaçuí Grande","Caratinga","Caratinga","Caratinga","Caratinga","Caratinga","Caratinga","Caratinga","Caratinga","Caratinga","Caratinga","Caratinga","Caratinga","Manhuaçu","Manhuaçu","Manhuaçu","Manhuaçu","Manhuaçu","Manhuaçu","Manhuaçu","Manhuaçu","Manhuaçu","Manhuaçu","Manhuaçu","São José","São José","São José","São José","São José","São José","São José","São José","São José","São José","Guandu","Guandu","Guandu","Guandu","Guandu","Guandu","Guandu","Guandu","Guandu","Sta Mª do Doce","Sta Mª do Doce","Sta Mª do Doce","Sta Mª do Doce","Sta Mª do Doce","Sta Mª do Doce","Sta Mª do Doce","Sta Mª do Doce","Sta Mª do Doce","Sta Mª do Doce")

fases <- cbind.data.frame(fases, uph_name) #combining vector

fases <- ddply(fases, 5) # organizing by fases

area_ha <- (fases$area_mine/10000)  # area hectare

prop_ha <- (area_ha/5196723) # calculating the proportion mining area (total mine area ha: 5196723

perc_ha <- (prop_ha*100) # percentage

fases <- cbind.data.frame(fases, perc_ha) #combining vector

# new vector name ####
Fs0 <- c("autorização de pesquisa (AP)", "consessão de lavra (CL)", "direito de requerer a lavra (DRL)", "disponibilidade (D)", "lavra garimpeira (LG)", "licenciamento (L)", "registro de extração (RE)", "requerimento de lavra (RL)", "requerimento de alvra garimpeira (RLG)", "requerimetno de licenciamento (RL)", "requerimento de pesquisa (RP)", "requerimento de registro de extração (RRE)") # label complete

Fs1 <- c("AP", "CL", "DRL", "D", "LG", "L", "RE", "RL", "RLG", "RL", "RP", "RRE") # short label

fs <- c("AP","AP","AP","AP","AP","AP","AP","AP","AP","CL","CL","CL","CL","CL","CL","CL","CL","CL","DRL","DRL","DRL","DRL","DRL","DRL","DRL","DRL","DRL","D","D","D","D","D","D","D","D","D","LG","LG","LG","LG","LG","LG","L","L","L","L","L","L","L","L","L","RE","RE","RE","RE","RE","RE","RL","RL","RL","RL","RL","RL","RL","RL","RL","RLG","RLG","RLG","RLG","RLG","RLG","RLG","RLG","RLG","RL","RL","RL","RL","RL","RL","RL","RL","RL","RP","RP","RP","RP","RP","RP","RP","RP","RP","RRE","RRE","RRE","RRE","RRE","RRE") # label vector

fases <- cbind.data.frame(fases, fs) #combining label vector

# defining colors by uph ####
col_bhrd <- brewer.pal(9, "Paired") # defining colors

# plot uph by fases ####
uph <- c("Piranga", "Piracicaba", "Sto Antonio", "Suaçuí Grande", "Caratinga", "Manhuaçu", "São José", "Guandu", "Sta Mª do Doce") # label

ap <- fases[1:9, ]
plot(ap$perc_ha, las = 1, xlab = "Unidades de Planejamento Hídrico - BHRD", names.arg = uph)

barplot(perc, las = 1,ylim = c(0, 100), xlab = "Unidades de Planejamento Hídrico - BHRD", ylab = "Área de mineração (%)",  names.arg = uph, col = col_bhrd)

plot(fases$perc_ha ~ fases$fs, las = 1, ylim = c(0, 20), xlab = "Fases (DNPM)", ylab = "Área proporcional na BHRD", col = "brown") 
















################################################
# Spliting uph ####
################################################

pg <- fases[1:12, ] # 501: Piranga (MG)
pc <- fases[13:23, ] # 502: Piracicaba (MG)
sa <- fases[24:35, ] # 503: Santo Antonio (MG)
sg <- fases[36:447, ] # 504: Suaçuí Grande (MG)
cr <- fases[48:59, ] # 505: Caratinga (MG)
mn <- fases[60:70, ] # 506: Manhuaçu (MG) 
sj <- fases[71:80, ] # 507: São José (ES)
gd <- fases[81:89, ] # 508: Guandu (ES)
smd <- fases[90:99, ] # 509: Santa Maria do Doce (ES)

#############################
# Exploratory mine fases
# Kele R. Firmiano
# Data: 02/06/2020
#############################

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

# plot fases using whole dataset ####
plot(fases$perc_ha ~ fases$fs, las = 1, ylim = c(0, 20), xlab = "Fases (DNPM)", ylab = "Área proporcional na BHRD", col = "brown") 




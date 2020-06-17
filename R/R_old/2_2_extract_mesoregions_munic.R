#########################################
# SPATIAL EXTRATION IN R 
# extracting mine information to each municipality
# Kele R. Firmiano 
# Date: 20/04/2020                  
########################################

# Loading packages ####
library(rgdal)
library(raster)
library(rgeos) # clip
library(maptools)
library(ggsn) # north arrow and a scale bar 

# Loading shp file ####
munic <-
  readOGR(dsn = "./outputs/reproj_shp",
          layer = "munic_wgs84",
          encoding = 'UTF-8')
mg_bhrd_munic <-
  readOGR(dsn = "./outputs/clip_shp",
          layer = "crop_mg_bhrd_munic",
          encoding = 'UTF-8')
es_bhrd_munic <-
  readOGR(dsn = "./outputs/clip_shp",
          layer = "crop_es_bhrd_munic",
          encoding = 'UTF-8')

# Checking coordinate system ####
crs(munic) 
crs(mg_bhrd_munic) 
crs(es_bhrd_munic) 

# simple plots
plot(munic, axes = TRUE, xlab = "cities within bhrd")

par(mfrow = c(1, 2), mar = c(5, 5, 4, 1))
plot(mg_bhrd_munic, axes = TRUE, xlab = "mg_bhrd_munic")
plot(es_bhrd_munic, axes = TRUE, xlab = "es_bhrd_munic")
dev.off()

# extracting uf, municipality and zone informations ####
df.uf <- data.frame(munic$NOMEUF) # selecting uf
df.munic <- data.frame(munic$NOMEMUNIC) # selecting municipalities
df.reg <- data.frame(munic$NOMEMES) # selecting regions 
df.munic.reg.uf <- cbind(df.munic, df.reg, df.uf) # combining all

# Extracting munic, by mesoregions ####
# JEQUITINHONHA
jec <- c("Angelândia", "Capelinha", "Itamarandiba", "Aricanduva", "Felício dos Santos", "Presidente Kubitschek") 
ext.jec <- munic[munic$NOMEMUNIC %in% jec,] 
writeOGR(ext.jec,"./outputs/clip_reg_shp", "ext.jec", driver = "ESRI Shapefile", overwrite_layer = TRUE)  

# VALE DO MUCURI
muc <- c("Setubinha", "Poté", "Malacacheta", "Frei Gaspar", "Franciscópolis")
ext.muc <- munic[munic$NOMEMUNIC %in% muc,]
writeOGR(ext.muc,"./outputs/clip_reg_shp", "ext.muc", driver = "ESRI Shapefile", overwrite_layer = TRUE) 

#  VALE DO RIO DOCE #### (see mesoregions in the end)
vrd <- c("?gua Boa", "Itambacuri", "S?o Sebasti?o do Maranh?o", "Santa Maria do Suaçuí", "Frei Lagonegro", "Coluna", "S?o José do Jacuri", "Campanário", "José Raydan", " S?o José da Safira", "S?o Pedro do Suaçuí", "Pescador", "Nova Módica", "S?o Jo?o Evangelista", "Peçanha", "Paulistas", "Jampruca", "Virgolândia", "Materlândia", "Frei Inocêncio", "Nacip Raydan", "Marilac", "Cantagalo", "Sabinópolis", "Mendes Pimentel", "S?o Félix de Minas", "Coroaci", "Mathias Lobato", "Governador Valadares", "Divino das Laranjeiras", "Guanh?es", "Virginópolis", "Central de Minas", "Divinolândia de Minas", "Sardoá", "Galiléia", "Gonzaga", "Senhora do Porto", "Santa Efigênia de Minas", "S?o Geraldo da Piedade", "S?o Geraldo do Baixio", "Conselheiro Pena", "Cuparaque", "Braúnas", "Tumiritinga", "Dores de Guanh?es", "Alpercata", "Açucena", "Goiabeira", "Carmésia", "Capit?o Andrade", "Periquito", "Engenheiro Caldas", "Itanhomi", "Fernandes Tourinho", "Resplendor", "Joanésia", "Naque", "Mesquita", "Sobrália", "Tarumirim", "Belo Oriente", "Iapu", "Itueta", "Alvarenga", "S?o Jo?o do Oriente", "Bugre", "Santa Rita do Itueto", "Santana do Paraíso", "Ipaba", "Coronel Fabriciano", "Inhapim", "Dom Cavati", "Ipatinga", "Aimorés", "Antônio Dias", "Pocrane", "Caratinga", "S?o Sebasti?o do Anta", "S?o Domingos das Dores", "Timóteo", "Bom Jesus do Galho", "Vargem Alegre", "Imbé de Minas", "Jaguaraçu", "Marliéria", "Ipanema", "Entre Folha", "Ubaporanga", "Mutum", "Taparuba", "Piedade de Caratinga", "Pingo d'?gua", "Córrego Novo", "Conceiç?o de Ipanema", "Santa Rita de Minas", "Santa Bárbara do Leste")


# vrd <- c("Conselheiro Pena", "Cuparaque", "Goiabeira", "Resplendor", "Itueta", "Alvarenga", "Santa Rita do Itueto", "Pocrane", "Ipanema", "Mutum", "Taparuba", "Aimorés", "Conceiç?o de Ipanema", "Tarumirim", "Iapu", "S?o Jo?o do Oriente", "Bugre", "Ipaba", "Inhapim", "Dom Cavati", "Caratinga", " S?o Sebasti?o do Anta", "S?o Domingos das Dores", "Bom Jesus do Galho", "Vargem Alegre", "Imbé de Minas", "Entre Folhas", "Ubaporanga", "Piedade de Caratinga",  "Pingo d'?gua","Córrego Novo", "Santa Rita de Minas", "Santa Bárbara do Leste", "Itambacuri", "Campanário", "S?o José da Safira", "Pescador", "Nova Módica", "Jampruca", "Virgolândia", "Frei Inocêncio", "Nacip Raydan", "Marilac", "Coroaci", "Mathias Lobato", "Governador Valadares", "Divino das Laranjeiras", "Galiléia", "S?o Geraldo da Piedade", "S?o Geraldo do Baixio", "Tumiritinga", "Alpercata", "Capit?o Andrade", "Engenheiro Caldas", "Itanhomi", "Fernandes Tourinho","Sobrália", "Coluna", "S?o Jo?o Evangelista", "Paulistas", "Materlândia", "Sabinópolis", "Guanh?es", "Virginópolis", "Divinolândia de Minas", "Sardoá", "Gonzaga", "Senhora do Porto", "Santa Efigênia de Minas", "Braúnas", "Dores de Guanh?es", "Carmésia", "Açucena", "Periquito", "Joanésia", "Naque", "Mesquita", "Belo Oriente", "Santana do Paraíso", "Coronel Fabriciano", "Ipatinga", "Antônio Dias", "Timóteo", "Jaguaraçu", "Marliéria", "Mendes Pimentel", "S?o Félix de Minas", "Central de Minas", "?gua Boa", "S?o Sebasti?o do Maranh?o", "Santa Maria do Suaçuí", "Frei Lagonegro", "S?o José do Jacuri", "José Raydan", "S?o Pedro do Suaçuí", "Peçanha", "Cantagalo")
ext.vrd <- munic[munic$NOMEMUNIC %in% vrd,]
writeOGR(ext.vrd.,"./outputs/clip_reg_shp", "ext.vrd.", driver = "ESRI Shapefile", overwrite_layer = TRUE)

# Campo das vertentes ####
c.vertentes <- c("Caranaíba", "Capela Nova", "Carandaí", "Senhora dos Remédios", "Ressaquinha", "Desterro do Melo", "Alfredo Vasconcelos", "Barbacena", "Santa Bárbara do Tugúrio")
ext.c.vertentes <- munic[munic$NOMEMUNIC %in% c.vertentes,]
writeOGR(ext.c.vertentes,"./outputs/clip_reg_shp", "ext.c.vertentes", driver = "ESRI Shapefile", overwrite_layer = TRUE)

# Central espírito-santense  #####
central.es <- c("Itaguaçu", "S?o Roque do Cana?", "Santa Teresa", "Laranja da Terra", "Itarana", "Afonso Claúdio", "Brejetuba", "Santa Maria de Jetibá", "Domingos Martins", "Conceiç?o do Castelo", "Venda Nova do Imigrante")
ext.central.es <- munic[munic$NOMEMUNIC %in% central.es,]
writeOGR(ext.central.es,"./outputs/clip_reg_shp", "ext.central.es", driver = "ESRI Shapefile", overwrite_layer = TRUE)

# Litoral Norte Espírtio-Santense ####
l.norte.es <- c("Sooretama", "Linhares", "Rio Bananal", "Aracruz", "Ibiraçu", "Jo?o Neiva")
ext.l.norte.es <- munic[munic$NOMEMUNIC %in% l.norte.es,]
writeOGR(ext.l.norte.es,"./outputs/clip_reg_shp", "ext.l.norte.es", driver = "ESRI Shapefile", overwrite_layer = TRUE)

# Metropolitana de BH ####
rmbh <- c(" Rio Vermelho", "Serro", "Serra Azul de Minas", "Santo Antônio do Itambé", "Conceiç?o do Mato Dentro", "Alvorada de Minas", "Dom Joaquim", "Ferros", "Morro do Pilar", "Santo Antônio do Rio Abaixo", "Jaboticatubas", "S?o Sebasti?o do Rio Preto", "Santa Maria de Itabira", "Itambé do Mato Dentro", "Passabém", "Itabira", "Nova Uni?o", "Nova Era", "Bom Jesus do Amparo", "S?o Gonçalo do Rio Abaixo", "Caeté", "S?o Domingos do Prata", "Bela Vista de Minas", "Dionísio", "Bar?o de Cocais", "Jo?o Monlevade", "Rio Piracicaba", "S?o José do Goiabal", "Santa Bárbara", "Catas Altas", "Rio Acima", "Alvinópolis", "Itabirito", "Mariana", "Ouro Preto", "Diogo de Vasconcelos", "Ouro Branco", "Conselheiro Lafaiete", "Itaverava", "Catas Altas da Noruega", "Santana dos Montes", "Cristiano Otoni")
ext.rmbh <- munic[munic$NOMEMUNIC %in% rmbh,]
writeOGR(ext.rmbh,"./outputs/clip_reg_shp", "ext.rmbh", driver = "ESRI Shapefile", overwrite_layer = TRUE)

# Noroeste Espírito-Santense ####
nor.es <- c("Nova Venécia", "Barra de S?o Francisco", "Mantenópolis", "Vila Valério", "?guia Branca", "S?o Gabriel da Palha", "Alto Rio Novo", "Pancas", "S?o Domingos do Norte", "Colatina", "Baixo Guandu", "Marilândia")
ext.nor.es <- munic[munic$NOMEMUNIC %in% nor.es,]
writeOGR(ext.nor.es,"./outputs/clip_reg_shp", "ext.nor.es", driver = "ESRI Shapefile", overwrite_layer = TRUE)

# Sul Espírito-Santense ####
sul.es <- c("Muniz Freire", "Iúna", "Ibatiba", "Irupi", "Ibitirama")
ext.sul.es <- munic[munic$NOMEMUNIC %in% sul.es,]
writeOGR(ext.sul.es,"./outputs/clip_reg_shp", "ext.sul.es", driver = "ESRI Shapefile", overwrite_layer = TRUE)

# Zona da Mata ####
zm <- c("Simonésia", "Raul Soares", "S?o Pedro dos Ferros", "Santana do Manhuaçu", "Chalé", "Vermelho Novo", "S?o José do Mantimento", "Rio Casca", "Manhuaçu", "Sem-Peixe", "Dom Silvério", "Lajinha", "Durandé", "Caputira", "Santa Cruz do Escalvado", "Abre Campo", "Rio Doce", "Reduto", "Barra Longa", "Piedade de Ponte Nova", "Martins Soares", "Matipó", "Santo Antônio do Grama", "Urucânia", "Ponte Nova", "S?o Jo?o do Manhuaçu", "Manhumirim", "Santa Margarida", "Acaiaca", "Jequeri", "Pedra Bonita", "Oratórios", "Luisburgo", "Alto Jequitibá", "Caparaó", "Sericita", "Orizânia", "Guaraciaba", "Amparo do Serra", "Divino", "Alto Caparaó", "Piranga", "Pedra do Anta", "Araponga", "Teixeiras", "Porto Firme", "Fervedouro", "Cana?", "S?o Miguel do Anta", "Viçosa", "Presidente Bernardes", "Lamim", "Senhora de Oliveira", "Cajuri", "Miradouro", "Ervália", "Paula Cândido", "Rio Espera", "Brás Pires", "Coimbra", "Senador Firmino", "S?o Geraldo", "Cipotânea", "Muriaé", "Guiricema", "Visconde do Rio Branco", "Dores do Turvo", "Divinésia", "Alto Rio Doce", "Ubá", "Mercês", "Silveirânia", "Tocantins", "Rio Pomba")
ext.zm <- munic[munic$NOMEMUNIC %in% zm,]
writeOGR(ext.zm,"./outputs/clip_reg_shp", "ext.zm", driver = "ESRI Shapefile", overwrite_layer = TRUE)

# plots regions ####
plot(munic, axes = TRUE)
plot(ext.jec, add = TRUE, col = "red", axes = TRUE)
plot(ext.muc, add = TRUE, col = "green", axes = TRUE)
plot(ext.vrd, add = TRUE, col = "yellow", axes = TRUE) # conf 
plot(ext.c.vertentes, add = TRUE, col = "purple", axes = TRUE)
plot(ext.central.es, add = TRUE, col = "gray", axes = TRUE)
plot(ext.l.norte.es, add = TRUE, col = "orange", axes = TRUE)
plot(ext.rmbh, add = TRUE, col = "pink", axes = TRUE) # conf, se ñ achar em vrd
plot(ext.nor.es, add = TRUE, col = "blue", axes = TRUE)
plot(ext.sul.es, add = TRUE, col = "dark green", axes = TRUE) # conf 
plot(ext.zm, add = TRUE, col = "brown", axes = TRUE)
#ggsn::north(munic, scale = .08)


#  VALE DO RIO DOCE + microregions ####
# Aimorés
vrd.aimores <- c("Conselheiro Pena", "Cuparaque", "Goiabeira", "Resplendor", "Itueta", "Alvarenga", "Santa Rita do Itueto", "Pocrane", "Ipanema", "Mutum", "Taparuba", "Aimorés", "Conceiç?o de Ipanema")
ext.vrd.aimores <- munic[munic$NOMEMUNIC %in% vrd.aimores,]
writeOGR(ext.muc,"./outputs/clip_reg_shp", "ext.vrd.aimores", driver = "ESRI Shapefile", overwrite_layer = TRUE) 

# Caratinga
vrd.caratinga <- c("Tarumirim", "Iapu", "S?o Jo?o do Oriente", "Bugre", "Ipaba", "Inhapim", "Dom Cavati", "Caratinga", " S?o Sebasti?o do Anta", "S?o Domingos das Dores", "Bom Jesus do Galho", "Vargem Alegre", "Imbé de Minas", "Entre Folhas", "Ubaporanga", "Piedade de Caratinga",  "Pingo d'?gua","Córrego Novo", "Santa Rita de Minas", "Santa Bárbara do Leste")
ext.vrd.caratinga <- munic[munic$NOMEMUNIC %in% vrd.caratinga,]
writeOGR(ext.vrd.caratinga,"./outputs/clip_reg_shp", "ext.vrd.caratinga", driver = "ESRI Shapefile", overwrite_layer = TRUE) 
# Gov Valadares
vrd.gov.val <- c("Itambacuri", "Campanário", "S?o José da Safira", "Pescador", "Nova Módica", "Jampruca", "Virgolândia", "Frei Inocêncio", "Nacip Raydan", "Marilac", "Coroaci", "Mathias Lobato", "Governador Valadares", "Divino das Laranjeiras", "Galiléia", "S?o Geraldo da Piedade", "S?o Geraldo do Baixio", "Tumiritinga", "Alpercata", "Capit?o Andrade", "Engenheiro Caldas", "Itanhomi", "Fernandes Tourinho","Sobrália")
ext.vrd.gov.val <- munic[munic$NOMEMUNIC %in% vrd.gov.val,]
writeOGR(ext.vrd.gov.val,"./outputs/clip_reg_shp", "ext.vrd.gov.val", driver = "ESRI Shapefile", overwrite_layer = TRUE)

# Guanhaes
vrd.guanhaes <- c("Coluna", "S?o Jo?o Evangelista", "Paulistas", "Materlândia", "Sabinópolis", "Guanh?es", "Virginópolis", "Divinolândia de Minas", "Sardoá", "Gonzaga", "Senhora do Porto", "Santa Efigênia de Minas", "Braúnas", "Dores de Guanh?es", "Carmésia")
ext.vrd.guanhaes <- munic[munic$NOMEMUNIC %in% vrd.guanhaes,]
writeOGR(ext.vrd.guanhaes,"./outputs/clip_reg_shp", "ext.vrd.guanhaes", driver = "ESRI Shapefile", overwrite_layer = TRUE)

# Ipatinga
vrd.ipatinga <- c("Açucena", "Periquito", "Joanésia", "Naque", "Mesquita", "Belo Oriente", "Santana do Paraíso", "Coronel Fabriciano", "Ipatinga", "Antônio Dias", "Timóteo", "Jaguaraçu", "Marliéria")
ext.vrd.ipatinga <- munic[munic$NOMEMUNIC %in% vrd.ipatinga,]
writeOGR(ext.vrd.ipatinga,"./outputs/clip_reg_shp", "ext.vrd.ipatinga", driver = "ESRI Shapefile", overwrite_layer = TRUE)

# Mantena
vrd.mantena <- c("Mendes Pimentel", "S?o Félix de Minas", "Central de Minas")
ext.vrd.mantena <- munic[munic$NOMEMUNIC %in% vrd.mantena,]
writeOGR(ext.vrd.mantena,"./outputs/clip_reg_shp", "ext.vrd.mantena", driver = "ESRI Shapefile", overwrite_layer = TRUE)
















#########################################
# DOWNLOAD BRAZIL MINING DATA
# From Agencia Naciona de Mineracao http://www.anm.gov.br/assuntos/ao-minerador/sigmine
# Kele R. Firmiano & Bruno M. Carvalho
# Date: 19/05/2020
########################################

download.file("http://sigmine.dnpm.gov.br/sirgas2000/Brasil.zip",
              destfile = "./data/DNPM_Brasil.zip")

unzip("./data/DNPM_Brasil.zip", exdir = "./data/DNPM_Brasil")

file.remove("./data/DNPM_Brasil.zip")

# check downloaded file:

#library(rgdal)
#dnpm_br <- readOGR(dsn = "./data/DNPM_Brasil",
#              layer = "BRASIL",
#              encoding = 'UTF-8')
#dnpm_br
#head(dnpm_br)

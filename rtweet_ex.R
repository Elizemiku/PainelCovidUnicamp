library(rtweet)
library(tidyverse)
library(wordcloud2)
library(httpuv)

#Keys de acesso
api_key <- "QVbudD80ms2yc0FyOrzSd74Jq"
api_secret_key <- "G8XGjoY91NoZ42fcweONb9iKmXLe0WkLf8U4ReeK4smDaFnk8x"
access_token <- "143947934-hy5cYTCLZ14rW0UngS23sZeDNMI4TFS28xCDhsqA"
access_token_secret <- "oU1tHKERX7NfrxzVz7jTuoT4YPf1KuLjzcnhp6S4bxvNX"

##authenticate via web browser
token <- create_token(
  app = "PainelCovidUnicamp",
  consumer_key = api_key,
  consumer_secret = api_secret_key,
  access_token = access_token,
  access_secret = access_token_secret)

#Só autentifica 1x, depois pode pular pra essa parte
get_token()

#Governantes
gov <- c("jairbolsonaro", "jdoriajr", "wilsonwitzel")

#Quantas pessoas diferentes falaram isso
#df$user_id %>% unique() %>% length()

google_maps_token <- "AIzaSyCKUhjZ8bDE6cDGiewgrv0WBFBDRRXoi84"

#Procurar por localização (acho que só funciona pra país ou capitais)
sp <- search_tweets("", 
                    geocode = lookup_coords(address = "São Paulo", 
                                            components = "country:Brazil",
                                            apikey = "AIzaSyCKUhjZ8bDE6cDGiewgrv0WBFBDRRXoi84",
                                            n = 100)) 

#Ex: Procurar filtrando Latitude,Longitude,Raio
sp_cidade <- search_tweets("show", 
                           geocode = "-23.55,-46.63,1mi", n = 100)

#Se fossemos plotar um gráfico (em desenvolvimento)
# sp <- lat_lng(sp)
# library(geobr)
# mapa_sp <- read_municipality(code_muni = "SP")
# 
# ggplot() +
#   geom_sf(data = mapa_sp, fill="darkolivegreen4", color="black") + 
#   geom_point(data = sp, aes(x = sp$lat, y = sp$lng), col = "deepskyblue4")+
#   theme_bw()

#Palavras de interesse
dicionario <- c("corona",  "covid", "quarentena", 
                "lockdown", "cloroquina", "casos", 
                "ministros" ,"colapso", "respiradores",
                "isolamento horizontal", "isolamento vertical", "quarentena") 

#Pegar a timeline
b <- get_timeline("jairbolsonaro", n = 15)

#Pegar a coluna com conteúdo de texto
texto <- b$text

#Essa função transforma todas as palavras em palavras escritas com letra minúscula
texto <- str_to_lower(texto)

#Juntando todos os twitters em um só, para a nuvem de palavras
texto2 <- paste(unlist(texto), collapse = " ")

#Criando um dataframe para o wordcloud2
df <- tibble(word = dicionario, freq = str_count(texto2, dicionario))

#(Pesquisar outros argumentos)
wordcloud2(df)




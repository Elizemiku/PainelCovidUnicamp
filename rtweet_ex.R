library(rtweet)
library(tidyverse)
library(wordcloud2)
library(httpuv)

# tutorial
api_key <- "QVbudD80ms2yc0FyOrzSd74Jq"
api_secret_key <- "G8XGjoY91NoZ42fcweONb9iKmXLe0WkLf8U4ReeK4smDaFnk8x"
access_token <- "143947934-hy5cYTCLZ14rW0UngS23sZeDNMI4TFS28xCDhsqA"
access_token_secret <- "oU1tHKERX7NfrxzVz7jTuoT4YPf1KuLjzcnhp6S4bxvNX"

## authenticate via web browser
token <- create_token(
  app = "PainelCovidUnicamp",
  consumer_key = api_key,
  consumer_secret = api_secret_key,
  access_token = access_token,
  access_secret = access_token_secret)

#get_token()

#Governantes
gov <- c("jairbolsonaro", "jdoriajr", "wilsonwitzel")

#Instituições


#Quantas pessoas diferentes falaram isso
#df$user_id %>% unique() %>% length()

#Procurar por localização
sp <- search_tweets("show", geocode = c("52.4", "4.88"), 100)

#Se fossemos plotar um gráfico
sp <- lat_lng(sp)
library(geobr)
mapa_sp <- read_municipality(code_muni = "SP")

ggplot() +
  geom_sf(data = mapa_sp, fill="darkolivegreen4", color="black") + 
  geom_point(data = sp, aes(x = sp$lat, y = sp$lng), col = "deepskyblue4")+
  theme_bw()
 
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

#Frequencia de vezes que uma palavra aparece
str_count(texto, dicionario)

texto2 <- paste(unlist(texto), collapse = " ")

#Criando um dataframe para o wordcloud2

df <- tibble(word = dicionario, freq = str_count(texto2, dicionario))

#Olhar outros argumentos
wordcloud2(df)


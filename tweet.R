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



#Quantas pessoas diferentes falaram isso
#df$user_id %>% unique() %>% length()

google_maps_token <- "AIzaSyCKUhjZ8bDE6cDGiewgrv0WBFBDRRXoi84"




#Ex: Procurar filtrando Latitude,Longitude,Raio

#Palavras de interesse
dicionario <- c("corona", "covid", "quarentena", "lockdown", "cloroquina", "casos", "ministros" ,"colapso",
                "respiradores","isolamento horizontal","isolamento vertical","quarentena","hospital",
                "campanha","isolamento social","distanciamento social","máscara", "epidemia",
                "pandemia","contágio","confinamento","assintomático","OMS","saúde pública",
                "pico","UTI","comorbidade","obesidade","diabete","doenças respiratórias",
                "doenças do coração","cardíacos","diabéticos","pneumonia","vacina",
                "casa","idosos",'"crianças","medidas","economia","Manaus","São Paulo",
                "Rio de Janeiro","febre","dor de cabeça","saudade","luto","mortes","óbitos",
                "aglomeração',"casos graves","suspeita","casos confirmados","testes",
                "subnotificação","solidariedade","doações","cestas básicas","risco","epicentro",
                "comércio","home office","hospitais de campanha","auxílio emergencial","fique em casa",
                "desemprego","empresários","Brasil","China","Itália","Estados Unidos","Espanha",
                "França","suspensão do contrato de trabalho","leitos","países","infecção",
                "contágio","contaminados","países","casos notificados","casos confirmados",
                "casos descartados","pacientes curados","ciência","médicos","medicina",
                "pesquisadores","salário","distanciamento","governadores","dinheiro público",
                "sus","corrupção","responsabilidade","achatamento da curva","estatísticas",
                "mortalidade","letalidade","transporte público","rodízio","lotação","enfermeiros",
                "hidroxicloroquina","gripezinha","clima","cardiovascular","crise sanitária",
                "cloroquina","álcool","lavar as mãos","medidas","caos social","fome","violência doméstica",
                "cidades","favelas","microempresas","microempresário","funcionários","funcionários público",
                "Suécia","depressão","escolas","shoppings","afastamento") 



tweets_brazil <- search_tweets(c("isa","indaiatuba"), 
                           geocode = "-10,-55,600mi", n = 100)

contas <- c("jairbolsonaro","jdoriajr","wilsonwitzel","RomeuZema","EduardoLeite_","costa_rui","
            CarlosMoises","CamiloSantanaCE","PauloCamara40","ratinho_jr","ronaldocaiado","helderbarbalho",
            "FlavioDino","wdiaspi","joaoazevedolins","MauroMendes40","belivaldochagas","Casagrande_ES",
            "RenanFilho_","GovernoAlagoas","gladsoncameli","maurocarlesse","GovernoRO","celmarcosrocha",
            "Reinaldo45psdb","waldezoficial","antoniodenarium","AbrahamWeint","DamaresAlves",
            "PauloGuedesMin","TerezaCrisMS","SF_Moro","tarcisiogdf","OsmarTerra","indaiatubapref",
            "prefpauliniasp","prefsp","sumaresp","pref_sorocaba","jonasdonizette_")

teste <- c("jairbolsonaro","jdoriajr","wilsonwitzel","RomeuZema")
#Palavras de interesse

#Pegar a timeline
get_timeline(teste, n=1000)

#Pegar a coluna com conteúdo de texto
texto <- b$text

#Essa função transforma todas as palavras em palavras escritas com letra minúscula
texto <- str_to_lower(texto)

#Juntando todos os twitters em um só, para a nuvem de palavras
texto2 <- paste(unlist(texto), collapse = " ")

#Criando um dataframe para o wordcloud2
df <- tibble(word = dicionario, freq = str_count(texto2, dicionario))

#(Pesquisar outros argumentos)
nuvem <- wordcloud2(df, size=1.6, color='random-light', backgroundColor="black")
nuvem







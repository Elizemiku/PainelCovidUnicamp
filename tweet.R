library("rtweet")
library("tidyverse")
library("wordcloud2")
library("httpuv")

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


#Ex: Procurar filtrando Latitude,Longitude,Raio

#Palavras de interesse
dicionario <- c("corona", "covid", "quarentena", "lockdown", "cloroquina", "casos", "ministros" ,"colapso",
                "respiradores","isolamento horizontal","isolamento vertical","quarentena","hospital",
                "campanha","isolamento social","distanciamento social","máscara", "epidemia",
                "pandemia","contágio","confinamento","assintomático","OMS","saúde pública",
                "pico","UTI","comorbidade","obesidade","diabete","doenças respiratórias",
                "doenças do coração","cardíacos","diabéticos","pneumonia","vacina",
                "casa","idosos","crianças","medidas","economia","Manaus","São Paulo",
                "Rio de Janeiro","febre","dor de cabeça","saudade","luto","mortes","óbitos",
                "aglomeração","casos graves","suspeita","casos confirmados","testes",
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


contas <- c("jairbolsonaro","jdoriajr","wilsonwitzel","RomeuZema","EduardoLeite_","costa_rui","	
            CarlosMoises","CamiloSantanaCE","PauloCamara40","ratinho_jr","ronaldocaiado","helderbarbalho",	
            "FlavioDino","wdiaspi","joaoazevedolins","MauroMendes40","belivaldochagas","Casagrande_ES",	
            "RenanFilho_","GovernoAlagoas","gladsoncameli","maurocarlesse","GovernoRO","celmarcosrocha",	
            "Reinaldo45psdb","waldezoficial","antoniodenarium","AbrahamWeint","DamaresAlves",	
            "PauloGuedesMin","TerezaCrisMS","SF_Moro","tarcisiogdf","OsmarTerra","indaiatubapref",	
            "prefpauliniasp","prefsp","sumaresp","pref_sorocaba","jonasdonizette_")	

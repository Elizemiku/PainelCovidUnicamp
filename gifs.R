library(transformr)
library(gganimate)
library(magick)

#Shapefile do estado de SP com divisão de municípios
mapa <- read_municipality(code_muni = 35, year = 2018)

#Pegando somente as regiões de saúde
regioes <- covid %>% drop_na() %>% select(nome_drs) %>% unique() %>% unlist() %>% unname()
#Adiciono Santos e São Paulo, pois suas regiões estão como baixada santista e grande São Paulo
regioes <- c(regioes, "Santos", "São Paulo")

#Crio um df com o nome do município + coordenadas
covid_regioes <- covid %>% 
  drop_na() %>% 
  select(Cidade, latitude, longitude) %>% 
  filter(Cidade %in% regioes) %>% 
  unique()

#Crio um df com o total da covid (casos e óbitos) por data e por região.
evolucao_casos <- covid %>% 
  group_by(datahora, nome_drs) %>% 
  summarise(casos_regiao = sum(casos), pop_regiao = sum(pop), obitos_regiao = sum(`óbitos`)) %>%
  ungroup() %>% 
  #Altero o nome das regiões para as referentes cidades antes da junção dos dados
  mutate(nome_drs = replace(nome_drs, nome_drs == "Grande São Paulo", "São Paulo")) %>% 
  mutate(nome_drs = replace(nome_drs, nome_drs == "Baixada Santista", "Santos")) %>% 
  left_join(covid_regioes, by = c("nome_drs" = "Cidade")) %>% 
  drop_na()

#Mapa
cidades <- "1-Araçatuba 2-Araraquara 3-Santos 4-Barretos 5-Bauru 6-Campinas 7-Franca 8-São Paulo \n9-Marília 10-Piracicaba 11-Presidente Prudente 12-Registro 13-Ribeirão Preto \n14-São João da Boa Vista 15-São José do Rio Preto 16-Sorocaba 17-Taubaté"

p <- ggplot(evolucao_casos) + 
  geom_sf(data = mapa, fill = "cyan4", color="black", size=.15, ) +
  geom_point(aes(x = longitude, y = latitude, group = nome_drs, 
                 size = 100000*(casos_regiao/pop_regiao),
                 color = 100000*(casos_regiao/pop_regiao)), alpha = .5) +
  scale_size_continuous(range = c(1, 15)) +
  scale_color_gradient(low = "darkgoldenrod1", high = "brown3")+
  guides(color=guide_legend(title = "Casos por 100.000 hab."), 
         size = guide_legend(title = "Casos por 100.000 hab."))+
  labs(title = "Evolução da Covid-19 em São Paulo", 
       subtitle = "{frame_time}",
       caption = cidades) +
  annotate(geom = "text", 
           x = evolucao_casos$longitude %>% unique(),
           y = evolucao_casos$latitude %>% unique(),
           label = as.character(1:17),
           size = 5) +
  theme_void() +
  theme(plot.title = element_text(size = 16, hjust = 0.5),
        plot.subtitle = element_text(size = 14, hjust = 0.5),
        plot.caption = element_text(size = 12, hjust = 0.5), 
        legend.title = element_text(size = 14),
        legend.text = element_text(size = 12)) +
  shadow_mark() +
  transition_time(datahora)

sp_novos <- covid %>% group_by(datahora) %>% 
  summarise(novos_casos = sum(casos_novos), novos_óbitos = sum(óbitos_novos)) 

estatisticas_moveis <- function(x){
  media = rep(NA, 6)
  for(i in 7:length(x)){
    media = c(media, sum(x[i:(i-6)])/7)
  }
  return(media)
}

sp_novos <- sp_novos %>% mutate(media_casos = estatisticas_moveis(.$novos_casos),
                                media_óbitos = estatisticas_moveis(.$novos_óbitos))

p1 <- ggplot(sp_novos %>% drop_na(), aes(x = datahora)) + 
  geom_line(aes(y = media_casos, color = "Média móvel"), size = 1.5) +
  geom_line(aes(y = novos_casos, color = "Novos casos diários"), alpha = 0.7) +
  theme_bw() +
  transition_reveal(datahora)+
  labs(y = "Notificações",
       title = "Incidência da Covid-19 no estado de SP", 
       subtitle = "{frame_along}",
       caption =  "Para o cálculo da média móvel, soma-se a quantidade de ocorrências no período de sete dias e divide-se o resultado por 7. Fonte: Fundação SEADE") +
  scale_color_manual(values = c("darkred", "darkorange"))+
  theme(plot.title = element_text(size = 16, hjust = 0.5),
      plot.subtitle = element_text(size = 14, hjust = 0.5),
      legend.title = element_blank(),
      legend.text = element_text(size = 12),
      legend.position = "top",
      plot.caption = element_text(size = 11, hjust = 0),
      axis.title.x = element_blank())

p2 <- ggplot(sp_novos %>% drop_na(), aes(x =datahora)) + 
  geom_line(aes(y = media_óbitos, color = "Média móvel"), size = 1.5) +
  geom_line(aes(y = novos_óbitos, color = "Novos óbitos diários"), alpha = 0.7) +
  theme_bw()+
  transition_reveal(datahora)+
  labs(y = "Óbitos",
       title = "Mortes de Covid-19 no estado de SP", 
       subtitle = "{frame_along}",
       caption =  "Para o cálculo da média móvel, soma-se a quantidade de óbitos no período de sete dias e divide-se o resultado por 7. \nFonte: Fundação SEADE") +
  scale_color_manual(values = c("darkviolet", "black"))+
  theme(plot.title = element_text(size = 16, hjust = 0.5),
        plot.subtitle = element_text(size = 14, hjust = 0.5),
        legend.title = element_blank(),
        legend.text = element_text(size = 12),
        legend.position = "top",
        plot.caption = element_text(size = 11, hjust = 0),
        axis.title.x = element_blank())

gif_casos <- animate(p1, start_pause = 5, end_pause = 15, width = 800, heigh = 400)
gif_mortes <- animate(p2, start_pause = 5, end_pause = 15, width = 800, heigh = 400)

anim_save("dados/casos.gif", gif_casos)
anim_save("dados/mortes.gif", gif_mortes)

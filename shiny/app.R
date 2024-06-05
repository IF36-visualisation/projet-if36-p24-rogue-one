library(shiny)
library(shinydashboard)
library(knitr)
library(rmarkdown)
library(ggplot2)
library(dplyr)
library(tidyr)
library(tibble)
library(readr)
library(lubridate)
library(forcats)
library(stringr)
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)

# 安装和加载必要的包
required_packages <- c("shiny", "shinydashboard", "knitr", "rmarkdown", "markdown", "ggplot2", "dplyr", "tidyr", "tibble", "readr", "lubridate", "forcats", "stringr", "sf", "rnaturalearth", "rnaturalearthdata")
new_packages <- required_packages[!(required_packages %in% installed.packages()[,"Package"])]

if(length(new_packages)) install.packages(new_packages)

lapply(required_packages, library, character.only = TRUE)

# 读取RMD文件内容
rmd_file <- "../rogue-one.Rmd"
rmd_content <- readLines(rmd_file, warn = FALSE)

# 提取各部分内容
get_section <- function(rmd_lines, section_title) {
  start <- grep(paste0("^## ", section_title), rmd_lines)
  if (length(start) == 0) {
    return("")
  }
  end <- grep("^## ", rmd_lines[-(1:start)]) + start
  if (length(end) == 0) end <- length(rmd_lines) + 1
  return(paste(rmd_lines[(start+1):(end-1)], collapse = "\n"))
}

intro_text <- get_section(rmd_content, "Introduction")
datasets_text <- get_section(rmd_content, "Données")
stations_text <- get_section(rmd_content, "Analyse des Gares")
passengers_text <- get_section(rmd_content, "Analyse des Voyageurs")
lost_items_text <- get_section(rmd_content, "Analyse des Objets Perdus")
suggestions_text <- get_section(rmd_content, "Suggestions")

# 定义UI
ui <- dashboardPage(
  dashboardHeader(title = "Projet de Visualisation des Données - Réseau Ferroviaire en France"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Introduction", tabName = "introduction", icon = icon("info")),
      menuItem("Données", tabName = "datasets", icon = icon("database")),
      menuItem("Analyse des Gares", tabName = "stations", icon = icon("train")),
      menuItem("Analyse des Voyageurs", tabName = "passengers", icon = icon("user")),
      menuItem("Analyse des Objets Perdus", tabName = "lost_items", icon = icon("search")),
      menuItem("Suggestions", tabName = "suggestions", icon = icon("lightbulb"))
    )
  ),
  dashboardBody(
    tabItems(
      # Introduction
     tabItem(tabName = "introduction",
              h2("Introduction"),
              img(src = "entete-rapportIF36.png", alt = "Entête", style = "width: 100%; max-width: 600px; height: auto;"),
              p("Ce projet a été réalisé dans le cadre du cours Visualisation de Données, au cours du semestre de printemps 2024, à l'Université de Technologie de Troyes."),
              p("Nous avons choisi d'analyser des données originales qui nous permettent de nous interroger sur l'étude du transport ferroviaire en France. Notre analyse portera sur des jeux de données extraits du site de données de la SNCF (Société Nationale des Chemins de fer Français).")
      ),
      # Données
      tabItem(tabName = "datasets",
              h2("Données"),
              img(src = "categories-donnees.png", alt = "Catégories de données SNCF", style = "width: 100%; max-width: 600px; height: auto;"),
              HTML(markdown::renderMarkdown(text = datasets_text))
      ),
      # Analyse des Gares
      tabItem(tabName = "stations",
              h2("Analyse des Gares"),
              img(src = "carte-reseau-sncf-france2020.png", alt = "Réseau ferroviaire en France", style = "width: 100%; max-width: 600px; height: auto;"),
              h3("Fréquentation des gares"),
              p("Cette section présente un aperçu de la fréquentation des gares. Nous avons filtré les gares avec plus de 20.000.000 voyageurs en 2022 pour observer les gares les plus fréquentées."),
              plotOutput("stations_plot"),
              p("On remarque que les gares parisiennes sont les plus fréquentées, notamment Gare du Nord, Gare Saint-Lazare, Gare de Lyon et Gare Montparnasse."),
              img(src = "carte-reseau-sncf.png", alt = "Carte des destinations en France et en Europe", style = "width: 100%; max-width: 600px; height: auto;"),
              p("Figure 1. Carte des destinations en France et en Europe (2022)"),
              h3("Carte de la fréquentation des gares en France Métropolitaine"),
              p("Cette carte montre la répartition de la fréquentation des gares en France Métropolitaine en 2022."),
              plotOutput("stations_map")
      ),
      # Analyse des Voyageurs
      tabItem(tabName = "passengers",
              h2("Analyse des Voyageurs"),
              h3("Nombre de voyageurs total par département (2022)"),
              p("Cette section présente le nombre total de voyageurs par département en 2022."),
              plotOutput("passengers_plot"),
              h3("Répartition du nombre de voyageurs dans les gares d'un même département"),
              p("Cette section analyse la répartition des voyageurs entre les gares d'un même département."),
              plotOutput("age_distribution_plot"),
              h3("Répartition par âge des passagers"),
              p("Cette section explore la répartition des passagers par groupe d'âge pour les années 2015, 2016 et 2017."),
              plotOutput("csp_plot"),
              h3("Catégorie socio-professionnelle"),
              p("Cette section présente la répartition des voyageurs par catégorie socio-professionnelle."),
              plotOutput("yearly_passengers_plot")
      ),
      # Analyse des Objets Perdus
      tabItem(tabName = "lost_items",
              h2("Analyse des Objets Perdus"),
              img(src = "carte-reseau-sncf.png", alt = "Carte des destinations en France et en Europe", style = "width: 100%; max-width: 600px; height: auto;"),
              h3("Objets perdus"),
              p("Cette section présente une analyse des objets perdus en 2019."),
              plotOutput("lost_items_plot"),
              h3("Objets restitués"),
              p("Cette section présente une analyse des objets restitués en 2019."),
              plotOutput("returned_items_plot"),
              h3("Probabilité de retrouver un objet perdu"),
              p("Cette section calcule la probabilité de retrouver un objet perdu en fonction des données disponibles."),
              plotOutput("lost_items_monthly_plot")
      ),
      # Suggestions
      tabItem(tabName = "suggestions",
              h2("Suggestions"),
              HTML(markdown::renderMarkdown(text = suggestions_text))
      )
    )
  ),
  skin = "purple"
)

# 定义服务器逻辑
server <- function(input, output) {
  # 数据清洗
  gares <- read_delim(file = "www/data/dataset1-gares-de-voyageurs.csv", delim=";")
  frequentation <- read_delim(file = "www/data/dataset2-frequentation-gares.csv", delim=";")
  motif_depl <- read_delim(file = "www/data/dataset3-motif-deplacement.csv", delim=";")
  CSP_voya <- read_delim(file = "www/data/dataset4-enquetes-gares-connexions-repartition-par-repartition-par-categories-socio-profe.csv", delim=";")
  age_voya <- read_delim(file = "www/data/dataset5-enquetes-gares-connexions-repartition-repartition-par-classe-dage.csv", delim=";")
  obj_perdus <- read_delim(file = "www/data/dataset6-objets-trouves-gares.csv", delim=";")
  obj_trouves <- read_delim(file = "www/data/dataset7-objets-trouves-restitution.csv", delim=";")
  
  gares_clean <- gares %>%
    separate("Position géographique", into = c("Latitude", "Longitude"), sep = ", ") %>%
    mutate(across(c(Latitude, Longitude), as.numeric)) %>%
    rename(Gare = "Nom", Code_Postal = "Code commune", Zones_vac = "Segment DRG")
  
  frequentation_clean <- frequentation %>%
    rename_with(.cols = contains("Non"), 
                ~ sub('Total Voyageurs \\+ Non voyageurs', "Personnes", .))%>%
    rename_with(.cols = contains("Total"), 
                ~ sub('Total Voyageurs', "Voyageurs", .))%>%
    pivot_longer(cols = starts_with("Personnes") | starts_with("Voyageurs"), 
                 names_to = c(".value", "Année"), 
                 names_sep = " ")%>%
    mutate(Année = as.numeric(Année))%>%
    rename(Gare = "Nom de la gare", UIC = "Code UIC", Code_Postal = "Code postal", Zones_vac = "Segmentation DRG")%>%
    mutate(UIC = as.character(UIC)) %>%
    mutate(UIC = substr(UIC, 3, 8)) %>%
    mutate(Département = substr(Code_Postal, 1, 2))
  
  age_voya_clean <- age_voya %>%
    rename(Gare = `Gare enquêtée`)%>%
    mutate(UIC = as.character(UIC))
  
  gares_freq_clean <- gares_clean %>% 
    inner_join(frequentation_clean, by = "Gare")
  france <- ne_countries(scale="medium", country = "France", returnclass="sf")%>%
    st_crop(xmin = -5.2, xmax = 9.7, ymin = 41, ymax = 51)  # Limites de la France métropolitaine
  
  obj_perdus_clean <- obj_perdus %>%
    rename(date = "Date de la déclaration de perte", UIC = "Code UIC", gare = "Gare", nature = "Nature d'objets", type = "Type d'objets", enregistrement = "Type d'enregistrement")
  
  obj_trouves_clean <- obj_trouves %>%
    rename(date = "Date", date_restit = "Date et heure de restitution", gare = "Gare", UIC = "Code UIC", nature = "Nature d'objets", type = "Type d'objets", enregistrement = "Type d'enregistrement")
  
  # 绘图代码
  output$stations_plot <- renderPlot({
    freq <- frequentation_clean %>%
      select(Gare, Voyageurs, Année) %>%
      filter(Voyageurs > 20000000) %>%
      filter(Année == "2022")
    
    ggplot(data = freq, mapping = aes(x=Voyageurs, y=Gare)) +
      geom_point() +
      xlim(20000000,250000000) +
      theme_minimal() +
      labs(title = "Fréquentation par gare (2022)",
           subtitle = "< minimum 20.000.000 de voyageurs >",
           x = "Nombre de voyageurs",
           y = "Gares")
  })
  
  output$stations_map <- renderPlot({
    france <- ne_countries(scale="medium", country = "France", returnclass="sf") %>%
      st_crop(xmin = -5.2, xmax = 9.7, ymin = 41, ymax = 51)  # Limites de la France métropolitaine
    
    gares_2022 <- gares_freq_clean %>%
      filter(Année == "2022")
    
    ggplot(data = france) +
      geom_sf(fill = "white", color = "black") +
      geom_point(data = gares_freq_clean, aes(x = Longitude, y = Latitude, size=Voyageurs), color = "peachpuff4", alpha = 0.7) +
      scale_size_continuous(range = c(1,8)) +
      theme_minimal() +
      labs(title = "Fréquentation par gare (2022)",
           x = "Longitude",
           y = "Latitude",
           size = "Fréquentation")
  })
  
  output$passengers_plot <- renderPlot({
    freq_departement <- frequentation_clean %>%
      filter(Année == "2022")
    
    freq_departement <- freq_departement %>%
      group_by(Département) %>%
      summarize(Total_passagers = sum(Voyageurs))
    
    ggplot(freq_departement, aes(x = Total_passagers, y = Département)) +
      geom_bar(stat = "identity") +
      labs(title = "Nombre de voyageurs total par département (2022)",
           subtitle = "<Vue Globale>",
           x = "Nombre total de passagers",
           y = "Département") +
      theme(axis.text.y = element_text(size = 8))
  })
  
  output$age_distribution_plot <- renderPlot({
    age_filtered <- age_voya_clean %>%
      select(-Gare) %>%
      filter(Année %in% c(2015, 2016, 2017))
    
    joined_dataset <- inner_join(age_filtered, frequentation_clean, join_by(UIC, Année))
    cleaned_dataset <- joined_dataset %>%
      pivot_wider(names_from = `Classe d'âge`, values_from = Pourcentage, values_fill = list(Pourcentage = 0))
    
    age_columns <- c('19 ans et moins', '20 ans à 29 ans', '30 ans à 39 ans', '40 ans à 49 ans', '50 ans à 59 ans', '60 ans et plus')
    cleaned_dataset <- cleaned_dataset %>%
      mutate(across(all_of(age_columns), ~ .x * Voyageurs / 100, .names = "passengers_{.col}"))
    age_passenger_totals <- cleaned_dataset %>%
      group_by(Année) %>%
      summarise(across(starts_with("passengers"), sum, .names = "total_{.col}"))
    
    age_passenger_totals_long <- age_passenger_totals %>%
      pivot_longer(cols = starts_with("total_passengers"), names_to = "Age_Group", values_to = "Total_Passengers", names_prefix = "total_passengers_")
    age_passenger_totals_long <- age_passenger_totals_long %>%
      group_by(Année) %>%
      mutate(Total_Passengers_Year = sum(Total_Passengers)) %>%
      ungroup() %>%
      mutate(Percentage = (Total_Passengers / Total_Passengers_Year) * 100)
    
    ggplot(age_passenger_totals_long, aes(x = Année, y = Percentage, fill = Age_Group)) +
      geom_bar(stat = "identity", position = "dodge") +
      labs(title = "Pourcentage de passagers par groupe d'âge et année",
           x = "Année",
           y = "Pourcentage (%)",
           fill = "Groupes d'âge") +
      theme_minimal()
  })
  
  output$csp_plot <- renderPlot({
    profil_moyen <- CSP_voya %>%
      group_by(CSP) %>%
      summarise(Pourcentage_moyen = mean(Pourcentage, na.rm = TRUE))
    
    profil_moyen <- profil_moyen %>%
      arrange(desc(Pourcentage_moyen))
    
    ggplot(profil_moyen, aes(x = reorder(CSP, -Pourcentage_moyen), y = Pourcentage_moyen)) +
      geom_bar(stat = "identity") +
      coord_flip() +
      labs(title = "Profil Moyen du Voyageur SNCF par CSP",
           x = "Catégorie Socio-Professionnelle",
           y = "Pourcentage Moyen") +
      theme_minimal()
  })
  
  output$yearly_passengers_plot <- renderPlot({
    total_par_annee <- frequentation_clean %>%
      group_by(Année) %>%
      summarise(Total = sum(Voyageurs, na.rm = TRUE))
    
    ggplot(total_par_annee, aes(x = Année, y = Total)) +
      geom_line() +
      geom_point() +
      labs(title = "Nombre total de voyageurs par année",
           x = "Année",
           y = "Nombre total de voyageurs") +
      theme_minimal()
  })
  
  output$lost_items_plot <- renderPlot({
    obj_perdus_2019 <- obj_perdus_clean %>%
      filter(date < ymd(20200101)) %>% 
      filter(date > ymd(20190101))
    
    obj_perdus_2019 %>% 
      ggplot(aes(y=fct_rev(fct_infreq(type)))) +
      geom_bar() +
      labs(title = "Nombre d'objets perdus par type d'objets en 2019",
           y = "Type d'objet",
           x = "Nombre d'objets perdus en unité") +
      theme_minimal() +
      theme(axis.text.y = element_text(size = rel(0.8)))
  })
  
  output$returned_items_plot <- renderPlot({
    obj_trouves_2019 <- obj_trouves_clean %>%
      filter(date < ymd(20200101)) %>% 
      filter(date > ymd(20190101))
    
    obj_trouves_2019 %>% 
      ggplot(aes(y=fct_rev(fct_infreq(type)))) +
      geom_bar() +
      labs(title = "Nombre d'objets perdus retrouvés par type d'objets en 2019",
           y = "Type d'objet",
           x = "Nombre d'objets perdus en unité") +
      theme_minimal() +
      theme(axis.text.y = element_text(size = rel(0.8)))
  })
  
  output$lost_items_monthly_plot <- renderPlot({
    obj_perdus_date <- obj_perdus_clean %>% 
      select(date) %>%
      mutate(date = as.Date(date))
    obj_perdus_date2 <- obj_perdus_date %>%  
      mutate(datem = format(as.Date(date), "%m")) %>%
      filter(year(date) > 2014) %>%
      filter(year(date) != 2024)
    
    obj_perdus_date2 %>%
      ggplot(aes(x=datem, fill=after_stat(count))) +
      facet_grid(rows = vars(year(date))) +
      geom_bar() +
      scale_fill_continuous(type = "viridis", option ="turbo") +
      labs(title = "Nombre d'objets perdus par mois et par année",
           y = "Nombre d'objets perdus",
           x = "Mois") +
      theme_minimal() +
      theme(plot.title = element_text(size = rel(2)), axis.text.y = element_text(size = rel(0.5)))
  })
}

# 运行应用程序
shinyApp(ui, server)

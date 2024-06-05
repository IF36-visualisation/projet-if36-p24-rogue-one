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

gares <- read_delim(file = "../data/dataset1-gares-de-voyageurs.csv", delim=";")
frequentation <- read_delim(file = "../data/dataset2-frequentation-gares.csv", delim=";")
motif_depl <- read_delim(file = "../data/dataset3-motif-deplacement.csv", delim=";")
CSP_voya <- read_delim(file = "../data/dataset4-enquetes-gares-connexions-repartition-par-repartition-par-categories-socio-profe.csv", delim=";")
age_voya <- read_delim(file = "../data/dataset5-enquetes-gares-connexions-repartition-repartition-par-classe-dage.csv", delim=";")
obj_perdus <- read_delim(file = "../data/dataset6-objets-trouves-gares.csv", delim=";")
obj_trouves <- read_delim(file = "../data/dataset7-objets-trouves-restitution.csv", delim=";")


gares_clean <- gares %>%
  separate("Position géographique", into = c("Latitude", "Longitude"), sep = ", ") %>%
  mutate(across(c(Latitude, Longitude), as.numeric)) %>%
  rename(Gare = "Nom", Code_Postal = "Code commune", Zones_vac = "Segment DRG")

frequentation_clean <- frequentation %>%
  rename_with(.cols = contains("Non"), 
              ~ sub('Total Voyageurs \\+ Non voyageurs', "Personnes", .)) %>%
  rename_with(.cols = contains("Total"), 
              ~ sub('Total Voyageurs', "Voyageurs", .)) %>%
  pivot_longer(cols = starts_with("Personnes") | starts_with("Voyageurs"), 
               names_to = c(".value", "Année"), 
               names_sep = " ") %>%
  mutate(Année = as.numeric(Année)) %>%
  rename(Gare = "Nom de la gare", UIC = "Code UIC", Code_Postal = "Code postal", Zones_vac = "Segmentation DRG") %>%
  mutate(UIC = as.character(UIC)) %>%
  mutate(UIC = substr(UIC, 3, 8)) %>%
  mutate(Département = substr(Code_Postal, 1, 2))

age_voya_clean <- age_voya %>%
  rename(Gare = `Gare enquêtée`) %>%
  mutate(UIC = as.character(UIC))

gares_freq_clean <- gares_clean %>% 
  inner_join(frequentation_clean, by = "Gare")

france <- ne_countries(scale = "medium", country = "France", returnclass = "sf") %>%
  st_crop(xmin = -5.2, xmax = 9.7, ymin = 41, ymax = 51)  # Limites de la France métropolitaine

obj_perdus_clean <- obj_perdus %>%
  rename(date = "Date de la déclaration de perte", UIC = "Code UIC", gare = "Gare", nature = "Nature d'objets", type = "Type d'objets", enregistrement = "Type d'enregistrement")

obj_trouves_clean <- obj_trouves %>%
  rename(date = "Date", date_restit = "Date et heure de restitution", gare = "Gare", UIC = "Code UIC", nature = "Nature d'objets", type = "Type d'objets", enregistrement = "Type d'enregistrement")

ui <- dashboardPage(
  dashboardHeader(title = "Projet de Visualisation des Données - Réseau Ferroviaire en France"),
  dashboardSidebar(
    width = 250,  
    sidebarMenu(
      menuItem("Frequentation regions", tabName = "regions", icon = icon("map")),
      menuItem("Frequentation gares", tabName = "gares", icon = icon("train")),
      menuItem("Objets", tabName = "objets", icon = icon("object-group"))
    ),
    sliderInput("annees", "Années:", min = 2015, max = 2022, value = 2015, step = 1, width = '100%')
  ),
  dashboardBody(
    tags$head(
      tags$style(HTML("
        .box {
          height: calc(100vh - 80px);
        }
        #bigMap, #zoomMap {
          height: calc(100vh - 130px) !important;
        }
      "))
    ),
    tabItems(
      tabItem(tabName = "regions",
              fluidRow(
                column(width = 7,  
                       box(width = NULL, plotOutput("bigMap"))
                ),
                column(width = 5,  
                       selectInput("region", "Région:",
                                   choices = list(
                                     "Auvergne-Rhône-Alpes" = "Auvergne-Rhône-Alpes",
                                     "Bourgogne-Franche-Comté" = "Bourgogne-Franche-Comté",
                                     "Bretagne" = "Bretagne",
                                     "Centre-Val de Loire" = "Centre-Val de Loire",
                                     "Grand Est" = "Grand Est",
                                     "Hauts-de-France" = "Hauts-de-France",
                                     "Île-de-France" = "Île-de-France",
                                     "Normandie" = "Normandie",
                                     "Nouvelle-Aquitaine" = "Nouvelle-Aquitaine",
                                     "Occitanie" = "Occitanie",
                                     "Pays de la Loire" = "Pays de la Loire",
                                     "Provence-Alpes-Côte d'Azur" = "Provence-Alpes-Côte d'Azur"
                                   ),
                                   selected = "Île-de-France"),
                       box(width = NULL, plotOutput("zoomMap"))
                )
              )
      ),
      tabItem(tabName = "gares",
              fluidRow(
                column(width = 8,  # 占比60%（8/12）
                       box(width = NULL, plotOutput("barPlot", height = "calc(100vh - 130px)"))
                ),
                column(width = 4,  # 占比40%（4/12）
                       sliderInput("min_passagers", "Nombre minimum de passagers:", min = 0, max = 100000000, value = 100000, step = 10000, width = '100%')
                )
              )
      ),
      tabItem(tabName = "objets",
              fluidRow(
                column(width = 4,
                       selectInput("type_objet", "Type d'objets:", 
                                   choices = unique(obj_perdus_clean$type), 
                                   selected = unique(obj_perdus_clean$type)[1], 
                                   multiple = TRUE)
                ),
                column(width = 8,
                       box(width = NULL, plotOutput("objetsPlot", height = "calc(100vh - 130px)"))
                )
              )
      )
    )
  )
)

server <- function(input, output) {
  url <- "https://raw.githubusercontent.com/gregoiredavid/france-geojson/master/departements-version-simplifiee.geojson"
  departements_geojson <- st_read(url)
  
  # Define regions and corresponding departments
  regions <- list(
    "Auvergne-Rhône-Alpes" = c("01", "03", "07", "15", "26", "38", "42", "43", "63", "69", "73", "74"),
    "Bourgogne-Franche-Comté" = c("21", "25", "39", "58", "70", "71", "89", "90"),
    "Bretagne" = c("22", "29", "35", "56"),
    "Centre-Val de Loire" = c("18", "28", "36", "37", "41", "45"),
    "Grand Est" = c("08", "10", "51", "52", "54", "55", "57", "67", "68", "88"),
    "Hauts-de-France" = c("02", "59", "60", "62", "80"),
    "Île-de-France" = c("75", "77", "78", "91", "92", "93", "94", "95"),
    "Normandie" = c("14", "27", "50", "61", "76"),
    "Nouvelle-Aquitaine" = c("16", "17", "19", "23", "24", "33", "40", "47", "64", "79", "86", "87"),
    "Occitanie" = c("09", "11", "12", "30", "31", "32", "34", "46", "48", "65", "66", "81", "82"),
    "Pays de la Loire" = c("44", "49", "53", "72", "85"),
    "Provence-Alpes-Côte d'Azur" = c("04", "05", "06", "13", "83", "84")
  )
  
  output$bigMap <- renderPlot({
    req(input$annees)
    freq_departement <- frequentation_clean %>%
      filter(Année == input$annees) %>%
      group_by(Département) %>%
      summarize(Total_passagers = sum(Voyageurs, na.rm = TRUE))
    
    departements_data <- departements_geojson %>%
      rename(Département = "code") %>%
      left_join(freq_departement, by = "Département")
    
    ggplot(data = departements_data) +
      geom_sf(aes(fill = Total_passagers), color = "grey50", size = 0.1) +
      scale_fill_viridis_c(option = "turbo", na.value = "black", name = "Passagers") +
      labs(title = paste("Fréquentation des gares par département en France (", input$annees, ")", sep = "")) +
      theme_minimal() +
      theme(legend.position = "right")
  })
  
  output$zoomMap <- renderPlot({
    req(input$annees, input$region)
    freq_departement <- frequentation_clean %>%
      filter(Année == input$annees) %>%
      group_by(Département) %>%
      summarize(Total_passagers = sum(Voyageurs, na.rm = TRUE))
    
    departements_data <- departements_geojson %>%
      rename(Département = "code") %>%
      filter(Département %in% regions[[input$region]]) %>%
      left_join(freq_departement, by = "Département")
    
    ggplot(data = departements_data) +
      geom_sf(aes(fill = Total_passagers), color = "grey50", size = 0.1) +
      scale_fill_viridis_c(option = "turbo", na.value = "white", name = "Passagers") +
      labs(title = paste("Fréquentation des gares de ", input$region, " (", input$annees, ")", sep = "")) +
      theme_minimal() +
      theme(legend.position = "right")
  })
  
  output$barPlot <- renderPlot({
    req(input$annees, input$min_passagers)
    freq_departement <- frequentation_clean %>%
      filter(Année == input$annees) %>%
      group_by(Département) %>%
      summarize(Total_passagers = sum(Voyageurs, na.rm = TRUE)) %>%
      filter(Total_passagers >= input$min_passagers)
    
    ggplot(freq_departement, aes(x = Total_passagers, y = reorder(Département, Total_passagers))) +
      geom_bar(stat = "identity") +
      labs(title = paste("Nombre de voyageurs total par département (", input$annees, ")", sep = ""),
           subtitle = "<Vue Globale>",
           x = "Nombre total de passagers",
           y = "Département") +
      theme(axis.text.y = element_text(size = 8))
  })
  output$objetsPlot <- renderPlot({
    req(input$type_objet, input$annees)
    
    obj_perdus_date <- obj_perdus_clean %>%
      select(date, type) %>%
      mutate(date = as.Date(date)) %>%
      filter(type %in% input$type_objet) %>%
      filter(year(date) == input$annees)
    
    ggplot(obj_perdus_date, aes(x = format(date, "%m"), fill = after_stat(count))) +
      geom_bar() +
      scale_fill_continuous(type = "viridis", option = "turbo") +
      labs(title = paste("Nombre d'objets perdus par mois en ", input$annees),
           y = "Nombre d'objets perdus",
           x = "Mois") +
      theme_minimal() +
      theme(
        plot.title = element_text(size = rel(2)),
        axis.text.y = element_text(size = rel(0.5))
      )
  })
}

shinyApp(ui = ui, server = server)

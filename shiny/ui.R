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

dashboardPage(
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
                column(width = 8,  
                       box(width = NULL, plotOutput("barPlot", height = "calc(100vh - 130px)"))
                ),
                column(width = 4,  
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

[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-24ddc0f5d75046c5622901739e7c5dd533143b0c8e959d652212380cedb1ea36.svg)](https://classroom.github.com/a/Fj4cXJY4)
# Introduction

Nous avons décidés de nous concentrer sur les données récoltées par l'entreprise __SNCF__, entreprise ferroviaire française.
Les données récoltées sur le transport sont assez importantes c'est pourquoi nous avons choisi de nous concentrer sur les gares et leurs données liées ainsi que les données de perte et vol et des voyageurs.
Ces données sont toutes archivées sur le site web : [Data SCNF](https://data.sncf.com)


## Données

17 variables.

|--- | Nom de la variable | Type | Format | Dataset (Origine) |
|--- |--- |--- |--- |--- |
|01 | gare | Nominale | String | 1,2,3,4,5,6,7 |
|02 | departement | Ordinale | NN | 1 |
|03 | zone | Nominale | {A,B,C} | 1 | 
|04 | latitude | Continue | M"S'NS | 1 |
|05 | longitude | Continue | M"S'NS | 1 |
|06 | annee | Ordinale | YYYY | 2,3,4 |
|07 | timing_reception | Discrète | YYYY-MM-DD-HH-MM-SS | 6,7 |
|08 | nb_voyageurs | Discrète | Integer | 2 |
|09 | age | Ordinale | String | 5 |
|10 | pourcentage_csp | Continue | % | 5 |
|11 | csp | Nominale | String | 4 |
|12 | pourcentage_csp | Continue | % | 4 |
|13 | motif_deplacement | Nominale | String | 3 |
|14 | pourcentage_deplacement | Continue | % | 3 |
|15 | nature_objet | Nominale | String | 6,7 |
|16 | categorie_objet | Nominale | String | 6,7 |
|17 | code_uic | Nominale | NNNNNNNNNN | 6,7 |


**Nombre d'observations**
+ dataset1-gares-de-voyageurs.csv (2.862)
+ dataset2-frequentation-gares.csv (21.147)
+ dataset3-motif-deplacement.csv (284) 
+ datset4-enquetes-gares-connexions-repartition-par-repartition-par-categories-socio-profe.csv (697)
+ datset5-enquetes-gares-connexions-repartition-repartition-par-classe-dage.csv (375)
+  dataset6-objets-trouves-gares (1.844.912)
+  dataset7-objets-trouves-restitution (858.180)


## Plan d'analyse
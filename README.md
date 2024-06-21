[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-24ddc0f5d75046c5622901739e7c5dd533143b0c8e959d652212380cedb1ea36.svg)](https://classroom.github.com/a/Fj4cXJY4)


![](images/entete-rapportIF36.png "Entête")

# Introduction

Ce projet a été réalisé dans le cadre du cours **Visualisation de données**, au cours du semestre de **printemps 2024**, à **l'Université de Technologie de Troyes**.

Pour cette étude, nous avons choisi d'analyser des données originales qui nous permettent de nous interroger sur **l'étude du transport ferroviaire en France**. Notre analyse portera sur des jeux de données extraits du site de données de la SNCF (Société Nationale des Chemins de fer Français) [Data SNCF](https://data.sncf.com). L'ensemble des données qui vont donc être traitées dans ce projet proviennent donc toutes de cette source. Nous n'avons donc pas utilisé de jeux de données extérieurs à ce site.

Les données récoltées sur le transport sont assez importantes c'est pourquoi nous avons choisi de nous concentrer sur une découverte avec un spectre assez large, allant des voyageurs aux objets perdus. Nous utiliserons les données des gares, des voyageurs et des objets perdus/retrouvés. Cette étude permettra de déterminer et de comprendre des tendances clés associées au trafic ferroviaire sur des périodes allant de 2017 à 2022.

L'objectif de ce projet est de fournir des interprétations basées sur les visualisations issues d'une analyse exploratoire de nos jeux de données (7 jeux de données). 

## Données

Nous avons donc choisi d'étudier sept jeux de données (7) issues du site [Data SNCF](https://data.sncf.com). Ce sont des données collectées par la SNCF parmi les différentes catégories disponible sur le site (voir ci-dessous).

![](images/categories-donnees.png "Catégories de données SNCF")

Ces données concernent des objets possedés par la SNCF (gares, objets) mais aussi des enquêtes réalisées sur des individus anonymement (fréquentation, voyageurs). Les données sont liées à une période temporelle précise de **2017 à 2022**.

> L'ensemble des données brutes sont accessibles depuis le dossier /data.

**Nombre d'observations**

Le nombre d'observations varie selon chaque jeu de données. Pour plus de détail, nous avons détaillé précisement le nombre d'observations dont nous disposions.

| --- | Nom du dataset                                                                                | Nombre d'observations | Lien                                                                                                     | Description                                  |
| --- | --------------------------------------------------------------------------------------------- | --------------------- |-------------------------------------------------------------------------------------------------------- | ----------------------------------------------- |
| 01  | dataset1-gares-de-voyageurs.csv                                                               | 2.862                 | [Dataset1](https://data.sncf.com/explore/dataset/gares-de-voyageurs/export/)                                                                      | Jeu de données sur les gares de voyageurs       |
| 02  | dataset2-frequentation-gares.csv                                                              | 21.147                | [Dataset2](https://data.sncf.com/explore/dataset/frequentation-gares/export/)                                                                     | Jeu de données sur la fréquentation des gares   |
| 03  | dataset3-motif-deplacement.csv                                                                | 284                   | [Dataset3](https://data.sncf.com/explore/dataset/motif-deplacement/export/)                                                                       | Jeu de données sur les motifs de déplacement    |
| 04  | dataset4-enquetes-gares-connexions-repartition-par-repartition-par-categories-socio-profe.csv | 697                   | [Dataset4](https://data.sncf.com/explore/dataset/enquetes-gares-connexions-repartition-par-repartition-par-categories-socio-profe/export/)        | Jeu de données sur les CSP des voyageurs        |
| 05  | dataset5-enquetes-gares-connexions-repartition-repartition-par-classe-dage.csv                | 375                   | [Dataset5](https://data.sncf.com/explore/dataset/enquetes-gares-connexions-repartition-repartition-par-classe-dage/export/)                       | Jeu de données sur l'âge des voyageurs          |
| 06  | dataset6-objets-trouves-gares.csv                                                             | 1.844.912             | [Dataset6](https://data.sncf.com/explore/dataset/objets-trouves-gares/export/)                                                                    | Jeu de données sur les objets trouvés en gare   |
| 07  | dataset7-objets-trouves-restitution.csv                                                       | 858.180               | [Dataset7](https://data.sncf.com/explore/dataset/objets-trouves-restitution/export/)                                                              | Jeu de données sur les objets restitués         |


Au sein de ces données nous constatons que toutes s'orchestrent autour d'une donnée principale (Gare, 01) qui est présent dans tous les datasets. Nous pouvons donc segmenter les données restantes par des critères géographiques (02,03,04,05), des critères temporels (06,07), des critères voyageurs (08,09,10,11,12,13,14) et des critères sur les objets perdus/trouvés (15,16,17).

**Variables**

Nous avons décidé d'utiliser **17 variables** pour notre projet provenant des jeux de données bruts ou alors d'attributs crées par nos soins.

| --- | Nom de la variable      | Type     | Format              | Dataset (Origine) | Description                                                    |
| --- | ----------------------- | -------- | ------------------- | ----------------- | -------------------------------------------------------------- |
| 01  | gare                    | Nominale | String              | 1,2,3,4,5,6,7     | Nom de la gare                                                 |
| 02  | departement             | Ordinale | NN                  | 1                 | Numéro du département                                          |
| 03  | zone                    | Nominale | {A,B,C}             | 1                 | Lettre correspondant à la zone géographique                    |
| 04  | latitude                | Continue | M"S'NS              | 1                 | Latitude de l'objet gare                                       |
| 05  | longitude               | Continue | M"S'NS              | 1                 | Longitude de l'objet gare                                      |
| 06  | annee                   | Ordinale | YYYY                | 2,3,4             | Année correspondante                                           |
| 07  | timing_reception        | Discrète | YYYY-MM-DD-HH-MM-SS | 6,7               | Réception de l'objet perdu                                     |
| 08  | nb_voyageurs            | Discrète | Integer             | 2                 | Nombre de voyageurs                                            |
| 09  | age                     | Ordinale | String              | 5                 | Age d'un voyageur                                              |
| 10  | pourcentage_age         | Continue | %                   | 5                 | Pourcentage sur l'âge des voyageurs                            |
| 11  | csp                     | Nominale | String              | 4                 | Catégorie socio-professionnel d'un voyageur                    |
| 12  | pourcentage_csp         | Continue | %                   | 4                 | Pourcentage sur la catégorie socio-professionnel des voyageurs |
| 13  | motif_deplacement       | Nominale | String              | 3                 | Motif de déplacement d'un voyageur                             |
| 14  | pourcentage_deplacement | Continue | %                   | 3                 | Pourcentage sur le motif de déplacement des voyageurs          |
| 15  | nature_objet            | Nominale | String              | 6,7               | Nature de l'objet                                              |
| 16  | categorie_objet         | Nominale | String              | 6,7               | Catégorie de l'objet                                           |
| 17  | code_uic                | Nominale | NNNNNNNNNN          | 6,7               | Code UIC de la gare                                            |

**Variables particulières**

Notre jeu de données comprenant des coordonnées spatiales, nous avons estimé qu'il était intéressant de réaliser des cartes. En effet, les coordonnées géographiques de longitude et latitude pourront être utilisée pour catographier le réseau des gares françaises.

L'ensemble des données énoncées plus en haut nous paraissent pertinentes dans le cadre d'une étude. En effet, elles permettent :

- d'étudier les effets de la fréquentation sur les vols/pertes d'objets
- d'effectuer une analyse temporelle et spatiale du réseau
- d'effectuer des classements et des comparaisons entre les différentes régions et/ou départements (analyse multiscalaire). Exemple : espace moins déservi par exemple.


## Plan d'analyse

1. **Découverte du jeu de données** et surtout comprendre à quoi servent nos données. Par exemple : nous souhaitons réaliser des visualisations sur le réseau ferroviaire actuel, étudier la répartition générale des voyageurs...
    > A quoi ressemble le réseau SNCF en France ? Quels sont les départements les mieux équipés ? A quel point Paris a une place importante dans le réseau des autres territoires ?
2. **Analyse des voyageurs** : De façon plus précise, nous étudierons les voyageurs qui utilisent quotidiennement les réseaux ferrés français. Cela passera notamment par des attributs d'âge, de CSP ou encore de motif de déplacement.
    > Le nombre de voyageurs est-il bien repartis entre les gares d'un même département ? Quel est le voyageur moyen de la SNCF ? Comment ce voyageur diffère en fonction des gares ? Quel est la relation entre les motifs de voyage des passagers et leur répartition par âge et par profession ?
3. **Analyse des objets** : De la même façon, nous souhaiterions étudier les objets perdus en gares. Pour cela, nous utiliserons également un second jeu de données sur les objets retrouvés.
    > Y-a-t-il plus de chances de perdre un objet selon la gare ? Doit-on s'attendre à un afflux d'objets perdus plus important dans les mois de Juillet-Août 2024 plus important que les dernières années ? Quelles sont les chances de retrouver un objet perdu ? Quelles sont les chances de retrouver un objet en fonction de sa nature ?
4. **Analyse spatiale** : A l'aide de nos données spatiales, nous souhaitons réaliser des cartes. Ces dernières permettront visuellement de voir la disposition et la répartition des gares en France Métropolitaine.
5. Enfin si nous souhaitons **rajouter des questions**, nous nous laissons la liberté de les rajouter au plan d'analyse.


**Découverte**

- A quoi ressemble le réseau SNCF en France ?
  > Type de données : Quantitative (Discrètes), Géospatiales
  > Raisonnement : Visualisation spatiale
  > Visualisation : Carte

- Quels sont les départements les mieux équipés (infrastructures de gare) ?
  > Type de données : Quantitative (Discrètes)
  > Raisonnement : Comparaison
  > Visualisation : Bar Chart

- A quel point Paris a une place importante dans le réseau des autres territoires ?
  > Type de données : Quantitative (Discrètes), Géospatiales
  > Raisonnement : Visualisation spatiale
  > Visualisation : Carte

  - Le nombre de voyageurs est-il bien repartis entre les gares d'un même département ?
  > Type de données :
  > Raisonnement :
  > Visualisation : Bar Chart

**Voyageurs**

- Quel est le voyageur moyen de la SNCF ?
  > Type de données :
  > Raisonnement :
  > Visualisation : 

- Comment ce voyageur diffère en fonction des gares ?
  > Type de données :
  > Raisonnement :
  > Visualisation : 

- Quel est la relation entre les motifs de voyage des passagers et leur répartition par âge et par profession ?
  > Type de données :
  > Raisonnement :
  > Visualisation : 

**Objets**

- Y-a-t-il plus de chances de perdre un objet selon la gare ?
  > Type de données :
  > Raisonnement :
  > Visualisation : 

- Doit-on s'attendre à un afflux d'objets perdus plus important dans les mois de Juillet-Août 2024 plus important que les dernières années ?
  > Type de données :
  > Raisonnement :
  > Visualisation : 

- Quelles sont les chances de retrouver un objet perdu ?
  > Type de données :
  > Raisonnement :
  > Visualisation : 

- Quelles sont les chances de retrouver un objet en fonction de sa nature ?
  > Type de données :
  > Raisonnement :
  > Visualisation : 

## Suggestions

Nous aimerions aussi ajouter des données créées personnellement pour visualiser le volume des objets que cela peut représenter comme par exemple un volume type par catégorie d'objet. De même, les données voyageurs sont assez faibles et l'équipe extrapolera sûrement certaines données afin de garder un sens à l'analyse de celles-ci.

---
Copyright : [Mathis Girod](https://github.com/girodmat), [Maxence Jaulin](https://github.com/maxencejaulin), [Louis Prodhon](https://github.com/Grexiem), [Wang Zezhong](https://github.com/RubiesWzz)
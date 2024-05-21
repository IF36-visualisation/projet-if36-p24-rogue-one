[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-24ddc0f5d75046c5622901739e7c5dd533143b0c8e959d652212380cedb1ea36.svg)](https://classroom.github.com/a/Fj4cXJY4)


![](entete-rapportIF36.png "Entête")

# Introduction



Dans le cadre de notre projet, nous avons souhaité traiter des données originales et de nous poser des questions concernant le transport ferroviaire français.

Afin de les données récoltées par l'entreprise **SNCF**, entreprise ferroviaire française.

Les données récoltées sur le transport sont assez importantes c'est pourquoi nous avons choisi de nous concentrer sur les gares et leurs données liées ainsi que les données de perte et vol et des voyageurs.
Ces données sont toutes archivées sur le site web : [Data SNCF](https://data.sncf.com)

## Données

17 variables.

| --- | Nom de la variable      | Type     | Format              | Dataset (Origine) |
| --- | ----------------------- | -------- | ------------------- | ----------------- |
| 01  | gare                    | Nominale | String              | 1,2,3,4,5,6,7     |
| 02  | departement             | Ordinale | NN                  | 1                 |
| 03  | zone                    | Nominale | {A,B,C}             | 1                 |
| 04  | latitude                | Continue | M"S'NS              | 1                 |
| 05  | longitude               | Continue | M"S'NS              | 1                 |
| 06  | annee                   | Ordinale | YYYY                | 2,3,4             |
| 07  | timing_reception        | Discrète | YYYY-MM-DD-HH-MM-SS | 6,7               |
| 08  | nb_voyageurs            | Discrète | Integer             | 2                 |
| 09  | age                     | Ordinale | String              | 5                 |
| 10  | pourcentage_age         | Continue | %                   | 5                 |
| 11  | csp                     | Nominale | String              | 4                 |
| 12  | pourcentage_csp         | Continue | %                   | 4                 |
| 13  | motif_deplacement       | Nominale | String              | 3                 |
| 14  | pourcentage_deplacement | Continue | %                   | 3                 |
| 15  | nature_objet            | Nominale | String              | 6,7               |
| 16  | categorie_objet         | Nominale | String              | 6,7               |
| 17  | code_uic                | Nominale | NNNNNNNNNN          | 6,7               |

**Nombre d'observations**

- [dataset1-gares-de-voyageurs.csv](https://data.sncf.com/explore/dataset/gares-de-voyageurs/export/) (2.862)
- [dataset2-frequentation-gares.csv](https://data.sncf.com/explore/dataset/frequentation-gares/export/) (21.147)
- [dataset3-motif-deplacement.csv](https://data.sncf.com/explore/dataset/motif-deplacement/export/) (284)
- [dataset4-enquetes-gares-connexions-repartition-par-repartition-par-categories-socio-profe.csv](https://data.sncf.com/explore/dataset/enquetes-gares-connexions-repartition-par-repartition-par-categories-socio-profe/export/) (697)
- [dataset5-enquetes-gares-connexions-repartition-repartition-par-classe-dage.csv](https://data.sncf.com/explore/dataset/enquetes-gares-connexions-repartition-repartition-par-classe-dage/export/) (375)
- [dataset6-objets-trouves-gares.csv](https://data.sncf.com/explore/dataset/objets-trouves-gares/export/)(1.844.912)
- [dataset7-objets-trouves-restitution.csv](https://data.sncf.com/explore/dataset/objets-trouves-restitution/export/) (858.180)

Au sein de ces données nous constatons que toutes s'orchestrent autour d'une donnée principale (Gare, 01) qui est présent dans tous les datasets.
Nous pouvons segmenter les données restantes par des critères géographiques (02,03,04,05), des critères temporels (06,07), des critères voyageurs (08,09,10,11,12,13,14) et des critères sur les objets perdus/trouvés (15,16,17).

## Plan d'analyse

Dans un premier temps, nous souhaitons concentrer notre effort sur la découverte du jeu de données et surtout sa compréhension. Nous entendons par cela de faire des visualisations sur le réseau ferroviaire actuel, son affluence, etc.
Nous nous concentrerons ensuite sur une analyse des voyageurs puis celles des objets perdus

### Découverte

- [] A quoi ressemble le réseau SNCF en France ?
- [] Quels sont les départements les mieux équipés ?
- [] A quel point Paris a une place importante dans le réseau des autres territoires ?

### Voyageurs

- [] Le nombre de voyageurs est-il bien repartis entre les gares d'un même département ?
- [] Quel est le voyageur moyen de la SNCF ?
- [] Comment ce voyageur diffère en fonction des gares ?
- [] Quel est la relation entre les motifs de voyage des passagers et leur répartition par âge et par profession ?

### Objets

- [] Y-a-t-il plus de chances de perdre un objet selon la gare ?
- [] Doit-on s'attendre à un afflux d'objets perdus plus important dans les mois de Juillet-Août 2024 plus important que les dernières années ?
- [] Quelles sont les chances de retrouver un objet perdu ?
- [] Quelles sont les chances de retrouver un objet en fonction de sa nature ?

## Ajouts possibles de l'équipe

Nous aimerions aussi ajouter des données créées personnellement pour visualiser le volume des objets que cela peut représenter comme par exemple un volume type par catégorie d'objet.
De même, les données voyageurs sont assez faibles et l'équipe extrapolera sûrement certaines données afin de garder un sens à l'analyse de celles-ci.

# L'équipe du projet

[Maxence Jaulin](https://github.com/maxencejaulin)
[Louis Prodhon](https://github.com/Grexiem)
[Mathis Girod](https://github.com/girodmat)
[Zezhong Wang](https://github.com/RubiesWzz)

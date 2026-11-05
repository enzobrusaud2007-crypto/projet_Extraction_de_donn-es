#!/bin/bash
ville="$1"

if [ -z "$ville" ]; then 
   echo "Erreur : Vous devez spécifier une ville en argument."
   echo "Usage : $0 nom_de_la_ville"
   exit 1
fi

ville_url=$(echo "$ville" | tr " " "+")

# Etape 1 : récupération des données brutes
curl -s "wttr.in/$ville_url?T" > meteo_brut.txt

# Etape 2 : extraire les temperatures 

temp_actuelle=$(grep "°C" meteo_brut.txt | head -1 | grep -o -E "[-+]?[0-9]+" | head -1 | tr -d "+")
temp_demain=$(grep "°C" meteo_brut.txt | head -3 | tail -1 |grep -o -E "[-+]?[0-9]+(\([-+]?[0-9]+\))? °C" | head -2 | tail -1 |cut -d"(" -f1 | cut -d" " -f1 | tr -d "+")


#Etape 3 : Formater : date et heure

jour=$(date "+%Y-%m-%d")
heure=$(date "+%H:%M")
ligne="$jour - $heure - $ville : ${temp_actuelle}°C - ${temp_demain}°C"

#Etape 4 : Enregistrer sur une seule ligne dans meteo.txt

echo "$ligne" >> meteo.txt

echo "Extraction réussie :"
echo "$ligne"


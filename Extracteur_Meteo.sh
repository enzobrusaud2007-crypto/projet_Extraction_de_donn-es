#!/bin/bash
# Extracteur_Meteo.sh - Version 3 : gestion de l'historique
# Usage : ./Extracteur_Meteo.sh [-h] [ville]
#   -h    archive aussi la ligne dans le fichier du jour meteo_YYYYMMDD.txt

historique=0
if [ "$1" = "-h" ]; then
   historique=1
   shift
fi

ville="$1"
if [ -z "$ville" ]; then
   ville="Toulouse"
fi

ville_url=$(echo "$ville" | tr " " "+")

# Etape 1 : récupération des données brutes (le > écrase le fichier à chaque exécution)
curl -s "wttr.in/$ville_url?T" > meteo_brut.txt

# Etape 2 : extraire les températures
temp_actuelle=$(grep "°C" meteo_brut.txt | head -1 | grep -o -E "[-+]?[0-9°]+" | head -1 | tr -d "+")
temp_demain=$(grep "°C" meteo_brut.txt | head -3 | tail -1 | grep -o -E "[-+]?[0-9]+(\([-+]?[0-9]+\))? °C" | head -2 | tail -1 | cut -d"(" -f1 | cut -d" " -f1 | tr -d "+")

# Etape 3 : formater
jour=$(date "+%Y-%m-%d")
heure=$(date "+%H:%M")
ligne="$jour - $heure - $ville : ${temp_actuelle}°C - ${temp_demain}°C"

# Etape 4 : enregistrer
echo "$ligne" >> meteo.txt

# V3 : historique, un fichier par jour ; chaque exécution ajoute une ligne au fichier de la journée
if [ "$historique" = "1" ]; then
   fichier_historique="meteo_$(date "+%Y%m%d").txt"
   echo "$ligne" >> "$fichier_historique"
   echo "Archivé dans $fichier_historique"
fi

echo "Extraction réussie :"
echo "$ligne"

#!/bin/bash
# Extracteur_Météo.sh - VARIANTE 1 : vent et visibilité en plus
# Usage : ./Extracteur_Météo.sh [-a] [-h] [ville]

archive=0

while [ "${1#-}" != "$1" ]; do
   case "$1" in
      -a) archive=1 ;;
      -h) echo "Usage : $0 [-a] [-h] [ville]"
          echo "  -a  archive aussi la ligne dans meteo_YYYYMMDD.txt"
          echo "  -h  affiche cette aide"
          exit 0 ;;
      *) echo "Option inconnue : $1"; echo "Usage : $0 [-a] [-h] [ville]"; exit 1 ;;
   esac
   shift
done

ville="${1:-Toulouse}"
ville_url=$(echo "$ville" | tr " " "+")

erreur() {
   echo "[$(date "+%Y-%m-%d %H:%M:%S")] ERREUR ($ville) : $1" >> meteo_error.log
   echo "Erreur : $1 (voir meteo_error.log)"
   exit 1
}

# Etape 1 : récupération des données brutes
if ! curl -s -f -m 15 "wttr.in/$ville_url?T" > meteo_brut.txt; then
   erreur "impossible de récupérer la météo depuis wttr.in (connexion impossible ou ville inconnue)"
fi

if ! grep -q "°C" meteo_brut.txt; then
   erreur "réponse de wttr.in vide ou sans température"
fi

# Etape 2 : températures
lignes_temp=$(grep "°C" meteo_brut.txt)
motif="[-+]?[0-9]+(-[0-9]+)?(\([-+]?[0-9]+\))? °C"

temp_actuelle=$(echo "$lignes_temp" | head -n 1 | grep -o -E "$motif" | head -n 1 | grep -o -E "^[-+]?[0-9]+" | tr -d "+")
temp_demain=$(echo "$lignes_temp" | head -n 3 | tail -n 1 | grep -o -E "$motif" | head -n 2 | tail -n 1 | grep -o -E "^[-+]?[0-9]+" | tr -d "+")

if [ -z "$temp_actuelle" ] || [ -z "$temp_demain" ]; then
   erreur "températures introuvables dans la réponse de wttr.in"
fi

# Etape 2 bis : vent et visibilité (bloc "conditions actuelles" = 7 premières lignes)
vent=$(head -n 7 meteo_brut.txt | grep -o -E "[0-9]+ km/h" | head -n 1 | grep -o -E "[0-9]+")
visibilite=$(head -n 7 meteo_brut.txt | grep -o -E "[0-9]+ km([^/]|$)" | head -n 1 | grep -o -E "[0-9]+")

if [ -z "$vent" ]; then vent="N/A"; else vent="${vent} km/h"; fi
if [ -z "$visibilite" ]; then visibilite="N/A"; else visibilite="${visibilite} km"; fi

# Etape 3 : formater
jour=$(date "+%Y-%m-%d")
heure=$(date "+%H:%M")
ligne="$jour - $heure - $ville : ${temp_actuelle}°C - ${temp_demain}°C - Vent : $vent - Visibilité : $visibilite"

# Etape 4 : enregistrer
echo "$ligne" >> meteo.txt

if [ "$archive" = 1 ]; then
   fichier_historique="meteo_$(date "+%Y%m%d").txt"
   echo "$ligne" >> "$fichier_historique"
   echo "Archivé dans $fichier_historique"
fi

echo "Extraction réussie :"
echo "$ligne"




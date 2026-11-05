#!/bin/bash
# Extracteur_Météo.sh - VARIANTE 2 : sortie JSON (option -j)  => SCRIPT FINAL COMPLET
# Usage : ./Extracteur_Météo.sh [-a] [-j] [-h] [ville]

archive=0
json=0

while [ "${1#-}" != "$1" ]; do
   case "$1" in
      -a) archive=1 ;;
      -j) json=1 ;;
      -h) echo "Usage : $0 [-a] [-j] [-h] [ville]"
          echo "  -a  archive aussi la ligne dans le fichier du jour (meteo_YYYYMMDD)"
          echo "  -j  enregistre au format JSON (meteo.json) au lieu de meteo.txt"
          echo "  -h  affiche cette aide"
          exit 0 ;;
      *) echo "Option inconnue : $1"; echo "Usage : $0 [-a] [-j] [-h] [ville]"; exit 1 ;;
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

# Etape 2 bis : vent et visibilité
vent=$(head -n 7 meteo_brut.txt | grep -o -E "[0-9]+ km/h" | head -n 1 | grep -o -E "[0-9]+")
visibilite=$(head -n 7 meteo_brut.txt | grep -o -E "[0-9]+ km([^/]|$)" | head -n 1 | grep -o -E "[0-9]+")

if [ -z "$vent" ]; then vent="N/A"; else vent="${vent} km/h"; fi
if [ -z "$visibilite" ]; then visibilite="N/A"; else visibilite="${visibilite} km"; fi

# Etape 3 : formatage
jour=$(date "+%Y-%m-%d")
heure=$(date "+%H:%M")
date_fichier=$(date "+%Y%m%d")

if [ "$json" = 1 ]; then
   # un objet JSON par ligne, dans meteo.json au lieu de meteo.txt
   sortie="{ \"date\": \"$jour\", \"heure\": \"$heure\", \"ville\": \"$ville\", \"temperature\": \"${temp_actuelle}°C\", \"prevision\": \"${temp_demain}°C\", \"vent\": \"$vent\", \"humidite\": \"non disponible\", \"visibilite\": \"$visibilite\" }"
   fichier_principal="meteo.json"
   fichier_historique="meteo_${date_fichier}.json"
else
   sortie="$jour - $heure - $ville : ${temp_actuelle}°C - ${temp_demain}°C - Vent : $vent - Visibilité : $visibilite"
   fichier_principal="meteo.txt"
   fichier_historique="meteo_${date_fichier}.txt"
fi

# Etape 4 : enregistrement
echo "$sortie" >> "$fichier_principal"

# Etape 5 : archivage quotidien (option -a)
if [ "$archive" = 1 ]; then
   echo "$sortie" >> "$fichier_historique"
   echo "Archivé dans $fichier_historique"
fi

echo "Extraction réussie :"
echo "$sortie"



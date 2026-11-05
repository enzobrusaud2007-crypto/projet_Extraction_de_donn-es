#!/bin/bash
# Extracteur_Meteo.sh - Variante 3 : gestion des erreurs et des logs
# Usage : ./Extracteur_Meteo.sh [-h] [ville]
#   -h    archive aussi la ligne dans le fichier du jour meteo_YYYYMMDD.txt
# En cas de problème avec wttr.in, un message horodaté est écrit dans meteo_error.log

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

# Variante 3 : écrit une erreur horodatée dans meteo_error.log, l'affiche et arrête le script
erreur() {
   echo "[$(date "+%Y-%m-%d %H:%M:%S")] ERREUR ($ville) : $1" >> meteo_error.log
   echo "Erreur : $1 (voir meteo_error.log)"
   exit 1
}

# Etape 1 : récupération des données brutes
# -f : curl échoue aussi si wttr.in renvoie une erreur HTTP (ex. ville inconnue)
if ! curl -s -f "wttr.in/$ville_url?T" > meteo_brut.txt; then
   erreur "impossible de récupérer la météo depuis wttr.in (connexion impossible ou ville inconnue)"
fi

# Réponse vide ou sans température : données inutilisables
if ! grep -q "°C" meteo_brut.txt; then
   erreur "réponse de wttr.in vide ou sans température"
fi

# Etape 2 : extraire les températures
temp_actuelle=$(grep "°C" meteo_brut.txt | head -1 | grep -o -E "[-+]?[0-9°]+" | head -1 | tr -d "+")
temp_demain=$(grep "°C" meteo_brut.txt | head -3 | tail -1 | grep -o -E "[-+]?[0-9]+(\([-+]?[0-9]+\))? °C" | head -2 | tail -1 | cut -d"(" -f1 | cut -d" " -f1 | tr -d "+")

if [ -z "$temp_actuelle" ] || [ -z "$temp_demain" ]; then
   erreur "températures introuvables dans la réponse de wttr.in"
fi

# Etape 3 : formater
jour=$(date "+%Y-%m-%d")
heure=$(date "+%H:%M")
ligne="$jour - $heure - $ville : ${temp_actuelle}°C - ${temp_demain}°C"

# Etape 4 : enregistrer
echo "$ligne" >> meteo.txt

# V3 : historique, un fichier par jour
if [ "$historique" = "1" ]; then
   fichier_historique="meteo_$(date "+%Y%m%d").txt"
   echo "$ligne" >> "$fichier_historique"
   echo "Archivé dans $fichier_historique"
fi

echo "Extraction réussie :"
echo "$ligne"





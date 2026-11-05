## Dépôt distant

https://github.com/enzobrusaud2007-crypto/projet_Extraction_de_donn-es

## Travail collaboratif

| Membre | Rôle |
|---|---|
| Enzo Brusaud | Chef de projet (Teams, GitHub, Jira) ; V1, V2, V3 ; README ; Rédaction de la version 1 et 2 du projet ; Correcteur du code |
| Wael Saffiedine | Variantes 1 et 2 ; relecture du code |
| Ilias Bariol-Alaoui | Tests sur la sortie réelle de wttr.in ; V3 corrigée et variante 3 ; dossier (travail collaboratif, gestion de projet) |
| Matteo Lubat | Membre de l'équipe |
| Mohamed Amine Khadraoui | Membre de l'équipe |

- **Teams** : un canal pour l'organisation de l'équipe (partage du code, relectures, répartition) et un canal pour les échanges avec les enseignants.
- **GitHub** : une branche par version (`feature/v2`, `feature/v3`, `feature/variante3`), des commits réguliers, des tags `v1`, `v2` et `v3` pour les versions de base (convention `Variante1` à `Variante3` pour les variantes).
- **Jira** : suivi des tâches. L'intégration Jira–Teams demande des droits d'administration, et la demande a été transmise aux enseignants.
- **Relecture croisée** : les versions publiées sur Teams sont relues par un autre membre. Exemples : la parenthèse en trop dans l'heure, `rm` non autorisé, l'extraction de la prévision.

## Gestion de projet

Démarche **incrémentale** qui suit le découpage du sujet. On traite une version à la fois (V1 → V2 → V3 → variantes). Pour chaque version, on suit le même cycle : développement, publication sur Teams, relecture, correction, puis commit et tag. Les versions de base et les variantes ont avancé en parallèle, et la coordination s'est faite à distance via Teams pendant le blocage du campus.

Étapes clés :
- **20/10** : lancement du projet.
- **28/10** : création du dépôt.
- **03/11 et 04/11** : V1, V2 et V3.
- **05/11** : tests, corrections et variante 3.
- **06/11** : rendu.

## Solution implémentée : Version 1 (script de base)

Utilisation : ./Extracteur_Meteo.sh <ville> (après chmod +x Extracteur_Meteo.sh) ou bash Extracteur_Meteo.sh <ville>. Si aucune ville n’est donnée, le script affiche un message d’erreur et un rappel d’usage, puis s’arrête avec exit 1.

Le script suit les quatre étapes du sujet :

Étape 1, récupération : les espaces du nom de ville sont remplacés par des + avec tr " " "+" (pour « Saint Etienne » par exemple). curl -s "wttr.in/$ville_url?T" récupère la réponse au format texte de wttr.in (?T supprime les couleurs), qui est sauvegardée dans le fichier local meteo_brut.txt.
Étape 2, extraction : la réponse contient une ligne de températures pour le moment présent, puis une ligne par jour de prévision. La température actuelle est le premier nombre de la première ligne qui contient °C : grep "°C" sélectionne les lignes, head -1 garde la première, grep -o -E "[-+]?[0-9]+" isole les nombres (avec leur signe), un second head -1 garde le premier, et tr -d "+" enlève le signe +. La prévision du lendemain est lue sur la troisième ligne contenant °C (head -3 | tail -1), c’est-à-dire la ligne du jour suivant, avec la même extraction.
Étape 3, formatage : la date et l’heure sont obtenues avec date "+%Y-%m-%d" et date "+%H:%M", puis assemblées dans une variable : [Date] - [Heure] - Ville : [Température actuelle] - [Prévision du lendemain].
Étape 4, enregistrement : la ligne est ajoutée à la fin de meteo.txt avec echo "$ligne" >> meteo.txt : une seule ligne par exécution, et les anciens relevés sont conservés.

Exemple de ligne obtenue : [2026-11-03 - 12:41 - Toulouse : 17°C - 19°C].

Limite connue : sur la ligne de demain, le premier nombre rencontré est celui de la colonne du matin, et non celui de midi. Ce point a été corrigé dans la version 3 (voir plus haut).

Tag : v1.0.

## Solution implémentée : Version 2 (automatisation périodique)

Par rapport à la V1, le script garde les quatre étapes et ajoute trois éléments :

Ville par défaut : le test if [ -z "$ville" ] ne s’arrête plus avec une erreur, il affecte ville="Toulouse". ./Extracteur_Meteo.sh fonctionne donc sans argument, et ./Extracteur_Meteo.sh Paris utilise toujours la ville donnée.
Tâche cron : Windows n’ayant pas cron, la tâche a été configurée sous WSL (Ubuntu) avec crontab -e. La ligne 0 * * * * cd /chemin/vers/le/depot && bash Extracteur_Meteo.sh lance le script toutes les heures et ajoute un relevé à meteo.txt. Le cd est nécessaire, car cron n’exécute pas le script depuis le dossier du projet. Le service doit être démarré avec sudo service cron start. Pour le test, la tâche a d’abord été lancée chaque minute (* * * * *), puis passée à une exécution par heure. Vérification : crontab -l et lecture de meteo.txt [captures d’écran à joindre].
README : il explique l’objectif du projet, l’exécution du script (avec la ville par défaut) et la configuration pas à pas d’une tâche cron (voir la section « Automatisation avec cron » ci-dessus).

Tag : v2.0.

## Solution implémentée : Version 3 (gestion d'historique) 

Utilisation : `./Extracteur_Meteo.sh [-h] [ville]` (après `chmod +x Extracteur_Meteo.sh`) ou `bash Extracteur_Meteo.sh [-h] [ville]`. Sans ville, le script prend Toulouse. L'option `-h` archive le relevé dans le fichier du jour.

- **Prévision du lendemain** : les colonnes de wttr.in sont séparées par `│` et non par `|`, donc `cut -d"|"` ne découpait rien et renvoyait la température du matin. On extrait maintenant les 4 températures de la ligne de demain avec `grep -o -E "[-+]?[0-9]+(\([-+]?[0-9]+\))? °C"`, puis on garde celle de midi avec `head -2 | tail -1`.
- **Variante 3 (erreurs et logs)** : si wttr.in est injoignable, si la ville est inconnue (`curl -f`) ou si la réponse n'a pas de température, un message horodaté `[AAAA-MM-JJ HH:MM:SS] ERREUR` est ajouté à `meteo_error.log`, et le script s'arrête avec le code 1.

Tests du 05/11 :
- `Toulouse` donne `7°C - 14°C`.
- `Yakutsk` donne `-15°C - -18°C` (températures négatives).
- `-h "Saint Petersburg"` crée bien le fichier du jour.
- `Zzqxwvlk` écrit une erreur horodatée dans `meteo_error.log`.

## Solution Variante 1 : Informations supplémentaires (vent et visibilité)

- **Extraction** : on lit les 7 premières lignes de `meteo_brut.txt` (`head -n 7`) pour récupérer les données actuelles sans toucher aux prévisions. Le vent est extrait avec `grep -o -E "[0-9]+ km/h"` et la visibilité avec `grep -o -E "[0-9]+ km([^/]|$)"` (pour éviter de reprendre le vent). Si une donnée manque, on met `N/A`.
- **Format** : la ligne enregistrée devient `[Date] - [Heure] - Ville : [Temp. actuelle] - [Prévision] - Vent : [Vent] - Visibilité : [Visibilité]`.
- **Options** : `-h` affiche l'aide et `-a` remplace l'ancien `-h` de la V3 pour archiver dans `meteo_$(date "+%Y%m%d").txt`.


## Solution Variante 2 : Sauvegarde au format JSON

- **Option `-j`** : redirige l'écriture vers `meteo.json` au lieu de `meteo.txt`.
- **Format** : écrit un objet JSON par ligne avec la date, l'heure, la ville, les températures, le vent et la visibilité.
- **Archivage** : combiné avec `-a`, le script archive directement dans un fichier `.json` du jour (`meteo_$(date "+%Y%m%d").json`).

  
## Solution Variante 3 : Ajouter une Gestion des erreurs et des logs

- **V3 (historique)** : avec `-h`, la ligne est ajoutée à `meteo_$(date "+%Y%m%d").txt`, ce qui donne un fichier par jour. Le `$` manquait devant `fichier_historique`, et `rm -f` a été retiré : il n'est pas autorisé, et `>` écrase déjà le fichier brut.
